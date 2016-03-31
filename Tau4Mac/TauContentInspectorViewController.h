//
//  TauContentInspectorViewController.h
//  Tau4Mac
//
//  Created by Tong G. on 3/23/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

@class TauAbstractContentInspectorView;

typedef NS_ENUM ( NSInteger, TauContentInspectorMode )
    { TauContentInspectorNoSelectionMode       = 0
    , TauContentInspectorSingleSelectionMode   = 1
    , TauContentInspectorMultipleSelectionMode = 2
    };

// TauContentInspectorViewController class
@interface TauContentInspectorViewController : NSViewController

@property ( strong, readwrite ) NSArray <GTLObject*>* YouTubeContents;   // KVB-Compliant
@property ( assign, readonly ) TauContentInspectorMode mode;    // KVB-Compliant

@end // TauContentInspectorViewController class