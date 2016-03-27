//
//  TauPlaylistItemResultsCollectionContentSubViewController.h
//  Tau4Mac
//
//  Created by Tong G. on 3/25/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauAbstractCollectionContentSubViewController.h"

// TauPlaylistItemResultsCollectionContentSubViewController class
@interface TauPlaylistItemResultsCollectionContentSubViewController : TauAbstractCollectionContentSubViewController

@property ( strong, readwrite ) NSString* playlistName;         // KVB compliant
@property ( strong, readwrite ) NSString* playlistIdentifier;   // KVB compliant

@end // TauPlaylistItemResultsCollectionContentSubViewController class