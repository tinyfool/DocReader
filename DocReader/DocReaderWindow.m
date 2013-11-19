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
        
        float textSize;
        textSize = [webview textSizeMultiplier];
        if ([theEvent.characters isEqualToString:@"f"]) {
            
            [webview showSearch:self];
        } else if ([theEvent.characters isEqualToString:@"="]) {
            
            textSize = textSize * 1.2;
            [webview setTextSizeMultiplier:textSize];
            
            //once think about method blow
            //http://stackoverflow.com/questions/13192385/scale-html-content-in-webview
            //but this method did scale webview, but mouse selection position has offset...
        } else if ([theEvent.characters isEqualToString:@"-"]) {
            
            textSize = textSize/1.2;
            [webview setTextSizeMultiplier:textSize];
            
        } else if ([theEvent.characters isEqualToString:@"0"]) {
            
            textSize = 1.0;
            [webview setTextSizeMultiplier:textSize];
        }
        return;
    }
    
    if (webview.canNotSpeaking) {
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
