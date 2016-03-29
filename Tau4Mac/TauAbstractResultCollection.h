//
//  TauAbstractResultCollection.h
//  Tau4Mac
//
//  Created by Tong G. on 3/14/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

// TauAbstractResultCollection class
@interface TauAbstractResultCollection : NSObject <NSFastEnumeration>

#pragma mark - Initializations

- ( instancetype ) initWithGTLCollectionObject: ( GTLCollectionObject* )_GTLCollectionObject;

#pragma mark - External KVO Compliant Properties

// KVO-Observable
@property ( strong, readwrite ) GTLCollectionObject* ytCollectionObject;

// The items included in the API response.
// KVO-Observable
// Being subject to change of ytCollectionObject property
@property ( strong, readonly ) NSArray <GTLObject*>* items;

// The actual number of items.
// KVO-Observable
// Being subject to change of items property
@property ( assign, readonly ) NSUInteger count;

// Returns the first object in the collection
// KVO-Observable
// Being subject to change of items property
@property ( readonly ) GTLObject* firstObject;

// Returns the last object in the collection
// KVO-Observable
// Being subject to change of items property
@property ( readonly ) GTLObject* lastObject;

// The number of results included in the API response.
// KVO-Observable
// Being subject to change of ytCollectionObject property
@property ( assign, readonly ) NSInteger resultsPerPage;

// The total number of results in the result set.
// KVO-Observable
// Being subject to change of ytCollectionObject property
@property ( assign, readonly ) NSInteger totalResults;

// The token that can be used as the value of the pageToken parameter to
// retrieve the previous page in the result set.
// KVO-Observable
// Being subject to change of ytCollectionObject property
@property ( strong, readonly ) NSString* prevPageToken;

// The token that can be used as the value of the pageToken parameter to
// retrieve the next page in the result set.
// KVO-Observable
// Being subject to change of ytCollectionObject property
@property ( strong, readonly ) NSString* nextPageToken;

@end // TauAbstractResultCollection class