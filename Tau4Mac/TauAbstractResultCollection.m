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

    if ( [ _Key isEqualToString: TAU_KVO_KEY( items ) ]
            || [ _Key isEqualToString: TAU_KVO_KEY( count ) ]
            || [ _Key isEqualToString: TAU_KVO_KEY( firstObject ) ]
            || [ _Key isEqualToString: TAU_KVO_KEY( lastObject ) ]
            || [ _Key isEqualToString: TAU_KVO_KEY( resultsPerPage ) ]
            || [ _Key isEqualToString: TAU_KVO_KEY( totalResults ) ]
            || [ _Key isEqualToString: TAU_KVO_KEY( prevPageToken ) ]
            || [ _Key isEqualToString: TAU_KVO_KEY( nextPageToken ) ] )
        paths = [ NSSet setWithObjects: TAU_KVO_KEY( ytCollectionObject ), nil ];

    return paths;
    }

#pragma mark - Initializations

- ( instancetype ) initWithGTLCollectionObject: ( GTLCollectionObject* )_GTLCollectionObject
    {
    if ( self = [ super init ] )
        ytCollectionObject_ = _GTLCollectionObject;

    return self;
    }

#pragma mark - Conforms to <NSFastEnumeration>

- ( NSUInteger ) countByEnumeratingWithState: ( NSFastEnumerationState* )_State objects: ( __unsafe_unretained id _Nonnull* )_Buffer count: ( NSUInteger )_Len
    {
    return [ ytCollectionObject_ countByEnumeratingWithState: _State objects: _Buffer count: _Len ];
    }

#pragma mark - External KVO Compliant Properties

@synthesize ytCollectionObject = ytCollectionObject_;

@dynamic items;
- ( NSArray <GTLObject*>* ) items
    {
    return ytCollectionObject_.items;
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
- ( NSUInteger ) count
    {
    return self.items.count;
    }

@dynamic firstObject;
@dynamic lastObject;
- ( GTLObject* ) firstObject
    {
    return self.items.firstObject;
    }

- ( GTLObject* ) lastObject
    {
    return self.items.lastObject;
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

    if ( ytCollectionObject_ )
        {
        @try {
            token = [ ytCollectionObject_ valueForKey: TAU_KVO_KEY( prevPageToken ) ];
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

    if ( ytCollectionObject_ )
        {
        @try {
            token = [ ytCollectionObject_
             valueForKey: TAU_KVO_KEY( nextPageToken ) ];
        } @catch ( NSException* _Ex )
            {
            DDLogUnexpected( @"Exception captured: %@", _Ex );
            }
        }

    return token;
    }

#pragma mark - Private Interfaces

@dynamic pageInfo_;

- ( GTLYouTubePageInfo* ) pageInfo_
    {
    GTLYouTubePageInfo* pageInfo = nil;

    @try {
    pageInfo = [ ytCollectionObject_ valueForKey: TAU_KVO_KEY( pageInfo ) ];
    } @catch ( NSException* _Ex )
        {
        DDLogUnexpected( @"Exception captured: %@", _Ex );
        }

    return pageInfo;
    }

@end // TauAbstractResultCollection class