//
//  TauPlayerController.h
//  Tau4Mac
//
//  Created by Tong G. on 4/1/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

// TauPlayerController class
@interface TauPlayerController : NSObject

@property ( strong, readonly ) AVPlayerView* playerView;

#pragma mark - Operations

- ( void ) playYouTubeVideo: ( GTLObject* )_YouTubeObject;

#pragma mark - Singleton

+ ( instancetype ) defaultTheater;

@end // TauPlayerController class