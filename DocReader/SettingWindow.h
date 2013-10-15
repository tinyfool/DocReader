//
//  SettingWindow.h
//  DocReader
//
//  Created by pei hao on 13-10-14.
//  Copyright (c) 2013年 pei hao. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class MainDelegate;
@interface SettingWindow : NSWindow <NSTableViewDataSource,NSTableViewDelegate>{

    NSArray* searchPaths;
    NSArray* docSets;
}

@property (weak) IBOutlet MainDelegate *mainDelegate;
@property (weak) IBOutlet NSScrollView *docSetsTable;
-(NSArray*)searchPaths;
-(NSArray*)docSets;
@end
