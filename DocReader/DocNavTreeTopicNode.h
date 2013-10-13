//
//  DocNavTreeTopicNode.h
//  DocReader
//
//  Created by pei hao on 13-10-12.
//  Copyright (c) 2013年 pei hao. All rights reserved.
//

#import "DocNavTreeNode.h"
@class DocNavTreeDocsetNode;

@interface DocNavTreeTopicNode : DocNavTreeNode {
    NSDictionary* info;
    DocNavTreeDocsetNode* docset;
}
- (id)initWithPath:(NSString *)path parent:(DocNavTreeNode *)parent andInfo:(id)aInfo andDocsetNode:(DocNavTreeDocsetNode*)aDocset;
@end
