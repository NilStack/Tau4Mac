//
//  TauExploreSegmentControl.m
//  Tau4Mac
//
//  Created by Tong G. on 3/28/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauExploreSegmentControl.h"

// TauExploreSegmentControl class
@implementation TauExploreSegmentControl

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
        switch ( activedTabTag_ )
            {
            case TauExploreSubTabMeTubeTag:
                {
                self.MeTubeRecessedButton.state = NSOnState;
                self.subscriptionsRecessedButton.state = NSOffState;
                } break;

            case TauExploreSubTabSubscriptionsTag:
                {
                self.MeTubeRecessedButton.state = NSOffState;
                self.subscriptionsRecessedButton.state = NSOnState;
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

- ( IBAction ) tabsSwitchedAction: ( id )_Sender
    {
    if ( _Sender == self.MeTubeRecessedButton )
        self.activedTabTag = TauExploreSubTabMeTubeTag;
    else if ( _Sender == self.subscriptionsRecessedButton )
        self.activedTabTag = TauExploreSubTabSubscriptionsTag;
    }

@end // TauExploreSegmentControl class