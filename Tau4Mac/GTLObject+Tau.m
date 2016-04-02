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
    else
        DDLogNotice( @"{%@} is not an object that can be recognized by %@.", self, THIS_METHOD );

    return type;
    }

@dynamic tauEssentialIdentifier;
- ( NSString* ) tauEssentialIdentifier
    {
    NSString* identifier = nil;
    GTLObject* YouTubeObject = self;

    // If YouTubeObject is instance of ...

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
    else
        DDLogNotice( @"{%@} is not an object that can be recognized by %@.", self, THIS_METHOD );

    return identifier ? [ identifier copy ] : nil;
    }

@dynamic tauEssentialTitle;
- ( NSString* ) tauEssentialTitle
    {
    NSString* title = nil;
    @try {
    title = [ self valueForKeyPath: @"snippet.title" ];
    } @catch ( NSException* _Ex )
        { DDLogNotice( @"{%@} doesn't contain a title property that can be recognized by %@.", self, THIS_METHOD ); }

    return title ? [ title copy ] : nil;
    }

- ( void ) exposeMeOnBahalfOf: ( id )_Sender
    {
    if ( self.tauContentType == TauYouTubeUnknownContent )
        DDLogUnexpected( @"Encountered unknown content collection item type" );
    else
        {
        NSNotificationCenter* defaultNotifCenter = [ NSNotificationCenter defaultCenter ];
        NSNotification* exposeNotif = [ NSNotification exposeYouTubeContentNotificationWithYouTubeObject: self poster: _Sender ];
        [ defaultNotifCenter postNotification: exposeNotif ];
        }
    }

@dynamic urlOnWebsite;
- ( NSURL* ) urlOnWebsite
    {
    NSURL* url = [ NSURL URLWithString: @"https://www.youtube.com" ];

    switch ( self.tauContentType )
        {
        case TauYouTubeVideo:
            url = [ url URLByAppendingPathComponent: [ NSString stringWithFormat: @"/watch?v=%@", self.tauEssentialIdentifier ] ];
            break;

        case TauYouTubePlayList:
            url = [ url URLByAppendingPathComponent: [ NSString stringWithFormat: @"/playlist?list=%@", self.tauEssentialIdentifier ] ];
            break;

        case TauYouTubeChannel:
            url = [ url URLByAppendingPathComponent: [ NSString stringWithFormat: @"/channel/%@", self.tauEssentialIdentifier ] ];
            break;

        case TauYouTubeUnknownContent:
            DDLogUnexpected( @"Unknown YouTube content {%@}.", self );
            url = nil;
            break;
        }

    return url ? [ url copy ] : nil;
    }

@end // GTLObject + Tau
