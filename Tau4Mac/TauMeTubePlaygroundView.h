//
//  TauMeTubePlaygroundView.h
//  Tau4Mac
//
//  Created by Tong G. on 3/28/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

@class TauMeTubeTabModel;

// TauMeTubePlaygroundView class
@interface TauMeTubePlaygroundView : NSView

#pragma mark - External KVB Comliant Properties

@property ( strong, readwrite ) TauMeTubeTabModel* selectedTab;

@end // TauMeTubePlaygroundView class