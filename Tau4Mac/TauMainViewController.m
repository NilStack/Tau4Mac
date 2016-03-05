//
//  TauMainViewController.m
//  Tau4Mac
//
//  Created by Tong G. on 3/3/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauMainViewController.h"

#import "TauSearchPanelStackViewController.h"

// Private Interfaces
@interface TauMainViewController ()
@property ( strong, readonly ) TauSearchPanelStackViewController* searchPanelStackViewController_;
@end // Private Interfaces

// TauMainViewController class
@implementation TauMainViewController

#pragma mark - Initializations

- ( void ) viewDidLoad
    {
    [ super viewDidLoad ];

    // Do any additional setup after loading the view.

    [ self.view addSubview: self.searchPanelStackViewController_.view ];
    [ self.searchPanelStackViewController_.view autoPinEdgesToSuperviewEdges ];
    }

#pragma mark - Private Interfaces

@dynamic searchPanelStackViewController_;

- ( TauSearchPanelStackViewController* ) searchPanelStackViewController_
    {
    TauSearchPanelStackViewController static* sCtrller;

    dispatch_once_t static onceToken;
    dispatch_once( &onceToken
                 , ( dispatch_block_t )
    ^( void )
        {
        sCtrller = [ [ TauSearchPanelStackViewController alloc ] initWithNibName: nil bundle: nil ];
        } );

    return sCtrller;
    }

@end // TauMainViewController class