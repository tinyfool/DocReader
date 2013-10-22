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
@synthesize children = children;

- (id)initWithPath:(NSString *)path parent:(DocNavTreeNode *)aParent {
    
    if (self = [super init]) {
        
        relativePath = [[path lastPathComponent] copy];
        parent = aParent;
        _path = [path copy];
    }
    return self;
}


- (NSInteger)numberOfChildren {
    
    id tmp = [self children];
    if (tmp) {
        return [tmp count];
    }
    else
        return 0;
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

- (NSUInteger)hash
{
    return self.path.hash;
}

- (BOOL)isEqual:(id)object
{
    if (self == object) {
        return YES;
    }
    
    if ([self isMemberOfClass:[object class]]) {
        return [[self path] isEqualToString:[object path]];
    }
    
    return NO;
}

@end
