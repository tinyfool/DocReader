//
//  DocNavTreeDocsetNode.h
//  DocReader
//
//  Created by pei hao on 13-10-12.
//  Copyright (c) 2013年 pei hao. All rights reserved.
//

#import "DocNavTreeNode.h"
#import <sqlite3.h>

@class DocSet;
@class DocNavTreeTopicNode;

@interface DocNavTreeDocsetNode : DocNavTreeNode {
    
    DocSet* docSet;
}

- (id)initWithPath:(NSString *)path parent:(DocNavTreeNode *)aParent;
- (NSArray*)topicNodes:(DocNavTreeTopicNode*)aParent;

@property (readonly) DocSet* docSet;
@end
