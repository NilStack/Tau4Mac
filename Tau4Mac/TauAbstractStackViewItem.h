//
//  TauAbstractStackViewItem.h
//  Tau4Mac
//
//  Created by Tong G. on 3/5/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//


@class TauAbstractStackPanelController;

// TauAbstractStackViewItem class
@interface TauAbstractStackViewItem : NSViewController

@property ( weak, readwrite ) TauAbstractStackPanelController* hostStack;

- ( void ) cleanUp;

@end // TauAbstractStackViewItem class