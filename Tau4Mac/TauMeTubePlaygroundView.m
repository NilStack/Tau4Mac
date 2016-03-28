//
//  TauMeTubePlaygroundView.m
//  Tau4Mac
//
//  Created by Tong G. on 3/28/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauMeTubePlaygroundView.h"
#import "TauMeTubeTabModel.h"

// TauMeTubePlaygroundView class
@implementation TauMeTubePlaygroundView
    {
    // Layouts cache
    NSArray <NSLayoutConstraint*> __strong* selectedPinEdgesCache_;
    }

#pragma mark - Relay

@dynamic titlebarAccessoryViewControllerWhileActive;
+ ( NSSet <NSString*>* ) keyPathsForValuesAffectingTitlebarAccessoryViewControllerWhileActive
    {
    return [ NSSet setWithObjects: TAU_KEY_OF_SEL( @selector( selectedTabs ) ), nil ];
    }

- ( NSTitlebarAccessoryViewController* ) titlebarAccessoryViewControllerWhileActive
    {
    return [ self.selectedTabs.firstObject.viewController valueForKey: TAU_KEY_OF_SEL( @selector( titlebarAccessoryViewControllerWhileActive ) ) ];
    }

#pragma mark - External KVB Comliant Properties

@synthesize selectedTabs = selectedTabs_;
+ ( BOOL ) automaticallyNotifiesObserversOfSelectedTabs
    {
    return NO;
    }

- ( void ) setSelectedTabs: ( NSArray <TauMeTubeTabModel*>* )_New
    {
    if ( selectedTabs_ != _New )
        {
        [ self willChangeValueForKey: TAU_KEY_OF_SEL( @selector( selectedTabs ) ) ];

        TauMeTubeTabModel* oldSelected = self.selectedTabs.firstObject;
        if ( oldSelected && oldSelected.viewController )
            {
            [ oldSelected.viewController removeFromParentViewController ];
            [ oldSelected.viewController.view removeFromSuperview ];

            if ( selectedPinEdgesCache_ )
                {
                [ self removeConstraints: selectedPinEdgesCache_ ];
                selectedPinEdgesCache_ = nil;
                }
            }

        selectedTabs_ = _New;

        TauMeTubeTabModel* newSelected = self.selectedTabs.firstObject;
        [ self addSubview: newSelected.viewController.view ];
        selectedPinEdgesCache_ = [ newSelected.viewController.view autoPinEdgesToSuperviewEdges ];

        [ newSelected.viewController setValue: newSelected.repPlaylistIdentifier forKey: TAU_KEY_OF_SEL( @selector( playlistIdentifier ) ) ];

        [ self didChangeValueForKey: TAU_KEY_OF_SEL( @selector( selectedTabs ) ) ];
        }
    }

- ( NSArray <TauMeTubeTabModel*>* ) selectedTabs
    {
    return selectedTabs_;
    }

- ( NSUInteger ) countOfSelectedTabs
    {
    return selectedTabs_.count;
    }

- ( NSArray <TauMeTubeTabModel*>* ) selectedTabsAtIndexes: ( NSIndexSet* )_Indexes
    {
    return [ selectedTabs_ objectsAtIndexes: _Indexes ];
    }

- ( void ) getSelectedTabs: ( out TauMeTubeTabModel* __unsafe_unretained* )_Buffer range: ( NSRange )_InRange
    {
    [ selectedTabs_ getObjects: _Buffer range: _InRange ];
    }

@end // TauMeTubePlaygroundView class