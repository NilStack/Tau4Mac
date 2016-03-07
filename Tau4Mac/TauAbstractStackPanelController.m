//
//  TauAbstractStackPanelController.m
//  Tau4Mac
//
//  Created by Tong G. on 3/5/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauAbstractStackPanelController.h"
#import "TauViewsStack.h"
#import "TauStackViewItem.h"

// TauAbstractStackPanelController class
@interface TauAbstractStackPanelController ()
@end

@implementation TauAbstractStackPanelController

- ( void ) pushView: ( TauStackViewItem* )_NewItem
    {
    if ( constraintsCache_ )
        [ self.view removeConstraints: constraintsCache_ ];

    [ viewsStack_.currentView.view removeFromSuperview ];

    [ viewsStack_ pushView: _NewItem ];
    [ self.view addSubview: viewsStack_.currentView.view ];
    constraintsCache_ = [ viewsStack_.currentView.view autoPinEdgesToSuperviewEdges ];
    }

- ( void ) popView
    {
    if ( constraintsCache_ )
        [ self.view removeConstraints: constraintsCache_ ];

    [ viewsStack_.currentView.view removeFromSuperview ];

    [ viewsStack_ popView ];
    [ self.view addSubview: viewsStack_.currentView.view ];
    constraintsCache_ = [ viewsStack_.currentView.view autoPinEdgesToSuperviewEdges ];
    }

@end // TauAbstractStackPanelController class