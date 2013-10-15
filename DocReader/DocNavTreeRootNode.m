//
//  DocNavTreeRootNode.m
//  DocReader
//
//  Created by pei hao on 13-10-12.
//  Copyright (c) 2013年 pei hao. All rights reserved.
//

#import "DocNavTreeRootNode.h"
#import "DocNavTreeDocsetNode.h"
@implementation DocNavTreeRootNode
static DocNavTreeRootNode *rootItem = nil;


- (id)initWithPath:(NSString *)path parent:(DocNavTreeNode *)aParent withPathArray:(NSArray*) array{
    
    if (self = [super initWithPath:path parent:aParent]) {
        
        pathArray = array;
        label = @"文档库";
    }
    return self;
}

+ (void)clearRootNode {

    rootItem = nil;
}
+ (DocNavTreeRootNode *)rootItemWithPathArray:(NSArray*)array{
    
    if (rootItem == nil) {
        rootItem = [[DocNavTreeRootNode alloc] initWithPath:@"/" parent:nil withPathArray:array];
    }
    return rootItem;
}

- (NSDictionary*)docsetInfo:(NSString*)path {
    
    NSString *errorDesc = nil;
    NSPropertyListFormat format;
    
    NSFileManager* filem = [NSFileManager defaultManager];
    NSString* infoplistPath = [path stringByAppendingPathComponent:@"Contents/Info.plist"];
    if (![filem fileExistsAtPath:infoplistPath isDirectory:nil])
        return nil;
    
    NSData *plistXML = [filem contentsAtPath:infoplistPath];
    NSDictionary *temp = (NSDictionary *)[NSPropertyListSerialization
                                          propertyListFromData:plistXML
                                          mutabilityOption:NSPropertyListMutableContainersAndLeaves
                                          format:&format
                                          errorDescription:&errorDesc];
    if (!temp) {
        NSLog(@"Error reading plist: %@", errorDesc);
    }
    
    return temp;
}

- (NSMutableArray*)findAllDocsets {
    
    NSMutableArray* aChildren = [[NSMutableArray alloc] initWithCapacity:100];
    for (NSString* fullpath in pathArray) {
        
        NSDictionary* docinfo = [self docsetInfo:fullpath];
        if (docinfo) {
            
            DocNavTreeDocsetNode* node = [[DocNavTreeDocsetNode alloc] initWithPath:[fullpath lastPathComponent] parent:self andInfo:docinfo];
            [aChildren addObject:node];
        }
    }
    return aChildren;
}

- (NSArray *)children {
    
    if (children!=nil)
        return children;
    children = [self findAllDocsets];
    return children;
}

@end
