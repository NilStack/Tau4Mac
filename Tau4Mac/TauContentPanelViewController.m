//
//  TauContentPanelViewController.m
//  Tau4Mac
//
//  Created by Tong G. on 3/3/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauContentPanelViewController.h"

#import "TauCollectionObject.h"
#import "TauVideoView.h"

// Private Interfaces
@interface TauContentPanelViewController ()
@end // Private Interfaces

// TauContentPanelViewController class
@implementation TauContentPanelViewController
    {
@protected
    GTLCollectionObject __strong* repContents_;
    }

#pragma mark - Initializations

#define TAU_ROW_COUNT 4
#define TAU_COL_COUNT 5

#define TAU_ROW_MAX_IDX ( TAU_ROW_COUNT - 1 )
#define TAU_COL_MAX_IDX ( TAU_COL_COUNT - 1 )

- ( void ) setRepresentedObject: ( GTLCollectionObject* )_RepresentedObject
    {
    [ super setRepresentedObject: _RepresentedObject ];

    NSMutableArray <TauVideoView*>* videoViews = [ NSMutableArray array ];
    for ( GTLYouTubeSearchResult* _SearchResult in _RepresentedObject )
        {
        DDLogDebug( @"%@", _SearchResult );

        if ( [ _SearchResult.identifier.kind isEqualToString: @"youtube#video" ] )
            [ videoViews addObject: [ [ TauVideoView alloc ] initWithGTLObject: _SearchResult ] ];
//            [ videoView autoMatchDimension: ALDimensionWidth toDimension: ALDimensionWidth ofView: self.view withMultiplier: 1.f / 4.f ];
        }

    NSView* superview = self.view;
    NSView __block* anchorView = nil;
    NSView __block* previousView = nil;

    [ videoViews enumerateObjectsUsingBlock:
    ^( TauVideoView* _Nonnull _VideoView, NSUInteger _Index, BOOL* _Nonnull _Stop )
        {
        [ self.view addSubview: _VideoView ];

        NSUInteger row = _Index / TAU_ROW_COUNT;
        NSUInteger col = _Index % TAU_ROW_COUNT;

        // Upper Left
        if ( row == 0 && col == 0 )
            {
            [ _VideoView autoPinEdgeToSuperviewEdge: ALEdgeTop ];
            [ _VideoView autoPinEdgeToSuperviewEdge: ALEdgeLeading ];

            [ _VideoView autoMatchDimension: ALDimensionWidth toDimension: ALDimensionWidth ofView: superview withMultiplier: 1.f / TAU_ROW_COUNT ];

            anchorView = _VideoView;
            previousView = _VideoView;
            }

        // Left Side
        else if ( ( row > 0 && row < TAU_ROW_MAX_IDX ) && col == 0 )
            {
            NSView* pin2 = videoViews[ _Index - TAU_ROW_COUNT ];
            [ _VideoView autoPinEdge: ALEdgeTop toEdge: ALEdgeBottom ofView: pin2 ];
            [ _VideoView autoPinEdgeToSuperviewEdge: ALEdgeLeading ];

            [ _VideoView autoMatchDimension: ALDimensionWidth toDimension: ALDimensionWidth ofView: superview withMultiplier: 1.f / TAU_ROW_COUNT ];

            previousView = _VideoView;
            }

        // Upper Right
        else if ( row == 0 && col == TAU_COL_MAX_IDX )
            {
            [ _VideoView autoPinEdgeToSuperviewEdge: ALEdgeTop ];
            [ _VideoView autoPinEdgeToSuperviewEdge: ALEdgeTrailing ];
            [ _VideoView autoPinEdge: ALEdgeLeading toEdge: ALEdgeTrailing ofView: previousView ];

            [ _VideoView autoMatchDimension: ALDimensionWidth toDimension: ALDimensionWidth ofView: superview withMultiplier: 1.f / TAU_ROW_COUNT ];

            previousView = _VideoView;
            }

        // Right Side
        else if ( ( row > 0 && row < TAU_ROW_MAX_IDX ) && col == TAU_COL_MAX_IDX )
            {
            NSView* pin2 = videoViews[ _Index - TAU_ROW_COUNT ];

            [ _VideoView autoPinEdge: ALEdgeTop toEdge: ALEdgeBottom ofView: pin2 ];
            [ _VideoView autoPinEdgeToSuperviewEdge: ALEdgeTrailing ];
            [ _VideoView autoPinEdge: ALEdgeLeading toEdge: ALEdgeTrailing ofView: previousView ];

            [ _VideoView autoMatchDimension: ALDimensionWidth toDimension: ALDimensionWidth ofView: superview withMultiplier: 1.f / TAU_ROW_COUNT ];

            previousView = _VideoView;
            }

        // Bottom Left
        else if ( row == TAU_ROW_MAX_IDX && col == 0 )
            {
            NSView* pin2 = videoViews[ _Index - TAU_ROW_COUNT ];

            [ _VideoView autoPinEdge: ALEdgeTop toEdge: ALEdgeBottom ofView: pin2 ];
            [ _VideoView autoPinEdgeToSuperviewEdge: ALEdgeLeading ];
            [ _VideoView autoPinEdgeToSuperviewEdge: ALEdgeBottom ];

            [ _VideoView autoMatchDimension: ALDimensionWidth toDimension: ALDimensionWidth ofView: superview withMultiplier: 1.f / TAU_ROW_COUNT ];

            previousView = _VideoView;
            }

        // Bottom Side
        else if ( row == TAU_ROW_MAX_IDX && ( col > 0 && col < TAU_COL_MAX_IDX ) )
            {
            NSView* pin2 = videoViews[ _Index - TAU_ROW_COUNT ];

            [ _VideoView autoPinEdge: ALEdgeTop toEdge: ALEdgeBottom ofView: pin2 ];
            [ _VideoView autoPinEdgeToSuperviewEdge: ALEdgeBottom ];

            [ _VideoView autoMatchDimension: ALDimensionWidth toDimension: ALDimensionWidth ofView: superview withMultiplier: 1.f / TAU_ROW_COUNT ];

            previousView = _VideoView;
            }

        // Bottom Right
        else if ( row == TAU_ROW_MAX_IDX && col == TAU_COL_MAX_IDX )
            {
            NSView* pin2 = videoViews[ _Index - TAU_ROW_COUNT ];

            [ _VideoView autoPinEdge: ALEdgeTop toEdge: ALEdgeBottom ofView: pin2 ];
            [ _VideoView autoPinEdgeToSuperviewEdge: ALEdgeTrailing ];
            [ _VideoView autoPinEdgeToSuperviewEdge: ALEdgeBottom ];
            [ _VideoView autoPinEdge: ALEdgeLeading toEdge: ALEdgeTrailing ofView: previousView ];

            previousView = _VideoView;
            }

        // Top Side
        else if ( row == 0 && ( col > 0 && col < TAU_COL_MAX_IDX ) )
            {
            [ _VideoView autoPinEdgeToSuperviewEdge: ALEdgeTop ];
            [ _VideoView autoPinEdge: ALEdgeLeading toEdge: ALEdgeTrailing ofView: previousView ];

            [ _VideoView autoMatchDimension: ALDimensionWidth toDimension: ALDimensionWidth ofView: superview withMultiplier: 1.f / TAU_ROW_COUNT ];

            previousView = _VideoView;
            }

        // Central
        else if ( ( row > 0 && row < TAU_ROW_MAX_IDX ) && ( ( col > 0 ) && ( col < TAU_COL_MAX_IDX ) ) )
            {
            NSView* pin2 = videoViews[ _Index - TAU_ROW_COUNT ];

            [ _VideoView autoPinEdge: ALEdgeTop toEdge: ALEdgeBottom ofView: pin2 ];
            [ _VideoView autoPinEdge: ALEdgeLeading toEdge: ALEdgeTrailing ofView: previousView ];

            [ _VideoView autoMatchDimension: ALDimensionWidth toDimension: ALDimensionWidth ofView: superview withMultiplier: 1.f / TAU_ROW_COUNT ];

            previousView = _VideoView;
            }
        } ];
    }

// #pragma mark - Private Interfaces

@end // TauContentPanelViewController class