//
//  TauResultsCollectionToolbar.h
//  Tau4Mac
//
//  Created by Tong G. on 3/5/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

@class TauResultsCollectionSummaryView;

// TauResultsCollectionToolbar class
@interface TauResultsCollectionToolbar : NSView

@property ( strong ) GTLCollectionObject* ytCollectionObject;

#pragma mark - Outlets

@property ( weak ) IBOutlet NSSegmentedControl* segPager;
@property ( weak ) IBOutlet TauResultsCollectionSummaryView* titleView;
@property ( weak ) IBOutlet NSButton* dismissButton;

@end // TauResultsCollectionToolbar class