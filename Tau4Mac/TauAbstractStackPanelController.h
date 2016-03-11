//
//  TauAbstractStackPanelController.h
//  Tau4Mac
//
//  Created by Tong G. on 3/5/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

@class TauAbstractStackViewItem;
@class TauViewsStack;

// TauAbstractStackPanelController class
@interface TauAbstractStackPanelController : NSViewController
    {
@protected
    TauViewsStack __strong* viewsStack_;
    NSArray <NSLayoutConstraint*> __strong* constraintsCache_;
    }

#pragma mark - Stack Operations

- ( void ) cleanUp;

- ( void ) pushView: ( TauAbstractStackViewItem* )_NewItem;
- ( void ) popView;

@end // TauAbstractStackPanelController class