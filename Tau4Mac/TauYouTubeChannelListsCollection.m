//
//  TauYouTubeChannelListsCollection.m
//  Tau4Mac
//
//  Created by Tong G. on 3/15/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauYouTubeChannelListsCollection.h"

// TauYouTubeChannelListsCollection class
@implementation TauYouTubeChannelListsCollection

@dynamic channelLists;

// An object observing the channelLists property must be notified
// when super's ytCollectionObject properties change,
// as it affects the value of the property
+ ( NSSet <NSString*>* ) keyPathsForValuesAffectingChannelLists
    {
    return [ NSSet setWithObjects: kYtBackingCollectionObjectKey, nil ];
    }

- ( NSArray <GTLYouTubeChannel*>* ) channelLists
    {
    return ( NSArray <GTLYouTubeChannel*>* )( ytBackingCollectionObject_.items );
    }

- ( NSUInteger ) countOfSearchListResults
    {
    return ytBackingCollectionObject_.items.count;
    }

- ( NSArray* ) channelListsAtIndexes: ( NSIndexSet* )_Indexes
    {
    return [ ytBackingCollectionObject_.items objectsAtIndexes: _Indexes ];
    }

- ( void ) getChannelLists: ( GTLYouTubeChannel* __unsafe_unretained* )_Buffer
                     range: ( NSRange )_InRange
    {
    [ ytBackingCollectionObject_.items getObjects: _Buffer range: _InRange ];
    }

@end // TauYouTubeChannelListsCollection class