//
//  TauToolbarController.h
//  Tau4Mac
//
//  Created by Tong G. on 3/18/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

NSString extern* const TauToolbarSwitcherItemIdentifier;
NSString extern* const TauToolbarUserProfileButtonItemIdentifier;

#define contentViewAffiliatedTo_kvoKey @"contentViewAffiliatedTo"

@class TauAbstractContentSubViewController;

// TauToolbarController class
@interface TauToolbarController : NSObject <NSToolbarDelegate>

@property ( weak ) IBOutlet NSToolbar* managedToolbar;

// --------------------------------------------------------------------------------------------



@property ( assign, readwrite ) TauContentViewTag contentViewAffiliatedTo;  // KVB compliant
@property ( weak, readwrite ) NSAppearance* appearance;   // KVB compliant
@property ( weak, readwrite ) NSArray* toolbarItemIdentifiers;  // KVB compliant
@property ( weak, readwrite ) NSTitlebarAccessoryViewController* accessoryViewController;   // KVB compliant



// --------------------------------------------------------------------------------------------

+ ( instancetype ) sharedController;

@end // TauToolbarController class