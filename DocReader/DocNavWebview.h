//
//  DocNavWebview.h
//  DocReader
//
//  Created by pei hao on 13-10-31.
//  Copyright (c) 2013年 pei hao. All rights reserved.
//

#import <WebKit/WebKit.h>
@protocol DocNavWebviewDelegate;
@interface DocNavWebview : WebView {
    
    NSSpeechSynthesizer* speech;
    
}

@property id<DocNavWebviewDelegate> docNavWebviewDelegate;


@end

@protocol DocNavWebviewDelegate <NSObject>
@optional

-(void)showDictionary:(NSString*)word;
-(void)speak:(NSString*)word;
-(void)translate:(NSString*)word;
@end
