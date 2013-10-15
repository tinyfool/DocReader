//
//  DocNavTreeTopicNode.h
//  DocReader
//
//  Created by pei hao on 13-10-12.
//  Copyright (c) 2013年 pei hao. All rights reserved.
//

#import "DocNavTreeNode.h"

@class DocNavTreeDocsetNode;
@class DocSet;
@class DocSetTopic;

@interface DocNavTreeTopicNode : DocNavTreeNode {
    
    DocSetTopic* topic;
    NSDictionary* info;
    DocNavTreeDocsetNode* docsetNode;
}

- (id)initWithPath:(NSString *)path parent:(DocNavTreeNode *)aParent andTopic:(DocSetTopic*)aTopic andDocsetNode:(DocNavTreeDocsetNode*)aDocsetNode;
- (NSString*)Url;

@property (readonly) NSDictionary* info;
@end
