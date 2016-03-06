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
    {
    NSArray <NSLayoutConstraint*>* layoutConstraintsCache_;
    }

#pragma mark - Initializations

- ( void ) viewDidLoad
    {
    [ super viewDidLoad ];

    // Do any additional setup after loading the view.
    }

#pragma mark - KVO Notifications

- ( void ) selectedSegmentDidChange: ( NSDictionary* )_Change observing: ( id )_ObservingObject
    {
    TauPanelsSwitcherSegmentTag new = [ _Change[ @"new" ] integerValue ];
    TauPanelsSwitcherSegmentTag old = [ _Change[ @"old" ] integerValue ];

    if ( new != old )
        {
        if ( layoutConstraintsCache_ )
            [ self.view removeConstraints: layoutConstraintsCache_ ];

        [ self.view setSubviews: @[] ];

        switch ( new )
            {
            case TauPanelsSwitcherSearchTag:
                {
                [ self.view addSubview: self.searchPanelStackViewController_.view ];
                layoutConstraintsCache_ = [ self.searchPanelStackViewController_.view autoPinEdgesToSuperviewEdges ];
                } break;

            case TauPanelsSwitcherMeTubeTag:
            case TauPanelsSwitcherTrendingTag:
                {
                } break;
            }
        }
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