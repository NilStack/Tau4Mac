//
//  TauPlaylistResultsCollectionContentSubViewController.h
//  Tau4Mac
//
//  Created by Tong G. on 3/25/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauAbstractCollectionContentSubViewController.h"

// TauPlaylistResultsCollectionContentSubViewController class
@interface TauPlaylistResultsCollectionContentSubViewController : TauAbstractCollectionContentSubViewController

@property ( strong, readwrite ) NSString* playlistName;          // KVB compliant
@property ( strong, readwrite ) NSString* playlistIdentifier;   // KVB compliant

@end // TauPlaylistResultsCollectionContentSubViewController class