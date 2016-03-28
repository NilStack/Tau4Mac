//
//  TauMeTubeTabModel.h
//  Tau4Mac
//
//  Created by Tong G. on 3/28/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

// TauMeTubeTabModel class
@interface TauMeTubeTabModel : NSObject

@property ( strong, readwrite ) NSString* tabTitle;
@property ( strong, readwrite ) NSString* repPlaylistIdentifier;
@property ( strong, readwrite ) NSViewController* viewController;

#pragma mark - Initializations

- ( instancetype ) initWithTitle: ( NSString* )_Title playlistIdentifier: ( NSString* )_PlaylistId viewController: ( NSViewController* )_ViewController;

@end // TauMeTubeTabModel class