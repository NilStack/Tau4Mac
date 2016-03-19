//
//  TauToolbarItem.m
//  Tau4Mac
//
//  Created by Tong G. on 3/19/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauToolbarItem.h"
#import "TauToolbarController.h"

// TauToolbarItem class
@implementation TauToolbarItem

@synthesize itemIdentifier;
@synthesize item;

#pragma mark - Common Items

+ ( TauToolbarSwitcherItem* ) switcherItem { return [ [ TauToolbarSwitcherItem alloc ] init ]; }
+ ( TauToolbarFlexibleSpaceItem* ) flexibleSpaceItem { return [ [ TauToolbarFlexibleSpaceItem alloc ] init ]; }
+ ( TauToolbarFixedSpaceItem* ) fixedSpaceItem { return [ [ TauToolbarFixedSpaceItem alloc ] init ]; }
+ ( TauToolbarUserProfileItem* ) userProfileItem { return [ [ TauToolbarUserProfileItem alloc ] init ]; }

@end // TauToolbarItem class

// TauToolbarSwitcherItem class
@implementation TauToolbarSwitcherItem : TauToolbarItem

TauToolbarSwitcherItem static* sSwitcherItem_;
- ( instancetype ) init
    {
    if ( !sSwitcherItem_ )
        {
        if ( self = [ super init ] )
            {
            self.itemIdentifier = TauToolbarSwitcherItemIdentifier;
            sSwitcherItem_ = self;
            }
        }

    return sSwitcherItem_;
    }

@end //TauToolbarSwitcherItem class

// TauToolbarFlexibleSpaceItem class
@implementation TauToolbarFlexibleSpaceItem : TauToolbarItem

TauToolbarFlexibleSpaceItem static* sFlexibleSpaceItem_;
- ( instancetype ) init
    {
    if ( !sFlexibleSpaceItem_ )
        {
        if ( self = [ super init ] )
            {
            self.itemIdentifier = NSToolbarFlexibleSpaceItemIdentifier;
            sFlexibleSpaceItem_ = self;
            }
        }

    return sFlexibleSpaceItem_;
    }

@end //TauToolbarFlexibleSpaceItem class

// TauToolbarFixedSpaceItem class
@implementation TauToolbarFixedSpaceItem : TauToolbarItem

TauToolbarFixedSpaceItem static* sFixedSpaceItem_;
- ( instancetype ) init
    {
    if ( !sFixedSpaceItem_ )
        {
        if ( self = [ super init ] )
            {
            self.itemIdentifier = NSToolbarSpaceItemIdentifier;
            sFixedSpaceItem_ = self;
            }
        }

    return sFixedSpaceItem_;
    }

@end // TauToolbarFixedSpaceItem class

// TauUserProfileItem class
@implementation TauToolbarUserProfileItem : TauToolbarItem

TauToolbarUserProfileItem static* sUserProfileItem_;
- ( instancetype ) init
    {
    if ( !sUserProfileItem_ )
        {
        if ( self = [ super init ] )
            {
            self.itemIdentifier = TauToolbarUserProfileButtonItemIdentifier;
            sUserProfileItem_ = self;
            }
        }

    return sUserProfileItem_;
    }

@end // TauUserProfileItem class