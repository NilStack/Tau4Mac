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

    TauSearchStackPanelController __strong* priSearchPanelStackViewController_;
    TauMeTubeStackPanelController __strong* priMeTubePanelStackViewController_;
    TauPlayerStackPanelController __strong* priPlayerPanelStackViewController_;
    }

#pragma mark - Initializations

- ( void ) viewDidLoad
    {
    [ super viewDidLoad ];

    [ self.view configureForAutoLayout ];
    [ self.view autoSetDimension: ALDimensionWidth toSize: 200 * 4 relation: NSLayoutRelationGreaterThanOrEqual ];
    [ self.view autoSetDimension: ALDimensionHeight toSize: 200 * 0.56 * 5 relation: NSLayoutRelationGreaterThanOrEqual ];
    }

- ( void ) cleanUp
    {
//    [ self.view removeConstraints: layoutConstraintsCache_ ];
//    [ priSearchPanelStackViewController_.view removeFromSuperview ];
//    [ priMeTubePanelStackViewController_.view removeFromSuperview ];
//    [ priPlayerPanelStackViewController_.view removeFromSuperview ];

    [ self.searchPanelStackViewController_ cleanUp ];
    [ self.meTubePanelStackViewController_ cleanUp ];
    [ self.playerPanelStackViewController_ cleanUp ];

//    layoutConstraintsCache_ = nil;
//    priSearchPanelStackViewController_ = nil;
//    priMeTubePanelStackViewController_ = nil;
//    priPlayerPanelStackViewController_ = nil;
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
    if ( !priSearchPanelStackViewController_ )
        priSearchPanelStackViewController_ = [ [ TauSearchStackPanelController alloc ] initWithNibName: nil bundle: nil ];

    return priSearchPanelStackViewController_;
    }

- ( TauMeTubeStackPanelController* ) meTubePanelStackViewController_
    {
    if ( !priMeTubePanelStackViewController_ )
        priMeTubePanelStackViewController_ = [ [ TauMeTubeStackPanelController alloc ] initWithNibName: nil bundle: nil ];

    return priMeTubePanelStackViewController_;
    }

- ( TauPlayerStackPanelController* ) playerPanelStackViewController_
    {
    if ( !priPlayerPanelStackViewController_ )
        priPlayerPanelStackViewController_ = [ [ TauPlayerStackPanelController alloc ] initWithNibName: nil bundle: nil ];

    return priPlayerPanelStackViewController_;
    }

@end // TauMainViewController class