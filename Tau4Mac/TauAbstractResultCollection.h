//
//  TauAbstractResultCollection.h
//  Tau4Mac
//
//  Created by Tong G. on 3/14/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#define kYtBackingCollectionObjectKey  @"ytBackingCollectionObject_"

#define kResultsPerPageKey      @"resultsPerPage"
#define kTotalResultsKey        @"totalResults"
#define kPrevPageTokenKey       @"prevPageToken"
#define kNextPageTokenKey       @"nextPageToken"

// TauAbstractResultCollection class
@interface TauAbstractResultCollection : NSObject
    {
@protected
    GTLCollectionObject __strong* ytBackingCollectionObject_;
    }

#pragma mark - Initializations

- ( instancetype ) initWithGTLCollectionObject: ( GTLCollectionObject* )_GTLCollectionObject;

#pragma mark - Properties

// KVO-Observable
@property ( strong, readwrite ) GTLCollectionObject* ytCollectionObject;

// The number of results included in the API response.
// KVO-Observable
@property ( assign, readonly ) NSInteger resultsPerPage;

// The total number of results in the result set.
// KVO-Observable
@property ( assign, readonly ) NSInteger totalResults;

// The token that can be used as the value of the pageToken parameter to
// retrieve the previous page in the result set.
// KVO-Observable
@property ( strong, readonly ) NSString* prevPageToken;

// The token that can be used as the value of the pageToken parameter to
// retrieve the next page in the result set.
// KVO-Observable
@property ( strong, readonly ) NSString* nextPageToken;

@end // TauAbstractResultCollection class