//
//  TauEntryMosEnteredInteractionView.m
//  Tau4Mac
//
//  Created by Tong G. on 3/9/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauEntryMosEnteredInteractionView.h"
#import "TauMosEnteredInteractionButton.h"

// TauEntryMosEnteredInteractionView class
@implementation TauEntryMosEnteredInteractionView
    {
    NSTextFieldCell __strong* titleLabelCell_;
    NSTextFieldCell __strong* descLabelCell_;

    TauMosEnteredInteractionButton __strong* playButton_;
    }

#pragma mark - Initializations

#define ORIGIN_X 15.f
#define ORIGIN_Y 10.f

#define TITLE_LABEL_HEIGHT 25.F

#define PLAY_BUTTON_HEI 22.F

#define GEN_GAP 10.f

- ( instancetype ) initWithGTLObject: ( GTLObject* )_GTLObject host: ( TauYouTubeEntryView* )_EntryView
    {
    if ( self = [ super initWithGTLObject: _GTLObject host: _EntryView ] )
        {
        self.layer.backgroundColor = [ [ NSColor blackColor ] colorWithAlphaComponent: .8f ].CGColor;

        titleLabelCell_ = [ [ NSTextFieldCell alloc ] init ];
        titleLabelCell_.truncatesLastVisibleLine = YES;
        titleLabelCell_.font = [ NSFont fontWithName: @"PingFang SC Light" size: 13.f ];
        titleLabelCell_.stringValue = @"...";

        descLabelCell_ = [ [ NSTextFieldCell alloc ] init ];
        descLabelCell_.truncatesLastVisibleLine = YES;
        descLabelCell_.font = [ NSFont fontWithName: @"PingFang SC Light" size: 9.f ];
        descLabelCell_.stringValue = @"...";

        playButton_ = [ [ TauMosEnteredInteractionButton alloc ] initWithFrame: NSZeroRect ];


        [ self addSubview: playButton_ ];
        [ playButton_ autoAlignAxisToSuperviewAxis: ALAxisVertical ];
        [ playButton_ autoPinEdgeToSuperviewEdge: ALEdgeBottom withInset: GEN_GAP ];

        NSString* titleString = nil;
        switch ( self.type )
            {
            case TauYouTubeVideoView:
            case TauYouTubePlayListItemView: titleString = NSLocalizedString( @"Play", nil );           break;
            case TauYouTubeChannelView:      titleString = NSLocalizedString( @"View Channel", nil );   break;
            case TauYouTubePlayListView:     titleString = NSLocalizedString( @"Playlist", nil );       break;
            default:                         titleString = @"...";
            }

        [ playButton_ setTitle: titleString ];
        [ playButton_ sizeToFit ];
        [ playButton_ autoSetDimensionsToSize: CGSizeMake( NSWidth( NSInsetRect( playButton_.frame, -5.f, 0.f ) ), PLAY_BUTTON_HEI ) ];

        GTLYouTubePlaylistItem* object = ( GTLYouTubePlaylistItem* )self.ytContent;
        titleLabelCell_.stringValue = [ object snippet ].title;
        descLabelCell_.stringValue = [ object snippet ].descriptionProperty;
        }

    return self;
    }

- ( BOOL ) isFlipped
    {
    return YES;
    }

- ( void ) drawRect: ( NSRect )_DirtyRect
    {
    [ super drawRect: _DirtyRect ];

    [ titleLabelCell_ drawWithFrame:
        NSMakeRect( ORIGIN_X, ORIGIN_Y, NSWidth( self.bounds ) - ORIGIN_X * 2, TITLE_LABEL_HEIGHT ) inView: self ];

    [ descLabelCell_ drawWithFrame:
        NSMakeRect( ORIGIN_X
                  , ORIGIN_Y + TITLE_LABEL_HEIGHT
                  , NSWidth( self.bounds ) - ORIGIN_X * 2
                  , NSHeight( self.bounds ) - GEN_GAP * 2 - ( GEN_GAP + TITLE_LABEL_HEIGHT ) - PLAY_BUTTON_HEI
                  ) inView: self ];
    }

@end // TauEntryMosEnteredInteractionView class