//
//  TauContentInspectorCandidates.m
//  Tau4Mac
//
//  Created by Tong G. on 3/31/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauContentInspectorCandidates.h"

#import "TauYouTubeContentInspector.h"

// TauContentInspectorNoSelectionCandidate class
@interface TauContentInspectorNoSelectionCandidate ()
@property ( weak ) IBOutlet NSView* noSelectionLabelSection_;
@end

@implementation TauContentInspectorNoSelectionCandidate
@end // TauContentInspectorNoSelectionCandidate class



// ---------------------------------------------------



// TauContentInspectorMultipleSelectionsCandidate class
@interface TauContentInspectorMultipleSelectionsCandidate ()
@property ( weak ) IBOutlet NSView* multipleSelectionLabelSection_;
@end

@implementation TauContentInspectorMultipleSelectionsCandidate
@end // TauContentInspectorMultipleSelectionsCandidate class



// ---------------------------------------------------



// TauContentInspectorSingleSelectionCandidate class
@interface TauContentInspectorSingleSelectionCandidate ()
@property ( weak ) IBOutlet TauYouTubeContentInspector* contentInspector_;
@end

@implementation TauContentInspectorSingleSelectionCandidate

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
    }

- ( GTLObject* ) YouTubeContent
    {
    return YouTubeContent_;
    }

#pragma mark - Private
// TODO:

@end // TauContentInspectorSingleSelectionCandidate class