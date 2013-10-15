//
//  DocSet.m
//  DocReader
//
//  Created by pei hao on 13-10-15.
//  Copyright (c) 2013年 pei hao. All rights reserved.
//

#import "DocSet.h"
#import "DocSetTopic.h"

@implementation DocSet
@synthesize name;

-(id)initWithPath:(NSString*)aPath {
    
    self = [super init];
    if (self) {
        
        path = aPath;
        NSString *errorDesc = nil;
        NSPropertyListFormat format;
        
        NSFileManager* filem = [NSFileManager defaultManager];
        NSString* infoplistPath = [path stringByAppendingPathComponent:@"Contents/Info.plist"];
        if (![filem fileExistsAtPath:infoplistPath isDirectory:nil])
            return nil;
        
        NSData *plistXML = [filem contentsAtPath:infoplistPath];
        NSDictionary *temp = (NSDictionary *)[NSPropertyListSerialization
                                              propertyListFromData:plistXML
                                              mutabilityOption:NSPropertyListMutableContainersAndLeaves
                                              format:&format
                                              errorDescription:&errorDesc];
        if (!temp) {
            NSLog(@"Error reading plist: %@", errorDesc);
        }
        info = temp;
        name = [info objectForKey:@"CFBundleName"];
    }
    return self;
}

-(NSString*)path {

    return path;
}

- (sqlite3*) dsidx_db {
    
    if (dsidx_db==NULL) {
        
        NSString* fullpath = [path stringByAppendingPathComponent:@"Contents/Resources/docSet.dsidx"];
        sqlite3_open_v2([fullpath UTF8String], &dsidx_db,SQLITE_OPEN_READWRITE|SQLITE_OPEN_FULLMUTEX,NULL);
    }
    return dsidx_db;
}

- (NSArray*)runSql:(NSString*)sql{
	
	sqlite3_stmt *statement;
	int sqlRet;
	sqlRet=sqlite3_prepare_v2([self dsidx_db],[sql UTF8String],-1,&statement,NULL);
	if(sqlRet!=SQLITE_OK)
		NSAssert1(0,@"ERROR:\"%s\"",sqlite3_errmsg([self dsidx_db]));
	
	NSMutableArray* ret = [[NSMutableArray alloc] initWithCapacity:100];
	while (sqlite3_step(statement)==SQLITE_ROW) {
		
		int cloumncount = sqlite3_column_count(statement);
		NSMutableDictionary* row = [NSMutableDictionary dictionaryWithCapacity:10];;
		for (int i = 0; i < cloumncount ; i++) {
			
			NSString* cloumnName =[NSString stringWithUTF8String:sqlite3_column_name(statement,i)];
			int clountype = sqlite3_column_type(statement,i);
			
			switch (clountype) {
				case SQLITE_INTEGER:
				{
					int column = sqlite3_column_int(statement, i);
					NSNumber* number = [NSNumber numberWithInt:column];
					[row setObject:number forKey:cloumnName];
				}
					break;
				case SQLITE_FLOAT:
				{
					double column = sqlite3_column_double(statement, i);
					NSNumber* number = [NSNumber numberWithDouble:column];
					[row setObject:number forKey:cloumnName];
				}
					break;
				case SQLITE_NULL:
					break;
			    case SQLITE_BLOB:
				{
					char* column = (char*)sqlite3_column_blob(statement, i);
					int length = sqlite3_column_bytes(statement, i);
					NSData* data = [NSData dataWithBytes:column length:length];
					[row setObject:data forKey:cloumnName];
				}
					break;
				case SQLITE_TEXT:
				{
					NSString* text = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, i)];
					[row setObject:text forKey:cloumnName];
				}
					break;
				default:
					break;
			}
		}
		[ret addObject:row];
	}
	sqlite3_finalize(statement);
	return ret;
}

-(NSArray*)topicsWithParent:(DocSetTopic*)parent {

    NSArray* results;
    if (parent==nil) {
        
        NSArray* c = [self runSql:@"SELECT count(*) as c FROM ZNODE WHERE ifnull(ZPRIMARYPARENT, '') = '';"];
        NSInteger count =[[[c objectAtIndex:0] objectForKey:@"c"] integerValue];
        if(count >5)
            return nil;
        
        results = [self runSql:@"SELECT * FROM ZNODE WHERE ifnull(ZPRIMARYPARENT, '') = '';"];
        if ([results count]==0) {
            
            return nil;
        }
    }else {
    
        NSString* sql = [NSString stringWithFormat:@"SELECT * FROM ZNODE WHERE ZPRIMARYPARENT = %@;",parent.z_pk];
        results = [self runSql:sql];
        if ([results count]==0) {
            
            return nil;
        }
    }
    
    NSMutableArray* topicArray = [NSMutableArray arrayWithCapacity:100];
    for (NSDictionary* dict  in results) {
        
        DocSetTopic* topic = [[DocSetTopic alloc] initWithDict:dict andDocSet:self];
        [topicArray addObject:topic];
    }
    return topicArray;
}
@end
