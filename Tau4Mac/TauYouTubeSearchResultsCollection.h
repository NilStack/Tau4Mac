//
//  TauYouTubeSearchResultsCollection.h
//  Tau4Mac
//
//  Created by Tong G. on 3/14/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauAbstractResultCollection.h"

// TauYouTubeSearchResultsCollection class
@interface TauYouTubeSearchResultsCollection : TauAbstractResultCollection

@property ( strong, readonly ) NSArray <GTLYouTubeSearchResult*>* searchResults;   // KVO-Observable

@end // TauYouTubeSearchResultsCollection class