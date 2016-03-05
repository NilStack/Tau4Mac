//
//  TauYouTubeEntryView.h
//  Tau4Mac
//
//  Created by Tong G. on 3/3/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

// TauYouTubeEntryView class

typedef NS_ENUM ( NSUInteger, TauYouTubeContentViewType )
    { TauYouTubeVideoView       = 1
    , TauYouTubeChannelView     = 2
    , TauYouTubePlayListView    = 3

    , TauYouTubeUnknownView     = 0
    };

@interface TauYouTubeEntryView : NSView
    {
@protected
    NSImage __strong* thumbnailImage_;
    GTLObject __strong* ytContent_;

    Class concreteClass_;
    }

#pragma mark - Initializations

- ( instancetype ) initWithGTLObject: ( GTLObject* )_GTLObject;

#pragma mark - Properties

@property ( strong, readwrite ) GTLObject* ytContent;
@property ( assign, readonly ) TauYouTubeContentViewType type;

@end // TauYouTubeEntryView class