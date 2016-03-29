//
//  TauAbstractResultCollection.m
//  Tau4Mac
//
//  Created by Tong G. on 3/14/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauAbstractResultCollection.h"

// Private Interfaces
@interface TauAbstractResultCollection ()

@property ( copy, readwrite ) GTLCollectionObject* ytBackingCollectionObject_;
@property ( strong, readonly ) GTLYouTubePageInfo* pageInfo_;

@end // Private Interfaces

// TauAbstractResultCollection class
@implementation TauAbstractResultCollection

#pragma mark - KVC Compliance

+ ( BOOL ) accessInstanceVariablesDirectly
    {
    return YES;
    }

+ ( NSSet <NSString*>* ) keyPathsForValuesAffectingValueForKey: ( NSString* )_Key
    {
    NSSet <NSString*>* paths = [ super keyPathsForValuesAffectingValueForKey: _Key ];

    if ( [ _Key isEqualToString: kResultsPerPageKey ]
            || [ _Key isEqualToString: kTotalResultsKey ]
            || [ _Key isEqualToString: kPrevPageTokenKey ]
            || [ _Key isEqualToString: kNextPageTokenKey ] )
        paths = [ NSSet setWithObjects: kYtBackingCollectionObjectKey, nil ];

    return paths;
    }

#pragma mark - Initializations

- ( instancetype ) initWithGTLCollectionObject: ( GTLCollectionObject* )_GTLCollectionObject
    {
    if ( self = [ super init ] )
        self.ytBackingCollectionObject_ = _GTLCollectionObject;

    return self;
    }

#pragma mark - External KVO Compliant Properties

@dynamic items;
- ( NSArray <GTLObject*>* ) items
    {
    return ytBackingCollectionObject_.items;
    }

- ( NSUInteger ) countOfItems
    {
    return self.items.count;
    }

- ( NSArray <GTLObject*>* ) itemsAtIndexes: ( NSIndexSet* )_Indexes
    {
    return [ self.items objectsAtIndexes: _Indexes ];
    }

- ( void ) getItems: ( GTLObject * __unsafe_unretained* )_Buffer range: ( NSRange )_InRange
    {
    [ self.items getObjects: _Buffer range: _InRange ];
    }

@dynamic count;
+ ( NSSet <NSString*>* ) keyPathsForValuesAffectingCount
    {
    return [ NSSet setWithObjects: FBKVOClassKeyPath( TauAbstractResultCollection, items ), nil ];
    }

- ( NSUInteger ) count
    {
    return self.items.count;
    }

@dynamic resultsPerPage;
@dynamic totalResults;
@dynamic prevPageToken;
@dynamic nextPageToken;

- ( NSInteger ) resultsPerPage
    {
    NSNumber* result = @( -1 );

    if ( self.pageInfo_ )
        result = self.pageInfo_.resultsPerPage;

    return result.integerValue;
    }

- ( NSInteger ) totalResults
    {
    NSNumber* result = @( -1 );

    if ( self.pageInfo_ )
        result = self.pageInfo_.totalResults;

    return result.integerValue;
    }

- ( NSString* ) prevPageToken
    {
    NSString* token = nil;

    if ( ytBackingCollectionObject_ )
        {
        @try {
            token = [ ytBackingCollectionObject_ valueForKey: @"prevPageToken" ];
        } @catch ( NSException* _Ex )
            {
            DDLogUnexpected( @"Exception captured: %@", _Ex );
            }
        }

    return token;
    }

- ( NSString* ) nextPageToken
    {
    NSString* token = nil;

    if ( ytBackingCollectionObject_ )
        {
        @try {
            token = [ ytBackingCollectionObject_
             valueForKey: @"nextPageToken" ];
        } @catch ( NSException* _Ex )
            {
            DDLogUnexpected( @"Exception captured: %@", _Ex );
            }
        }

    return token;
    }

@dynamic ytCollectionObject;

- ( void ) setYtCollectionObject: ( GTLCollectionObject* )_YtCollectionObject
    {
    [ self setValue: _YtCollectionObject forKey: kYtBackingCollectionObjectKey ];
    }

- ( GTLCollectionObject* ) ytCollectionObject
    {
    return [ [ self valueForKey: kYtBackingCollectionObjectKey ] copy ];
    }

#pragma mark - Private Interfaces

@dynamic pageInfo_;
@synthesize ytBackingCollectionObject_ = ytBackingCollectionObject_;

- ( GTLYouTubePageInfo* ) pageInfo_
    {
    GTLYouTubePageInfo* pageInfo = nil;

    @try {
    pageInfo = [ ytBackingCollectionObject_ valueForKey: @"pageInfo" ];
    } @catch ( NSException* _Ex )
        {
        DDLogUnexpected( @"Exception captured: %@", _Ex );
        }

    return pageInfo;
    }

@end // TauAbstractResultCollection class