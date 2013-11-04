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
#import "DictionaryViewController.h"
#import "DocNavWebview.h"

@interface MainDelegate () <SearchResultsViewControllerDelegate>

@end

#define USER_docSetPaths @"USER_docSetPaths"
@implementation MainDelegate

- (void)awakeFromNib
{
    [self reloadData];
    self.docWebview.DocNavWebviewDelegate = self;
}

- (void)reloadData
{
    [DocNavTreeRootNode clearRootNode];
    DocNavTreeRootNode* aRootNode = [DocNavTreeRootNode rootItemWithPathArray:self.docSetPathArray];
    rootNode = aRootNode;
    self.nodes = [[aRootNode children] mutableCopy];

}

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
    
    [self reloadData];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldSelectItem:(id)item {

    id node = [item representedObject];
    
    if ([[node class] isSubclassOfClass:[DocNavTreeTopicNode class]]) {
        
        [self.docWebview showCatalog:NO];
        [self loadContentOfTopic:node];
    }
    return YES;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldEditTableColumn:(NSTableColumn *)tableColumn item:(id)item {

    return NO;
}

- (void)loadContentOfTopic:(DocNavTreeTopicNode *)topic
{
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

- (void)controlTextDidChange:(NSNotification *)notification {

    NSSearchField *searchField = [notification object];
    NSString* word = [searchField stringValue];

    if (!searchResultsViewController) {
    
        searchResultsViewController = [[SearchResultsViewController alloc] initWithNibName:@"SearchResultsView" bundle:nil];
        searchResultsViewController.delegate = self;
        searchResultsViewController.navWebview = self.docWebview;
        [searchResultsViewController setDocsetSelector:docsetSelector];
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
        NSMutableArray* results = [NSMutableArray array];
        for (DocSet* aDocSet in rootNode.docSetArray) {
            NSArray *aResults = [aDocSet search:word];
            [results addObjectsFromArray:aResults];
        }
        NSArray* combineResults = [DocSet combineSearchResults:results];
        dispatch_async(dispatch_get_main_queue(),^{
            
            searchResultsViewController.results = combineResults;
            [searchResultsViewController.resultsTableview reloadData];
        });
    }]];
}

- (void)searchResultsViewController:(SearchResultsViewController *)vc didSelectedItem:(id)item
{
    [self loadContentOfTopic:item];
}

- (IBAction)updateFilter:sender {

}

- (IBAction)Setting:(id)sender {

    [NSApp runModalForWindow:self.settingWindow];
}

-(void)showDictionaryView {

    if (!dictionaryViewController) {
        
        dictionaryViewController = [[DictionaryViewController alloc] initWithNibName:@"DictionaryViewController" bundle:nil];
    }
    if (!dictionaryPopover) {
        
        dictionaryPopover = [[NSPopover alloc] init];
        dictionaryPopover.contentViewController = dictionaryViewController;
        dictionaryPopover.behavior = NSPopoverBehaviorSemitransient;
    }
    if (!dictionaryPopover.shown) {
        
        [dictionaryPopover showRelativeToRect:self.dictionaryButton.bounds ofView:self.dictionaryButton preferredEdge:NSMinYEdge];
    }
    [dictionaryViewController setWord:@"" andDefinition:@""];
}

- (IBAction)dictionary:(id)sender {
 
    [self showDictionaryView];
}

-(NSSpeechSynthesizer*)speech {
    
    if (!speech) {
        
        speech = [[NSSpeechSynthesizer alloc] initWithVoice:nil];
    }
    return speech;
}

-(void)speak:(NSString*)word {

    [[self speech] startSpeakingString:word];

}

-(void)translate:(NSString*)word {


}

-(void)showDictionary:(NSString*)word {

    [[self speech] startSpeakingString:word];
    [self showDictionaryView];
    CFRange range = DCSGetTermRangeInString(NULL,(__bridge CFStringRef)word,0);
    NSString* result =  (__bridge NSString *)(DCSCopyTextDefinition(NULL,(__bridge CFStringRef)word,range));
    NSString* newWord = [word substringWithRange:NSMakeRange(range.location, range.length)];
    if (dictionaryViewController)
        [dictionaryViewController setWord:newWord andDefinition:result];
}

- (IBAction)docsetSelected:(id)sender {

    if (searchResultsViewController) {
        
        [searchResultsViewController docsetSelected:sender];
    }
}

@end
