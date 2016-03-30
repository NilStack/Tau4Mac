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
        // Unbinding in overrides of cancelAction:
        [ self bind: TauKVOKey( results ) toObject: self withKeyPath: TauKVOKey( searchResults ) options: nil ];
        }

    return self;
    }

TauDeallocBegin
TauDeallocEnd

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
        TAU_CHANGE_VALUE_FOR_KEY( searchText,
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

- ( IBAction ) cancelAction: ( id )_Sender
    {
    // Get rid of self-binding
    [ self unbind: TauKVOKey( results ) ];
    [ super cancelAction: _Sender ];
    }

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
        TAU_CHANGE_VALUE_FOR_KEY( searchResults, ^{ searchResults_ = _New; } );
    }

- ( TauYouTubeSearchResultsCollection* ) searchResults
    {
    return searchResults_;
    }

@end // TauSearchResultsCollectionContentSubViewController class