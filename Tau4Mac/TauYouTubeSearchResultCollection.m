//
//  TauYouTubeSearchResultCollection.m
//  Tau4Mac
//
//  Created by Tong G. on 3/14/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauYouTubeSearchResultCollection.h"

// TauYouTubeSearchResultCollection class
@implementation TauYouTubeSearchResultCollection

@dynamic searchListResults;

// An object observing the searchListResults property must be notified
// when super's ytCollectionObject properties change,
// as it affects the value of the property
+ ( NSSet <NSString*>* ) keyPathsForValuesAffectingSearchListResults
    {
    return [ NSSet setWithObjects: kYtBackingCollectionObjectKey, nil ];
    }

- ( NSArray <GTLYouTubeSearchResult*>* ) searchListResponse
    {
    return ( NSArray <GTLYouTubeSearchResult*>* )( ytBackingCollectionObject_.items );
    }

- ( NSUInteger ) countOfSearchListResponse
    {
    return ytBackingCollectionObject_.items.count;
    }

- ( NSArray* ) searchListResultsAtIndexes: ( NSIndexSet* )_Indexes
    {
    return [ ytBackingCollectionObject_.items objectsAtIndexes: _Indexes ];
    }

- ( void ) getSearchListResults: ( GTLYouTubeSearchResult* __unsafe_unretained* )_Buffer
                          range: ( NSRange )_InRange
    {
    [ ytBackingCollectionObject_.items getObjects: _Buffer range: _InRange ];
    }

@end // TauYouTubeSearchResultCollection class
