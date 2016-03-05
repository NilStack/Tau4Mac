//
//  TauSearchPanelStackViewController.m
//  Tau4Mac
//
//  Created by Tong G. on 3/5/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauSearchPanelStackViewController.h"
#import "TauViewsStack.h"
#import "TauSearchPanelBaseViewController.h"
#import "TauStackViewItem.h"

// TauSearchPanelStackViewController class
@interface TauSearchPanelStackViewController ()
@property ( strong, readwrite ) TauSearchPanelBaseViewController* baseViewController_;
@end

@implementation TauSearchPanelStackViewController
    {
    TauViewsStack __strong* viewsStack_;
    NSArray <NSLayoutConstraint*> __strong* constraintsCache_;
    }

- ( void ) viewDidLoad
    {
    self.baseViewController_ = [ [ TauSearchPanelBaseViewController alloc ] initWithNibName: nil bundle: nil ];
    self.baseViewController_.hostStack = self;

    viewsStack_ = [ [ TauViewsStack alloc ] init ];
    viewsStack_.baseViewController = self.baseViewController_;

    [ self.view addSubview: viewsStack_.baseViewController.view ];
    constraintsCache_ = [ viewsStack_.currentView.view autoPinEdgesToSuperviewEdges ];
    }

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

@end // TauSearchPanelStackViewController class