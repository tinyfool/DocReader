//
//  DocSet.h
//  DocReader
//
//  Created by pei hao on 13-10-15.
//  Copyright (c) 2013年 pei hao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
@class DocSetTopic;

@interface DocSet : NSObject {
    
    NSDictionary* info;
    NSString* name;
    NSString* path;
    sqlite3* dsidx_db;
}

@property (readonly) NSString* name;
-(id)initWithPath:(NSString*)path;
-(NSString*)path;
- (sqlite3*) dsidx_db;
- (NSArray*)runSql:(NSString*)sql;
-(NSArray*)topicsWithParent:(DocSetTopic*)parent;
@end
