//
//  SearchResultsViewController.h
//  DocReader
//
//  Created by pei hao on 13-10-16.
//  Copyright (c) 2013年 pei hao. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

@interface SearchResultsViewController : NSViewController<NSTableViewDataSource,NSTableViewDelegate> {

    NSArray* results;
    WebView *docWebview;
}

@property (weak) IBOutlet NSTableView *resultsTableview;
-(void)setResults:(NSArray*)aResults;
-(void)setDocWebView:(WebView*)webview;
@end
