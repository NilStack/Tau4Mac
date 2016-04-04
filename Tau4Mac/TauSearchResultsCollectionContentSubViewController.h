//
//  TauSearchResultsCollectionContentSubViewController.h
//  Tau4Mac
//
//  Created by Tong G. on 3/20/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauAbstractCollectionContentSubViewController.h"

// TauSearchResultsCollectionContentSubViewController class
@interface TauSearchResultsCollectionContentSubViewController : TauAbstractCollectionContentSubViewController

@property ( strong, readwrite ) GTLQueryYouTube* gtlQuery;  // KVO compliant
@property ( strong, readwrite ) NSString* searchText;   // KVB compliant

@end // TauSearchResultsCollectionContentSubViewController class