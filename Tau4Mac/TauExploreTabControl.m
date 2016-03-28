//
//  TauExploreTabControl.m
//  Tau4Mac
//
//  Created by Tong G. on 3/28/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauExploreTabControl.h"

@interface TauExploreTabControl ()

@property ( weak ) IBOutlet NSSegmentedControl* exploreTabsSegment_;

@end

// TauExploreTabControl class
@implementation TauExploreTabControl

#pragma mark - External KVB Compliant Properties

@synthesize activedTabTag = activedTabTag_;
+ ( BOOL ) automaticallyNotifiesObserversOfActivedTabTag
    {
    return NO;
    }

- ( void ) setActivedTabTag: ( TauExploreSubTabTag )_New
    {
    if ( activedTabTag_ != _New )
        {
        [ self willChangeValueForKey: TAU_KEY_OF_SEL( @selector( activedTabTag ) ) ];
        activedTabTag_ = _New;
        switch ( activedTabTag_ )
            {
            case TauExploreSubTabMeTubeTag:
                {
                [ self.exploreTabsSegment_ setSelectedSegment: _New ];
                } break;

            case TauExploreSubTabSubscriptionsTag:
                {
                [ self.exploreTabsSegment_ setSelectedSegment: _New ];
                } break;

            case TauExploreSubTabUnknownTag:
                {
                DDLogNotice( @"Explore sub tag is unknown" );
                } break;
            }

        [ self didChangeValueForKey: TAU_KEY_OF_SEL( @selector( activedTabTag ) ) ];
        }
    }

- ( TauExploreSubTabTag ) activedTabTag
    {
    return activedTabTag_;
    }

#pragma mark - Actions

- ( IBAction ) tabsSwitchedAction: ( NSSegmentedControl* )_Sender
    {
    self.activedTabTag = ( TauExploreSubTabTag )( _Sender.selectedSegment );
    }

@end // TauExploreTabControl class