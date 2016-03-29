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
//@property ( strong, readwrite ) NSArray <GTLYouTubeChannel*>* channels; // KVO-compliant
//@property ( strong, readwrite ) NSArray <GTLYouTubePlaylistItem*>* playlistItems;   // KVB-compliant

@property ( strong, readwrite ) TauYouTubeChannelsCollection* channels; // KVO-compliant
@property ( strong, readwrite ) TauYouTubePlaylistItemsCollection* playlistItems;   // KVB-compliant

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
        TAU_CHANGE_VALUE_FOR_KEY( playlistIdentifier,
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
                                                  success: nil
            failure: ^( NSError* _Error )
                {
                DDLogRecoverable( @"Failted to fetch channel due to {%@}", _Error );
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
- ( void ) setChannels: ( TauYouTubeChannelsCollection* )_New
    {
    if ( channels_ != _New )
        {
        TAU_CHANGE_VALUE_FOR_KEY( channels,
         ( ^{
            channels_ = _New;

            GTLYouTubeChannelContentDetails* contentDetails = [ channels_.firstObject valueForKey: FBKVOClassKeyPath( GTLYouTubeChannel, contentDetails ) ];
            [ self setPlaylistIdentifier: contentDetails.relatedPlaylists.uploads ];
            } ) );
        }
    }

- ( TauYouTubeChannelsCollection* ) channels
    {
    return channels_;
    }

- ( NSUInteger ) countOfChannels
    {
    return channels_.count;
    }

@synthesize playlistItems = playlistItems_;
+ ( BOOL ) automaticallyNotifiesObserversOfPlaylistItems
    {
    return NO;
    }

// Directly invoked by TDS.
// We should never invoke this method explicitly.
- ( void ) setPlaylistItems: ( TauYouTubePlaylistItemsCollection* )_New
    {
    if ( playlistItems_ != _New )
        TAU_CHANGE_VALUE_FOR_KEY( playlistItems, ^{ playlistItems_ = _New; } );
    }

- ( TauYouTubePlaylistItemsCollection* ) playlistItems
    {
    return playlistItems_;
    }

@end // TauChannelResultsCollectionContentSubViewController class