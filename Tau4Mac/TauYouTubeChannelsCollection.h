//
//  TauYouTubeChannelsCollection.h
//  Tau4Mac
//
//  Created by Tong G. on 3/15/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauAbstractResultCollection.h"

// TauYouTubeChannelsCollection class
@interface TauYouTubeChannelsCollection : TauAbstractResultCollection

@property ( strong, readonly ) NSArray <GTLYouTubeChannel*>* channels;   // KVO-Observable

@end // TauYouTubeChannelsCollection class