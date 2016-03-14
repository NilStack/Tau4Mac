//
//  TauYouTubeSearchResultCollection.h
//  Tau4Mac
//
//  Created by Tong G. on 3/14/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauAbstractResultCollection.h"

// TauYouTubeSearchResultCollection class
@interface TauYouTubeSearchResultCollection : TauAbstractResultCollection

@property ( strong, readonly ) NSArray <GTLYouTubeSearchResult*>* searchListResults;   // KVO-Observable

@end // TauYouTubeSearchResultCollection class