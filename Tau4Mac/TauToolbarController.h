//
//  TauToolbarController.h
//  Tau4Mac
//
//  Created by Tong G. on 3/18/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

// TauToolbarController class
@interface TauToolbarController : NSObject <NSToolbarDelegate>

@property ( strong, readonly ) NSSegmentedControl* segSwitcher;

+ ( instancetype ) sharedController;

@end // TauToolbarController class