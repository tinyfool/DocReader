//
//  DocNavTreeRootNode.h
//  DocReader
//
//  Created by pei hao on 13-10-12.
//  Copyright (c) 2013年 pei hao. All rights reserved.
//

#import "DocNavTreeNode.h"

@interface DocNavTreeRootNode : DocNavTreeNode
{
    NSArray* pathArray;
}
+ (DocNavTreeRootNode *)rootItemWithPathArray:(NSArray*)array;
+ (void)clearRootNode;
@end
