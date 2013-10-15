//
//  DocSetTopic.h
//  DocReader
//
//  Created by pei hao on 13-10-15.
//  Copyright (c) 2013年 pei hao. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DocSet;
@interface DocSetTopic : NSObject {
    
    NSDictionary* info;
    NSString* name;
    DocSet* docSet;
}

-(id)initWithDict:aInfo andDocSet:(DocSet*)aDocSet;
@property (readonly) NSString* name;
-(NSString*)z_pk;
-(NSString*)url;
@end
