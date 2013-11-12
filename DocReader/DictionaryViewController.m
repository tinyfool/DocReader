//
//  DictionaryViewController.m
//  DocReader
//
//  Created by pei hao on 13-10-31.
//  Copyright (c) 2013年 pei hao. All rights reserved.
//

#import "DictionaryViewController.h"
#import "AppDelegate.h"
#import "NewWords.h"
@interface DictionaryViewController ()

@end

@implementation DictionaryViewController
@synthesize managedObjectContext = _managedObjectContext;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        _managedObjectContext = [(AppDelegate*)[[NSApplication sharedApplication] delegate] managedObjectContext];
    }
    return self;
}

- (BOOL)validateMyAttribute:(NSString *)value{
    // Return NO if there is already an object with a myAtribute of value
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"NewWords" inManagedObjectContext:self.managedObjectContext];
    request.predicate = [NSPredicate predicateWithFormat:@"word = %@", value];
    NewWords* existWord = [[self.managedObjectContext executeFetchRequest:request error:nil] firstObject];
    if (existWord) {
        return NO;
    }
    return YES;
}

-(void)setWord:(NSString*)word andDefinition:(NSString*)definition {
    
    [searchField setStringValue:word];
    [textView setString:[self formatDefinition:definition withWord:word]];
    if (word && [word length]>0) {
        
        if (![self validateMyAttribute:word]) {
            return;
        }

        NewWords *newWord = [NSEntityDescription
                             insertNewObjectForEntityForName:@"NewWords"
                             inManagedObjectContext:self.managedObjectContext];
        newWord.word = word;
        newWord.addDate = [NSDate date];
        [self.managedObjectContext save:nil];
    }
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

- (BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row {

    NewWords* object = [arrayController.selectedObjects firstObject];
    NSString* word = object.word;
    CFRange range = DCSGetTermRangeInString(NULL,(__bridge CFStringRef)word,0);
    NSString* result =  (__bridge NSString *)(DCSCopyTextDefinition(NULL,(__bridge CFStringRef)word,range));
    NSString* newWord = [word substringWithRange:NSMakeRange(range.location, range.length)];
    [self setWord:newWord andDefinition:result];
    return YES;
}
@end
