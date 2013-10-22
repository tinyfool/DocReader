//
//  DocNavTree.h
//  DocReader
//
//  Created by pei hao on 13-10-11.
//  Copyright (c) 2013年 pei hao. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DocNavTreeRootNode;

@interface DocNavTreeNode : NSObject {

    NSString *relativePath;
    DocNavTreeNode *parent;
    NSMutableArray *children;
    NSString* label;
}

- (NSInteger)numberOfChildren;
- (DocNavTreeNode *)childAtIndex:(NSInteger)n;
- (NSString *)fullPath;
- (NSString *)relativePath;
- (id)initWithPath:(NSString *)path parent:(DocNavTreeNode *)obj;

@property (nonatomic, strong) NSArray *children;
@property (nonatomic, copy) NSString *path;

@property (readonly) int level;
@property (readonly) NSString* label;
@end

