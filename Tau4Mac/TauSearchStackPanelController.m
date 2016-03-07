//
//  TauSearchStackPanelController.m
//  Tau4Mac
//
//  Created by Tong G. on 3/7/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauSearchStackPanelController.h"
#import "TauSearchStackPanelBaseViewController.h"
#import "TauViewsStack.h"

// Private Interfaces
@interface TauSearchStackPanelController ()
@property ( strong, readwrite ) TauSearchStackPanelBaseViewController* baseViewController_;
@end // Private Interfaces

// TauSearchStackPanelController class
@implementation TauSearchStackPanelController

#pragma mark - Initializations

- ( void ) viewDidLoad
    {
    self.baseViewController_ = [ [ TauSearchStackPanelBaseViewController alloc ] initWithNibName: nil bundle: nil ];
    self.baseViewController_.hostStack = self;

    viewsStack_ = [ [ TauViewsStack alloc ] init ];
    viewsStack_.baseViewController = self.baseViewController_;

    [ self.view addSubview: viewsStack_.baseViewController.view ];
    constraintsCache_ = [ viewsStack_.currentView.view autoPinEdgesToSuperviewEdges ];
    }

@end // TauSearchStackPanelController class