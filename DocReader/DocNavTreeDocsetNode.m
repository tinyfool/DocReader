//
//  DocNavTreeDocsetNode.m
//  DocReader
//
//  Created by pei hao on 13-10-12.
//  Copyright (c) 2013年 pei hao. All rights reserved.
//

#import "DocNavTreeDocsetNode.h"
#import "DocNavTreeTopicNode.h"
#import "DocSet.h"
#import "DocSetTopic.h"

@implementation DocNavTreeDocsetNode
@synthesize docSet;

- (id)initWithPath:(NSString *)path parent:(DocNavTreeNode *)aParent{
    
    if (self = [super initWithPath:path parent:aParent]) {
        
        docSet = [[DocSet alloc] initWithPath:path];
        label = docSet.name;
    }
    return self;
}

- (NSArray*)topicNodes:(DocNavTreeTopicNode*)aParent {

    return nil;
}

- (NSArray *)children {
    
    if (children!=nil)
        return children;
    
    NSArray* topicArray  = [docSet topicsWithParent:nil];
    NSMutableArray* tempChildren = [NSMutableArray arrayWithCapacity:[topicArray count]];
    for (DocSetTopic* topic in topicArray) {
        DocNavTreeTopicNode* node = [[DocNavTreeTopicNode alloc] initWithPath:topic.name parent:nil andTopic:topic andDocsetNode:self];
        [tempChildren addObject:node];
    }
    children = tempChildren;
    return children;
}


@end
