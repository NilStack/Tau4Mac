//
//  TauSearchResultCollectionToolbar.h
//  Tau4Mac
//
//  Created by Tong G. on 3/5/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

@class TauSearchResultCollectionSummaryView;

// TauSearchResultCollectionToolbar class
@interface TauSearchResultCollectionToolbar : NSView

@property ( strong ) GTLCollectionObject* ytCollectionObject;

#pragma mark - Outlets

@property ( weak ) IBOutlet NSSegmentedControl* segPager;
@property ( weak ) IBOutlet TauSearchResultCollectionSummaryView* titleView;
@property ( weak ) IBOutlet NSButton* dismissButton;

@end // TauSearchResultCollectionToolbar class