//
//  TauYouTubeSearchResultsCollection.m
//  Tau4Mac
//
//  Created by Tong G. on 3/14/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauYouTubeSearchResultsCollection.h"

// TauYouTubeSearchResultsCollection class
@implementation TauYouTubeSearchResultsCollection

@dynamic searchResults;

// An object observing the searchResults property must be notified
// when super's ytCollectionObject properties change,
// as it affects the value of the property
+ ( NSSet <NSString*>* ) keyPathsForValuesAffectingSearchResults
    {
    return [ NSSet setWithObjects: TauKVOKey( ytCollectionObject ), nil ];
    }

- ( NSArray <GTLYouTubeSearchResult*>* ) searchResults
    {
    return ( NSArray <GTLYouTubeSearchResult*>* )( self.ytCollectionObject.items );
    }

- ( NSUInteger ) countOfSearchResults
    {
    return self.ytCollectionObject.items.count;
    }

- ( NSArray* ) searchResultsAtIndexes: ( NSIndexSet* )_Indexes
    {
    return [ self.ytCollectionObject.items objectsAtIndexes: _Indexes ];
    }

- ( void ) getSearchResults: ( GTLYouTubeSearchResult* __unsafe_unretained* )_Buffer
                      range: ( NSRange )_InRange
    {
    [ self.ytCollectionObject.items getObjects: _Buffer range: _InRange ];
    }

@end // TauYouTubeSearchResultsCollection class
