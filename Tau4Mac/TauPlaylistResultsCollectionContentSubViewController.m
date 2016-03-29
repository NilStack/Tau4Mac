//
//  TauPlaylistResultsCollectionContentSubViewController.m
//  Tau4Mac
//
//  Created by Tong G. on 3/25/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauPlaylistResultsCollectionContentSubViewController.h"

// Private
@interface TauPlaylistResultsCollectionContentSubViewController ()

// Model: Feed me, if you dare.
//@property ( strong, readwrite ) NSArray <GTLYouTubePlaylistItem*>* playlistItems;   // KVB-compliant
@property ( strong, readwrite ) TauYouTubePlaylistsCollection* playlistItems;   // KVB-compliant

@end // Private



// ------------------------------------------------------------------------------------------------------------ //



// TauPlaylistResultsCollectionContentSubViewController class
@implementation TauPlaylistResultsCollectionContentSubViewController

#pragma mark - Initializations

- ( instancetype ) initWithNibName: ( NSString* )_NibNameOrNil bundle: ( NSBundle* )_NibBundleOrNil
    {
    Class superClass = [ TauAbstractCollectionContentSubViewController class ];
    if ( self = [ super initWithNibName: NSStringFromClass( superClass ) bundle: [ NSBundle bundleForClass: superClass ] ] )
        {
        // Dangerous self-binding.
        // Unbinding in overrides of cancelAction:
        [ self bind: TauKeyOfSel( @selector( results ) ) toObject: self withKeyPath: TauKeyOfSel( @selector( playlistItems ) ) options: nil ];
        }

    return self;
    }

TauDeallocBegin
TauDeallocEnd

#pragma mark - External KVB Compliant

@synthesize playlistName = playlistName_;

@synthesize playlistIdentifier = playlistIdentifier_;
+ ( BOOL ) automaticallyNotifiesObserversOfPlaylistIdentifier
    {
    return NO;
    }

- ( void ) setPlaylistIdentifier: ( NSString* )_New
    {
    if ( playlistIdentifier_ != _New )
        {
        TAU_CHANGE_VALUE_FOR_KEY( playlistIdentifier,
         ( ^{
            playlistIdentifier_ = _New;

            self.originalOperationsCombination =
                @{ TauTDSOperationMaxResultsPerPage : @50
                 , TauTDSOperationRequirements : @{ TauTDSOperationRequirementPlaylistID : playlistIdentifier_ }
                 , TauTDSOperationPartFilter : @"contentDetails,id,snippet,status"
                 };
            } ) );
        }
    }

- ( NSString* ) playlistIdentifier
    {
    return playlistIdentifier_;
    }

#pragma mark - Overrides

- ( IBAction ) cancelAction: ( id )_Sender
    {
    // Get rid of self-binding
    [ self unbind: TauKeyOfSel( @selector( results ) ) ];
    [ super cancelAction: _Sender ];
    }

- ( NSString* ) appWideSummaryText
    {
    return NSLocalizedString( @"Playlist", nil );
    }

- ( NSString* ) resultsSummaryText
    {
    NSUInteger resultsCount = self.results.count;

    NSString* prefix = nil;
    if ( resultsCount )
        prefix = [ NSString stringWithFormat: NSLocalizedString( @"%lu Video%@", @"Presents when playlist items array isn't empty" ), resultsCount, resultsCount ? @"s" : @"" ];
    else
        prefix = NSLocalizedString( @"No Videos Yet", @"Presents when playlist items array is still empty" );
    
    return [ NSString stringWithFormat: NSLocalizedString( @"%@ • %@ • Playlist", @"Final summary text" ), prefix, playlistName_ ];
    }

#pragma mark - Internal KVB Compliant

@synthesize playlistItems = playlistItems_;
+ ( BOOL ) automaticallyNotifiesObserversOfPlaylistItems
    {
    return NO;
    }

// Directly invoked by TDS.
// We should never invoke this method explicitly.
- ( void ) setPlaylistItems: ( TauYouTubePlaylistsCollection* )_New
    {
    if ( playlistItems_ != _New )
        TAU_CHANGE_VALUE_FOR_KEY( playlistItems, ^{ playlistItems_ = _New; } );
    }

- ( TauYouTubePlaylistsCollection* ) playlistItems
    {
    return playlistItems_;
    }

@end // TauPlaylistResultsCollectionContentSubViewController class