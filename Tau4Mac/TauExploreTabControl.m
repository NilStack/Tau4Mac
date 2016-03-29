//
//  TauExploreTabControl.m
//  Tau4Mac
//
//  Created by Tong G. on 3/28/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauExploreTabControl.h"

// Private
@interface TauExploreTabControl ()
@property ( weak ) IBOutlet NSSegmentedControl* exploreTabsSegment_;
@end // Private

// TauExploreTabControl class
@implementation TauExploreTabControl

- ( instancetype ) initWithFrame: ( NSRect )_Frame
    {
    if ( self = [ super initWithFrame: _Frame ] )
        activedTabTag_ = TauExploreSubTabUnknownTag;
    return self;
    }

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
        TAU_CHANGE_VALUE_FOR_KEY( activedTabTag,
         ( ^{
            activedTabTag_ = _New;
            [ self.exploreTabsSegment_ setSelectedSegment: activedTabTag_ ];
            } ) );
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