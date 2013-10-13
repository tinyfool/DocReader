//
//  DocNavTreeDocsetNode.m
//  DocReader
//
//  Created by pei hao on 13-10-12.
//  Copyright (c) 2013年 pei hao. All rights reserved.
//

#import "DocNavTreeDocsetNode.h"
#import "DocNavTreeTopicNode.h"

@implementation DocNavTreeDocsetNode
@synthesize docInfo;

- (id)initWithPath:(NSString *)path parent:(DocNavTreeNode *)aParent andInfo:(id)aInfo{
    
    if (self = [super initWithPath:path parent:aParent]) {
        
        docInfo = aInfo;
        label =  [docInfo objectForKey:@"CFBundleName"];
    }
    return self;
}

- (sqlite3*) dsidx_db {

    if (dsidx_db==NULL) {
        
        NSString* fullpath = [[srcPath stringByAppendingPathComponent:[self relativePath]] stringByAppendingPathComponent:@"Contents/Resources/docSet.dsidx"];
        sqlite3_open_v2([fullpath UTF8String], &dsidx_db,SQLITE_OPEN_READWRITE|SQLITE_OPEN_FULLMUTEX,NULL);
    }
    return dsidx_db;
}

- (NSArray*)topicNodes:(DocNavTreeTopicNode*)aParent {


    return nil;
}

- (NSArray *)children {
    
    if (children!=nil)
        return children;
    
    NSArray* c = [self runSql:@"SELECT count(*) as c FROM ZNODE WHERE ifnull(ZPRIMARYPARENT, '') = '';"];
    NSInteger count =[[[c objectAtIndex:0] objectForKey:@"c"] integerValue];
    if(count <=5) {
        
        NSMutableArray* aChildren = [[NSMutableArray alloc] initWithCapacity:count];
        NSArray* results = [self runSql:@"SELECT * FROM ZNODE WHERE ifnull(ZPRIMARYPARENT, '') = '';"];
        for (id ret in results) {
            
            NSString* path = [ret objectForKey:@"ZKPATH"];
            DocNavTreeTopicNode* node = [[DocNavTreeTopicNode alloc] initWithPath:path parent:self andInfo:ret andDocsetNode:self];
            [aChildren addObject:node];
        }
        children = aChildren;
    }
    return children;
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

@end
