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
#import "DocSet.h"
#import "SearchResultsViewController.h"

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
    
    if (item == nil) {
        DocNavTreeRootNode* aRootNode = [DocNavTreeRootNode rootItemWithPathArray:self.docSetPathArray];
        rootNode = aRootNode;
        return aRootNode;
    }
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
        NSDictionary* urlInfo = topic.urlInfo;
        NSURL *fileURL = [NSURL fileURLWithPath:[urlInfo objectForKey:@"url"]];
        NSString* anchor = [urlInfo objectForKey:@"anchor"];
        
        NSURL *fullURL = fileURL;
        if (anchor) {
            fullURL = [NSURL URLWithString:[NSString stringWithFormat:@"#%@",anchor] relativeToURL:fileURL];
        }

        if (fileURL) {
            NSString *currentPath = self.docWebview.mainFrame.dataSource.request.URL.path;
            if (![currentPath isEqualToString:fileURL.path]) {
                [[self.docWebview mainFrame] loadRequest:[NSURLRequest requestWithURL:fullURL]];
            } else {
                if (anchor) {
                    NSString* js = [NSString stringWithFormat:@"window.location.href = '#%@';",anchor];
                    [self.docWebview stringByEvaluatingJavaScriptFromString:js];
                }
            }
        }
    }
    return YES;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldEditTableColumn:(NSTableColumn *)tableColumn item:(id)item {

    return NO;
}

- (void)controlTextDidChange:(NSNotification *)notification {

    NSSearchField *searchField = [notification object];
    NSString* word = [searchField stringValue];
    
    if (!searchResultsViewController) {
    
        searchResultsViewController = [[SearchResultsViewController alloc] initWithNibName:@"SearchResultsView" bundle:nil];
        [searchResultsViewController setDocWebView:self.docWebview];
    }
    if (!searchPopover) {
        
        searchPopover = [[NSPopover alloc] init];
        searchPopover.contentViewController = searchResultsViewController;
        searchPopover.behavior = NSPopoverBehaviorSemitransient;
    }
    if (!searchPopover.shown) {
        
        [searchPopover showRelativeToRect:searchField.bounds ofView:searchField preferredEdge:NSMinYEdge];
        [searchField becomeFirstResponder];
        [[searchField currentEditor] moveToEndOfLine:nil];
    }
    
    if (!searchQueue) {
        
        searchQueue = [[NSOperationQueue alloc] init];
    }
    [searchQueue addOperation:[NSBlockOperation blockOperationWithBlock:^{
        NSArray* results;
        for (DocSet* aDocSet in rootNode.docSetArray) {
            results = [aDocSet search:word];
            break;
        }
        dispatch_async(dispatch_get_main_queue(),^{
            
            searchResultsViewController.results = results;
            [searchResultsViewController.resultsTableview reloadData];
        });
    }]];
}


- (IBAction)updateFilter:sender {

}

- (IBAction)Setting:(id)sender {

    [NSApp runModalForWindow:self.settingWindow];
}




@end
