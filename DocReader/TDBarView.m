//
//  InPageSearchViewController.m
//  DocReader
//
//  Created by pei hao on 13-11-2.
//  Copyright (c) 2013年 pei hao. All rights reserved.
//

#import "TDBarView.h"

@interface TDBarView ()

@end

@implementation TDBarView
- (void)drawRect:(NSRect)dirtyRect {

    [[NSColor grayColor] setFill];
    NSRectFill(dirtyRect);
    [super drawRect:dirtyRect];
}

@end
