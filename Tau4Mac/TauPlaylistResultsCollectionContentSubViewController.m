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
@property ( strong, readwrite ) NSArray <GTLYouTubePlaylistItem*>* playlistItems;   // KVB-compliant

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
        [ self bind: TAU_KEY_OF_SEL( @selector( results ) ) toObject: self withKeyPath: TAU_KEY_OF_SEL( @selector( playlistItems ) ) options: nil ];
        }

    return self;
    }

- ( void ) dealloc
    {
    DDLogDebug( @"%@ got deallocated", self );
    }

#pragma mark - External KVB Compliant

@synthesize playlistIdentifier = playlistIdentifier_;
+ ( BOOL ) automaticallyNotifiesObserversOfPlaylistIdentifier
    {
    return NO;
    }

- ( void ) setPlaylistIdentifier: ( NSString* )_New
    {
    if ( playlistIdentifier_ != _New )
        {
        TAU_CHANGE_VALUE_FOR_KEY_of_SEL( @selector( playlistIdentifier ),
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
    [ self unbind: TAU_KEY_OF_SEL( @selector( results ) ) ];
    [ super cancelAction: _Sender ];
    }

- ( NSString* ) appWideSummaryText
    {
    return NSLocalizedString( @"Videos", @"App wide summary text of playlist items results collection" );
    }

#pragma mark - Internal KVB Compliant

@synthesize playlistItems = playlistItems_;
+ ( BOOL ) automaticallyNotifiesObserversOfPlaylistItems
    {
    return NO;
    }

// Directly invoked by TDS.
// We should never invoke this method explicitly.
- ( void ) setPlaylistItems: ( NSArray <GTLYouTubePlaylistItem*>* )_New
    {
    if ( playlistItems_ != _New )
        {
        TAU_CHANGE_VALUE_FOR_KEY_of_SEL( @selector( playlistItems ), ^{ playlistItems_ = _New; } );
        }
    }

- ( NSArray <GTLYouTubePlaylistItem*>* ) playlistItems
    {
    return playlistItems_;
    }

- ( NSUInteger ) countOfPlaylistItems
    {
    return playlistItems_.count;
    }

- ( NSArray <GTLYouTubePlaylistItem*>* ) playlistItemsAtIndexes: ( NSIndexSet* )_Indexes
    {
    return [ playlistItems_ objectsAtIndexes: _Indexes ];
    }

- ( void ) getPlaylistItems: ( GTLYouTubePlaylistItem* __unsafe_unretained* )_Buffer range: ( NSRange )_InRange
    {
    [ playlistItems_ getObjects: _Buffer range: _InRange ];
    }

@end // TauPlaylistResultsCollectionContentSubViewController class