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

#pragma mark - Relay the Delicious of TauToolbarController

// Relay the delicious that will be used to feed the singleton of TauToolbarController class
// from self.selectedTab to the instance of TauExploreSubContentViewController

@property ( strong, readonly ) NSTitlebarAccessoryViewController* titlebarAccessoryViewControllerWhileActive;   // KVO-observable

#pragma mark - External KVB Comliant Properties

@property ( strong, readwrite ) NSArray <TauMeTubeTabItem*>* selectedTabs;  // KVB-compliant

@end // TauMeTubePlayground class



// ------------------------------------------------------------------------------------------------------------ //



// TauMeTubeTabItem class
@interface TauMeTubeTabItem : NSObject

@property ( strong, readwrite ) NSString* tabTitle;

@property ( strong, readwrite ) NSString* repPlaylistName;
@property ( strong, readwrite ) NSString* repPlaylistIdentifier;

@property ( strong, readwrite ) NSViewController* viewController;

#pragma mark - Initializations

- ( instancetype ) initWithTitle: ( NSString* )_Title playlistName: ( NSString* )_PlaylistName playlistIdentifier: ( NSString* )_PlaylistId viewController: ( NSViewController* )_ViewController;

@end // TauMeTubeTabItem class