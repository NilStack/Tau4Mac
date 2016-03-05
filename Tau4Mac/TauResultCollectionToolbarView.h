//
//  TauResultCollectionToolbarView.h
//  Tau4Mac
//
//  Created by Tong G. on 3/5/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

// TauResultCollectionToolbarView class
@interface TauResultCollectionToolbarView : NSVisualEffectView

#pragma mark - Outlets

@property ( weak ) IBOutlet NSSegmentedControl* segPager;
@property ( weak ) IBOutlet NSButton* dismissButton;

@end // TauResultCollectionToolbarView class