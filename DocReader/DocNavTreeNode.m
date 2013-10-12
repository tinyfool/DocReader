//
//  DocNavTree.m
//  DocReader
//
//  Created by pei hao on 13-10-11.
//  Copyright (c) 2013年 pei hao. All rights reserved.
//

#import "DocNavTreeNode.h"
#import "DocNavTreeRootNode.h"

@implementation DocNavTreeNode
@synthesize label;



- (id)initWithPath:(NSString *)path parent:(DocNavTreeNode *)aParent {
    
    if (self = [super init]) {
        
        relativePath = [[path lastPathComponent] copy];
        parent = aParent;
    }
    return self;
}


- (NSInteger)numberOfChildren {
    
    id tmp = [self children];
    if (tmp) {
        return [tmp count];
    }
    else
        return -1;
}

- (DocNavTreeNode *)childAtIndex:(NSInteger)n {

    if (!children)
        return nil;
    return [children objectAtIndex:n];
}

- (NSString *)fullPath {
    
    return @"/";
}

- (NSString *)relativePath {
    
    return relativePath;
}

- (NSArray *)children {
    
    if (children!=nil)
        return children;
    return nil;
}
@end
