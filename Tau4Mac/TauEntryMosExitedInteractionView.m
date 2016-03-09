//
//  TauEntryMosExitedInteractionView.m
//  Tau4Mac
//
//  Created by Tong G. on 3/9/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauEntryMosExitedInteractionView.h"
#import "TauYouTubeVideoDurationBadge.h"
#import "TauYouTubeChannelBadge.h"
#import "TauYouTubePlaylistSummaryView.h"

// TauEntryMosExitedInteractionView class
@implementation TauEntryMosExitedInteractionView
    {
    NSImage __strong* thumbnailImage_;
    }

#pragma mark - Initializations

- ( instancetype ) initWithGTLObject: ( GTLObject* )_GTLObject host: ( TauYouTubeEntryView* )_EntryView thumbnail: ( NSImage* )_Thumbnail
    {
    if ( self = [ super initWithGTLObject: _GTLObject host: _EntryView ] )
        {
        thumbnailImage_ = _Thumbnail;

        switch ( self.type )
            {
            case TauYouTubeChannelView:
                {
                TauYouTubeChannelBadge* channelBadge = [ [ TauYouTubeChannelBadge alloc ] initWithFrame: NSZeroRect ];
                [ self addSubview: channelBadge ];

                [ channelBadge autoPinEdge: ALEdgeTop toEdge: ALEdgeTop ofView: channelBadge.superview withOffset: 5.f ];

                [ channelBadge autoPinEdge: ALEdgeTrailing toEdge: ALEdgeTrailing ofView: channelBadge.superview withOffset: -5.f ];

                NSImageView* imageView = [ [ NSImageView alloc ] initWithFrame: NSZeroRect ];
                [ imageView setImageFrameStyle: NSImageFrameNone ];
                [ imageView setImage: thumbnailImage_ ];

                [ self addSubview: imageView ];

                [ imageView autoSetDimensionsToSize: NSMakeSize( 80.f, 80.f ) ];
                [ imageView autoAlignAxisToSuperviewAxis: ALAxisHorizontal ];
                [ imageView autoMatchDimension: ALDimensionHeight toDimension: ALDimensionWidth ofView: imageView ];
                [ imageView autoPinEdge: ALEdgeLeading toEdge: ALEdgeLeading ofView: imageView.superview withOffset: 15.f ];
                } break;

            case TauYouTubePlayListView:
                {
                TauYouTubePlaylistSummaryView* plistSummaryView = [ [ TauYouTubePlaylistSummaryView alloc ] initWithFrame: NSZeroRect ];
                [ self addSubview: plistSummaryView ];

                [ plistSummaryView autoPinEdgesToSuperviewEdgesWithInsets: NSEdgeInsetsZero excludingEdge: ALEdgeLeading ];
                [ plistSummaryView autoMatchDimension: ALDimensionWidth toDimension: ALDimensionWidth ofView: self withMultiplier: 0.4f ];
                [ plistSummaryView setYtObject: self.ytContent ];
                } break;

            case TauYouTubeVideoView:
            case TauYouTubePlayListItemView:
                {
                TauYouTubeVideoDurationBadge* durationBadge = [ [ TauYouTubeVideoDurationBadge alloc ] initWithFrame: NSZeroRect ];
                [ self addSubview: durationBadge ];

                [ durationBadge autoPinEdge: ALEdgeBottom toEdge: ALEdgeBottom ofView: durationBadge.superview withOffset: -5.f ];

                [ durationBadge autoPinEdge: ALEdgeTrailing toEdge: ALEdgeTrailing ofView: durationBadge.superview withOffset: -5.f ];
                } break;

            default:
                {
                DDLogWarn( @"Host entry view has an unknown type: %ld", self.type );
                } break;
            }
        }

    return self;
    }

@end // TauEntryMosExitedInteractionView class