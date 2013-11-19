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
}

@property id<DocNavWebviewDelegate> docNavWebviewDelegate;
-(TDBarView*)inPageSearchViewController;
-(void)showSearch:(BOOL)show;
-(void)showCatalog:(BOOL)show;
-(void)updateContentsConstraints;
@end

@protocol DocNavWebviewDelegate <NSObject>
@optional

-(void)showDictionary:(NSString*)word;
-(void)speak:(NSString*)word;
-(void)translate:(NSString*)word;
@end
