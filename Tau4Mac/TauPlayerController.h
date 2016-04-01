//
//  TauPlayerController.h
//  Tau4Mac
//
//  Created by Tong G. on 4/1/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

// TauPlayerController class
@interface TauPlayerController : NSObject

#pragma mark - UI Elements

@property ( strong, readonly ) AVPlayerView* playerView;

#pragma mark - Player Operations

- ( void ) playYouTubeVideo: ( GTLObject* )_YouTubeObject switchToPlayer: ( BOOL )_Flag;
- ( void ) playYouTubeVideoWithVideoIdentifier: ( NSString* )_VideoIdentifier switchToPlayer: ( BOOL )_Flag;

#pragma mark - Singleton

+ ( instancetype ) defaultPlayerController;

@end // TauPlayerController class