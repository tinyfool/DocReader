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


- (id)initWithPath:(NSString *)path parent:(DocNavTreeNode *)aParent {
    
    if (self = [super initWithPath:path parent:aParent]) {
        
        label = @"文档库";
    }
    return self;
}

+ (DocNavTreeRootNode *)rootItem {
    
    if (rootItem == nil) {
        rootItem = [[DocNavTreeRootNode alloc] initWithPath:@"/" parent:nil];
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
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *array = [fileManager contentsOfDirectoryAtPath:srcPath error:NULL];
    for (NSString* path in array) {
        
        NSString* fullpath = [srcPath stringByAppendingPathComponent:path];
        NSDictionary* docinfo = [self docsetInfo:fullpath];
        if (docinfo) {
            
            DocNavTreeDocsetNode* node = [[DocNavTreeDocsetNode alloc] initWithPath:path parent:self andInfo:docinfo];
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
