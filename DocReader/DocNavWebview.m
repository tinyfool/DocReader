//
//  DocNavWebview.m
//  DocReader
//
//  Created by pei hao on 13-10-31.
//  Copyright (c) 2013年 pei hao. All rights reserved.
//

#import "DocNavWebview.h"
#import "TDBarView.h"

@implementation DocNavWebview
@synthesize docNavWebviewDelegate;



- (void)keyDown:(NSEvent *)theEvent {
    
    
    
    if ([theEvent modifierFlags] & NSCommandKeyMask) {
        
        float textSize;
        textSize = [self textSizeMultiplier];
        if ([theEvent.characters isEqualToString:@"f"]) {
            
            [self showSearch:YES];
        } else if ([theEvent.characters isEqualToString:@"="]) {
        
            textSize = textSize * 1.2;
            [self setTextSizeMultiplier:textSize];
            
            //once think about method blow
            //http://stackoverflow.com/questions/13192385/scale-html-content-in-webview
            //but this method did scale webview, but mouse selection position has offset...
        } else if ([theEvent.characters isEqualToString:@"-"]) {
        
            textSize = textSize/1.2;
            [self setTextSizeMultiplier:textSize];

        } else if ([theEvent.characters isEqualToString:@"0"]) {
            
            textSize = 1.0;
            [self setTextSizeMultiplier:textSize];
        }
        return;
    }
    if (canNotSpeaking) {
        return;
    }
    DOMRange *ff = [self selectedDOMRange];
    
    NSString *word = [ff text];
    if ([word length]==0)
        return;
    
    if (self.docNavWebviewDelegate && [self.docNavWebviewDelegate conformsToProtocol:@protocol(DocNavWebviewDelegate)]) {
        
        if ([theEvent.characters isEqualToString:@"a"])
            [self.docNavWebviewDelegate speak:word];
        else if([theEvent.characters isEqualToString:@"s"])
            [self.docNavWebviewDelegate showDictionary:word];
        else if (([theEvent.characters isEqualToString:@"d"]))
            [self.docNavWebviewDelegate translate:word];
    }
}

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

-(void)showSearch:(BOOL)show {

    if ([inPageSearchBar isHidden]) {
        [inPageSearchBar setHidden:NO];
        [inPageSearchField becomeFirstResponder];
    }
    else
        [inPageSearchBar setHidden:YES];
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
    NSString* word = [searchField stringValue];
    BOOL found = [self searchFor:word direction:YES caseSensitive:NO wrap:YES];
    if (found) {
        
        [self stringByEvaluatingJavaScriptFromString:
         @"var sel = window.getSelection();\
         if (!sel.isCollapsed) {\
             var selRange = sel.getRangeAt(0);\
             document.designMode = \"on\";\
             sel.removeAllRanges();\
             sel.addRange(selRange);\
             document.execCommand(\"HiliteColor\", false, \"#ffffcc\");\
             sel.removeAllRanges();\
             document.designMode = \"off\";\
         }\
         "];
    }
    [searchField becomeFirstResponder];
    [[searchField currentEditor] moveToEndOfLine:nil];
}

- (BOOL)control:(NSControl *)control textShouldBeginEditing:(NSText *)fieldEditor {
    
    canNotSpeaking = YES;
    return YES;
}
- (BOOL)control:(NSControl *)control textShouldEndEditing:(NSText *)fieldEditor{

    canNotSpeaking = NO;
    return YES;
}

@end
