//
//  DictionaryViewController.h
//  DocReader
//
//  Created by pei hao on 13-10-31.
//  Copyright (c) 2013年 pei hao. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface DictionaryViewController : NSViewController {

    IBOutlet NSSearchField* searchField;
    IBOutlet NSTextView* textView;
}
-(void)setWord:(NSString*)word andDefinition:(NSString*)definition;
-(NSString*)formatDefinition:(NSString*)definition withWord:(NSString*)word;
@end
