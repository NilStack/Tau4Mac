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

@end // Private

// TauChannelResultsCollectionContentSubViewController class
@implementation TauChannelResultsCollectionContentSubViewController

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

            self.originalOperationsCombination =
                @{ TauTDSOperationMaxResultsPerPage : @1
                 , TauTDSOperationRequirements : @{ TauTDSOperationRequirementChannelID : channelIdentifier_ }
                 , TauTDSOperationPartFilter : @"contentDetails,snippet,contentOwnerDetails,statistics,topicDetails"
                 };
            } ) );
        }
    }

- ( NSString* ) channelIdentifier
    {
    return channelIdentifier_;
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
        TAU_CHANGE_VALUE_FOR_KEY_of_SEL( @selector( channels ), ^{ channels_ = _New; } );
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

@end // TauChannelResultsCollectionContentSubViewController class