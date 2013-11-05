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
#import "DocNavWebview.h"

@interface SearchResultsViewController ()

@end

@implementation SearchResultsViewController
@synthesize navWebview;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

-(void)setResults:(NSArray*)aResults {

    results = aResults;
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {

    return [results count];
}

- (NSString *)readableTypeNameForDatabaseType:(NSString *)type
{
    static NSDictionary *map = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        map = @{
                @"cat":@"",
                @"cl":@"Class",
                @"clm":@"", //Class Method
                @"data":@"Data",
                @"econst":@"",
                @"func":@"function",
                @"instm":@"", //Instance Method
                @"instp":@"", //Instance Property
                @"intf":@"",
                @"intfm":@"",
                @"intfp":@"",
                @"macro":@"macro",
                @"tag":@"tag",
                @"tdef":@"typedef",
                };

    });
    NSString *readable = map[type];
    if (readable.length == 0) {
        if (!readable) {NSLog(@"[DEBUG]missing type: %@",type);}
        readable = type;
    }
    return readable;
}

- (NSString *)imageFileNameForDatabaseType:(NSString *)type
{
    static NSDictionary *map = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        map = @{
                @"cl":@"class.png",
                @"func":@"function.jpg",
                };
    });
    NSString *fileName = map[type];
    if (fileName.length == 0) {
        fileName = @"class.png";
    }
    return fileName;

}

- (NSView *)tableView:(NSTableView *)tableView
   viewForTableColumn:(NSTableColumn *)tableColumn
                  row:(NSInteger)row {

    NSDictionary* kwDict = [results objectAtIndex:row];
    id ret = [kwDict objectForKey:[[kwDict allKeys] objectAtIndex:0]];
    NSString* type = [ret objectForKey:@"ZTYPENAME"];
    NSString* typename = [self readableTypeNameForDatabaseType:type];
    NSString* filename =  [self imageFileNameForDatabaseType:type];
    
    if ([tableColumn.identifier isEqualToString:@"left"]) {
        
        NSTableCellView* cell = [tableView makeViewWithIdentifier:@"LEFT_CELL" owner:self];
        [cell.textField setStringValue:typename];
        return cell;
    }else {
        
        NSTableCellView* cell = [tableView makeViewWithIdentifier:@"RIGHT_CELL" owner:self];
        NSString* tokenName = [ret objectForKey:@"ZTOKENNAME"];
        [cell.textField setStringValue:tokenName];
        cell.imageView.image = [NSImage imageNamed:filename];
        return cell;
    }
}

- (void)makeSegment:(NSDictionary*)kwData {

    NSArray* keys = [kwData allKeys];
    if ([keys count]==1) {
        [docsetSelector setHidden:YES];
        [self.navWebview showCatalog:NO];
        return;
    }
    [docsetSelector setHidden:NO];
    [self.navWebview showCatalog:YES];
    NSMutableArray* returnArray = [NSMutableArray array];
    [docsetSelector setSegmentCount:[keys count]];
    int n = 0;
    for (NSString* key in keys) {
        
        NSDictionary* line = [kwData objectForKey:key];
        [returnArray addObject:line];
        DocSet* docset = [line objectForKey:@"DocSet"];
        [docsetSelector setLabel:docset.name forSegment:n];
        [docsetSelector setWidth:100 forSegment:n];
        n++;
    }
    docsetSelector.selectedSegment = 0;
    segmentArray = returnArray;
}

- (BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row {
    
    NSDictionary* kwData = [results objectAtIndex:row];
    [self makeSegment:kwData];
    NSDictionary* data = [kwData objectForKey:[[kwData allKeys] objectAtIndex:0]];
    DocSetTopic* topic = [[data objectForKey:@"DocSet"] topicWithSearchResult:data];
    if ([self.delegate respondsToSelector:@selector(searchResultsViewController:didSelectedItem:)]) {
        [self.delegate searchResultsViewController:self didSelectedItem:topic];
    }
    return YES;
}

-(void)setDocsetSelector:(id)sender {

    docsetSelector = sender;
}

-(void)setCatalogBarView:(id)sender {

    catalogBarView = sender;
}

- (void)docsetSelected:(id)sender {
    
    NSInteger sel = docsetSelector.selectedSegment;
    NSDictionary* data = [segmentArray objectAtIndex:sel];
    DocSetTopic* topic = [[data objectForKey:@"DocSet"] topicWithSearchResult:data];
    if ([self.delegate respondsToSelector:@selector(searchResultsViewController:didSelectedItem:)]) {
        [self.delegate searchResultsViewController:self didSelectedItem:topic];
    }
}
@end
