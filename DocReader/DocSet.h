//
//  DocSet.h
//  DocReader
//
//  Created by pei hao on 13-10-15.
//  Copyright (c) 2013年 pei hao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DocSet : NSObject {
    
    NSDictionary* info;
    NSString* name;
    NSString* path;
}

@property (readonly) NSString* name;
-(id)initWithPath:(NSString*)path;
-(NSString*)path;
@end
