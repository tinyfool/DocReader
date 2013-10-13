//
//  DocNavTreeDocsetNode.h
//  DocReader
//
//  Created by pei hao on 13-10-12.
//  Copyright (c) 2013年 pei hao. All rights reserved.
//

#import "DocNavTreeNode.h"
#import <sqlite3.h>

@class DocNavTreeTopicNode;

@interface DocNavTreeDocsetNode : DocNavTreeNode {
    
    NSDictionary* docInfo;
    sqlite3* dsidx_db;
}

- (id)initWithPath:(NSString *)path parent:(DocNavTreeNode *)parent andInfo:(id)aInfo;
- (NSArray*)topicNodes:(DocNavTreeTopicNode*)aParent;
- (sqlite3*) dsidx_db;
- (NSArray*)runSql:(NSString*)sql;
@end
