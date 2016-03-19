//
//  TauToolbarItem.h
//  Tau4Mac
//
//  Created by Tong G. on 3/19/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

@class TauToolbarSwitcherItem;
@class TauToolbarFlexibleSpaceItem;
@class TauToolbarFixedSpaceItem;
@class TauToolbarUserProfileItem;

// TauToolbarItem class
@interface TauToolbarItem : NSObject

@property ( copy, readwrite ) NSString* itemIdentifier;
@property ( weak, readwrite ) NSToolbarItem* item;

#pragma mark - Common Items

+ ( TauToolbarSwitcherItem* ) switcherItem;
+ ( TauToolbarFlexibleSpaceItem* ) flexibleSpaceItem;
+ ( TauToolbarFixedSpaceItem* ) fixedSpaceItem;
+ ( TauToolbarUserProfileItem* ) userProfileItem;

@end // TauToolbarItem class

// TauToolbarSwitcherItem class
@interface TauToolbarSwitcherItem : TauToolbarItem
@end //TauToolbarSwitcherItem class

// TauToolbarFlexibleSpaceItem class
@interface TauToolbarFlexibleSpaceItem : TauToolbarItem
@end //TauToolbarFlexibleSpaceItem class

// TauToolbarFixedSpaceItem class
@interface TauToolbarFixedSpaceItem : TauToolbarItem
@end // TauToolbarFixedSpaceItem class

// TauUserProfileItem class
@interface TauToolbarUserProfileItem : TauToolbarItem
@end // TauUserProfileItem class

// NSArray + TauToolbarItem
@interface NSArray ( TauToolbarItem )
- ( NSArray <NSString*>* ) cocoaToolbarIdentifiers;
@end // NSArray + TauToolbarItem