//
//  TauShouldExposeCollectionItemNotif.h
//  Tau4Mac
//
//  Created by Tong G. on 3/27/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

// NSNotification + TauShouldExposeCollectionItemNotif
@interface NSNotification ( TauShouldExposeCollectionItemNotif )

@property ( copy, readwrite ) NSString* videoIdentifier;
@property ( copy, readwrite ) NSString* playlistIdentifier;
@property ( copy, readwrite ) NSString* channelIdentifier;

@end // NSNotification + TauShouldExposeCollectionItemNotif