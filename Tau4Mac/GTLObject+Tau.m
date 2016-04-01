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

- ( void ) exposeMeOnBahalfOf: ( id )_Sender
    {
    if ( self.tauContentType != TauYouTubeUnknownContent )
        {
        NSNotificationCenter* defaultNotifCenter = [ NSNotificationCenter defaultCenter ];
        NSNotification* exposeNotif = [ NSNotification exposeYouTubeContentNotificationWithYouTubeObject: self poster: _Sender ];

        [ defaultNotifCenter postNotification: exposeNotif ];
        }
    else
        DDLogUnexpected( @"Encountered unknown content collection item type" );
    }

@end // GTLObject + Tau
