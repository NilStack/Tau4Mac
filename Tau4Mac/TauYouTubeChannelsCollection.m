//
//  TauYouTubeChannelsCollection.m
//  Tau4Mac
//
//  Created by Tong G. on 3/15/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauYouTubeChannelsCollection.h"

// TauYouTubeChannelsCollection class
@implementation TauYouTubeChannelsCollection

@dynamic channels;

// An object observing the channels property must be notified
// when super's ytCollectionObject properties change,
// as it affects the value of the property
+ ( NSSet <NSString*>* ) keyPathsForValuesAffectingChannels
    {
    return [ NSSet setWithObjects: TAU_KVO_KEY( ytCollectionObject ), nil ];
    }

- ( NSArray <GTLYouTubeChannel*>* ) channels
    {
    return ( NSArray <GTLYouTubeChannel*>* )( self.ytCollectionObject.items );
    }

- ( NSUInteger ) countOfChannels
    {
    return self.ytCollectionObject.items.count;
    }

- ( NSArray* ) channelsAtIndexes: ( NSIndexSet* )_Indexes
    {
    return [ self.ytCollectionObject.items objectsAtIndexes: _Indexes ];
    }

- ( void ) getChannels: ( GTLYouTubeChannel* __unsafe_unretained* )_Buffer
                 range: ( NSRange )_InRange
    {
    [ self.ytCollectionObject.items getObjects: _Buffer range: _InRange ];
    }

@end // TauYouTubeChannelsCollection class