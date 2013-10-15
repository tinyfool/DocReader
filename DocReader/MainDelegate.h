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
@class SettingWindow;
@interface MainDelegate : NSObject {

    NSArray* docSetPathArray;
}
@property (weak) IBOutlet NSOutlineView *outlineView;
@property (weak) IBOutlet WebView *docWebview;
- (IBAction)updateFilter:sender;
- (IBAction)Setting:(id)sender;
@property (unsafe_unretained) IBOutlet  SettingWindow *settingWindow;
-(NSArray*)docSetPathArray;
-(void)setDocSetPathArray:(NSArray*)array;

@end
