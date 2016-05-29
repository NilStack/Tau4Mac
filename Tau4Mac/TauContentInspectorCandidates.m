//
//  TauContentInspectorCandidates.m
//  Tau4Mac
//
//  Created by Tong G. on 3/31/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauContentInspectorCandidates.h"

#import "TauContentInspectorSingleSelectionCandidate.h"

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