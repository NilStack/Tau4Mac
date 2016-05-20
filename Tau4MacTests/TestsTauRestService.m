//
//  TestsTauRestService.m
//  Tau4Mac
//
//  Created by Tong G. on 4/25/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TestsTauRestService.h"

enum { kTypeSearchResults = TRSRestRequestTypeSearchResultsList
     , kTypeChannelsList = TRSRestRequestTypeChannelsList
     , kTypePlaylistsList = TRSRestRequestTypePlaylistsList
     , kTypePlaylistItemsList = TRSRestRequestTypePlaylistItemsList
     , kTypeSubscriptionsList = TRSRestRequestTypeSubscriptionsList
     , kTypeVideosList = TRSRestRequestTypeVideosList
     , kTypeUnknown = TRSRestRequestTypeUnknown
     , kTypeOthers = TRSRestRequestTypeOthers
     };

// TestsTauRestService test case
@implementation TestsTauRestService

- ( void ) setUp
    {
    [ super setUp ];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    }

- ( void ) tearDown
    {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [ super tearDown ];
    }

- ( int ) type_: ( NSString* )_String
    {
    TRSRestRequestType resultsType = kTypeUnknown;

    if ( [ _String isEqualToString: @"SearchResults" ] )
        resultsType = kTypeSearchResults;
    else if ( [ _String isEqualToString: @"Channel" ] || [ _String isEqualToString: @"Channels" ] )
        resultsType = kTypeChannelsList;
    else if ( [ _String isEqualToString: @"Playlist" ] || [ _String isEqualToString: @"Playlists" ] )
        resultsType = kTypePlaylistsList;
    else if ( [ _String isEqualToString: @"PlaylistItem" ] || [ _String isEqualToString: @"PlaylistItems" ] )
        resultsType = kTypePlaylistItemsList;
    else if ( [ _String isEqualToString: @"Subscriptions" ] )
        resultsType = kTypeSubscriptionsList;
    else if ( [ _String isEqualToString: @"Video" ] || [ _String isEqualToString: @"Videos" ] )
        resultsType = kTypeVideosList;

    return resultsType;
    }

- ( void ) testCreatingReadOnlyRestRequest
    {
    unsigned int count = 0;
    struct objc_method_description* descrps = protocol_copyMethodDescriptionList( @protocol( TauRestListingRequests ), YES, YES, &count );

    for ( int _index = 0; _index < count; _index++ )
        {
        struct objc_method_description desc = *( descrps + _index );
        SEL sel = desc.name;
        NSString* selName = NSStringFromSelector( sel );

        if ( [ selName hasSuffix: @"Request" ] )
            continue;

        NSMethodSignature* sig = [ NSMethodSignature signatureWithObjCTypes: desc.types ];
        NSInvocation* invok = [ NSInvocation invocationWithMethodSignature: sig ];
        [ invok setSelector: sel ];

        NSArray* components = [ [ selName stringByReplacingCharactersInRange: NSMakeRange( 0, @"init".length ) withString: @"" ] componentsSeparatedByString: @"RequestWith" ];

//        TRSRestRequestType resultsType = [ self type_: components.firstObject ];

        // init Channel RequestWith ChannelIdentifier:

        NSUInteger length = 0;
        for ( NSString* _str in @[ @"Identifier", @"Name" ] )
            {
            NSRange range = [ components.lastObject rangeOfString: _str options: NSBackwardsSearch ];
            if ( range.location != NSNotFound )
                {
                length = range.location;
                break;
                }
            }

        NSRange range = NSMakeRange( 0, length );
        TRSRestRequestType paramsType = [ self type_: [ components.lastObject substringWithRange: range ] ];
        NSString* keyPathTemplate = nil;
        switch ( paramsType )
            {
            case kTypeSearchResults: keyPathTemplate = @"searchQSample"; break;
            case kTypeChannelsList: keyPathTemplate = @"channelIdentifiersSample"; break;
            case kTypePlaylistsList: keyPathTemplate = @"playlistIdentifiersSample"; break;
            case kTypePlaylistItemsList: keyPathTemplate = @"playlistItemIdentifiersSample"; break;
            case kTypeSubscriptionsList: keyPathTemplate = @"subscriptionIdentifiersSample"; break;
            case kTypeVideosList: keyPathTemplate = @"videoIdentifiersSample"; break;

            default: {;}
            }

        for ( int _index = 0; _index < 5; _index++ )
            {
            id arg = [ self valueForKey: [ keyPathTemplate stringByAppendingString: @( _index ).stringValue ] ];
            [ invok setArgument: &arg atIndex: 2 ];

            TauRestRequest* allocated = [ [ TauRestRequest class ] alloc ];
            TauRestRequest __unsafe_unretained* res = nil;
            [ invok invokeWithTarget: allocated ];

            [ invok getReturnValue: &res ];

            XCTAssertNotNil( res );
            }
        }

    free( descrps );
    }

@end // TestsTauRestService test ca