//
//  TauPlayerStackPanelController.m
//  Tau4Mac
//
//  Created by Tong G. on 3/8/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauPlayerStackPanelController.h"
#import "TauPlayerStackPanelBaseViewController.h"
#import "TauViewsStack.h"

// Private Interfaces
@interface TauPlayerStackPanelController ()
@property ( strong, readwrite ) TauPlayerStackPanelBaseViewController* baseViewController_;
@end // Private Interfaces

// TauPlayerStackPanelController class
@implementation TauPlayerStackPanelController

#pragma mark - Initializations

- ( void ) viewDidLoad
    {
    self.baseViewController_ = [ [ TauPlayerStackPanelBaseViewController alloc ] initWithNibName: nil bundle: nil ];
    self.baseViewController_.hostStack = self;

    viewsStack_ = [ [ TauViewsStack alloc ] init ];
    viewsStack_.baseViewController = self.baseViewController_;

    [ self.view addSubview: viewsStack_.baseViewController.view ];
    constraintsCache_ = [ viewsStack_.currentView.view autoPinEdgesToSuperviewEdges ];
    }

- ( void ) cleanUp
    {
    [ super cleanUp ];

    [ self.baseViewController_ cleanUp ];
    }

@end // TauPlayerStackPanelController class