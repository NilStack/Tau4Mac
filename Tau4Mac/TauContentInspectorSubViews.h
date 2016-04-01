//
//  TauContentInspectorSubViews.h
//  Tau4Mac
//
//  Created by Tong G. on 3/31/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

// TauContentInspectorNoSelectionSubView class
@interface TauContentInspectorNoSelectionSubView : NSVisualEffectView
@end // TauContentInspectorNoSelectionSubView class



// ------------------------------------------------------------------------------------------------------------ //



// TauContentInspectorSingleSelectionSubView class
@interface TauContentInspectorSingleSelectionSubView : NSView

@property ( strong, readwrite ) GTLObject* YouTubeContent;

@end // TauContentInspectorSingleSelectionSubView class



// ------------------------------------------------------------------------------------------------------------ //



// TauContentInspectorMultipleSelectionsSubView class
@interface TauContentInspectorMultipleSelectionsSubView : NSView
@end // TauContentInspectorMultipleSelectionsSubView class