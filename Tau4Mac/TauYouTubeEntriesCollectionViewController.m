//
//  TauYouTubeEntriesCollectionViewController.m
//  Tau4Mac
//
//  Created by Tong G. on 3/3/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauYouTubeEntriesCollectionViewController.h"

#import "TauCollectionObject.h"
#import "TauYouTubeEntryView.h"

// Private Interfaces
@interface TauYouTubeEntriesCollectionViewController ()
@end // Private Interfaces

// TauYouTubeEntriesCollectionViewController class
@implementation TauYouTubeEntriesCollectionViewController
    {
@protected
    GTLCollectionObject __strong* repContents_;
    GTLServiceTicket __strong* ticket_;

    NSMutableArray __strong* mutVideoViews_;
    }

#pragma mark - Initializations

#define TAU_ROW_COUNT 5
#define TAU_COL_COUNT 4

#define TAU_ROW_MAX_IDX ( TAU_ROW_COUNT - 1 )
#define TAU_COL_MAX_IDX ( TAU_COL_COUNT - 1 )

#pragma mark - Initializations

- ( instancetype ) initWithGTLCollectionObject: ( GTLCollectionObject* )_CollectionObject
                                        ticket: ( GTLServiceTicket* )_Ticket
    {
    NSBundle* correctBundle = [ NSBundle bundleForClass: [ TauYouTubeEntriesCollectionViewController class ] ];
    
    if ( self = [ super initWithNibName: @"TauYouTubeEntriesCollectionView" bundle: correctBundle ] )
        {
        repContents_ = _CollectionObject;
        ticket_ = _Ticket;
        }

    return self;
    }

- ( void ) viewDidLoad
    {
    [ self setRepresentedObject: repContents_ ];
    }

