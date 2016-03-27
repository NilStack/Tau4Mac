//
//  TauShouldExposeCollectionItemNotif.m
//  Tau4Mac
//
//  Created by Tong G. on 3/27/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauShouldExposeCollectionItemNotif.h"

// NSNotification + TauShouldExposeCollectionItemNotif
@implementation NSNotification ( TauShouldExposeCollectionItemNotif )

void static* const kVideoAssocKey;
void static* const kPlaylistAssocKey;
void static* const kChannelAssocKey;

@dynamic videoIdentifier;
- ( void ) setVideoIdentifier: ( NSString* )_New
    {
    objc_setAssociatedObject( self, &kVideoAssocKey, _New, OBJC_ASSOCIATION_COPY );
    }

- ( NSString* ) videoIdentifier
    {
    return ( NSString* )objc_getAssociatedObject( self, &kVideoAssocKey );
    }

@dynamic playlistIdentifier;
- ( void ) setPlaylistIdentifier: ( NSString* )_New
    {
    objc_setAssociatedObject( self, &kPlaylistAssocKey, _New, OBJC_ASSOCIATION_COPY );
    }

- ( NSString* ) playlistIdentifier
    {
    return ( NSString* )objc_getAssociatedObject( self, &kPlaylistAssocKey );
    }

@dynamic channelIdentifier;
- ( void ) setChannelIdentifier: ( NSString* )_New
    {
    objc_setAssociatedObject( self, &kChannelAssocKey, _New, OBJC_ASSOCIATION_COPY );
    }

- ( NSString* ) channelIdentifier
    {
    return ( NSString* )objc_getAssociatedObject( self, &kChannelAssocKey );
    }

@end // NSNotification + TauShouldExposeCollectionItemNotif