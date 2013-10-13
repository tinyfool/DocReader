//
//  DocNavTreeTopicNode.m
//  DocReader
//
//  Created by pei hao on 13-10-12.
//  Copyright (c) 2013年 pei hao. All rights reserved.
//

#import "DocNavTreeTopicNode.h"
#import "DocNavTreeDocsetNode.h"

@implementation DocNavTreeTopicNode
- (id)initWithPath:(NSString *)path parent:(DocNavTreeNode *)aParent andInfo:(id)aInfo andDocsetNode:(DocNavTreeDocsetNode*)aDocset {

    if (self = [super initWithPath:path parent:aParent]) {
        
        info = aInfo;
        label = [info objectForKey:@"ZKNAME"];
        docset = aDocset;
    }
    return self;

    
    
}

- (NSArray *)children {
    
    if (children!=nil)
        return children;
    
    NSString* pk = [info objectForKey:@"Z_PK"];
    NSInteger subCount = [[info objectForKey:@"ZKSUBNODECOUNT"] integerValue];
    if (subCount<=0)
        return nil;
    NSMutableArray* aChildren = [[NSMutableArray alloc] initWithCapacity:subCount];
    NSString* sql = [NSString stringWithFormat:@"SELECT * FROM ZNODE WHERE ZPRIMARYPARENT = %@",pk];
    NSArray* results = [docset runSql:sql];
    for (id ret in results) {
        
        NSString* path = [ret objectForKey:@"ZKPATH"];
        DocNavTreeTopicNode* node = [[DocNavTreeTopicNode alloc] initWithPath:path parent:self andInfo:ret andDocsetNode:docset];
        [aChildren addObject:node];
    }
    children = aChildren;

    return children;
}

@end
