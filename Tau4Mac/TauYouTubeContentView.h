//
//  TauYouTubeContentView.h
//  Tau4Mac
//
//  Created by Tong G. on 3/3/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

// TauYouTubeContentView class

typedef NS_ENUM ( NSUInteger, TauYouTubeContentViewType )
    { TauYouTubeVideoView       = 1
    , TauYouTubeChannelView     = 2
    , TauYouTubePlayListView    = 3

    , TauYouTubeUnknownView     = 0
    };

@interface TauYouTubeContentView : NSView
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

@end // TauYouTubeContentView class