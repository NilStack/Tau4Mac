//
//  TauAbstractContentViewController.h
//  Tau4Mac
//
//  Created by Tong G. on 3/17/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

@protocol TauContentSubViewController;

@class TauViewsStack;
@class TauToolbarItem;

// TauAbstractContentViewController class
@interface TauAbstractContentViewController : NSViewController
    {
@protected
    // Layout caches
    NSArray __strong* activedPinEdgesCache_;
    }

#pragma mark - KVO Observable External Properties

@property ( strong, readonly ) TauViewsStack* viewsStack;

@property ( weak, readonly ) NSViewController <TauContentSubViewController>* backgroundViewController;  // KVO-Observable
@property ( weak, readonly ) NSViewController <TauContentSubViewController>* activedSubViewController;  // KVO-Observable

#pragma mark - View Stack Operations

- ( void ) pushContentSubView: ( NSViewController <TauContentSubViewController>* )_New;
- ( void ) popContentSubView;

@end // TauAbstractContentViewController class

// TauContentSubViewController protocol
@protocol TauContentSubViewController <NSObject>

@optional
@property ( strong, readonly ) NSAppearance* windowAppearanceWhileActive;
@property ( strong, readonly ) NSArray <TauToolbarItem*>* exposedToolbarItemsWhileActive;
@property ( strong, readonly ) NSTitlebarAccessoryViewController* titlebarAccessoryViewControllerWhileActive;

@end // TauContentSubViewController protocol