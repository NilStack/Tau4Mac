//
//  TauPlayerContentViewController.m
//  Tau4Mac
//
//  Created by Tong G. on 3/17/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauPlayerContentViewController.h"
#import "TauViewsStack.h"

// TauPlayerContentSubViewController class
@interface TauPlayerContentSubViewController : NSViewController <TauContentSubViewController>
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
    [ self.viewsStack setBackgroundViewController: self.initialPlayerContentSubViewController_ ];
    }

@end // TauPlayerContentViewController class



// ------------------------------------------------------------------------------------------------------------ //



// TauPlayerContentSubViewController class
@implementation TauPlayerContentSubViewController
@end // TauPlayerContentSubViewController class