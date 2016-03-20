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

// NSArray + TauToolbarItem
@implementation NSArray ( TauToolbarItem )

- ( NSArray <NSString*>* ) cocoaToolbarIdentifiers
    {
    NSMutableArray <NSString*>* identifiers = [ NSMutableArray arrayWithCapacity: self.count ];

    for ( TauToolbarItem* _Item in self )
        {
        if ( [ _Item isMemberOfClass: [ TauToolbarItem class ] ] )
            [ identifiers addObject: _Item.itemIdentifier ];

        else if ( [ _Item isMemberOfClass: [ TauToolbarSwitcherItem class ] ] )
            [ identifiers addObject: TauToolbarSwitcherItemIdentifier ];

        else if ( [ _Item isMemberOfClass: [ TauToolbarFlexibleSpaceItem class ] ] )
            [ identifiers addObject: NSToolbarFlexibleSpaceItemIdentifier ];

        else if ( [ _Item isMemberOfClass: [ TauToolbarFixedSpaceItem class ] ] )
            [ identifiers addObject: NSToolbarSpaceItemIdentifier ];

        else if ( [ _Item isMemberOfClass: [ TauToolbarUserProfileItem class ] ] )
            [ identifiers addObject: TauToolbarUserProfileButtonItemIdentifier ];
        }

    return [ identifiers copy ];
    }

- ( TauToolbarItem* ) itemWithIdentifier: ( NSString* )_Identifier
    {
    for ( TauToolbarItem* _Item in self )
        if ( [ _Item.itemIdentifier isEqualToString: _Identifier ] )
            return _Item;

    return nil;
    }

- ( BOOL ) containsItemWithIdentifier: ( NSString* )_Identifier
    {
    BOOL contains = NO;

    for ( TauToolbarItem* _Item in self )
        {
        if ( [ _Item.itemIdentifier isEqualToString: _Identifier ] )
            {
            contains = YES;
            break;
            }
        }

    return contains;
    }

@end // NSArray + TauToolbarItem