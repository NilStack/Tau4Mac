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

// TauToolbarController class
@interface TauToolbarController : NSObject <NSToolbarDelegate>

@property ( weak ) IBOutlet NSToolbar* managedToolbar;

// --------------------------------------------------------------------------------------------



@property ( assign, readwrite ) TauContentViewTag contentViewAffiliatedTo;  // KVB compliant
@property ( strong, readwrite ) NSAppearance* appearance;



// --------------------------------------------------------------------------------------------

+ ( instancetype ) sharedController;

@end // TauToolbarController class