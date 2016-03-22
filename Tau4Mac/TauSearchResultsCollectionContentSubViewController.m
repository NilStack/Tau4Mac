//
//  TauSearchResultsCollectionContentSubViewController.m
//  Tau4Mac
//
//  Created by Tong G. on 3/20/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauSearchResultsCollectionContentSubViewController.h"
#import "TauToolbarItem.h"

// TauSearchResultsAccessoryBarViewController class
@interface TauSearchResultsAccessoryBarViewController : NSTitlebarAccessoryViewController
@end // TauSearchResultsAccessoryBarViewController class



// ------------------------------------------------------------------------------------------------------------ //



// Private
@interface TauSearchResultsCollectionContentSubViewController ()

// Model: Feed me, if you dare.
@property ( strong, readwrite ) NSArray <GTLYouTubeSearchResult*>* searchResults;   // KVB-compliant
@property ( strong, readwrite ) NSString* prevToken_;   // KVB-compliant
@property ( strong, readwrite ) NSString* nextToken_;   // KVB-compliant
@property ( assign, readwrite, setter = setPaging: ) BOOL isPaging;   // KVB compliant

@property ( weak ) IBOutlet NSArrayController* searchResultsModelController_;
@property ( weak ) IBOutlet TauSearchResultsAccessoryBarViewController* accessoryBarViewController_;
@property ( strong, readonly ) TauContentCollectionViewController* contentCollectionViewController_;
@property ( strong, readonly ) TauYTDataServiceCredential* credential_;

- ( void ) executeSearchWithPageToken_: ( NSString* )_PageToken;

@end // Private



// ------------------------------------------------------------------------------------------------------------ //



// TauSearchResultsCollectionContentSubViewController class
@implementation TauSearchResultsCollectionContentSubViewController
    {
    TauYTDataServiceCredential __strong* priCredential_;
    NSDictionary __strong* priOriginalOperationsCombination_;
    TauContentCollectionViewController __strong* priContentCollectionViewController_;
    }

#pragma mark - Conforms to <TauContentCollectionViewRelayDataSource>

- ( NSArray <GTLObject*>* ) contentCollectionViewRequiredData: ( TauContentCollectionViewController* )_Controller
    {
    if ( _Controller == priContentCollectionViewController_ )
        return self.searchResults;
    return nil;
    }

#pragma mark - Actions

- ( IBAction ) loadPrevPageAction: ( id )_Sender
    {
    [ self executeSearchWithPageToken_: self.prevToken_ ];
    }

- ( IBAction ) loadNextPageAction: ( id )_Sender
    {
    [ self executeSearchWithPageToken_: self.nextToken_ ];
    }

- ( IBAction ) cancelAction: ( id )_Sender
    {
    id consumer = self;
    [ [ TauYTDataService sharedService ] unregisterConsumer: consumer withCredential: priCredential_ ];

    [ self popMe ];
    }

#pragma mark - Overrides

- ( NSTitlebarAccessoryViewController* ) titlebarAccessoryViewControllerWhileActive
    {
    return self.accessoryBarViewController_;
    }

#pragma mark - External KVB Compliant

@synthesize searchText = searchText_;
+ ( BOOL ) automaticallyNotifiesObserversOfSearchText
    {
    return NO;
    }

- ( void ) setSearchText: ( NSString* )_New
    {
    if ( searchText_ != _New )
        {
        [ self willChangeValueForKey: @"searchText" ];
        searchText_ = _New;

        priOriginalOperationsCombination_ =
            @{ TauTDSOperationMaxResultsPerPage : @50, TauTDSOperationRequirements : @{ TauTDSOperationRequirementQ : searchText_ }, TauTDSOperationPartFilter : @"snippet" };

        [ self executeSearchWithPageToken_: nil ];
        [ self didChangeValueForKey: @"searchText" ];
        }
    }

- ( NSString* ) searchText
    {
    return searchText_;
    }

@dynamic hasPrev;
+ ( NSSet <NSString*>* ) keyPathsForValuesAffectingHasPrev
    {
    return [ NSSet setWithObjects: @"prevToken_", nil ];
    }

- ( BOOL ) hasPrev
    {
    return ( self.prevToken_ != nil );
    }

@dynamic hasNext;
+ ( NSSet <NSString*>* ) keyPathsForValuesAffectingHasNext
    {
    return [ NSSet setWithObjects: @"nextToken_", nil ];
    }

- ( BOOL ) hasNext
    {
    return ( self.nextToken_ != nil );
    }

