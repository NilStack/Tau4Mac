//
//  TauPanelStackViewController.m
//  Tau4Mac
//
//  Created by Tong G. on 3/5/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauPanelStackViewController.h"
#import "TauViewsStack.h"
#import "TauSearchPanelBaseViewController.h"
#import "TauStackViewItem.h"

// TauPanelStackViewController class
@interface TauPanelStackViewController ()
@property ( strong, readwrite ) TauSearchPanelBaseViewController* baseViewController_;
@end

@implementation TauPanelStackViewController
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

@end // TauPanelStackViewController class