//
//  TauSearchResultsCollectionContentSubViewController.m
//  Tau4Mac
//
//  Created by Tong G. on 3/20/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauSearchResultsCollectionContentSubViewController.h"
#import "TauToolbarItem.h"
#import "TauSearchDashboardController.h"

// Private
@interface TauSearchResultsCollectionContentSubViewController ()

// Model: Feed me, if you dare.
@property ( weak, readwrite ) TauYouTubeSearchResultsCollection* searchResults;   // KVB-compliant

@end // Private

// TauSearchResultsCollectionContentSubViewController class
@implementation TauSearchResultsCollectionContentSubViewController

#pragma mark - Initializations

- ( instancetype ) initWithNibName: ( NSString* )_NibNameOrNil bundle: ( NSBundle* )_NibBundleOrNil
    {
    Class superClass = [ TauAbstractCollectionContentSubViewController class ];
    if ( self = [ super initWithNibName: NSStringFromClass( superClass ) bundle: [ NSBundle bundleForClass: superClass ] ] )
        {
        // Dangerous self-binding.
        // Unbinding in overrides of contentSubViewWillPop
        [ self bind: TauKVOStrictKey( results ) toObject: self withKeyPath: TauKVOStrictKey( searchResults ) options: nil ];
        }

    return self;
    }

TauDeallocBegin
TauDeallocEnd

#pragma mark - External KVB Compliant

@synthesize gtlQuery = gtlQuery_;
+ ( BOOL ) automaticallyNotifiesObserversOfGtlQuery
    {
    return NO;
    }

- ( void ) setGtlQuery: ( GTLQueryYouTube* )_New
    {
    gtlQuery_ = _New;
    TauChangeValueForKVOStrictKey( gtlQuery,
     ( ^{
        if ( gtlQuery_ )
            self.originalOperationsCombination = gtlQuery_;
        } ) );
    }

- ( GTLQueryYouTube* ) gtlQuery
    {
    return gtlQuery_;
    }

@synthesize searchText = searchText_;
+ ( BOOL ) automaticallyNotifiesObserversOfSearchText
    {
    return NO;
    }

- ( void ) setSearchText: ( NSString* )_New
    {
    if ( searchText_ != _New )
        {
        TauChangeValueForKVOStrictKey( searchText,
         ( ^{
            searchText_ = _New;

            self.originalOperationsCombination =
               @{ TauTDSOperationMaxResultsPerPage : @50
                , TauTDSOperationRequirements : @{ TauTDSOperationRequirementQ : searchText_ }
                , TauTDSOperationPartFilter : @"snippet"
                };
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

    for ( GTLYouTubeSearchResult* _Nonnull _Result in searchResults_ )
        {
        NSString* kindString = _Result.identifier.kind;
        if ( [ kindString isEqualToString: @"youtube#channel" ] )
            channelsCount++;
        else if ( [ kindString isEqualToString: @"youtube#playlist" ] )
            playlistsCount++;
        else if ( [ kindString isEqualToString: @"youtube#video" ] )
            videosCount++;
        }

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

- ( NSString* ) appWideSummaryText
    {
    return NSLocalizedString( @"Search Results", @"App wide summary text of search results collection" );
    }

#pragma mark - Internal KVB Compliant

@synthesize searchResults = searchResults_;
+ ( BOOL ) automaticallyNotifiesObserversOfSearchResults
    {
    return NO;
    }

// Directly invoked by TDS.
// We should never invoke this method explicitly.
- ( void ) setSearchResults: ( TauYouTubeSearchResultsCollection* )_New
    {
    if ( searchResults_ != _New )
        TauChangeValueForKVOStrictKey( searchResults, ^{ searchResults_ = _New; } );
    }

- ( TauYouTubeSearchResultsCollection* ) searchResults
    {
    return searchResults_;
    }

@end // TauSearchResultsCollectionContentSubViewController class