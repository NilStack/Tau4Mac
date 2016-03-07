//
//  TauYouTubeEntryView.h
//  Tau4Mac
//
//  Created by Tong G. on 3/3/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

// TauYouTubeEntryView class

typedef NS_ENUM ( NSUInteger, TauYouTubeContentViewType )
    { TauYouTubeVideoView           = 1
    , TauYouTubeChannelView         = 2
    , TauYouTubePlayListView        = 3
    , TauYouTubePlayListItemView    = 4

    , TauYouTubeUnknownView         = 0
    };

@interface TauYouTubeEntryView : NSView

#pragma mark - Initializations

- ( instancetype ) initWithGTLObject: ( GTLObject* )_GTLObject;

#pragma mark - Properties

@property ( strong, readwrite ) GTLObject* ytContent;
@property ( assign, readonly ) TauYouTubeContentViewType type;

@end // TauYouTubeEntryView class