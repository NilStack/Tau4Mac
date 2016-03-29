//
//  TauYouTubeSubscriptionsCollection.h
//  Tau4Mac
//
//  Created by Tong G. on 3/29/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauAbstractResultCollection.h"

// TauYouTubeSubscriptionsCollection class
@interface TauYouTubeSubscriptionsCollection : TauAbstractResultCollection

@property ( strong, readonly ) NSArray <GTLYouTubeSubscription*>* subscriptions;   // KVO-Observable

@end // TauYouTubeSubscriptionsCollection class