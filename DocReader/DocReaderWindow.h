//
//  DocReaderWindow.h
//  DocReader
//
//  Created by pei hao on 13-11-19.
//  Copyright (c) 2013年 pei hao. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class DocNavWebview;
@interface DocReaderWindow : NSWindow
{

    IBOutlet DocNavWebview* webview;
}
@end
