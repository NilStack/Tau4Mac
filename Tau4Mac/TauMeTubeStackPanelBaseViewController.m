//
//  TauMeTubeStackPanelBaseViewController.m
//  Tau4Mac
//
//  Created by Tong G. on 3/7/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauMeTubeStackPanelBaseViewController.h"
#import "TauResultCollectionPanelViewController.h"

// Private Interfaces
@interface TauMeTubeStackPanelBaseViewController ()

@property ( strong, readonly ) TauResultCollectionPanelViewController* likesCollectionSubPanelController_;
@property ( assign, readonly ) BOOL isFetchingRelatedPlaylists_;

- ( void ) doMeTubeStackPanelBaseViewControllerInit_;
@end // Private Interfaces

// TauMeTubeStackPanelBaseViewController class
@implementation TauMeTubeStackPanelBaseViewController
    {
    FBKVOController __strong* kvoController_;

    BOOL __block isFetchRelatedPlaylistsSuccess_;

    NSString __strong* likesPlaylistID_;
    NSString __strong* favoritesPlaylistID_;
    NSString __strong* uploadsPlaylistID_;
    NSString __strong* historyPlaylistID_;
    NSString __strong* watchLaterPlaylistID_;

    GTLYouTubePlaylistItemListResponse __strong* likesPlaylistItemsResp_;
    GTLYouTubePlaylistItemListResponse __strong* favoritesPlaylistItemResp_;
    GTLYouTubePlaylistItemListResponse __strong* uploadsPlaylistItemResp_;
    GTLYouTubePlaylistItemListResponse __strong* historyPlaylistItemResp_;
    GTLYouTubePlaylistItemListResponse __strong* watchLaterPlaylistItemResp_;

    GTLServiceTicket __strong __block* ytChannelMineListTicket_;
    GTLServiceTicket __strong* ytLikesListTicket_;

    NSMutableArray <NSLayoutConstraint*>* layoutConstraintsCache_;

    NSView __weak* currentCollectionPanelView_;
    }

#pragma mark - Initializations

- ( instancetype ) initWithCoder: ( NSCoder* )_Coder
    {
    if ( self = [ super initWithCoder: _Coder ] )
        [ self doMeTubeStackPanelBaseViewControllerInit_ ];
    return self;
    }

- ( instancetype ) initWithNibName: ( NSString* )_NibNameOrNil
                            bundle: ( NSBundle* )_NibBundleOrNil
    {
    if ( self = [ super initWithNibName: _NibNameOrNil bundle: _NibBundleOrNil ] )
        [ self doMeTubeStackPanelBaseViewControllerInit_ ];
    return self;
    }

- ( void ) fetchPlaylistIDs_
    {
    if ( !self.isFetchingRelatedPlaylists_ )
        {
        GTLQueryYouTube* channelsMineListQuery = [ GTLQueryYouTube queryForChannelsListWithPart: @"snippet,contentDetails" ];
        [ channelsMineListQuery setMine: YES ];

        ytChannelMineListTicket_ = [ [ TauDataService sharedService ].ytService
            executeQuery: channelsMineListQuery completionHandler:
        ^( GTLServiceTicket* _Ticket, GTLYouTubeChannelListResponse* _ChannelListResp, NSError* _Error )
            {
            if ( _ChannelListResp && !_Error )
                {
                isFetchRelatedPlaylistsSuccess_ = YES;

                GTLYouTubeChannelContentDetails* contentDetails = [ ( GTLYouTubeChannel* )( _ChannelListResp.items.firstObject ) contentDetails ];
                GTLYouTubeChannelContentDetailsRelatedPlaylists* relatedPlaylists = contentDetails.relatedPlaylists;

                likesPlaylistID_ = relatedPlaylists.likes;
                favoritesPlaylistID_ = relatedPlaylists.favorites;
                uploadsPlaylistID_ = relatedPlaylists.uploads;
                historyPlaylistID_ = relatedPlaylists.watchHistory;
                watchLaterPlaylistID_ = relatedPlaylists.watchLater;

                self.subPanelSegSwitcher.enabled = YES;
                self.subPanelSegSwitcher.selectedSegment = TauMeTubeSubPanelSwitcherLikesTag;
                }
            else
                {
                DDLogError( @"%@", _Error );
                isFetchRelatedPlaylistsSuccess_ = NO;
                ytChannelMineListTicket_ = nil;
                }
            } ];
        }
    }

