//
//  TauYouTubePlaylistItemsCollection.h
//  Tau4Mac
//
//  Created by Tong G. on 3/15/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauAbstractResultCollection.h"

// TauYouTubePlaylistItemsCollection class
@interface TauYouTubePlaylistItemsCollection : TauAbstractResultCollection

@property ( strong, readonly ) NSArray <GTLYouTubePlaylistItem*>* playlistItems;   // KVO-Observable

@end // TauYouTubePlaylistItemsCollection class