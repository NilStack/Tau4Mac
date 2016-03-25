//
//  TauSearchResultsCollectionContentSubViewController.m
//  Tau4Mac
//
//  Created by Tong G. on 3/20/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauSearchResultsCollectionContentSubViewController.h"
#import "TauToolbarItem.h"

// Private
@interface TauSearchResultsCollectionContentSubViewController ()

// Model: Feed me, if you dare.
@property ( strong, readwrite ) NSArray <GTLYouTubeSearchResult*>* searchResults;   // KVB-compliant

@end // Private



// ------------------------------------------------------------------------------------------------------------ //



// TauSearchResultsCollectionContentSubViewController class
@implementation TauSearchResultsCollectionContentSubViewController

#pragma mark - Initializations

- ( instancetype ) initWithNibName: ( NSString* )_NibNameOrNil bundle: ( NSBundle* )_NibBundleOrNil
    {
    Class superClass = [ TauAbstractCollectionContentSubViewController class ];
    return [ super initWithNibName: NSStringFromClass( superClass ) bundle: [ NSBundle bundleForClass: superClass ] ];
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
        TAU_CHANGE_VALUE_FOR_KEY_of_SEL( @selector( searchText ),
         ( ^{
            searchText_ = _New;

            self.originalOperationsCombination =
                @{ TauTDSOperationMaxResultsPerPage : @50, TauTDSOperationRequirements : @{ TauTDSOperationRequirementQ : searchText_ }, TauTDSOperationPartFilter : @"snippet" };
            } ) );
        }
    }

- ( NSString* ) searchText
    {
    return searchText_;
    }

#pragma mark - Overrides

- ( NSString* ) resultsSummaryText
    {
    NSUInteger __block channelsCount = 0u;
    NSUInteger __block playlistsCount = 0u;
    NSUInteger __block videosCount = 0u;

    [ searchResults_ enumerateObjectsUsingBlock:
    ^( GTLYouTubeSearchResult* _Nonnull _Result, NSUInteger _Idx, BOOL* _Nonnull _Stop )
        {
        NSString* kindString = _Result.identifier.kind;
        if ( [ kindString isEqualToString: @"youtube#channel" ] )
            channelsCount++;
        else if ( [ kindString isEqualToString: @"youtube#playlist" ] )
            playlistsCount++;
        else if ( [ kindString isEqualToString: @"youtube#video" ] )
            videosCount++;
        } ];

    if ( channelsCount || playlistsCount || videosCount )
        {
        return [ NSString stringWithFormat: NSLocalizedString(  @"%lu Channel%@, %lu Playlist%@ and %lu Video%@", nil )
               , channelsCount, ( channelsCount > 1 ) ? @"s" : @""
               , playlistsCount, ( playlistsCount > 1 ) ? @"s" : @""
               , videosCount, ( videosCount > 1 ) ? @"s" : @""
               ];
        }
    else
        return NSLocalizedString( @"No Results Yet", nil );
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
        TAU_CHANGE_VALUE_FOR_KEY_of_SEL( @selector( searchResults ),
         ( ^{
            searchResults_ = _New;
            self.results = searchResults_;
            } ) );
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

@end // TauSearchResultsCollectionContentSubViewController class