- ( void ) setRepresentedObject: ( GTLCollectionObject* )_RepresentedObject
    {
    [ super setRepresentedObject: _RepresentedObject ];

    if ( ![ _RepresentedObject isKindOfClass: [ GTLCollectionObject class ] ] )
        return;

    if ( !mutVideoViews_ )
        {
        mutVideoViews_ = [ NSMutableArray arrayWithCapacity: TAU_ROW_COUNT * TAU_COL_COUNT ];

        NSView* superview = self.view;
        NSView __block* previousView = nil;

        for ( int _Index = 0; _Index < TAU_ROW_COUNT * TAU_COL_COUNT; _Index++ )
            {
            TauYouTubeEntryView* videoView = [ [ TauYouTubeEntryView alloc ] initWithFrame: NSZeroRect ];
            [ self.view addSubview: videoView ];

            NSUInteger row = _Index / TAU_COL_COUNT;
            NSUInteger col = _Index % TAU_COL_COUNT;

            [ videoView setIdentifier: [ NSString stringWithFormat: @"[%lu, %lu]", row, col ] ];

            // Upper Left
            if ( row == 0 && col == 0 )
                {
                [ videoView autoPinEdgeToSuperviewEdge: ALEdgeTop ];
                [ videoView autoPinEdgeToSuperviewEdge: ALEdgeLeading ];

                [ videoView autoMatchDimension: ALDimensionWidth toDimension: ALDimensionWidth ofView: superview withMultiplier: 1.f / TAU_COL_COUNT ];

                previousView = videoView;
                }

            // Left Side
            else if ( ( row > 0 && row < TAU_ROW_MAX_IDX ) && col == 0 )
                {
                NSView* pin2 = mutVideoViews_[ _Index - TAU_COL_COUNT ];
                [ videoView autoPinEdge: ALEdgeTop toEdge: ALEdgeBottom ofView: pin2 ];
                [ videoView autoPinEdgeToSuperviewEdge: ALEdgeLeading ];

                [ videoView autoMatchDimension: ALDimensionWidth toDimension: ALDimensionWidth ofView: superview withMultiplier: 1.f / TAU_COL_COUNT ];

                previousView = videoView;
                }

            // Upper Right
            else if ( row == 0 && col == TAU_COL_MAX_IDX )
                {
                [ videoView autoPinEdgeToSuperviewEdge: ALEdgeTop ];
                [ videoView autoPinEdgeToSuperviewEdge: ALEdgeTrailing ];
                [ videoView autoPinEdge: ALEdgeLeading toEdge: ALEdgeTrailing ofView: previousView ];

                [ videoView autoMatchDimension: ALDimensionWidth toDimension: ALDimensionWidth ofView: superview withMultiplier: 1.f / TAU_COL_COUNT ];

                previousView = videoView;
                }

            // Right Side
            else if ( ( row > 0 && row < TAU_ROW_MAX_IDX ) && col == TAU_COL_MAX_IDX )
                {
                NSView* pin2 = mutVideoViews_[ _Index - TAU_COL_COUNT ];

                [ videoView autoPinEdge: ALEdgeTop toEdge: ALEdgeBottom ofView: pin2 ];
                [ videoView autoPinEdgeToSuperviewEdge: ALEdgeTrailing ];
                [ videoView autoPinEdge: ALEdgeLeading toEdge: ALEdgeTrailing ofView: previousView ];

                [ videoView autoMatchDimension: ALDimensionWidth toDimension: ALDimensionWidth ofView: superview withMultiplier: 1.f / TAU_COL_COUNT ];

                previousView = videoView;
                }

            // Bottom Left
            else if ( row == TAU_ROW_MAX_IDX && col == 0 )
                {
                NSView* pin2 = mutVideoViews_[ _Index - TAU_COL_COUNT ];

                [ videoView autoPinEdge: ALEdgeTop toEdge: ALEdgeBottom ofView: pin2 ];
                [ videoView autoPinEdgeToSuperviewEdge: ALEdgeLeading ];
                [ videoView autoPinEdgeToSuperviewEdge: ALEdgeBottom ];

                [ videoView autoMatchDimension: ALDimensionWidth toDimension: ALDimensionWidth ofView: superview withMultiplier: 1.f / TAU_COL_COUNT ];

                previousView = videoView;
                }

            // Bottom Side
            else if ( row == TAU_ROW_MAX_IDX && ( col > 0 && col < TAU_COL_MAX_IDX ) )
                {
                NSView* pin2 = mutVideoViews_[ _Index - TAU_COL_COUNT ];

                [ videoView autoPinEdge: ALEdgeTop toEdge: ALEdgeBottom ofView: pin2 ];
                [ videoView autoPinEdge: ALEdgeLeading toEdge: ALEdgeTrailing ofView: previousView ];
                [ videoView autoPinEdgeToSuperviewEdge: ALEdgeBottom ];

                [ videoView autoMatchDimension: ALDimensionWidth toDimension: ALDimensionWidth ofView: superview withMultiplier: 1.f / TAU_COL_COUNT ];

                previousView = videoView;
                }

            // Bottom Right
            else if ( row == TAU_ROW_MAX_IDX && col == TAU_COL_MAX_IDX )
                {
                NSView* pin2 = mutVideoViews_[ _Index - TAU_COL_COUNT ];

                [ videoView autoPinEdge: ALEdgeTop toEdge: ALEdgeBottom ofView: pin2 ];
                [ videoView autoPinEdgeToSuperviewEdge: ALEdgeTrailing ];
                [ videoView autoPinEdgeToSuperviewEdge: ALEdgeBottom ];
                [ videoView autoPinEdge: ALEdgeLeading toEdge: ALEdgeTrailing ofView: previousView ];

                previousView = videoView;
                }

            // Top Side
            else if ( row == 0 && ( col > 0 && col < TAU_COL_MAX_IDX ) )
                {
                [ videoView autoPinEdgeToSuperviewEdge: ALEdgeTop ];
                [ videoView autoPinEdge: ALEdgeLeading toEdge: ALEdgeTrailing ofView: previousView ];

                [ videoView autoMatchDimension: ALDimensionWidth toDimension: ALDimensionWidth ofView: superview withMultiplier: 1.f / TAU_COL_COUNT ];

                previousView = videoView;
                }

            // Central
            else if ( ( row > 0 && row < TAU_ROW_MAX_IDX ) && ( ( col > 0 ) && ( col < TAU_COL_MAX_IDX ) ) )
                {
                NSView* pin2 = mutVideoViews_[ _Index - TAU_COL_COUNT ];

                [ videoView autoPinEdge: ALEdgeTop toEdge: ALEdgeBottom ofView: pin2 ];
                [ videoView autoPinEdge: ALEdgeLeading toEdge: ALEdgeTrailing ofView: previousView ];

                [ videoView autoMatchDimension: ALDimensionWidth toDimension: ALDimensionWidth ofView: superview withMultiplier: 1.f / TAU_COL_COUNT ];

                previousView = videoView;
                }

            [ mutVideoViews_ addObject: videoView ];
            }
        }

    NSMutableArray* videoObjects = [ NSMutableArray array ];
    for ( GTLYouTubeSearchResult* _SearchResult in _RepresentedObject )
        {
        DDLogDebug( @"%@", _SearchResult );
        [ videoObjects addObject: _SearchResult ];
        }

    [ videoObjects enumerateObjectsUsingBlock:
    ^( GTLYouTubeSearchResult* _Nonnull _SearchResult, NSUInteger _Index, BOOL* _Nonnull _Stop )
        {
        [ mutVideoViews_[ _Index ] setYtContent: _SearchResult ];
        } ];
    }

#pragma mark - Dynamic Properties

@dynamic collectionObject;
@dynamic ticket;

- ( void ) setCollectionObject: ( GTLCollectionObject* )_CollectionObject
    {
    if ( repContents_ != _CollectionObject )
        {
        repContents_ = _CollectionObject;
        [ self setRepresentedObject: repContents_ ];
        }
    }

- ( GTLCollectionObject* ) collectionObject
    {
    return repContents_;
    }

- ( void ) setTicket: ( GTLServiceTicket* )_Ticket
    {
    if ( ticket_ != _Ticket )
        ticket_ = _Ticket;
    }

- ( GTLServiceTicket* ) ticket
    {
    return ticket_;
    }

@end // TauYouTubeEntriesCollectionViewController class