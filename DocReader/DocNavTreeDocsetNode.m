//
//  DocNavTreeDocsetNode.m
//  DocReader
//
//  Created by pei hao on 13-10-12.
//  Copyright (c) 2013年 pei hao. All rights reserved.
//

#import "DocNavTreeDocsetNode.h"

@implementation DocNavTreeDocsetNode

- (id)initWithPath:(NSString *)path parent:(DocNavTreeNode *)aParent andInfo:(id)aInfo{
    
    if (self = [super initWithPath:path parent:aParent]) {
        
        docInfo = aInfo;
        label =  [docInfo objectForKey:@"CFBundleName"];
    }
    return self;
}

@end
