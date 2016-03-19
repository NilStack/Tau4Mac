//
//  TauExploreContentViewController.m
//  Tau4Mac
//
//  Created by Tong G. on 3/17/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauExploreContentViewController.h"
#import "TauViewsStack.h"
#import "TauAbstractContentSubViewController.h"
#import "TauToolbarController.h"

// TauExploreContentSubViewController class
@interface TauExploreContentSubViewController : TauAbstractContentSubViewController
@end // TauExploreContentSubViewController class


// ------------------------------------------------------------------------------------------------------------ //



// Private
@interface TauExploreContentViewController ()
@property ( weak ) IBOutlet TauExploreContentSubViewController* initialExploreContentSubViewController_;
@end // Private



// ------------------------------------------------------------------------------------------------------------ //



// TauExploreContentViewController class
@implementation TauExploreContentViewController

- ( void ) viewDidLoad
    {
    [ super viewDidLoad ];
    [ self.viewsStack setBackgroundViewController: self.initialExploreContentSubViewController_ ];
    }

@end // TauExploreContentViewController class



// ------------------------------------------------------------------------------------------------------------ //



// TauExploreContentSubViewController class
@implementation TauExploreContentSubViewController

- ( NSArray <NSString*>* ) exposedToolbarItemIdentifiersWhileActive
    {
    return @[ TauToolbarSwitcherItemIdentifier
            , NSToolbarFlexibleSpaceItemIdentifier
            , TauToolbarUserProfileButtonItemIdentifier
            ];
    }

@end // TauExploreContentSubViewController class