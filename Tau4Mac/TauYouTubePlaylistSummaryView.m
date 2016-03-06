//
//  TauYouTubePlaylistSummaryView.m
//  Tau4Mac
//
//  Created by Tong G. on 3/6/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauYouTubePlaylistSummaryView.h"

// PrivateView_ class
@interface InternalView_ : NSView
#pragma mark - Wrapped Properties
@property ( strong, readwrite ) GTLObject* ytObject;
@end // PrivateView_ class

// Private Interfaces
@interface TauYouTubePlaylistSummaryView ()
- ( void ) doInit_;
@end // Private Interfaces

// TauYouTubePlaylistSummaryView class
@implementation TauYouTubePlaylistSummaryView
    {
    InternalView_ __strong* internalView_;
    }

#pragma mark - Initializations

- ( instancetype ) initWithFrame: ( NSRect )_FrameRect
    {
    if ( self = [ super initWithFrame: _FrameRect ] )
        [ self doInit_ ];
    return self;
    }

- ( instancetype ) initWithCoder: ( NSCoder* )_Coder
    {
    if ( self = [ super initWithCoder: _Coder ] )
        [ self doInit_ ];
    return self;
    }

#pragma mark - Private Interfaces

- ( void ) doInit_
    {
    [ self configureForAutoLayout ];

    self.blendingMode = NSVisualEffectBlendingModeWithinWindow;
    self.material = NSVisualEffectMaterialDark;
    self.state = NSVisualEffectStateActive;

    internalView_ = [ [ InternalView_ alloc ] initWithFrame: NSZeroRect ];
    [ self addSubview: internalView_ ];
    [ internalView_ autoPinEdgesToSuperviewEdges ];
    }

#pragma mark - Wrapped Properties

@dynamic ytObject;

- ( void ) setYtObject: ( GTLObject* )_New
    {
    [ internalView_ setYtObject: _New ];
    }

- ( GTLObject* ) ytObject
    {
    return [ internalView_ ytObject ];
    }

@end // TauYouTubePlaylistSummaryView class

// PrivateView_ class
@implementation InternalView_
    {
    GTLObject __strong* ytObject_;
    NSDictionary __strong* drawingAttrs_;

    NSInteger videoCount_;
    NSString __strong* videosText_;
    NSImage __strong* plistImageMod_;

    GTLServiceTicket __strong* plistsListTicket_;
    }

#pragma mark - Initializations

- ( instancetype ) initWithFrame: ( NSRect )_FrameRect
    {
    if ( self = [ super initWithFrame: _FrameRect ] )
        {
        videoCount_ = -1;
        videosText_ = NSLocalizedString( @"VIDEOS", nil );
        plistImageMod_ = [ NSImage imageNamed: @"tau-playlist-module" ];

        [ self configureForAutoLayout ];
        }

    return self;
    }

#pragma mark - Drawing

- ( BOOL ) isFlipped
    {
    return YES;
    }

- ( void ) drawRect: ( NSRect )_DirtyRect
    {
    if ( !drawingAttrs_ )
        drawingAttrs_ = @{ NSFontAttributeName : [ NSFont fontWithName: @"Helvetica Neue Light" size: 25.f ]
                         , NSForegroundColorAttributeName : [ NSColor whiteColor ]
                         };

    // Drawing count text
    NSString* countText = ( videoCount_ > -1 ) ? @( videoCount_ ).stringValue : @"\U0000221E";
    NSSize countTextSize = [ countText sizeWithAttributes: drawingAttrs_ ];
    [ countText drawAtPoint: NSMakePoint( ( NSWidth( self.bounds ) - countTextSize.width ) / 2
                                        , NSMidY( self.bounds ) - countTextSize.height - 15.f )
             withAttributes: drawingAttrs_ ];

    // Drawing 'VIDEOS' text
    NSDictionary* tmpDict = @{ NSFontAttributeName : [ NSFont fontWithName: @"Helvetica Neue Light" size: 18.f ]
                         , NSForegroundColorAttributeName : [ NSColor whiteColor ]
                         };
    NSSize videosTextSize = [ videosText_ sizeWithAttributes: tmpDict ];
    [ videosText_ drawAtPoint: NSMakePoint( ( NSWidth( self.bounds ) - videosTextSize.width ) / 2
                                          , NSMidY( self.bounds ) - 15.f )
               withAttributes: tmpDict ];

    // Drawing icon
    NSSize originImageSize = [ plistImageMod_ size ];
    CGFloat aspectRatio = originImageSize.width / originImageSize.height;
    NSSize adaptedSize = NSMakeSize( ( NSWidth( self.bounds ) / 4 ) * aspectRatio,  ( NSWidth( self.bounds ) / 4 ) );
    [ plistImageMod_ drawInRect: NSMakeRect( ( NSWidth( self.bounds ) - adaptedSize.width ) / 2
                                           , NSMidY( self.bounds ) + videosTextSize.height
                                           , adaptedSize.width
                                           , adaptedSize.height
                                           ) ];
    }

#pragma mark - Wrapped Properties

@dynamic ytObject;

- ( void ) setYtObject: ( GTLObject* )_New
    {
    if ( ytObject_ != _New )
        {
        ytObject_ = _New;

        if ( plistsListTicket_ )
            [ plistsListTicket_ cancelTicket ];

        GTLQueryYouTube* plistsListQuery = [ GTLQueryYouTube queryForPlaylistsListWithPart: @"contentDetails" ];

        // TODO: Instead of GTLYouTubeSearchResult, ytObject_ might also be kind of GTLYouTubePlaylist class
        GTLYouTubeSearchResult* searchResult = ( GTLYouTubeSearchResult* )ytObject_;
        GTLYouTubeResourceId* rsrcID = searchResult.identifier;
        NSString* originPlistID = rsrcID.JSON[ @"playlistId" ];

        // FIXIT: searchResult.identifier should return a instance of GTLYouTubeResourceId
        [ plistsListQuery setIdentifier: originPlistID ];
        [ plistsListQuery setMaxResults: 1 ];
        [ plistsListQuery setFields: @"items( id, contentDetails( itemCount ) )" ];

        plistsListTicket_ = [ [ TauDataService sharedService ].ytService executeQuery: plistsListQuery
                                                                    completionHandler:
        ^( GTLServiceTicket* _Ticket, GTLYouTubePlaylistListResponse* _PlistListResp, NSError* _Error )
            {
            if ( _PlistListResp && !_Error )
                {
                GTLYouTubePlaylist* plist = _PlistListResp.items.firstObject;
                if ( [ originPlistID isEqualToString: plist.identifier ] )
                    videoCount_ = [ plist.contentDetails itemCount ].integerValue;

                [ self setNeedsDisplay: YES ];
                }
            else
                DDLogError( @"%@", _Error );
            } ];

        self.needsDisplay = YES;
        }
    }

- ( GTLObject* ) ytObject
    {
    return ytObject_;
    }

@end // PrivateView_