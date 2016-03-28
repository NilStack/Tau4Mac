//
//  TauMeTubePlayground.h
//  Tau4Mac
//
//  Created by Tong G. on 3/28/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

@class TauMeTubeTabItem;

// TauMeTubePlayground class
@interface TauMeTubePlayground : NSView

#pragma mark - Relay

@property ( strong, readonly ) NSTitlebarAccessoryViewController* titlebarAccessoryViewControllerWhileActive;

#pragma mark - External KVB Comliant Properties

@property ( strong, readwrite ) NSArray <TauMeTubeTabItem*>* selectedTabs;

@end // TauMeTubePlayground class



// ------------------------------------------------------------------------------------------------------------ //



// TauMeTubeTabItem class
@interface TauMeTubeTabItem : NSObject

@property ( strong, readwrite ) NSString* tabTitle;
@property ( strong, readwrite ) NSString* repPlaylistIdentifier;
@property ( strong, readwrite ) NSViewController* viewController;

#pragma mark - Initializations

- ( instancetype ) initWithTitle: ( NSString* )_Title playlistIdentifier: ( NSString* )_PlaylistId viewController: ( NSViewController* )_ViewController;

@end // TauMeTubeTabItem class