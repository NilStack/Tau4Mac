//
//  GTLObject+Tau.m
//  Tau4Mac
//
//  Created by Tong G. on 3/27/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "GTLObject+Tau.h"

// GTLObject + Tau
@implementation GTLObject ( Tau )

@dynamic tauContentType;
- ( TauYouTubeContentType ) tauContentType
    {
    TauYouTubeContentType type = TauYouTubeUnknownContent;

    if ( [ self isKindOfClass: [ GTLYouTubeVideo class ] ]
            || [ self isKindOfClass: [ GTLYouTubePlaylistItem class ] ]
            || ( [ self isKindOfClass: [ GTLYouTubeSearchResult class ] ] && [ [ ( GTLYouTubeSearchResult* )self identifier ].kind isEqualToString: @"youtube#video" ] ) )
        type = TauYouTubeVideo;

    else if ( [ self isKindOfClass: [ GTLYouTubeChannel class ] ]
            || [ self isKindOfClass: [ GTLYouTubeSubscription class ] ]
            || ( [ self isKindOfClass: [ GTLYouTubeSearchResult class ] ] && [ [ ( GTLYouTubeSearchResult* )self identifier ].kind isEqualToString: @"youtube#channel" ] ) )
        type = TauYouTubeChannel;

    else if ( [ self isKindOfClass: [ GTLYouTubePlaylist class ] ]
            || ( [ self isKindOfClass: [ GTLYouTubeSearchResult class ] ] && [ [ ( GTLYouTubeSearchResult* )self identifier ].kind isEqualToString: @"youtube#playlist" ] ) )
        type = TauYouTubePlayList;

    return type;
    }

@dynamic tauEssentialIdentifier;
- ( NSString* ) tauEssentialIdentifier
    {
    NSString* identifier = nil;
    GTLObject* YouTubeObject = self;

    // If _YouTubeObject is instance of ...

    /* one of three classes below:

     * GTLYouTubeVideo
     * GTLYouTubeChannel
     * GTLYouTubePlaylist

     * its identifier property is simply an NSString object encapsulated in the outermost layer.
     */
    if ( [ YouTubeObject isKindOfClass: [ GTLYouTubeVideo class ] ]
            || [ YouTubeObject isKindOfClass: [ GTLYouTubeChannel class ] ]
            || [ YouTubeObject isKindOfClass: [ GTLYouTubePlaylist class ] ] )
        identifier = [ YouTubeObject valueForKey: TauKVOStrictKey( identifier ) ];

    /* GTLYouTubePlaylistItem, its identifier property is an NSString object encapsulated in a GTLYouTubePlaylistItemContentDetails object.
     */
    else if ( [ YouTubeObject isKindOfClass: [ GTLYouTubePlaylistItem class ] ] )
        identifier = [ YouTubeObject valueForKeyPath: @"contentDetails.videoId" ];

    else if ( [ YouTubeObject isKindOfClass: [ GTLYouTubeSubscription class ] ] )
        identifier = [ [ YouTubeObject valueForKeyPath: @"snippet.resourceId" ] JSON ][ @"channelId" ];

    /* GTLYouTubeSearchResult, its identifier property is an NSString object encapsulated in a GTLYouTubeResourceId object, instead.
     */
    else if ( [ YouTubeObject isKindOfClass: [ GTLYouTubeSearchResult class ] ] )
        {
        GTLYouTubeResourceId* resourceIdentifier = [ YouTubeObject valueForKey: TauKVOStrictKey( identifier ) ];
        NSDictionary* jsonDict = [ resourceIdentifier JSON ];
        identifier = [ jsonDict objectForKey: [ [ resourceIdentifier.kind componentsSeparatedByString: @"#" ].lastObject stringByAppendingString: @"Id" ] ];
        }

    return [ identifier copy ];
    }

@dynamic tauEssentialTitle;
- ( NSString* ) tauEssentialTitle
    {
    return [ [ self valueForKeyPath: @"snippet.title" ] copy ];
    }

- ( void ) exposeMeOnBahalfOf: ( id )_Sender
    {
    if ( self.tauContentType == TauYouTubeUnknownContent )
        DDLogUnexpected( @"Encountered unknown content collection item type" );
    else if ( self.tauContentType == TauYouTubeVideo )
        {
        NSString* videoIdentifier = self.tauEssentialIdentifier;
        [ [ TauPlayerController defaultPlayerController ] playYouTubeVideoWithVideoIdentifier: videoIdentifier switchToPlayer: YES ];
        }
    else
        {
        NSNotificationCenter* defaultNotifCenter = [ NSNotificationCenter defaultCenter ];
        NSNotification* exposeNotif = [ NSNotification exposeYouTubeContentNotificationWithYouTubeObject: self poster: _Sender ];

        [ defaultNotifCenter postNotification: exposeNotif ];
        }
    }

@end // GTLObject + Tau
