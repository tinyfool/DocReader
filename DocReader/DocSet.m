//
//  DocSet.m
//  DocReader
//
//  Created by pei hao on 13-10-15.
//  Copyright (c) 2013年 pei hao. All rights reserved.
//

#import "DocSet.h"

@implementation DocSet
@synthesize name;

-(id)initWithPath:(NSString*)aPath {
    
    self = [super init];
    if (self) {
        
        path = aPath;
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
        info = temp;
        name = [info objectForKey:@"CFBundleName"];
    }
    return self;
}
-(NSString*)path {

    return path;
}
@end
