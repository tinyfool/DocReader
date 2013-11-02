//
//  DocNavWebview.m
//  DocReader
//
//  Created by pei hao on 13-10-31.
//  Copyright (c) 2013年 pei hao. All rights reserved.
//

#import "DocNavWebview.h"

@implementation DocNavWebview
@synthesize docNavWebviewDelegate;

- (void)keyDown:(NSEvent *)theEvent {
    
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

@end
