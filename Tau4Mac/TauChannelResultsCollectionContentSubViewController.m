//
//  TauChannelResultsCollectionContentSubViewController.m
//  Tau4Mac
//
//  Created by Tong G. on 3/27/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauChannelResultsCollectionContentSubViewController.h"

// Private
@interface TauChannelResultsCollectionContentSubViewController ()

// Model: Feed me, if you dare.
@property ( strong, readwrite ) NSArray <GTLYouTubeChannel*>* channels; // KVO-compliant
@property ( strong, readwrite ) NSArray <GTLYouTubePlaylistItem*>* playlistItems;   // KVB-compliant

@end // Private

// TauChannelResultsCollectionContentSubViewController class
@implementation TauChannelResultsCollectionContentSubViewController
    {
    TauYTDataServiceCredential* channelsCredential_;
    }

TauDeallocBegin
TauDeallocEnd

#pragma mark - External KVB Compliant

@synthesize channelName = channelName_;

@synthesize channelIdentifier = channelIdentifier_;
+ ( BOOL ) automaticallyNotifiesObserversOfChannelIdentifier
    {
    return NO;
    }

- ( void ) setChannelIdentifier: ( NSString* )_New
    {
    if ( channelIdentifier_ != _New )
        {
        TAU_CHANGE_VALUE_FOR_KEY_of_SEL( @selector( playlistIdentifier ),
         ( ^{
            channelIdentifier_ = _New;

            NSDictionary* operations =
                @{ TauTDSOperationMaxResultsPerPage : @1
                 , TauTDSOperationRequirements : @{ TauTDSOperationRequirementChannelID : channelIdentifier_ }
                 , TauTDSOperationPartFilter : @"contentDetails,snippet,statistics,topicDetails"
                 };

            TauYTDataService* sharedDataService = [ TauYTDataService sharedService ];
            channelsCredential_ = [ [ TauYTDataService sharedService ] registerConsumer: self withMethodSignature: [ self methodSignatureForSelector: _cmd ] consumptionType: TauYTDataServiceConsumptionChannelsType ];
            [ sharedDataService executeConsumerOperations: operations
                                           withCredential: channelsCredential_
                                                  success:
            ^( NSString* _PrevPageToken, NSString* _NextPageToken )
                {

                    
                } failure: ^( NSError* _Error )
                    {

                    } ];
            } ) );
        }
    }

- ( NSString* ) channelIdentifier
    {
    return channelIdentifier_;
    }

#pragma mark - Overrides

- ( IBAction ) cancelAction: ( id )_Sender
    {
    [ [ TauYTDataService sharedService ] unregisterConsumer: self withCredential: channelsCredential_ ];
    [ super cancelAction: _Sender ];
    }

- ( NSString* ) appWideSummaryText
    {
    return NSLocalizedString( @"Channel", nil );
    }

- ( NSString* ) resultsSummaryText
    {
    NSUInteger resultsCount = self.results.count;

    NSString* prefix = nil;
    if ( resultsCount )
        prefix = [ NSString stringWithFormat: NSLocalizedString( @"%lu Video%@", @"Presents when playlist items array isn't empty" ), resultsCount, resultsCount ? @"s" : @"" ];
    else
        prefix = NSLocalizedString( @"No Videos Yet", @"Presents when playlist items array is still empty" );
    
    return [ NSString stringWithFormat: NSLocalizedString( @"%@ • %@ • Channel", @"Final summary text" ), prefix, channelName_ ];
    }

#pragma mark - Internal KVB Compliant

@synthesize channels = channels_;
+ ( BOOL ) automaticallyNotifiesObserversOfChannels
    {
    return NO;
    }

// Directly invoked by TDS.
// We should never invoke this method explicitly.
- ( void ) setChannels: ( NSArray <GTLYouTubeChannel*>* )_New
    {
    if ( channels_ != _New )
        {
        TAU_CHANGE_VALUE_FOR_KEY_of_SEL( @selector( channels ),
         ( ^{
            channels_ = _New;

            GTLYouTubeChannelContentDetails* contentDetails = channels_.firstObject.contentDetails;
            [ self setPlaylistIdentifier: contentDetails.relatedPlaylists.uploads ];
            } ) );
        }
    }

- ( NSArray <GTLYouTubeChannel*>* ) channels
    {
    return channels_;
    }

- ( NSUInteger ) countOfChannels
    {
    return channels_.count;
    }

- ( NSArray <GTLYouTubeChannel*>* ) channelsAtIndexes: ( NSIndexSet* )_Indexes
    {
    return [ channels_ objectsAtIndexes: _Indexes ];
    }

- ( void ) getChannels: ( GTLYouTubeChannel* __unsafe_unretained* )_Buffer range: ( NSRange )_InRange
    {
    [ channels_ getObjects: _Buffer range: _InRange ];
    }

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
        TAU_CHANGE_VALUE_FOR_KEY_of_SEL( @selector( playlistItems ), ^{ playlistItems_ = _New; } );
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

@end // TauChannelResultsCollectionContentSubViewController class