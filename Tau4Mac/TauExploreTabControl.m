//
//  TauExploreTabControl.m
//  Tau4Mac
//
//  Created by Tong G. on 3/28/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauExploreTabControl.h"

@interface TauExploreTabControl ()

@property ( weak ) IBOutlet NSButton* MeTubeRecessedButton_;
@property ( weak ) IBOutlet NSButton* subscriptionsRecessedButton_;

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
        activedTabTag_ = _New;

        [ self willChangeValueForKey: TAU_KEY_OF_SEL( @selector( activedTabTag ) ) ];
        switch ( activedTabTag_ )
            {
            case TauExploreSubTabMeTubeTag:
                {
                self.MeTubeRecessedButton_.state = NSOnState;
                self.subscriptionsRecessedButton_.state = NSOffState;
                } break;

            case TauExploreSubTabSubscriptionsTag:
                {
                self.MeTubeRecessedButton_.state = NSOffState;
                self.subscriptionsRecessedButton_.state = NSOnState;
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

- ( IBAction ) tabsSwitchedAction: ( NSButton* )_Sender
    {
    _Sender.state = NSOnState;
    self.activedTabTag = ( TauExploreSubTabTag )( _Sender.tag );
    }

@end // TauExploreTabControl class