//
//  TauPlayerContentViewController.m
//  Tau4Mac
//
//  Created by Tong G. on 3/17/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauPlayerContentViewController.h"
#import "TauViewsStack.h"
#import "TauAbstractContentSubViewController.h"
//#import "AccessoryBarViewController.h"
#import "TauToolbarController.h"
#import "TauToolbarItem.h"

// TauPlayerContentSubViewController class
@interface TauPlayerContentSubViewController : TauAbstractContentSubViewController
@end // TauPlayerContentSubViewController class



// ------------------------------------------------------------------------------------------------------------ //

// Private
@interface TauPlayerContentViewController ()
@property ( weak ) IBOutlet TauPlayerContentSubViewController* initialPlayerContentSubViewController_;
@end // Private



// ------------------------------------------------------------------------------------------------------------ //



// TauPlayerContentViewController class
@implementation TauPlayerContentViewController

- ( void ) viewDidLoad
    {
    [ super viewDidLoad ];
    [ self setBackgroundViewController: self.initialPlayerContentSubViewController_ ];
    }

@end // TauPlayerContentViewController class



// ------------------------------------------------------------------------------------------------------------ //



// TauPlayerContentSubViewController class
@implementation TauPlayerContentSubViewController

- ( NSAppearance* ) windowAppearanceWhileActive
    {
    return [ NSAppearance appearanceNamed: NSAppearanceNameVibrantDark ];
    }

- ( NSArray <TauToolbarItem*>* ) exposedToolbarItemsWhileActive
    {
    return @[ [ TauToolbarItem switcherItem ]
            , [ TauToolbarItem flexibleSpaceItem ]
            ];
    }

@end // TauPlayerContentSubViewController class