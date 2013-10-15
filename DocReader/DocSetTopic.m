//
//  DocSetTopic.m
//  DocReader
//
//  Created by pei hao on 13-10-15.
//  Copyright (c) 2013年 pei hao. All rights reserved.
//

#import "DocSetTopic.h"
#import "DocSet.h"

@implementation DocSetTopic

@synthesize name;

-(id)initWithDict:aInfo andDocSet:(DocSet*)aDocSet {

    self = [super init];
    if (self) {
        
        docSet = aDocSet;
        info = aInfo;
        name = [info objectForKey:@"ZKNAME"];
    }
    
    return self;
}

-(NSString*)z_pk {

    return [info objectForKey:@"Z_PK"];
}

-(NSString*)url {
    
    NSString* path = [info objectForKey:@"ZKPATH"];
    NSString* pk = [info objectForKey:@"Z_PK"];
    if (!path) {
        
        NSString* sql = [NSString stringWithFormat:@"SELECT * FROM ZNODEURL WHERE ZNODE = %@",pk];
        NSArray* results = [docSet runSql:sql];
        path = [[results objectAtIndex:0] objectForKey:@"ZPATH"];
        if (!path) {
            NSString* zbaseurl = [[results objectAtIndex:0] objectForKey:@"ZBASEURL"];
            if (zbaseurl) {
                return [NSURL URLWithString:zbaseurl];
            }
            else
                return nil;
        }
    }
    NSString* fullPath = [[docSet.path stringByAppendingPathComponent:@"Contents/Resources/Documents"] stringByAppendingPathComponent:path];
    
    return fullPath;
}
@end
