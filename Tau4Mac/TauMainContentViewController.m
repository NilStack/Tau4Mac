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

@property ( strong, readonly ) FBKVOController* kvoController_;
@property ( assign, readwrite ) TauSwitcherSegmentTag activedSegment_;

@end // Private

#define activedContentViewController_kvoKey @"activedContentViewController"
#define activedSegment_kvoKey               @"activedSegment_"

// TauMainContentViewController class
@implementation TauMainContentViewController
    {
    FBKVOController __strong* priKVOController_;

    TauSearchContentViewController __strong*  priSearchContentViewController_;
    TauExploreContentViewController __strong* priExploreContentViewController_;
    TauPlayerContentViewController __strong*  priPlayerContentViewController_;

    // Layout Caches
    NSArray* activedPinEdgesCache_;
    }

- ( void ) viewDidLoad
    {
    [ self.kvoController_ observe: self
                          keyPath: activedContentViewController_kvoKey
                          options: NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld | NSKeyValueObservingOptionInitial
                            block:
    ^( id _Nullable _Observer, id _Nonnull _Object, NSDictionary <NSString*, id>* _Nonnull _Change )
        {
        TauAbstractContentViewController* newActived = _Change[ NSKeyValueChangeNewKey ];
        TauAbstractContentViewController* oldActived = _Change[ NSKeyValueChangeOldKey ];

        [ oldActived removeFromParentViewController ];
        [ oldActived.view removeFromSuperview ];

        if ( activedPinEdgesCache_ )
            {
            [ self.view removeConstraints: activedPinEdgesCache_ ];
            activedPinEdgesCache_ = nil;
            }

        [ self addChildViewController: newActived ];
        [ self.view addSubview: newActived.view ];
        activedPinEdgesCache_ = [ newActived.view autoPinEdgesToSuperviewEdges ];
        } ];
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

@dynamic kvoController_;
- ( FBKVOController* ) kvoController_
    {
    if ( !priKVOController_ )
        priKVOController_ = [ [ FBKVOController alloc ] initWithObserver: self ];
    return priKVOController_;
    }

@dynamic activedContentViewController;
+ ( NSSet <NSString*>* ) keyPathsForValuesAffectingActivedContentViewController
    {
    return [ NSSet setWithObjects: activedSegment_kvoKey, nil ];
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
+ ( BOOL ) automaticallyNotifiesObserversOfActivedSegment_
    {
    return NO;
    }

- ( void ) setActivedSegment_: ( TauSwitcherSegmentTag )_New
    {
    if ( activedSegment_ != _New )
        {
        [ self willChangeValueForKey: activedSegment_kvoKey ];
        activedSegment_ = _New;
        [ self didChangeValueForKey: activedSegment_kvoKey ];
        }
    }

- ( TauSwitcherSegmentTag ) activedSegment_
    {
    return activedSegment_;
    }

- ( void ) selectedSegmentDidChange: ( NSDictionary * )_ChangeDict observing: ( NSSegmentedControl* )_Observing
    {
    // Observers of self.activedContentViewController will be notified
    self.activedSegment_ = _Observing.selectedSegment;
    }

@end // TauMainContentViewController class