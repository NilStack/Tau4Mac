//
//  TauResultsCollectionSummaryView.m
//  Tau4Mac
//
//  Created by Tong G. on 3/5/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauResultsCollectionSummaryView.h"

// TauResultsCollectionSummaryView class
@implementation TauResultsCollectionSummaryView
    {
    GTLCollectionObject __strong* ytCollectionObject_;

    NSDictionary __strong* sumDrawingAttrs_;
    NSDictionary __strong* countDrawingAttrs_;

    NSString __strong* summaryText_;
    NSString __strong* auxiliarySummaryText_;

    NSInteger numberOfResults_;
    }

#pragma mark - Dynmaic Properties

@dynamic ytCollectionObject;

- ( void ) setYtCollectionObject: ( GTLCollectionObject* )_NewCollectionObject
    {
    if ( ytCollectionObject_ != _NewCollectionObject )
        {
        ytCollectionObject_ = _NewCollectionObject;

        if ( [ ytCollectionObject_ isKindOfClass: [ GTLYouTubeSearchListResponse class ] ] )
            {
            summaryText_ = NSLocalizedString( @"Search Results", nil );
            NSNumber* resultsCount = [ ( GTLYouTubePageInfo* )[ ytCollectionObject_ performSelector: @selector( pageInfo ) ] totalResults ];
            auxiliarySummaryText_ = [ NSString stringWithFormat: NSLocalizedString( @"About %@ results", nil ), resultsCount ];
            }
        else if ( [ ytCollectionObject_ isKindOfClass: [ GTLYouTubePlaylistItemListResponse class ] ] )
            {
            GTLYouTubePlaylistItemListResponse* resp = ( GTLYouTubePlaylistItemListResponse* )ytCollectionObject_;
            GTLYouTubeChannelContentDetails* hintDetails = [ ytCollectionObject_ propertyForKey: @"hint" ];
            if ( hintDetails )
                {
                SEL sels[ 5 ] = { @selector( likes )
                                , @selector( favorites )
                                , @selector( uploads )
                                , @selector( watchHistory )
                                , @selector( watchLater )
                                };

                GTLYouTubeChannelContentDetailsRelatedPlaylists* relatedPlaylists = hintDetails.relatedPlaylists;
                for ( int _Index = 0; _Index < sizeof( sels ) / sizeof( SEL ); _Index++ )
                    {
                    NSString* playlistID = nil;
                    if ( [ relatedPlaylists respondsToSelector: sels[ _Index ] ] )
                        {
TAU_SUPPRESS_PERFORM_SELECTOR_LEAK_WARNING_BEGIN
                        playlistID = [ relatedPlaylists performSelector: sels[ _Index ] ];
TAU_SUPPRESS_PERFORM_SELECTOR_LEAK_WARNING_COMMIT
                        }
                    else
                        DDLogUnexpected( @"%@ does not respond to %@", relatedPlaylists, NSStringFromSelector( sels[ _Index ] ) );

                    GTLYouTubePlaylistItemSnippet* snippet = [ ( GTLYouTubePlaylistItem* )( resp.items.firstObject ) snippet ];
                    if ( snippet /* snippet may be nil */ && [ playlistID isEqualToString: snippet.playlistId ] )
                        {
                        if ( sels[ _Index ] == @selector( likes ) )
                            summaryText_ = NSLocalizedString( @"LIKES", nil );
                        else if ( sels[ _Index ] == @selector( favorites ) )
                            summaryText_ = NSLocalizedString( @"FAVORITES", nil );
                        if ( sels[ _Index ] == @selector( uploads ) )
                            summaryText_ = NSLocalizedString( @"UPLOADS", nil );
                        if ( sels[ _Index ] == @selector( watchHistory ) )
                            summaryText_ = NSLocalizedString( @"HISTORY", nil );
                        if ( sels[ _Index ] == @selector( watchLater ) )
                            summaryText_ = NSLocalizedString( @"WATCH LATER", nil );

                        break;
                        }
                    }

                auxiliarySummaryText_ = @"";
                }
            else
                DDLogUnexpected( @"Expecting a hint details, what's the hell with you?" );
            }

        [ self setNeedsDisplay: YES ];
        }
    }

- ( GTLCollectionObject* ) ytCollectionObject
    {
    return ytCollectionObject_;
    }

#pragma mark - Drawing

- ( void ) drawRect: ( NSRect )_DirtyRect
    {
    [ super drawRect: _DirtyRect ];

    NSString* fontName = @"Helvetica Neue";
    if ( !sumDrawingAttrs_ )
        {
        sumDrawingAttrs_ =
            @{ NSForegroundColorAttributeName : [ NSColor whiteColor ]
             , NSFontAttributeName : [ NSFont fontWithName: fontName size: 15 ]
             };
        }

    if ( !countDrawingAttrs_ )
        {
        countDrawingAttrs_ =
            @{ NSForegroundColorAttributeName : [ NSColor lightGrayColor ]
             , NSFontAttributeName : [ NSFont fontWithName: fontName size: 13 ]
             };
        }

    NSSize sumSize = [ summaryText_ sizeWithAttributes: sumDrawingAttrs_ ];
    NSSize countSize = [ auxiliarySummaryText_ sizeWithAttributes: countDrawingAttrs_ ];

    NSSize totalSize = sumSize;
    totalSize.width += ( 5.f + countSize.width );

    NSPoint sumTextDrawingPoint =
        NSMakePoint( ( NSWidth( self.bounds ) - totalSize.width ) / 2.f
                   , ( NSHeight( self.bounds ) - totalSize.height ) / 2.f
                   );

    NSPoint countTextDrawingPoint = sumTextDrawingPoint;
    countTextDrawingPoint.x = ( sumTextDrawingPoint.x + sumSize.width + 5 );
    countTextDrawingPoint.y = ( NSHeight( self.bounds ) - countSize.height ) / 2.f;

    [ summaryText_ drawAtPoint: sumTextDrawingPoint withAttributes: sumDrawingAttrs_ ];
    [ auxiliarySummaryText_ drawAtPoint: countTextDrawingPoint withAttributes: countDrawingAttrs_ ];
    }

@end // TauResultsCollectionSummaryView class