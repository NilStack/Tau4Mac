//
//  TauYouTubePlaylistSummaryView.h
//  Tau4Mac
//
//  Created by Tong G. on 3/6/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauAbstractBeautifulView.h"

// TauYouTubePlaylistSummaryView class
@interface TauYouTubePlaylistSummaryView : TauAbstractBeautifulView

#pragma mark - Wrapped Properties

@property ( strong, readwrite ) GTLObject* ytObject;

@end // TauYouTubePlaylistSummaryView class