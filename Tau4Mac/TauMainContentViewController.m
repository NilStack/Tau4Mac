//
//  TauMainContentViewController.m
//  Tau4Mac
//
//  Created by Tong G. on 3/17/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauMainContentViewController.h"
#import "TauToolbarController.h"

#import "TauSearchContentViewController.h"
#import "TauExploreContentViewController.h"
#import "TauPlayerContentViewController.h"

// Private
@interface TauMainContentViewController ()
@end // Private

#define activedContentViewController_kvoKey @"activedContentViewController"
#define activedContentViewTag_kvoKey        @"activedContentViewTag"

// TauMainContentViewController class
@implementation TauMainContentViewController
    {
    TauSearchContentViewController __strong*  priSearchContentViewController_;
    TauExploreContentViewController __strong* priExploreContentViewController_;
    TauPlayerContentViewController __strong*  priPlayerContentViewController_;

    // Layout caches
    NSArray __strong* activedPinEdgesCache_;
    }

- ( void ) viewDidLoad
    {
    activedContentViewTag_ = TauUnknownContentViewTag;
    [ self bind: activedContentViewTag_kvoKey toObject: [ TauToolbarController sharedController ] withKeyPath: @"contentViewAffiliatedTo" options: nil ];
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

@synthesize activedContentViewTag = activedContentViewTag_;
+ ( BOOL ) automaticallyNotifiesObserversOfActivedContentViewTag
    {
    return NO;
    }

- ( void ) setActivedContentViewTag: ( TauContentViewTag )_New
    {
    if ( activedContentViewTag_ != _New )
        {
        [ self willChangeValueForKey: activedContentViewTag_kvoKey ];

        TauAbstractContentViewController* oldActived = self.activedContentViewController;

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

        activedContentViewTag_ = _New;

        [ self didChangeValueForKey: activedContentViewTag_kvoKey ];

        // Value of self.activedContentViewController is derived from activedContentViewTag_ var.
        // We just assigned a new value to activedContentViewTag_,
        // so invocation of self.activedContentViewController results in a new value.
        TauAbstractContentViewController* newActived = self.activedContentViewController;
        if ( newActived )
            {
            [ self addChildViewController: newActived ];
            [ self.view addSubview: newActived.view ];
            activedPinEdgesCache_ = [ newActived.view autoPinEdgesToSuperviewEdges ];
            }
        else
            DDLogUnexpected( @"Unexpected new value: {%@}", newActived );
        }
    }

- ( TauContentViewTag ) activedContentViewTag
    {
    return activedContentViewTag_;
    }

@dynamic activedContentViewController;
+ ( NSSet <NSString*>* ) keyPathsForValuesAffectingActivedContentViewController
    {
    return [ NSSet setWithObjects: activedContentViewTag_kvoKey, nil ];
    }

- ( TauAbstractContentViewController* ) activedContentViewController
    {
    switch ( self.activedContentViewTag )
        {
        case TauSearchContentViewTag:  return self.searchContentViewController;
        case TauExploreContentViewTag: return self.exploreContentViewController;
        case TauPlayerContentViewTag:  return self.playerContentViewController;

        case TauUnknownContentViewTag:
            {
            DDLogDebug( @"Encountered unknown content view tag" );
            return nil;
            }
        }
    }

#pragma mark - Private Interfaces

//

@end // TauMainContentViewController class