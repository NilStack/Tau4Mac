//
//  TauToolbarController.h
//  Tau4Mac
//
//  Created by Tong G. on 3/18/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

NSString extern* const TauToolbarIdentifier;

NSString extern* const TauToolbarAdaptiveSpaceItemIdentifier;
NSString extern* const TauToolbarSwitcherItemIdentifier;
NSString extern* const TauToolbarUserProfileButtonItemIdentifier;

@class TauAbstractContentSubViewController;
@class TauToolbarItem;

// TauToolbarController class
@interface TauToolbarController : NSObject <NSToolbarDelegate>

// --------------------------------------------------------------------------------------------



@property ( assign, readwrite ) TauContentViewTag contentViewAffiliatedTo;  // KVB compliant
@property ( strong, readwrite ) NSAppearance* appearance;   // KVB compliant
@property ( strong, readwrite ) NSArray <TauToolbarItem*>* toolbarItems;  // KVB compliant
@property ( strong, readwrite ) NSTitlebarAccessoryViewController* accessoryViewController;   // KVB compliant



// --------------------------------------------------------------------------------------------

+ ( instancetype ) sharedController;

@end // TauToolbarController class