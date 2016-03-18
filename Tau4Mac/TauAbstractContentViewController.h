//
//  TauAbstractContentViewController.h
//  Tau4Mac
//
//  Created by Tong G. on 3/17/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

@protocol TauContentSubViewController;

@class TauViewsStack;

#define activedSubViewController_kvoKey @"activedSubViewController"

// TauAbstractContentViewController class
@interface TauAbstractContentViewController : NSViewController
    {
@protected
    // Layout caches
    NSArray __strong* activedPinEdgesCache_;
    }

#pragma mark - KVO Observable External Properties

@property ( strong, readonly ) TauViewsStack* viewsStack;
@property ( weak, readonly ) NSViewController <TauContentSubViewController>* activedSubViewController;

@end // TauAbstractContentViewController class

// TauContentSubViewController protocol
@protocol TauContentSubViewController <NSObject>

@optional
@property ( strong, readonly ) NSAppearance* windowAppearanceWhileActive;

@property ( strong, readonly ) NSArray <NSString*>* exposedToolbarItemIdentifiersWhileActive;
@property ( strong, readonly ) NSArray <NSToolbarItem*>* exposedToolbarItemsWhileActive;

@property ( strong, readonly ) NSTitlebarAccessoryViewController* titlebarAccessoryViewControllerWhileActive;

@end // TauContentSubViewController protocol