//
//  TauContentInspectorSubViews.m
//  Tau4Mac
//
//  Created by Tong G. on 3/31/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauContentInspectorSubViews.h"

// Private
@interface TauContentInspectorNoSelectionSubView ()
@property ( weak ) IBOutlet NSView* noSelectionLabelSection_;
@end // Private

// TauContentInspectorNoSelectionSubView class
@implementation TauContentInspectorNoSelectionSubView
@end // TauContentInspectorNoSelectionSubView class



// ------------------------------------------------------------------------------------------------------------ //



// Private
@interface TauContentInspectorMultipleSelectionsSubView ()
@property ( weak ) IBOutlet NSView* multipleSelectionLabelSection_;
@end // Private

// TauContentInspectorMultipleSelectionsSubView class
@implementation TauContentInspectorMultipleSelectionsSubView
@end // TauContentInspectorMultipleSelectionsSubView class



// ------------------------------------------------------------------------------------------------------------ //



// PriContentDescriptionSectionView_ class
@interface PriContentDescriptionSectionView_ : NSView <NSTextViewDelegate>

@property ( strong, readwrite ) GTLObject* YouTubeContent;

@property ( weak ) IBOutlet NSClipView* clipView_;
@property ( strong ) IBOutlet NSTextView* textView_;

@end

@implementation PriContentDescriptionSectionView_
@end // PriContentDescriptionSectionView_ class



// ------------------------------------------------------------------------------------------------------------ //



// Private
@interface TauContentInspectorSingleSelectionSubView ()
@end // Private

// TauContentInspectorSingleSelectionSubView class
@implementation TauContentInspectorSingleSelectionSubView

#pragma mark - Initializations

- ( void ) awakeFromNib
    {
    // TODO:
    }

@synthesize YouTubeContent = YouTubeContent_;
- ( void ) setYouTubeContent: ( GTLObject* )_New
    {
    YouTubeContent_ = _New;
    }

- ( GTLObject* ) YouTubeContent
    {
    return YouTubeContent_;
    }

#pragma mark - Private
// TODO:

@end // TauContentInspectorSingleSelectionSubView class