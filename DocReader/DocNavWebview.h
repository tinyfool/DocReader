//
//  DocNavWebview.h
//  DocReader
//
//  Created by pei hao on 13-10-31.
//  Copyright (c) 2013年 pei hao. All rights reserved.
//

#import <WebKit/WebKit.h>
#import "DHWebView.h"

@protocol DocNavWebviewDelegate;
@class TDBarView;

@interface DocNavWebview : DHWebView <NSControlTextEditingDelegate>{
    
    NSSpeechSynthesizer* speech;
    TDBarView* inPageSearchViewController;
    IBOutlet NSLayoutConstraint* webviewTopConstraint;
    IBOutlet NSLayoutConstraint* inPageSearchBarTopConstraint;
    IBOutlet NSView* catalogBar;
    IBOutlet NSView* inPageSearchBar;
    IBOutlet NSSearchField* inPageSearchField;
    BOOL canNotSpeaking;
    NSString* inPageSearchWord;
}

@property id<DocNavWebviewDelegate> docNavWebviewDelegate;
@property BOOL canNotSpeaking;

-(TDBarView*)inPageSearchViewController;
-(IBAction)showSearch:(id)sender;
-(void)showCatalog:(BOOL)show;
-(void)updateContentsConstraints;

-(IBAction)inPageSearchPrev:(id)sender;
-(IBAction)inPageSearchNext:(id)sender;
@end

@protocol DocNavWebviewDelegate <NSObject>
@optional

-(void)showDictionary:(NSString*)word;
-(void)speak:(NSString*)word;
-(void)translate:(NSString*)word;
@end
