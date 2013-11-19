//
//  DocReaderWindow.m
//  DocReader
//
//  Created by pei hao on 13-11-19.
//  Copyright (c) 2013年 pei hao. All rights reserved.
//

#import "DocReaderWindow.h"
#import "DocNavWebview.h"

@implementation DocReaderWindow

- (void)keyDown:(NSEvent *)theEvent {
    
    if ([theEvent modifierFlags] & NSCommandKeyMask) {
        
        if ([theEvent.characters isEqualToString:@"f"]) {
            
            [webview showSearch:self];
        } else if ([theEvent.characters isEqualToString:@"="]) {
            
            [webview zoomOut:self];
        } else if ([theEvent.characters isEqualToString:@"-"]) {
            
            [webview zoomIn:self];
        } else if ([theEvent.characters isEqualToString:@"0"]) {
            
            [webview resetZoom:self];
        }
        return;
    }
    
    if ([webview canNotSpeak]) {
        return;
    }
    
    DOMRange *ff = [webview selectedDOMRange];
    
    NSString *word = [ff text];
    if ([word length]==0)
        return;
    
    if (webview.docNavWebviewDelegate && [webview.docNavWebviewDelegate conformsToProtocol:@protocol(DocNavWebviewDelegate)]) {
        
        if ([theEvent.characters isEqualToString:@"a"])
            [webview.docNavWebviewDelegate speak:word];
        else if([theEvent.characters isEqualToString:@"s"])
            [webview.docNavWebviewDelegate showDictionary:word];
        else if (([theEvent.characters isEqualToString:@"d"]))
            [webview.docNavWebviewDelegate translate:word];
    }
}

@end
