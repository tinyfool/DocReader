//
//  SettingWindow.m
//  DocReader
//
//  Created by pei hao on 13-10-14.
//  Copyright (c) 2013年 pei hao. All rights reserved.
//

#import "SettingWindow.h"
#import "MainDelegate.h"
#import "DocSet.h"

@implementation SettingWindow

-(NSArray*)searchPaths {

    if (!searchPaths) {
        
        searchPaths = [[NSArray alloc] initWithObjects:
                       @"/Applications/Xcode.app/Contents/Developer/Documentation/DocSets",
                       [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Developer/Shared/Documentation/DocSets"],
                       @"/Library/Developer/Shared/Documentation/DocSets",
                       @"/Network/Library/Developer/Shared/Documentation/DocSets",
                       @"/System/Library/Developer/Shared/Documentation/DocSets",
                       nil];
    }
    return searchPaths;
}

-(IBAction)checkboxChanged:(id)sender{

    NSButton* checkbox = (NSButton*)sender;
    NSTableCellView* cell = (NSTableCellView*)[checkbox superview];
    DocSet* docSet = cell.objectValue;
    NSString* path = docSet.path;
    NSMutableArray* array =  [self.mainDelegate.docSetPathArray mutableCopy];
    if (checkbox.state == NSOnState) {
        
        if (![array containsObject:path]) {
            
            [array addObject:path];
            self.mainDelegate.docSetPathArray = array;
        }
    }
    else {
    
        if ([array containsObject:path]) {
            
            [array removeObject:path];
            self.mainDelegate.docSetPathArray = array;
        }
    }
}

-(NSArray*)docSets {

    if (!docSets) {
        
        docSets = [self reLoadDocsets];
    }
    return docSets;
}

- (NSArray*)reLoadDocsets {

    NSMutableArray* tempDocsetArray = [[NSMutableArray alloc] initWithCapacity:100];
    NSArray* paths = [self searchPaths];
    NSFileManager* fileManager = [NSFileManager defaultManager];
    for (NSString* path in paths) {
        
        [tempDocsetArray addObject:path];
        NSArray* files = [fileManager contentsOfDirectoryAtPath:path error:nil];
        for (NSString* filePath in files) {
            
            if ([[filePath pathExtension] isEqualToString:@"docset"]) {
                
                DocSet* tempDocSet = [[DocSet alloc] initWithPath:[path stringByAppendingPathComponent:filePath]];
                if (tempDocSet)
                    [tempDocsetArray addObject:tempDocSet];
            }
        }
    }
    return tempDocsetArray;
}


- (void)close {

    [NSApp stopModal];
    [NSApp endSheet:self];
    [self orderOut:self];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView {

    return [[self docSets] count];
}

- (id)tableView:(NSTableView *)aTableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    
    id item = [[self docSets] objectAtIndex:row];
    if ([[item class] isSubclassOfClass:[NSString class]]) {
        
        NSTextField* cell = [aTableView makeViewWithIdentifier:@"GROUP_CELL" owner:self];
        [cell setStringValue:item];
        return cell;
    } else if([[item class] isSubclassOfClass:[DocSet class]]){
     
        DocSet* docSet = item;
        NSTableCellView* cell = [aTableView makeViewWithIdentifier:@"DOCSET_CELL" owner:self];
        cell.objectValue = item;
        [cell.textField setStringValue:docSet.name];
        NSButton* checkbox = [cell viewWithTag:37211];
        checkbox.target = self;
        checkbox.action = @selector(checkboxChanged:);
        if ([[self.mainDelegate docSetPathArray] containsObject:docSet.path]) {
            checkbox.state  = NSOnState;
        }
        else {
            checkbox.state  = NSOffState;
        }
        return cell;
    }
    return nil;
}

- (BOOL)tableView:(NSTableView *)tableView isGroupRow:(NSInteger)row {

    id item = [[self docSets] objectAtIndex:row];
    if ([[item class] isSubclassOfClass:[NSString class]]) {
        return YES;
    }
    return NO;
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
    
    id item = [[self docSets] objectAtIndex:row];
    if ([[item class] isSubclassOfClass:[NSString class]]) {
    
        return 21.0;
    }
    else {
        return 47.0;
    }
}


@end
