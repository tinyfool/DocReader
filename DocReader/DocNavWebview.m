//
//  DocNavWebview.m
//  DocReader
//
//  Created by pei hao on 13-10-31.
//  Copyright (c) 2013年 pei hao. All rights reserved.
//

#import "DocNavWebview.h"
#import "TDBarView.h"
#import "DHWebView.h"

@implementation DocNavWebview
@synthesize docNavWebviewDelegate;
@synthesize canNotSpeaking;

-(TDBarView*)inPageSearchViewController {
    
    if (!inPageSearchViewController) {
        
    }
    return inPageSearchViewController;
}

-(void)showCatalog:(BOOL)show{

    if (show)
        [catalogBar setHidden:NO];
    else
        [catalogBar setHidden:YES];
    [self updateContentsConstraints];

}

-(IBAction)showSearch:(id)sender {

    if ([inPageSearchBar isHidden]) {
        [inPageSearchBar setHidden:NO];
        [inPageSearchField becomeFirstResponder];
    }
    else {
        [inPageSearchBar setHidden:YES];
        [self highlightQuery:@"" caseSensitive:NO];
    }
    [self updateContentsConstraints];
}

-(void)updateContentsConstraints {

    CGFloat c1 = 0;
    CGFloat c2 = 0;
    
    if ([catalogBar isHidden])
        c1 = 0;
    else
        c1 = 33;
    if ([inPageSearchBar isHidden])
        c2 = 0;
    else
        c2 = 33;
    inPageSearchBarTopConstraint.constant = c1;
    webviewTopConstraint.constant = c1 + c2;
}

- (void)controlTextDidChange:(NSNotification *)notification {

    NSSearchField *searchField = [notification object];
    inPageSearchWord = [searchField stringValue];
    [self highlightQuery:inPageSearchWord caseSensitive:NO];    
}

-(IBAction)inPageSearchPrev:(id)sender {

    [self searchFor:inPageSearchWord direction:NO caseSensitive:NO wrap:YES];

}
-(IBAction)inPageSearchNext:(id)sender {

    [self searchFor:inPageSearchWord direction:YES caseSensitive:NO wrap:YES];
}

- (BOOL)control:(NSControl *)control textShouldBeginEditing:(NSText *)fieldEditor {
    
    canNotSpeaking = YES;
    return YES;
}
- (BOOL)control:(NSControl *)control textShouldEndEditing:(NSText *)fieldEditor{

    canNotSpeaking = NO;
    return YES;
}

-(float)zoomLevel {

    float zoomLevel;
    NSString* jsReturnStr = [self stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.zoom"];
    zoomLevel = [jsReturnStr floatValue];
    if (zoomLevel<0.0001) {
        zoomLevel = 1;
    }
    return zoomLevel;
}

-(IBAction)zoomIn:(id)sender {

    float zoomLevel = [self zoomLevel]/1.2;
    NSString* js = [NSString stringWithFormat:@"document.documentElement.style.zoom = \"%f\";",zoomLevel];
    [self stringByEvaluatingJavaScriptFromString:js];
}

-(IBAction)zoomOut:(id)sender {

    float zoomLevel = [self zoomLevel]*1.2;
    NSString* js = [NSString stringWithFormat:@"document.documentElement.style.zoom = \"%f\";",zoomLevel];
    [self stringByEvaluatingJavaScriptFromString:js];
}

-(IBAction)resetZoom:(id)sender {

    float zoomLevel = 1;
    NSString* js = [NSString stringWithFormat:@"document.documentElement.style.zoom = \"%f\";",zoomLevel];
    [self stringByEvaluatingJavaScriptFromString:js];
}

@end
