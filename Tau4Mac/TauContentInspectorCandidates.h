//
//  TauContentInspectorCandidates.h
//  Tau4Mac
//
//  Created by Tong G. on 3/31/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

// TauContentInspectorNoSelectionCandidate class
@interface TauContentInspectorNoSelectionCandidate : NSVisualEffectView
@end // TauContentInspectorNoSelectionCandidate class



// ------------------------------------------------------------------------------------------------------------ //



// TauContentInspectorSingleSelectionCandidate class
@interface TauContentInspectorSingleSelectionCandidate : NSVisualEffectView
@property ( strong, readwrite ) GTLObject* YouTubeContent;
@end // TauContentInspectorSingleSelectionCandidate class



// ------------------------------------------------------------------------------------------------------------ //



// TauContentInspectorMultipleSelectionsSubView class
@interface TauContentInspectorMultipleSelectionsSubView : NSVisualEffectView
@end // TauContentInspectorMultipleSelectionsSubView class