@synthesize isPaging = isPaging_;
+ ( BOOL ) automaticallyNotifiesObserversOfIsPaging
    {
    return NO;
    }

- ( void ) setPaging: ( BOOL )_Flag
    {
    if ( isPaging_ != _Flag )
        {
        [ self willChangeValueForKey: @"isPaging" ];
        isPaging_ = _Flag;
        [ self didChangeValueForKey: @"isPaging" ];
        }
    }

- ( BOOL ) isPaging
    {
    return isPaging_;
    }

#pragma mark - Internal KVB Compliant

@synthesize searchResults = searchResults_;
+ ( BOOL ) automaticallyNotifiesObserversOfSearchResults
    {
    return NO;
    }

// Directly invoked by TDS.
// We should never invoke this method explicitly.
- ( void ) setSearchResults: ( NSArray <GTLYouTubeSearchResult*>* )_New
    {
    if ( searchResults_ != _New )
        {
        [ self willChangeValueForKey: @"searchResults" ];
        searchResults_ = _New;
        [ self.contentCollectionViewController_ reloadData ];
        [ self didChangeValueForKey: @"searchResults" ];
        }
    }

- ( NSArray <GTLYouTubeSearchResult*>* ) searchResults
    {
    return searchResults_;
    }

- ( NSUInteger ) countOfSearchResults
    {
    return searchResults_.count;
    }

- ( NSArray <GTLYouTubeSearchResult*>* ) searchResultsAtIndexes: ( NSIndexSet* )_Indexes
    {
    return [ searchResults_ objectsAtIndexes: _Indexes ];
    }

- ( void ) getSearchResults: ( GTLYouTubeSearchResult* __unsafe_unretained* )_Buffer range: ( NSRange )_InRange
    {
    [ searchResults_ getObjects: _Buffer range: _InRange ];
    }

@synthesize prevToken_;
@synthesize nextToken_;

#pragma mark - Private

@synthesize accessoryBarViewController_;

@dynamic contentCollectionViewController_;
- ( TauContentCollectionViewController* ) contentCollectionViewController_
    {
    if ( !priContentCollectionViewController_ )
        {
        priContentCollectionViewController_ = [ [ TauContentCollectionViewController alloc ] initWithNibName: nil bundle: nil ];
        [ priContentCollectionViewController_ setRelayDataSource: self ];
        [ self addChildViewController: priContentCollectionViewController_ ];
        [ self.view addSubview: priContentCollectionViewController_.view ];
        [ priContentCollectionViewController_.view autoPinEdgesToSuperviewEdges ];
        }

    return priContentCollectionViewController_;
    }

@dynamic credential_;
- ( TauYTDataServiceCredential* ) credential_
    {
    if ( !priCredential_ )
        {
        id consumer = self;
        priCredential_ =
            [ [ TauYTDataService sharedService ] registerConsumer: consumer
                                              withMethodSignature: [ self methodSignatureForSelector: _cmd ]
                                                  consumptionType: TauYTDataServiceConsumptionSearchResultsType ];
        }

    return priCredential_;
    }

- ( void ) executeSearchWithPageToken_: ( NSString* )_PageToken
    {
    NSDictionary* operationsCombination = nil;
    if ( _PageToken && ( _PageToken.length > 0 ) )
        {
        NSMutableDictionary* modified = [ NSMutableDictionary dictionaryWithDictionary: priOriginalOperationsCombination_ ];
        [ modified setObject: _PageToken forKey: TauTDSOperationPageToken ];
        operationsCombination = modified;
        }
    else
        operationsCombination = priOriginalOperationsCombination_;

    self.isPaging = ( _PageToken != nil );
    [ [ TauYTDataService sharedService ] executeConsumerOperations: operationsCombination
                                                    withCredential: self.credential_
                                                           success:
    ^( NSString* _PrevPageToken, NSString* _NextPageToken )
        {
        DDLogDebug( @"%@", self.searchResults );

        self.prevToken_ = _PrevPageToken;
        self.nextToken_ = _NextPageToken;
        self.isPaging = NO;
        } failure: ^( NSError* _Error )
            {
            DDLogRecoverable( @"Failed to execute the searching due to {%@}.", _Error );
            self.isPaging = NO;
            } ];
    }

@end // TauSearchResultsCollectionContentSubViewController class



// ------------------------------------------------------------------------------------------------------------ //



// TauSearchResultsAccessoryBarViewController class
@implementation TauSearchResultsAccessoryBarViewController
@end // TauSearchResultsAccessoryBarViewController class