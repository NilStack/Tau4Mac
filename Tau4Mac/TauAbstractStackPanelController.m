//
//  TauAbstractStackPanelController.m
//  Tau4Mac
//
//  Created by Tong G. on 3/5/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauAbstractStackPanelController.h"
#import "TauViewsStack.h"
#import "TauAbstractStackViewItem.h"

// TauAbstractStackPanelController class
@interface TauAbstractStackPanelController ()
@end

@implementation TauAbstractStackPanelController

#pragma mark - Initializations

- ( instancetype ) initWithNibName: ( NSString* )_NibNameOrNil
                            bundle: ( NSBundle* )_NibBundleOrNil
    {
    id correctedNibName = _NibNameOrNil ?: NSStringFromClass( [ TauAbstractStackPanelController class ] );
    return [ super initWithNibName: correctedNibName bundle: _NibBundleOrNil ];
    }

#pragma mark - Stack Operations

- ( void ) pushView: ( TauAbstractStackViewItem* )_NewItem
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