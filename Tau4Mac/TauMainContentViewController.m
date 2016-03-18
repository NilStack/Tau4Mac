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

@property ( strong, readonly ) FBKVOController* selfObservKVOController_;
@property ( strong, readonly ) FBKVOController* observSharedToolbarCtrlKVOController_;

@property ( assign, readwrite ) TauContentViewTag activedSegment_;

@end // Private

#define activedContentViewController_kvoKey @"activedContentViewController"
#define activedSegment_kvoKey               @"activedSegment_"

// TauMainContentViewController class
@implementation TauMainContentViewController
    {
    FBKVOController __strong* priSelfObservKVOController_;
    FBKVOController __strong* priObservSharedToolbarCtrlKVOController_;

    TauSearchContentViewController __strong*  priSearchContentViewController_;
    TauExploreContentViewController __strong* priExploreContentViewController_;
    TauPlayerContentViewController __strong*  priPlayerContentViewController_;

    // Layout caches
    NSArray __strong* activedPinEdgesCache_;
    }

- ( void ) viewDidLoad
    {
    [ self.observSharedToolbarCtrlKVOController_ observe: [ TauToolbarController sharedController ].segSwitcher
                                                 keyPath: @"cell.selectedSegment"
                                                 options: NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                                                   block:
    ^( id _Nullable _Observer, NSSegmentedControl* _Nonnull _Object, NSDictionary <NSString*, id>* _Nonnull _Change )
        {
        self.activedSegment_ = _Object.selectedSegment;
        } ];

    // self-observing to react to the change of activedContentViewController property
    [ self.selfObservKVOController_ observe: self
                                    keyPath: activedContentViewController_kvoKey
                                    options: NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld | NSKeyValueObservingOptionInitial
                                      block:
    ^( id _Nullable _Observer, id _Nonnull _Object, NSDictionary <NSString*, id>* _Nonnull _Change )
        {
        TauAbstractContentViewController* oldActived = _Change[ NSKeyValueChangeOldKey ];
        TauAbstractContentViewController* newActived = _Change[ NSKeyValueChangeNewKey ];

        if ( oldActived && ( ( __bridge void* )oldActived != ( __bridge void* )[ NSNull null ] ) )
            {
            [ oldActived removeFromParentViewController ];
            [ oldActived.view removeFromSuperview ];

            if ( activedPinEdgesCache_ )
                {
                [ self.view removeConstraints: activedPinEdgesCache_ ];
                activedPinEdgesCache_ = nil;
                }
            }

        if ( newActived && ( ( __bridge void* )newActived != ( __bridge void* )[ NSNull null ] ) )
            {
            [ self addChildViewController: newActived ];
            [ self.view addSubview: newActived.view ];
            activedPinEdgesCache_ = [ newActived.view autoPinEdgesToSuperviewEdges ];
            }
        else
            DDLogUnexpected( @"Unexpected new value: {%@}", newActived );
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

@dynamic selfObservKVOController_;
- ( FBKVOController* ) selfObservKVOController_
    {
    if ( !priSelfObservKVOController_ )
        priSelfObservKVOController_ = [ [ FBKVOController alloc ] initWithObserver: self ];
    return priSelfObservKVOController_;
    }

@dynamic observSharedToolbarCtrlKVOController_;
- ( FBKVOController* ) observSharedToolbarCtrlKVOController_
    {
    if ( !priObservSharedToolbarCtrlKVOController_ )
        priObservSharedToolbarCtrlKVOController_ = [ [ FBKVOController alloc ] initWithObserver: self ];
    return priObservSharedToolbarCtrlKVOController_;
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
        case TauSearchContentViewTag:  return self.searchContentViewController;
        case TauExploreContentViewTag: return self.exploreContentViewController;
        case TauPlayerContentViewTag:  return self.playerContentViewController;

        case TauUnknownContentViewTag:
            {
            DDLogUnexpected( @"Encountered unknown content view tag" );
            return nil;
            }
        }
    }

#pragma mark - Private Interfaces

@synthesize activedSegment_;
+ ( BOOL ) automaticallyNotifiesObserversOfActivedSegment_
    {
    return NO;
    }

- ( void ) setActivedSegment_: ( TauContentViewTag )_New
    {
    if ( activedSegment_ != _New )
        {
        [ self willChangeValueForKey: activedSegment_kvoKey ];
        activedSegment_ = _New;
        [ self didChangeValueForKey: activedSegment_kvoKey ];
        }
    }

- ( TauContentViewTag ) activedSegment_
    {
    return activedSegment_;
    }

@end // TauMainContentViewController class