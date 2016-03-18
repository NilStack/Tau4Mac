//
//  TauSearchContentViewController.m
//  Tau4Mac
//
//  Created by Tong G. on 3/17/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauSearchContentViewController.h"

// TauSearchContentSubViewController class
@interface TauSearchContentSubViewController : NSViewController <TauContentSubViewController>
@end // TauSearchContentSubViewController class



// ------------------------------------------------------------------------------------------------------------ //



// Private
@interface TauSearchContentViewController ()

@property ( weak ) IBOutlet TauSearchContentSubViewController* initialSearchContentSubViewController_;

@end // Private

// TauSearchContentViewController class
@implementation TauSearchContentViewController

- ( void ) viewDidLoad
    {
    [ super viewDidLoad ];

    }

- ( void ) active_: ( NSViewController <TauContentSubViewController>* )_ContentSubViewController
    {
//    [ 
    [ self addChildViewController: _ContentSubViewController ];
    [ self.view addSubview: self.initialSearchContentSubViewController_.view ];
    activedPinEdgesCache_ = [ self.initialSearchContentSubViewController_.view autoPinEdgesToSuperviewEdges ];
    }

@end // TauSearchContentViewController class



// ------------------------------------------------------------------------------------------------------------ //



// TauSearchContentSubViewController class
@implementation TauSearchContentSubViewController
@end // TauSearchContentSubViewController class