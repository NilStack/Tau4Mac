//
//  TauChannelResultsCollectionContentSubViewController.h
//  Tau4Mac
//
//  Created by Tong G. on 3/27/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauAbstractCollectionContentSubViewController.h"

// TauChannelResultsCollectionContentSubViewController class
@interface TauChannelResultsCollectionContentSubViewController : TauAbstractCollectionContentSubViewController

@property ( strong, readwrite ) NSString* channelName;         // KVB compliant
@property ( strong, readwrite ) NSString* channelIdentifier;   // KVB compliant

@end // TauChannelResultsCollectionContentSubViewController class