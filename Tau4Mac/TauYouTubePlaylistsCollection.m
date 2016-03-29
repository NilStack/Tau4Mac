//
//  TauYouTubePlaylistsCollection.m
//  Tau4Mac
//
//  Created by Tong G. on 3/15/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauYouTubePlaylistsCollection.h"

// TauYouTubePlaylistsCollection class
@implementation TauYouTubePlaylistsCollection

@dynamic playlists;

// An object observing the playlists property must be notified
// when super's ytCollectionObject properties change,
// as it affects the value of the property
+ ( NSSet <NSString*>* ) keyPathsForValuesAffectingPlaylists
    {
    return [ NSSet setWithObjects: TauKVOKey( ytCollectionObject ), nil ];
    }

- ( NSArray <GTLYouTubePlaylist*>* ) playlists
    {
    return ( NSArray <GTLYouTubePlaylist*>* )( self.ytCollectionObject.items );
    }

- ( NSUInteger ) countOfPlaylists
    {
    return self.ytCollectionObject.items.count;
    }

- ( NSArray* ) playlistsAtIndexes: ( NSIndexSet* )_Indexes
    {
    return [ self.ytCollectionObject.items objectsAtIndexes: _Indexes ];
    }

- ( void ) getPlaylists: ( GTLYouTubePlaylist* __unsafe_unretained* )_Buffer
                  range: ( NSRange )_InRange
    {
    [ self.ytCollectionObject.items getObjects: _Buffer range: _InRange ];
    }

@end // TauYouTubePlaylistsCollection class