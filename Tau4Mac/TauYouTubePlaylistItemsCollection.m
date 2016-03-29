//
//  TauYouTubePlaylistItemsCollection.m
//  Tau4Mac
//
//  Created by Tong G. on 3/15/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauYouTubePlaylistItemsCollection.h"

// TauYouTubePlaylistItemsCollection class
@implementation TauYouTubePlaylistItemsCollection

@dynamic playlistItems;

// An object observing the playlistItems property must be notified
// when super's ytCollectionObject properties change,
// as it affects the value of the property
+ ( NSSet <NSString*>* ) keyPathsForValuesAffectingPlaylistItems
    {
    return [ NSSet setWithObjects: TAU_KVO_KEY( ytCollectionObject ), nil ];
    }

- ( NSArray <GTLYouTubePlaylistItem*>* ) playlistItems
    {
    return ( NSArray <GTLYouTubePlaylistItem*>* )( self.ytCollectionObject.items );
    }

- ( NSUInteger ) countOfPlaylistItems
    {
    return self.ytCollectionObject.items.count;
    }

- ( NSArray* ) playlistItemsAtIndexes: ( NSIndexSet* )_Indexes
    {
    return [ self.ytCollectionObject.items objectsAtIndexes: _Indexes ];
    }

- ( void ) getPlaylistItems: ( GTLYouTubePlaylistItem* __unsafe_unretained* )_Buffer
                      range: ( NSRange )_InRange
    {
    [ self.ytCollectionObject.items getObjects: _Buffer range: _InRange ];
    }

@end // TauYouTubePlaylistItemsCollection class