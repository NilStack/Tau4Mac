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
@class TauToolbarAdaptiveSpaceItem;
@class TauToolbarUserProfileItem;

// TauToolbarItem class
@interface TauToolbarItem : NSObject

#pragma mark - Initializations

- ( instancetype ) initWithIdentifier: ( NSString*)_Id label: ( NSString* )_Label image: ( NSImage* )_Image toolTip: ( NSString* )_Tooltip invocation: ( NSInvocation* )_Invocation;
- ( instancetype ) initWithIdentifier: ( NSString*)_Id label: ( NSString* )_Label view: ( NSView* )_View;

#pragma mark - Properties

@property ( copy, readwrite ) NSString* identifier;

@property ( copy, readwrite ) NSString* label;
@property ( copy, readwrite ) NSString* paleteLabel;
@property ( copy, readwrite ) NSString* toolTip;
@property ( strong, readwrite ) NSInvocation* invocation;
@property ( strong, readwrite ) NSMenu* repMenu;

@property ( strong, readwrite ) NSView* view;
@property ( strong, readwrite ) NSImage* image;

@property ( weak, readonly ) NSToolbarItem* cocoaToolbarItemRep;

#pragma mark - Common Items

+ ( TauToolbarSwitcherItem* ) switcherItem;
+ ( TauToolbarFlexibleSpaceItem* ) flexibleSpaceItem;
+ ( TauToolbarFixedSpaceItem* ) fixedSpaceItem;
+ ( TauToolbarAdaptiveSpaceItem* ) adaptiveSpaceItem;
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

// TauToolbarAdaptiveSpaceItem class
@interface TauToolbarAdaptiveSpaceItem : TauToolbarItem
@end // TauToolbarAdaptiveSpaceItem class

// TauUserProfileItem class
@interface TauToolbarUserProfileItem : TauToolbarItem
@end // TauUserProfileItem class

// NSArray + TauToolbarItem
@interface NSArray ( TauToolbarItem )

- ( NSArray <NSString*>* ) cocoaToolbarIdentifiers;
- ( TauToolbarItem* ) itemWithIdentifier: ( NSString* )_Identifier;
- ( BOOL ) containsItemWithIdentifier: ( NSString* )_Identifier;

@end // NSArray + TauToolbarItem