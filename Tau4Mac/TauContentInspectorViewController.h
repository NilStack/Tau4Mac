//
//  TauContentInspectorViewController.h
//  Tau4Mac
//
//  Created by Tong G. on 3/23/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

@class TauContentInspectorView;

// TauContentInspectorViewController class
@interface TauContentInspectorViewController : NSViewController

@property ( strong, readwrite ) NSArray <GTLObject*>* ytContents;

@end // TauContentInspectorViewController class



// ------------------------------------------------------------------------------------------------------------ //



//TauContentInspectorView class
@interface TauContentInspectorView : NSView
@end //TauContentInspectorView class