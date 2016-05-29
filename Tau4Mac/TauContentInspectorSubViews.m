//
//  TauContentInspectorSubViews.m
//  Tau4Mac
//
//  Created by Tong G. on 3/31/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauContentInspectorSubViews.h"

#import "TauYouTubeContentInspector.h"

// TauContentInspectorNoSelectionSubView class
@interface TauContentInspectorNoSelectionSubView ()
@property ( weak ) IBOutlet NSView* noSelectionLabelSection_;
@end

@implementation TauContentInspectorNoSelectionSubView
@end // TauContentInspectorNoSelectionSubView class



// ---------------------------------------------------



// TauContentInspectorMultipleSelectionsSubView class
@interface TauContentInspectorMultipleSelectionsSubView ()
@property ( weak ) IBOutlet NSView* multipleSelectionLabelSection_;
@end

@implementation TauContentInspectorMultipleSelectionsSubView
@end // TauContentInspectorMultipleSelectionsSubView class



// ---------------------------------------------------



// TauContentInspectorSingleSelectionSubView class
@interface TauContentInspectorSingleSelectionSubView ()
@property ( weak ) IBOutlet TauYouTubeContentInspector* contentInspector_;
@end

@implementation TauContentInspectorSingleSelectionSubView

#pragma mark - Initializations

// ------------------------------------------------------
/// setup UI
- ( void ) awakeFromNib
// ------------------------------------------------------
    {
    // TODO:

    [ self addSubview: [ self.contentInspector_ configureForAutoLayout ] ];
    [ self.contentInspector_ autoPinEdgesToSuperviewEdges ];
    }

@synthesize YouTubeContent = YouTubeContent_;
- ( void ) setYouTubeContent: ( GTLObject* )_New
    {
    YouTubeContent_ = _New;
    self.contentInspector_.YouTubeContent = YouTubeContent_;
    }

- ( GTLObject* ) YouTubeContent
    {
    return YouTubeContent_;
    }

#pragma mark - Private
// TODO:

@end // TauContentInspectorSingleSelectionSubView class