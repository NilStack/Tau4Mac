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

// Private Interfaces
@interface TauEntryMosExitedInteractionView ()

@property ( strong, readonly ) TauYouTubeChannelBadge*          channelBadge_;
@property ( strong, readonly ) NSImageView*                     thumbnailView_;
@property ( strong, readonly ) TauYouTubePlaylistSummaryView*   plistSummaryView_;

@end // Private Interfaces

// TauEntryMosExitedInteractionView class
@implementation TauEntryMosExitedInteractionView
    {
    TauYouTubeChannelBadge __strong*        priChannelBadge_;
    NSImageView __strong*                   priThumbnailView_;
    TauYouTubePlaylistSummaryView __strong* priPlistSummaryView_;
    }

#pragma mark - Initializations

- ( instancetype ) initWithGTLObject: ( GTLObject* )_GTLObject host: ( TauYouTubeEntryView* )_EntryView thumbnail: ( NSImage* )_Thumbnail
    {
    if ( self = [ super initWithGTLObject: _GTLObject host: _EntryView ] )
        {
        NSView* superview = self;
        self.thumbnail = _Thumbnail;

        switch ( self.type )
            {
            case TauYouTubeChannelView:
                {
                [ superview addSubview: self.channelBadge_ ];
                [ self.channelBadge_ autoPinEdge: ALEdgeTop toEdge: ALEdgeTop ofView: superview withOffset: 5.f ];
                [ self.channelBadge_ autoPinEdge: ALEdgeTrailing toEdge: ALEdgeTrailing ofView: superview withOffset: -5.f ];

                [ superview addSubview: self.thumbnailView_ ];
                [ self.thumbnailView_ autoAlignAxisToSuperviewAxis: ALAxisHorizontal ];
                [ self.thumbnailView_ autoMatchDimension: ALDimensionHeight toDimension: ALDimensionWidth ofView: priThumbnailView_ ];
                [ self.thumbnailView_ autoPinEdge: ALEdgeLeading toEdge: ALEdgeLeading ofView: superview withOffset: 15.f ];
                } break;

            case TauYouTubePlayListView:
                {
                [ superview addSubview: self.plistSummaryView_ ];
                [ self.plistSummaryView_ autoPinEdgesToSuperviewEdgesWithInsets: NSEdgeInsetsZero excludingEdge: ALEdgeLeading ];
                [ self.plistSummaryView_ autoMatchDimension: ALDimensionWidth toDimension: ALDimensionWidth ofView: self withMultiplier: 0.4f ];
                } break;

            case TauYouTubeVideoView:
            case TauYouTubePlayListItemView:
                {
//                TauYouTubeVideoDurationBadge* durationBadge = [ [ TauYouTubeVideoDurationBadge alloc ] initWithFrame: NSZeroRect ];
//                [ self addSubview: durationBadge ];
//
//                [ durationBadge autoPinEdge: ALEdgeBottom toEdge: ALEdgeBottom ofView: durationBadge.superview withOffset: -5.f ];
//
//                [ durationBadge autoPinEdge: ALEdgeTrailing toEdge: ALEdgeTrailing ofView: durationBadge.superview withOffset: -5.f ];
                } break;

            default:
                {
                DDLogWarn( @"Host entry view has an unknown type: %ld", self.type );
                } break;
            }
        }

    return self;
    }

#pragma mark - Dynamic Properties

@dynamic thumbnail;

- ( void ) setThumbnail: ( NSImage* )_Thumbnail
    {
    if ( self.thumbnail != _Thumbnail )
        [ self.thumbnailView_ setImage: _Thumbnail ];
    }

- ( NSImage* ) thumbnail
    {
    return self.thumbnailView_.image;
    }

#pragma mark - Overrides

- ( void ) setYtContent: ( GTLObject* )_Content
    {
    [ super setYtContent: _Content ];

    if ( self.ytContent )
        {
//        self.thumbnail = 
        // FIXIT: Duplicate
        GTLYouTubePlaylistItem* object = ( GTLYouTubePlaylistItem* )self.ytContent;
        }
    }

#pragma mark - Private Interfaces

@dynamic channelBadge_;
@dynamic thumbnailView_;
@dynamic plistSummaryView_;

- ( TauYouTubeChannelBadge* ) channelBadge_
    {
    if ( !priChannelBadge_ )
        priChannelBadge_ = [ [ TauYouTubeChannelBadge alloc ] initWithFrame: NSZeroRect ];

    return priChannelBadge_;
    }

- ( NSImageView* ) thumbnailView_
    {
    if ( !priThumbnailView_ )
        {
        priThumbnailView_ = [ [ NSImageView alloc ] initWithFrame: NSZeroRect ];
        [ priThumbnailView_ setImageFrameStyle: NSImageFrameNone ];

        [ priThumbnailView_ autoSetDimensionsToSize: NSMakeSize( 80.f, 80.f ) ];
        }

    return priThumbnailView_;
    }

- ( TauYouTubePlaylistSummaryView* ) plistSummaryView_
    {
    if ( !priPlistSummaryView_ )
        {
        priPlistSummaryView_ = [ [ TauYouTubePlaylistSummaryView alloc ] initWithFrame: NSZeroRect ];
        [ priPlistSummaryView_ setYtObject: self.ytContent ];
        }

    return priPlistSummaryView_;
    }

@end // TauEntryMosExitedInteractionView class