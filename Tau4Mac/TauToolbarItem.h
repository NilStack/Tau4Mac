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

@property ( copy, readwrite ) NSString* label;
@property ( copy, readwrite ) NSString* paleteLabel;
@property ( copy, readwrite ) NSString* toolTip;
@property ( weak, readwrite ) id target;
@property ( assign, readwrite ) SEL action;
@property ( strong, readwrite ) id content;

- ( instancetype ) initWithIdentifier: ( NSString*)_Id label: ( NSString* )_Label toolTip: ( NSString* )_Tooltip target: ( id )_Target action: ( SEL )_Action;
- ( instancetype ) initWithIdentifier: ( NSString*)_Id label: ( NSString* )_Label toolTip: ( NSString* )_Tooltip content: ( id )_Content;

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
- ( TauToolbarItem* ) itemWithIdentifier: ( NSString* )_Identifier;
- ( BOOL ) containsItemWithIdentifier: ( NSString* )_Identifier;

@end // NSArray + TauToolbarItem