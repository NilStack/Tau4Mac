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

#pragma mark - External KVB Comliant Properties

@synthesize selectedTab = selectedTab_;
+ ( BOOL ) automaticallyNotifiesObserversOfSelectedTab
    {
    return NO;
    }

- ( void ) setSelectedTab: ( TauMeTubeTabModel* )_New
    {
    if ( selectedTab_ != _New )
        {
        selectedTab_ = _New;
        NSLog( @"%@", selectedTab_ );
        }
    }

- ( TauMeTubeTabModel* ) selectedTab
    {
    return selectedTab_;
    }

@end // TauMeTubePlaygroundView class