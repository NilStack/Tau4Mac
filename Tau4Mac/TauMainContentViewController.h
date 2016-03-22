//
//  TauMainContentViewController.h
//  Tau4Mac
//
//  Created by Tong G. on 3/17/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

@class TauAbstractContentViewController;

@class TauSearchContentViewController;
@class TauExploreContentViewController;
@class TauPlayerContentViewController;

// TauMainContentViewController class
@interface TauMainContentViewController : NSViewController

@property ( strong, readonly ) TauSearchContentViewController* searchContentViewController;
@property ( strong, readonly ) TauExploreContentViewController* exploreContentViewController;
@property ( strong, readonly ) TauPlayerContentViewController* playerContentViewController;



// --------------------------------------------------------------------------------------------



@property ( assign, readwrite ) TauContentViewTag activedContentViewTag;  // KVB compliant
@property ( strong, readonly ) TauAbstractContentViewController* activedContentViewController;  // KVO-Observable



// --------------------------------------------------------------------------------------------



@end // TauMainContentViewController class