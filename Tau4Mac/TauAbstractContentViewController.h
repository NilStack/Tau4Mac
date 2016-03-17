//
//  TauAbstractContentViewController.h
//  Tau4Mac
//
//  Created by Tong G. on 3/17/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

// TauAbstractContentViewController class
@interface TauAbstractContentViewController : NSViewController

@end // TauAbstractContentViewController class

// TauContentSubViewController protocol
@protocol TauContentSubViewController <NSObject>

@property ( strong, readonly ) NSAppearance* windowAppearanceWhileActive;

@property ( strong, readonly ) NSArray <NSString*>* exposedToolbarItemIdentifiersWhileActive;
@property ( strong, readonly ) NSArray <NSToolbarItem*>* exposedToolbarItemsWhileActive;

@property ( strong, readonly ) NSTitlebarAccessoryViewController* titlebarAccessoryViewControllerWhileActive;

@end // TauContentSubViewController protocol