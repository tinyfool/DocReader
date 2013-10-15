//
//  DocNavTreeDataSource.m
//  DocReader
//
//  Created by pei hao on 13-10-11.
//  Copyright (c) 2013年 pei hao. All rights reserved.
//

#import "MainDelegate.h"
#import "DocNavTreeNode.h"
#import "DocNavTreeRootNode.h"
#import "DocNavTreeTopicNode.h"
#import "SettingWindow.h"

#define USER_docSetPaths @"USER_docSetPaths"
@implementation MainDelegate


-(NSArray*)docSetPathArray {

    if (!docSetPathArray) {
     
        NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
        NSArray* paths = [userDefaults objectForKey:USER_docSetPaths];
        if (paths) {
            docSetPathArray = paths;
        }else {
        
            docSetPathArray = [NSArray array];
        }
    }
    return docSetPathArray;
}

-(void)setDocSetPathArray:(NSArray*)array {

    if (!array)
        return;
    docSetPathArray = array;
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:docSetPathArray forKey:USER_docSetPaths];
    [userDefaults synchronize];
    [DocNavTreeRootNode clearRootNode];
    [self.outlineView reloadData];
}

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item {
    
    if (item==nil)
        return 1;
    else
        return [(DocNavTreeNode*)item numberOfChildren];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item {

    if (item == nil)
        return YES;

    if ([(DocNavTreeNode*)item numberOfChildren] != -1)
        return YES;
    
    return NO;
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item {
    
    if (item == nil)
        return [DocNavTreeRootNode rootItemWithPathArray:self.docSetPathArray];

    return [(DocNavTreeNode *)item childAtIndex:index];
}

- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item {
    
    DocNavTreeNode* node = item;
    if (node == nil)
        return @"文档库";
    
    return [item label];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldSelectItem:(id)item {

    if ([[item class] isSubclassOfClass:[DocNavTreeTopicNode class]]) {
        
        DocNavTreeTopicNode* topic = (DocNavTreeTopicNode*)item;
        NSURL* url = [NSURL fileURLWithPath:topic.Url];
        if (url) {
            [[self.docWebview mainFrame]
             loadRequest:
             [NSURLRequest requestWithURL:url]];
        }
    }
    return YES;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldEditTableColumn:(NSTableColumn *)tableColumn item:(id)item {

    return NO;
}

- (IBAction)updateFilter:sender {

    NSSearchField* searchField = (NSSearchField*) sender;
    NSLog(@"%@",[searchField stringValue]);
}

- (IBAction)Setting:(id)sender {

    [NSApp runModalForWindow:self.settingWindow];
}
@end
