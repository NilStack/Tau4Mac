//
//  TauYouTubeChannelListsCollection.h
//  Tau4Mac
//
//  Created by Tong G. on 3/15/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauAbstractResultCollection.h"

// TauYouTubeChannelListsCollection class
@interface TauYouTubeChannelListsCollection : TauAbstractResultCollection

@property ( strong, readonly ) NSArray <GTLYouTubeChannel*>* channelLists;   // KVO-Observable

@end // TauYouTubeChannelListsCollection class