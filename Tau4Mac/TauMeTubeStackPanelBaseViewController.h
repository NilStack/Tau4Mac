//
//  TauMeTubeStackPanelBaseViewController.h
//  Tau4Mac
//
//  Created by Tong G. on 3/7/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauAbstractStackViewItem.h"

// TauMeTubeStackPanelBaseViewController class
@interface TauMeTubeStackPanelBaseViewController : TauAbstractStackViewItem

@property ( weak ) IBOutlet NSSegmentedControl* subPanelSegSwitcher;
@property ( weak ) IBOutlet NSView* subPanelSegSwitcherPanel;

@end // TauMeTubeStackPanelBaseViewController class