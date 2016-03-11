//
//  TauMeTubeStackPanelController.m
//  Tau4Mac
//
//  Created by Tong G. on 3/7/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauMeTubeStackPanelController.h"
#import "TauMeTubeStackPanelBaseViewController.h"
#import "TauViewsStack.h"

// Private Interfaces
@interface TauMeTubeStackPanelController ()
@property ( strong, readwrite ) TauMeTubeStackPanelBaseViewController* baseViewController_;
@end // Private Interfaces

// TauMeTubeStackPanelController class
@implementation TauMeTubeStackPanelController

- ( void ) viewDidLoad
    {
    self.baseViewController_ = [ [ TauMeTubeStackPanelBaseViewController alloc ] initWithNibName: nil bundle: nil ];
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

@end // TauMeTubeStackPanelController class