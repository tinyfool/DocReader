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

    id ret = [results objectAtIndex:row];
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

- (BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row {
    NSDictionary* data = [results objectAtIndex:row];
    NSString* nodeid = [data objectForKey:@"ZPARENTNODE"];
    DocSetTopic* topic = [[data objectForKey:@"DocSet"] topicWithNodeID:nodeid];
    if ([self.delegate respondsToSelector:@selector(searchResultsViewController:didSelectedItem:)]) {
        [self.delegate searchResultsViewController:self didSelectedItem:topic];
    }
    return YES;
}

@end
