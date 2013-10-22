//
//  SearchResultsViewController.h
//  DocReader
//
//  Created by pei hao on 13-10-16.
//  Copyright (c) 2013年 pei hao. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

@protocol SearchResultsViewControllerDelegate;
@interface SearchResultsViewController : NSViewController<NSTableViewDataSource,NSTableViewDelegate> {

    NSArray* results;
}
@property (weak) id<SearchResultsViewControllerDelegate> delegate;

@property (weak) IBOutlet NSTableView *resultsTableview;

-(void)setResults:(NSArray*)aResults;
@end

@protocol SearchResultsViewControllerDelegate <NSObject>
@optional
- (void)searchResultsViewController:(SearchResultsViewController *)vc didSelectedItem:(id)item;

@end