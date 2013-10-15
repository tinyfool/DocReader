//
//  DocNavTreeTopicNode.m
//  DocReader
//
//  Created by pei hao on 13-10-12.
//  Copyright (c) 2013年 pei hao. All rights reserved.
//

#import "DocNavTreeTopicNode.h"
#import "DocNavTreeDocsetNode.h"
#import "DocSetTopic.h"
#import "DocSet.h"

@implementation DocNavTreeTopicNode
@synthesize info;

- (id)initWithPath:(NSString *)path parent:(DocNavTreeNode *)aParent andTopic:(DocSetTopic*)aTopic andDocsetNode:(DocNavTreeDocsetNode*)aDocsetNode {

    if (self = [super initWithPath:path parent:aParent]) {
        
        topic = aTopic;
        docsetNode = aDocsetNode;
        label = topic.name;
    }
    return self;
    
}

- (NSArray *)children {
    
    if (children!=nil)
        return children;
    
    NSArray* topicArray  = [docsetNode.docSet topicsWithParent:topic];
    NSMutableArray* tempChildren = [NSMutableArray arrayWithCapacity:[topicArray count]];
    for (DocSetTopic* aTopic in topicArray) {
        
        DocNavTreeTopicNode* node = [[DocNavTreeTopicNode alloc] initWithPath:aTopic.name parent:self andTopic:aTopic andDocsetNode:docsetNode];
        [tempChildren addObject:node];
    }
    if ([tempChildren count]!=0) {
        children = tempChildren;
    }
    return children;
}

- (NSString*)Url {

    return topic.url;
}
@end
