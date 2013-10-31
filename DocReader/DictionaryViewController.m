//
//  DictionaryViewController.m
//  DocReader
//
//  Created by pei hao on 13-10-31.
//  Copyright (c) 2013年 pei hao. All rights reserved.
//

#import "DictionaryViewController.h"

@interface DictionaryViewController ()

@end

@implementation DictionaryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

-(void)setWord:(NSString*)word andDefinition:(NSString*)definition {
    
    [searchField setStringValue:word];
    [textView setString:[self formatDefinition:definition withWord:word]];
}

-(NSString*)formatDefinition:(NSString*)definition withWord:(NSString*)word {

    definition = [definition stringByReplacingOccurrencesOfString:@" A." withString:@"\r\n\r\nA."];
    definition = [definition stringByReplacingOccurrencesOfString:@" B." withString:@"\r\n\r\nB."];
    definition = [definition stringByReplacingOccurrencesOfString:@" C." withString:@"\r\n\r\nC."];

    definition = [definition stringByReplacingOccurrencesOfString:@"noun " withString:@"noun\r\n"];
    
    definition = [definition stringByReplacingOccurrencesOfString:@"①" withString:@"\r\n  ①"];
    definition = [definition stringByReplacingOccurrencesOfString:@"②" withString:@"\r\n  ②"];
    definition = [definition stringByReplacingOccurrencesOfString:@"③" withString:@"\r\n  ③"];
    definition = [definition stringByReplacingOccurrencesOfString:@"④" withString:@"\r\n  ④"];
    definition = [definition stringByReplacingOccurrencesOfString:@"⑤" withString:@"\r\n  ⑤"];
    definition = [definition stringByReplacingOccurrencesOfString:@"⑥" withString:@"\r\n  ⑥"];
    return definition;
}
@end
