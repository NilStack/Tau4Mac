//
//  TauSearchContentViewController.m
//  Tau4Mac
//
//  Created by Tong G. on 3/17/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauSearchContentViewController.h"
#import "TauViewsStack.h"
#import "TauToolbarController.h"

// TauSearchContentSubViewController class
@interface TauSearchContentSubViewController : NSViewController <TauContentSubViewController>
@end // TauSearchContentSubViewController class



// ------------------------------------------------------------------------------------------------------------ //



// Private
@interface TauSearchContentViewController ()

@property ( weak ) IBOutlet TauSearchContentSubViewController* initialSearchContentSubViewController_;

@end // Private



// ------------------------------------------------------------------------------------------------------------ //



// TauSearchContentViewController class
@implementation TauSearchContentViewController

- ( void ) viewDidLoad
    {
    [ super viewDidLoad ];
    [ self.viewsStack setBackgroundViewController: self.initialSearchContentSubViewController_ ];
    }

- ( IBAction ) clickedAction: ( id )_Sender
    {
    NSToolbar* toolbar = [ TauToolbarController sharedController ].managedToolbar;
    if ( toolbar.items.count > 0 )
        {
        [ [ TauToolbarController sharedController ].managedToolbar removeItemAtIndex: 0 ];
        }
    else
        {
        [ [ TauToolbarController sharedController ].managedToolbar insertItemWithItemIdentifier: TauToolbarSwitcherItemIdentifier atIndex: 0 ];
        }
    }

@end // TauSearchContentViewController class



// ------------------------------------------------------------------------------------------------------------ //



// TauSearchContentSubViewController class
@implementation TauSearchContentSubViewController
@end // TauSearchContentSubViewController class