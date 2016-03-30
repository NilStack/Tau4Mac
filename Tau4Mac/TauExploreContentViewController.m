//
//  TauExploreContentViewController.m
//  Tau4Mac
//
//  Created by Tong G. on 3/17/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauExploreContentViewController.h"
#import "TauViewsStack.h"
#import "TauAbstractContentSubViewController.h"
#import "TauToolbarController.h"
#import "TauToolbarItem.h"
#import "TauExploreTabControl.h"

#import "TauMeTubeContentSubViewController.h"
#import "TauSubscriptionsCollectionContentSubViewController.h"

// TauExploreContentSubViewController class
@interface TauExploreContentSubViewController : TauAbstractContentSubViewController

@property ( assign, readwrite ) TauExploreSubTabTag activedExploreTabViewTag;  // KVB compliant
@property ( strong, readonly ) NSViewController* activedExploreTabViewController;  // KVB compliant

@property ( weak ) IBOutlet TauExploreTabControl* exploreTabControl;

@end // TauExploreContentSubViewController class



// ------------------------------------------------------------------------------------------------------------ //



// Private
@interface TauExploreContentViewController ()
@property ( weak ) IBOutlet TauExploreContentSubViewController* initialExploreContentSubViewController_;
@end // Private

// TauExploreContentViewController class
@implementation TauExploreContentViewController

#pragma mark - Initializations

- ( void ) viewDidLoad
    {
    [ super viewDidLoad ];
    [ self.viewsStack setBackgroundViewController: self.initialExploreContentSubViewController_ ];
    }

@end // TauExploreContentViewController class



// ------------------------------------------------------------------------------------------------------------ //



// Private
@interface TauExploreContentSubViewController ()

/****************************** MeTube ******************************/
@property ( strong, readonly ) TauMeTubeContentSubViewController* MeTubeController_;


/****************************** Subscription ******************************/

@property ( strong, readonly ) TauSubscriptionsCollectionContentSubViewController* subscriptionsController_;

@end // Private

// TauExploreContentSubViewController class
@implementation TauExploreContentSubViewController
    {
    // Constraints caches
    NSArray <NSLayoutConstraint*>* activedPinEdgesCache_;
    }

#pragma mark - Initializations

- ( instancetype ) initWithCoder: ( NSCoder* )_Coder
    {
    if ( self = [ super initWithCoder: _Coder ] )
        priActivedExploreTabViewTag_ = TauExploreSubTabUnknownTag;
    return self;
    }

- ( void ) viewDidLoad
    {
    // Mutual Bindings between self and self.exploreTabControl
    TauMutuallyBind( self, TauKVOStrictKey( activedExploreTabViewTag ), self.exploreTabControl, TauKVOStrictKey( activedTabTag ) );

    [ self setActivedExploreTabViewTag: TauExploreSubTabMeTubeTag ];
    }

TauDeallocBegin
    // self and self.exploreTabControl will never be dealloced until the app is terminated,
    // so there is no need to unbind them explicitly.
TauDeallocEnd

#pragma mark - Overrides

// Update the titlebar accessory view controller
+ ( NSSet <NSString*>* ) keyPathsForValuesAffectingTitlebarAccessoryViewControllerWhileActive
    {
    return [ NSSet setWithObjects:
          TauKVOStrictKey( activedExploreTabViewTag )
        , @"MeTubeController_.titlebarAccessoryViewControllerWhileActive"
        , @"subscriptionsController_.titlebarAccessoryViewControllerWhileActive"
        , nil ];
    }

- ( NSTitlebarAccessoryViewController* ) titlebarAccessoryViewControllerWhileActive
    {
    NSTitlebarAccessoryViewController* c = [ self.activedExploreTabViewController valueForKey: TauKVOStrictKey( titlebarAccessoryViewControllerWhileActive ) ];
    return c;
    }

- ( NSArray <TauToolbarItem*>* ) exposedToolbarItemsWhileActive
    {
    return @[ [ TauToolbarItem switcherItem ]
            , [ TauToolbarItem adaptiveSpaceItem ]
            , [ [ TauToolbarItem alloc ] initWithIdentifier: nil label: nil view: self.exploreTabControl ]
            , [ TauToolbarItem flexibleSpaceItem ]
            ];
    }

#pragma mark - External KVB Compliant Properties

@synthesize activedExploreTabViewTag = priActivedExploreTabViewTag_;
+ ( BOOL ) automaticallyNotifiesObserversOfActivedExploreTabViewTag
    {
    return NO;
    }

- ( void ) setActivedExploreTabViewTag: ( TauExploreSubTabTag )_New
    {
    if ( priActivedExploreTabViewTag_ != _New )
        {
        TAU_CHANGE_VALUE_FOR_KEY( activedExploreTabViewTag,
         ( ^{
            NSViewController* oldActived = self.activedExploreTabViewController;

            if ( oldActived )
                {
                [ oldActived removeFromParentViewController ];
                [ oldActived.view removeFromSuperview ];

                if ( activedPinEdgesCache_ )
                    {
                    [ self.view removeConstraints: activedPinEdgesCache_ ];
                    activedPinEdgesCache_ = nil;
                    }
                }

            priActivedExploreTabViewTag_ = _New;
            } ) );

        // Value of self.activedContentViewController is derived from activedContentViewTag_ var.
        // We just assigned a new value to activedContentViewTag_,
        // so invocation of self.activedContentViewController results in a new value.
        NSViewController* newActived = self.activedExploreTabViewController;
        if ( newActived )
            {
            [ self addChildViewController: newActived ];
            [ self.view addSubview: newActived.view ];
            activedPinEdgesCache_ = [ newActived.view autoPinEdgesToSuperviewEdges ];
            }
        else
            DDLogUnexpected( @"Unexpected new value: {%@}.", newActived );
        }
    }

- ( TauExploreSubTabTag ) activedExploreTabViewTag
    {
    return priActivedExploreTabViewTag_;
    }

@dynamic activedExploreTabViewController;
+ ( NSSet <NSString*>* ) keyPathsForValuesAffectingActivedExploreTabViewController
    {
    return [ NSSet setWithObjects: TauKVOStrictKey( activedExploreTabViewTag ), nil ];
    }

- ( NSViewController* ) activedExploreTabViewController
    {
    NSViewController* actived = nil;
    switch ( priActivedExploreTabViewTag_ )
        {
        case TauExploreSubTabMeTubeTag: actived = self.MeTubeController_; break;
        case TauExploreSubTabSubscriptionsTag: actived = self.subscriptionsController_; break;
        case TauExploreSubTabUnknownTag: DDLogNotice( @"Explore sub tab tag is unknown" ); break;
        }

    return actived;
    }

#pragma mark - Private

@synthesize MeTubeController_ = priMeTubeController_;
- ( TauMeTubeContentSubViewController* ) MeTubeController_
    {
    if ( !priMeTubeController_ )
        priMeTubeController_ = [ [ TauMeTubeContentSubViewController alloc ] initWithNibName: nil bundle: nil ];

    return priMeTubeController_;
    }

@synthesize subscriptionsController_ = priSubscriptionsController_;
- ( NSViewController* ) subscriptionsController_
    {
    if ( !priSubscriptionsController_ )
        {
        priSubscriptionsController_ = [ [ TauSubscriptionsCollectionContentSubViewController alloc ] initWithNibName: nil bundle: nil ];
        [ priSubscriptionsController_ setMine: YES ];
        }

    return priSubscriptionsController_;
    }

@end // TauExploreContentSubViewController class