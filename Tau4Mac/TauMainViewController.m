//
//  TauMainViewController.m
//  Tau4Mac
//
//  Created by Tong G. on 3/3/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauMainViewController.h"
#import "TauContentPanelViewController.h"

// TauMainViewController class
@implementation TauMainViewController

#pragma mark - Initializations

- ( void ) viewDidLoad
    {
    [ super viewDidLoad ];

    // Do any additional setup after loading the view.
    [ self.view setFrameSize: NSMakeSize( 800, 800 ) ];
    }

- ( void ) setRepresentedObject: ( id )_RepresentedObject
    {
    [ super setRepresentedObject: _RepresentedObject ];

    // Update the view, if already loaded.
    }

#pragma mark - IBActions

- ( IBAction ) searchUserInputAction: ( id )_Sender
    {
    NSBundle* correctBundle = [ NSBundle bundleForClass: [ TauContentPanelViewController class ] ];
    TauContentPanelViewController* contentPanelViewController = [ [ TauContentPanelViewController alloc ] initWithNibName: nil bundle: correctBundle ];

    [ self.view removeConstraints: self.view.constraints ];
    [ self.view setSubviews: @[] ];
    [ self.view addSubview: contentPanelViewController.view ];
    [ contentPanelViewController.view autoPinEdgesToSuperviewEdges ];
    }

@end // TauMainViewController class