- ( void ) viewDidLoad
    {
    [ super viewDidLoad ];

    [ kvoController_ observe: self.subPanelSegSwitcher keyPath: @"cell.selectedSegment"
                     options: NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                       block:
    ^( id _Observer, id _Object, NSDictionary* _Change )
        {
        TauMeTubeSubPanelSwitcherSegmentTag new = [ _Change[ @"new" ] integerValue ];
        TauMeTubeSubPanelSwitcherSegmentTag old = [ _Change[ @"old" ] integerValue ];

        if ( new != old )
            {
            if ( layoutConstraintsCache_ )
                [ self.view removeConstraints: layoutConstraintsCache_ ];

            if ( currentCollectionPanelView_ )
                [ currentCollectionPanelView_ removeFromSuperview ];

            switch ( new )
                {
                case TauMeTubeSubPanelSwitcherLikesTag:
                    {
                    currentCollectionPanelView_ = self.likesCollectionSubPanelController_.view;
                    [ self.view addSubview: currentCollectionPanelView_ ];

                    [ layoutConstraintsCache_ addObjectsFromArray:
                        [ self.likesCollectionSubPanelController_.view autoPinEdgesToSuperviewEdgesWithInsets: NSEdgeInsetsZero excludingEdge: ALEdgeTop ] ];

                    [ layoutConstraintsCache_ addObject:
                        [ self.likesCollectionSubPanelController_.view autoPinEdge: ALEdgeTop toEdge: ALEdgeBottom ofView: self.subPanelSegSwitcherPanel ] ];

                    } break;
                }
            }
        } ];

    [ self fetchPlaylistIDs_ ];
    }

#pragma mark - Private Interfaces

@dynamic likesCollectionSubPanelController_;
@dynamic isFetchingRelatedPlaylists_;

- ( TauResultCollectionPanelViewController* ) likesCollectionSubPanelController_
    {
    TauResultCollectionPanelViewController static* sC;

    dispatch_once_t static onceToken;
    dispatch_once( &onceToken
                 , ( dispatch_block_t )
    ^( void )
        {
        sC = [ [ TauResultCollectionPanelViewController alloc ] initWithGTLCollectionObject: nil ticket: nil ];

        if ( !self.isFetchingRelatedPlaylists_ && likesPlaylistID_ )
            {
            GTLQueryYouTube* playlistListItemsQuery = [ GTLQueryYouTube queryForPlaylistItemsListWithPart: @"contentDetails,id,snippet,status" ];
            [ playlistListItemsQuery setPlaylistId: likesPlaylistID_ ];
            [ playlistListItemsQuery setMaxResults: 20 ];

            [ [ TauDataService sharedService ].ytService
                executeQuery: playlistListItemsQuery completionHandler:
            ^( GTLServiceTicket* _Ticket, GTLYouTubePlaylistItemListResponse* _PlaylistItemListResp, NSError* _Error )
                {
                if ( _PlaylistItemListResp && !_Error )
                    {
                    sC.ytCollectionObject = _PlaylistItemListResp;
                    sC.ytTicket = _Ticket;
                    }
                else
                    DDLogError( @"%@", _Error );
                } ];
            }
        } );

    return sC;
    }

- ( BOOL ) isFetchingRelatedPlaylists_
    {
    return !isFetchRelatedPlaylistsSuccess_ && ytChannelMineListTicket_;
    }

- ( void ) doMeTubeStackPanelBaseViewControllerInit_
    {
    isFetchRelatedPlaylistsSuccess_ = NO;
    kvoController_ = [ [ FBKVOController alloc ] initWithObserver: self ];

    layoutConstraintsCache_ = [ NSMutableArray array ];
    }

@end // TauMeTubeStackPanelBaseViewController class