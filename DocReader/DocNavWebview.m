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
        
        if ([theEvent.characters isEqualToString:@"f"]) {
            
            [self showSearch:YES];
        }
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
@end
