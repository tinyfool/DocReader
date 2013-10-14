//
//  DocNavTreeDataSource.h
//  DocReader
//
//  Created by pei hao on 13-10-11.
//  Copyright (c) 2013年 pei hao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
@class DocNavTreeTopicNode;
@interface MainDelegate : NSObject

@property (weak) IBOutlet WebView *docWebview;
- (IBAction)updateFilter:sender;
@end
