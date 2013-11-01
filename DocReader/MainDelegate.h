//
//  DocNavTreeDataSource.h
//  DocReader
//
//  Created by pei hao on 13-10-11.
//  Copyright (c) 2013年 pei hao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
#import "DocNavWebview.h"
@class DocNavTreeTopicNode;
@class SettingWindow;
@class DocNavTreeRootNode;
@class SearchResultsViewController;
@class DictionaryViewController;
@class DocNavWebview;
@protocol DocNavWebviewDelegate;

@interface MainDelegate : NSObject<NSControlTextEditingDelegate,DocNavWebviewDelegate> {

    NSArray* docSetPathArray;
    NSMutableArray* searchDocSets;
    DocNavTreeRootNode* rootNode;
    SearchResultsViewController* searchResultsViewController;
    NSPopover* searchPopover;
    NSOperationQueue* searchQueue;
    DictionaryViewController* dictionaryViewController;
    NSPopover* dictionaryPopover;
    NSSpeechSynthesizer* speech;
    IBOutlet NSSegmentedControl* docsetSelector;
}

@property (nonatomic, strong) IBOutlet NSMutableArray *nodes;
@property (nonatomic, strong) IBOutlet NSTreeController *treeController;
@property (weak) IBOutlet NSOutlineView *outlineView;
@property (weak) IBOutlet DocNavWebview *docWebview;
@property (weak) IBOutlet NSButton* dictionaryButton;

- (IBAction)updateFilter:sender;
- (IBAction)Setting:(id)sender;
- (IBAction)dictionary:(id)sender;
- (IBAction)docsetSelected:(id)sender;

-(void)showDictionaryView;
-(NSSpeechSynthesizer*)speech;

@property (unsafe_unretained) IBOutlet  SettingWindow *settingWindow;
-(NSArray*)docSetPathArray;
-(void)setDocSetPathArray:(NSArray*)array;

@end
