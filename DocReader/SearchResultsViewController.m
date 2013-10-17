//
//  SearchResultsViewController.m
//  DocReader
//
//  Created by pei hao on 13-10-16.
//  Copyright (c) 2013年 pei hao. All rights reserved.
//

#import "SearchResultsViewController.h"
#import "DocSet.h"
#import "DocSetTopic.h"

@interface SearchResultsViewController ()

@end

@implementation SearchResultsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

-(void)setDocWebView:(WebView*)webview {

    docWebview = webview;
}

-(void)setResults:(NSArray*)aResults {

    results = aResults;
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {

    return [results count];
}

- (NSView *)tableView:(NSTableView *)tableView
   viewForTableColumn:(NSTableColumn *)tableColumn
                  row:(NSInteger)row {

    id ret = [results objectAtIndex:row];
    NSString* type = [ret objectForKey:@"ZTYPENAME"];
    NSString* typename = @"";
    NSString* filename = @"class.png";
    if ([type isEqualToString:@"cl"]) {
        
        typename = @"Class";
        
    } else if ([type isEqualToString:@"func"]) {
    
        typename = @"function";
        filename = @"function.jpg";
    }
    
    else {
    
        typename = type;
    }
    if ([tableColumn.identifier isEqualToString:@"left"]) {
        
        NSTableCellView* cell = [tableView makeViewWithIdentifier:@"LEFT_CELL" owner:self];
        [cell.textField setStringValue:typename];
        return cell;
    }else {
        
        NSTableCellView* cell = [tableView makeViewWithIdentifier:@"RIGHT_CELL" owner:self];
        NSString* tokenName = [ret objectForKey:@"ZTOKENNAME"];
        [cell.textField setStringValue:tokenName];
        cell.imageView.image = [NSImage imageNamed:@"class.png"];
        return cell;
    }
}

- (BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row {

    NSDictionary* data = [results objectAtIndex:row];
    NSString* nodeid = [data objectForKey:@"ZPARENTNODE"];
    DocSetTopic* topic = [[data objectForKey:@"DocSet"] topicWithNodeID:nodeid];
    NSDictionary* urlInfo = topic.urlInfo;
    NSURL* url = [NSURL fileURLWithPath:[urlInfo objectForKey:@"url"]];
    if (url) {
        [[docWebview mainFrame]
         loadRequest:
         [NSURLRequest requestWithURL:url]];
        NSString* anchor = [urlInfo objectForKey:@"anchor"];
        if (anchor) {
            
            NSString* js = [NSString stringWithFormat:@"window.location.href = '#%@';",anchor];
            [docWebview stringByEvaluatingJavaScriptFromString:js];
        }
    }
    return YES;
}

@end
