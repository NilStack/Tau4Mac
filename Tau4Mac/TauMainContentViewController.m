//
//  TauMainContentViewController.m
//  Tau4Mac
//
//  Created by Tong G. on 3/17/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauMainContentViewController.h"

#import "TauSearchContentViewController.h"
#import "TauExploreContentViewController.h"
#import "TauPlayerContentViewController.h"

// Private
@interface TauMainContentViewController ()

@property ( assign, readwrite ) TauSwitcherSegmentTag activedSegment_;

@end // Private

// TauMainContentViewController class
@implementation TauMainContentViewController
    {
    TauSearchContentViewController __strong*  priSearchContentViewController_;
    TauExploreContentViewController __strong* priExploreContentViewController_;
    TauPlayerContentViewController __strong*  priPlayerContentViewController_;
    }

#pragma mark - Dynamic Properties

@dynamic searchContentViewController;
@dynamic exploreContentViewController;
@dynamic playerContentViewController;
- ( TauSearchContentViewController* ) searchContentViewController
    {
    if ( !priSearchContentViewController_ )
        priSearchContentViewController_ = [ [ TauSearchContentViewController alloc ] initWithNibName: nil bundle: nil ];

    return priSearchContentViewController_;
    }

- ( TauExploreContentViewController* ) exploreContentViewController
    {
    if ( !priExploreContentViewController_ )
        priExploreContentViewController_ = [ [ TauExploreContentViewController alloc ] initWithNibName: nil bundle: nil ];

    return priExploreContentViewController_;
    }

- ( TauPlayerContentViewController* ) playerContentViewController
    {
    if ( !priPlayerContentViewController_ )
        priPlayerContentViewController_ = [ [ TauPlayerContentViewController alloc ] initWithNibName: nil bundle: nil ];

    return priPlayerContentViewController_;
    }

@dynamic activedContentViewController;
+ ( NSSet <NSString*>* ) keyPathsForValuesAffectingActivedContentViewController
    {
    return [ NSSet setWithObjects: @"activedSegment_", nil ];
    }

- ( TauAbstractContentViewController* ) activedContentViewController
    {
    switch ( activedSegment_ )
        {
        case TauPanelsSwitcherSearchTag:  return self.searchContentViewController;
        case TauPanelsSwitcherExploreTag: return self.exploreContentViewController;
        case TauPanelsSwitcherPlayerTag:  return self.playerContentViewController;
        }
    }

#pragma mark - Private Interfaces

@synthesize activedSegment_;

- ( void ) selectedSegmentDidChange: ( NSDictionary* )_ChangeDict observing: ( NSSegmentedControl* )_Observing
    {
    // Observers of self.activedContentViewController will be notified
    self.activedSegment_ = _Observing.selectedSegment;
    }

@end // TauMainContentViewController class