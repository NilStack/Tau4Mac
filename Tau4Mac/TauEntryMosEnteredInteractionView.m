//
//  TauEntryMosEnteredInteractionView.m
//  Tau4Mac
//
//  Created by Tong G. on 3/9/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauEntryMosEnteredInteractionView.h"
#import "TauMosEnteredInteractionButton.h"

// Private Interfaces
@interface TauEntryMosEnteredInteractionView ()

@property ( strong, readonly ) NSTextFieldCell* titleLabelCell_;
@property ( strong, readonly ) NSTextFieldCell* descLabelCell_;

@end // Private Interfaces

// TauEntryMosEnteredInteractionView class
@implementation TauEntryMosEnteredInteractionView
    {
    NSTextFieldCell __strong* priTitleLabelCell_;
    NSTextFieldCell __strong* priTdescLabelCell_;

    TauMosEnteredInteractionButton __strong* interactionButton_;
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

        [ self.interactionButton autoAlignAxisToSuperviewAxis: ALAxisVertical ];
        [ self.interactionButton autoPinEdgeToSuperviewEdge: ALEdgeBottom withInset: GEN_GAP ];
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

    [ self.titleLabelCell_ drawWithFrame:
        NSMakeRect( ORIGIN_X, ORIGIN_Y, NSWidth( self.bounds ) - ORIGIN_X * 2, TITLE_LABEL_HEIGHT ) inView: self ];

    [ self.descLabelCell_ drawWithFrame:
        NSMakeRect( ORIGIN_X
                  , ORIGIN_Y + TITLE_LABEL_HEIGHT
                  , NSWidth( self.bounds ) - ORIGIN_X * 2
                  , NSHeight( self.bounds ) - GEN_GAP * 2 - ( GEN_GAP + TITLE_LABEL_HEIGHT ) - PLAY_BUTTON_HEI
                  ) inView: self ];
    }

#pragma mark - Dynamic Properties

@dynamic interactionButton;

- ( TauMosEnteredInteractionButton* ) interactionButton
    {
    if ( !interactionButton_ )
        {
        interactionButton_ = [ [ TauMosEnteredInteractionButton alloc ] initWithFrame: NSZeroRect ];

        [ self addSubview: interactionButton_ ];

        NSString* titleString = nil;
        switch ( self.type )
            {
            case TauYouTubeVideoView:
            case TauYouTubePlayListItemView: titleString = NSLocalizedString( @"Play", nil );           break;
            case TauYouTubeChannelView:      titleString = NSLocalizedString( @"View Channel", nil );   break;
            case TauYouTubePlayListView:     titleString = NSLocalizedString( @"Playlist", nil );       break;
            default:                         titleString = @"...";
            }

        [ interactionButton_ setTitle: titleString ];
        [ interactionButton_ sizeToFit ];
        [ interactionButton_ removeConstraints: interactionButton_.constraints ];
        [ interactionButton_ autoSetDimensionsToSize: CGSizeMake( NSWidth( NSInsetRect( interactionButton_.frame, -5.f, 0.f ) ), PLAY_BUTTON_HEI ) ];
        }

    return interactionButton_;
    }

#pragma mark - Overrides

- ( void ) setYtContent: ( GTLObject* )_Content
    {
    [ super setYtContent: _Content ];

    if ( self.ytContent )
        {
        // FIXIT: Duplicate
        NSString* titleString = nil;
        switch ( self.type )
            {
            case TauYouTubeVideoView:
            case TauYouTubePlayListItemView: titleString = NSLocalizedString( @"Play", nil );           break;
            case TauYouTubeChannelView:      titleString = NSLocalizedString( @"View Channel", nil );   break;
            case TauYouTubePlayListView:     titleString = NSLocalizedString( @"Playlist", nil );       break;
            default:                         titleString = @"...";
            }

        [ interactionButton_ setTitle: titleString ];
        [ interactionButton_ sizeToFit ];
        [ interactionButton_ removeConstraints: interactionButton_.constraints ];
        [ interactionButton_ autoSetDimensionsToSize: CGSizeMake( NSWidth( NSInsetRect( interactionButton_.frame, -5.f, 0.f ) ), PLAY_BUTTON_HEI ) ];

        // FIXIT: Duplicate
        GTLYouTubePlaylistItem* object = ( GTLYouTubePlaylistItem* )self.ytContent;
        self.titleLabelCell_.stringValue = [ object snippet ].title ?: @"...";
        self.descLabelCell_.stringValue = [ object snippet ].descriptionProperty ?: @"...";
        }
    }

#pragma mark - Private Interfaces

@dynamic titleLabelCell_;
@dynamic descLabelCell_;

- ( NSTextFieldCell* ) titleLabelCell_
    {
    if ( !priTitleLabelCell_ )
        {
        priTitleLabelCell_ = [ [ NSTextFieldCell alloc ] init ];
        priTitleLabelCell_.truncatesLastVisibleLine = YES;
        priTitleLabelCell_.font = [ NSFont fontWithName: @"PingFang SC Light" size: 13.f ];
        priTitleLabelCell_.stringValue = @"...";
        }

    return priTitleLabelCell_;
    }

- ( NSTextFieldCell* ) descLabelCell_
    {
    if ( !priTdescLabelCell_ )
        {
        priTdescLabelCell_ = [ [ NSTextFieldCell alloc ] init ];
        priTdescLabelCell_.truncatesLastVisibleLine = YES;
        priTdescLabelCell_.font = [ NSFont fontWithName: @"PingFang SC Light" size: 9.f ];
        priTdescLabelCell_.stringValue = @"...";
        }

    return priTdescLabelCell_;
    }

@end // TauEntryMosEnteredInteractionView class