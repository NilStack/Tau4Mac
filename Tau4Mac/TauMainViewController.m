//
//  TauMainViewController.m
//  Tau4Mac
//
//  Created by Tong G. on 3/3/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauMainViewController.h"

#import "TauSearchStackPanelController.h"
#import "TauMeTubeStackPanelController.h"
#import "TauPlayerStackPanelController.h"

#import "TauMeTubeStackPanelBaseViewController.h"

// Private Interfaces
@interface TauMainViewController ()

@property ( strong, readonly ) TauSearchStackPanelController* searchPanelStackViewController_;
@property ( strong, readonly ) TauMeTubeStackPanelController* meTubePanelStackViewController_;
@property ( strong, readonly ) TauPlayerStackPanelController* playerPanelStackViewController_;

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
                {
                [ self.view addSubview: self.meTubePanelStackViewController_.view ];
                layoutConstraintsCache_ = [ self.meTubePanelStackViewController_.view autoPinEdgesToSuperviewEdges ];
                } break;

            case TauPanelsSwitcherPlayerTag:
                {
                [ self.view addSubview: self.playerPanelStackViewController_.view ];
                layoutConstraintsCache_ = [ self.playerPanelStackViewController_.view autoPinEdgesToSuperviewEdges ];
                } break;
            }
        }
    }

#pragma mark - Private Interfaces

@dynamic searchPanelStackViewController_;
@dynamic meTubePanelStackViewController_;
@dynamic playerPanelStackViewController_;

- ( TauAbstractStackPanelController* ) searchPanelStackViewController_
    {
    TauAbstractStackPanelController static* sSearchC;

    dispatch_once_t static onceToken;
    dispatch_once( &onceToken
                 , ( dispatch_block_t )
    ^( void )
        {
        sSearchC = [ [ TauSearchStackPanelController alloc ] initWithNibName: nil bundle: nil ];
        } );

    return sSearchC;
    }

- ( TauMeTubeStackPanelController* ) meTubePanelStackViewController_
    {
    TauMeTubeStackPanelController static* sMeTubeC;

    dispatch_once_t static onceToken;
    dispatch_once( &onceToken
                 , ( dispatch_block_t )
    ^( void )
        {
        sMeTubeC = [ [ TauMeTubeStackPanelController alloc ] initWithNibName: nil bundle: nil ];
        } );

    return sMeTubeC;
    }

- ( TauPlayerStackPanelController* ) playerPanelStackViewController_
    {
    TauPlayerStackPanelController static* sPlayerC;

    dispatch_once_t static onceToken;
    dispatch_once( &onceToken
                 , ( dispatch_block_t )
    ^( void )
        {
        sPlayerC = [ [ TauPlayerStackPanelController alloc ] initWithNibName: nil bundle: nil ];
        } );

    return sPlayerC;
    }

@end // TauMainViewController class