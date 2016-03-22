//
//  TauYouTubePlaylistsCollection.h
//  Tau4Mac
//
//  Created by Tong G. on 3/15/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauAbstractResultCollection.h"

// TauYouTubePlaylistsCollection class
@interface TauYouTubePlaylistsCollection : TauAbstractResultCollection

@property ( strong, readonly ) NSArray <GTLYouTubePlaylist*>* playlists;   // KVO-Observable

@end // TauYouTubePlaylistsCollection class