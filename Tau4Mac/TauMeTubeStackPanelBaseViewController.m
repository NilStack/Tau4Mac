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
@property ( strong, readonly ) TauResultCollectionPanelViewController* uploadsCollectionSubPanelController_;
@property ( strong, readonly ) TauResultCollectionPanelViewController* historyCollectionSubPanelController_;
@property ( strong, readonly ) TauResultCollectionPanelViewController* watchLaterCollectionSubPanelController_;

@property ( assign, readonly ) BOOL isFetchingRelatedPlaylists_;

- ( void ) doMeTubeStackPanelBaseViewControllerInit_;
- ( void ) fetchPlaylistIDs_;
- ( TauResultCollectionPanelViewController* ) relatedPlaylistPanelControllerWithPlaylistID_: ( NSString* )_PlaylistID;

@end // Private Interfaces

// TauMeTubeStackPanelBaseViewController class
@implementation TauMeTubeStackPanelBaseViewController
    {
    FBKVOController __strong* kvoController_;

    BOOL __block isFetchRelatedPlaylistsSuccess_;

    TauResultCollectionPanelViewController __strong* likesC_;
    TauResultCollectionPanelViewController __strong* uploadsC_;
    TauResultCollectionPanelViewController __strong* historyC_;
    TauResultCollectionPanelViewController __strong* watchLaterC_;

    NSString __strong* likesPlaylistID_;
    NSString __strong* uploadsPlaylistID_;
    NSString __strong* historyPlaylistID_;
    NSString __strong* watchLaterPlaylistID_;

    GTLYouTubePlaylistItemListResponse __strong* likesPlaylistItemsResp_;
    GTLYouTubePlaylistItemListResponse __strong* uploadsPlaylistItemResp_;
    GTLYouTubePlaylistItemListResponse __strong* historyPlaylistItemResp_;
    GTLYouTubePlaylistItemListResponse __strong* watchLaterPlaylistItemResp_;

    GTLServiceTicket __strong __block* ytChannelMineListTicket_;
    GTLYouTubeChannelContentDetails __strong __block* ytChannelMineContentDetails_;

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
                    { currentCollectionPanelView_ = self.likesCollectionSubPanelController_.view; } break;

                case TauMeTubeSubPanelSwitcherUploadsTag:
                    { currentCollectionPanelView_ = self.uploadsCollectionSubPanelController_.view; } break;

                case TauMeTubeSubPanelSwitcherHistoryTag:
                    { currentCollectionPanelView_ = self.historyCollectionSubPanelController_.view; } break;

                case TauMeTubeSubPanelSwitcherWatchLaterTag:
                    { currentCollectionPanelView_ = self.watchLaterCollectionSubPanelController_.view; } break;
                }

            if ( currentCollectionPanelView_ )
                {
                [ self.view addSubview: currentCollectionPanelView_ ];

                [ layoutConstraintsCache_ addObjectsFromArray:
                    [ currentCollectionPanelView_ autoPinEdgesToSuperviewEdgesWithInsets: NSEdgeInsetsZero excludingEdge: ALEdgeTop ] ];
                [ layoutConstraintsCache_ addObject:
                    [ currentCollectionPanelView_ autoPinEdge: ALEdgeTop toEdge: ALEdgeBottom ofView: self.subPanelSegSwitcherPanel ] ];
                }
            }
        } ];

    [ self fetchPlaylistIDs_ ];
    }

- ( void ) cleanUp
    {
    [ likesC_.view removeFromSuperview ];
    [ uploadsC_.view removeFromSuperview ];
    [ historyC_.view removeFromSuperview ];
    [ watchLaterC_.view removeFromSuperview ];

    if ( layoutConstraintsCache_ )
        {
        [ self.view removeConstraints: layoutConstraintsCache_ ];
        layoutConstraintsCache_ = nil;
        }

//    self.likesCollectionSubPanelController_.ytCollectionObject = nil;
//    self.uploadsCollectionSubPanelController_.ytCollectionObject = nil;
//    self.historyCollectionSubPanelController_.ytCollectionObject = nil;
//    self.watchLaterCollectionSubPanelController_.ytCollectionObject = nil;
    }

#pragma mark - Private Interfaces

@dynamic likesCollectionSubPanelController_;
@dynamic uploadsCollectionSubPanelController_;
@dynamic historyCollectionSubPanelController_;
@dynamic watchLaterCollectionSubPanelController_;

@dynamic isFetchingRelatedPlaylists_;

- ( TauResultCollectionPanelViewController* ) likesCollectionSubPanelController_
    {
    return [ self relatedPlaylistPanelControllerWithPlaylistID_: likesPlaylistID_ ];
    }

- ( TauResultCollectionPanelViewController* ) uploadsCollectionSubPanelController_
    {
    return [ self relatedPlaylistPanelControllerWithPlaylistID_: uploadsPlaylistID_ ];
    }

- ( TauResultCollectionPanelViewController* ) historyCollectionSubPanelController_
    {
    return [ self relatedPlaylistPanelControllerWithPlaylistID_: historyPlaylistID_ ];
    }

- ( TauResultCollectionPanelViewController* ) watchLaterCollectionSubPanelController_
    {
    return [ self relatedPlaylistPanelControllerWithPlaylistID_: watchLaterPlaylistID_ ];
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

                ytChannelMineContentDetails_ = [ ( GTLYouTubeChannel* )( _ChannelListResp.items.firstObject ) contentDetails ];
                GTLYouTubeChannelContentDetailsRelatedPlaylists* relatedPlaylists = ytChannelMineContentDetails_.relatedPlaylists;

                likesPlaylistID_ = relatedPlaylists.likes;
                uploadsPlaylistID_ = relatedPlaylists.uploads;
                historyPlaylistID_ = relatedPlaylists.watchHistory;
                watchLaterPlaylistID_ = relatedPlaylists.watchLater;

                self.subPanelSegSwitcher.enabled = YES;
                self.subPanelSegSwitcher.selectedSegment = TauMeTubeSubPanelSwitcherLikesTag;
                }
            else
                {
                DDLogRecoverable( @"%@", _Error );
                isFetchRelatedPlaylistsSuccess_ = NO;
                ytChannelMineListTicket_ = nil;
                }
            } ];
        }
    }

- ( TauResultCollectionPanelViewController* ) relatedPlaylistPanelControllerWithPlaylistID_: ( NSString* )_PlaylistID
    {
    if ( !( !self.isFetchingRelatedPlaylists_ && _PlaylistID ) )
        return nil;

    BOOL needs = NO;
    TauResultCollectionPanelViewController* resultC = nil;
    TauMeTubeSubPanelSwitcherSegmentTag ivarTag = -1;

    if ( [ _PlaylistID isEqualToString: likesPlaylistID_ ] )
        {
        ivarTag = TauMeTubeSubPanelSwitcherLikesTag;
        needs = ( ( resultC = likesC_ ) == nil );
        }
    else if ( [ _PlaylistID isEqualToString: uploadsPlaylistID_ ] )
        {
        needs = ( ( resultC = uploadsC_ ) == nil );
        ivarTag = TauMeTubeSubPanelSwitcherUploadsTag;
        }
    else if ( [ _PlaylistID isEqualToString: historyPlaylistID_ ] )
        {
        ivarTag = TauMeTubeSubPanelSwitcherHistoryTag;
        needs = ( ( resultC = historyC_ ) == nil );
        }
    else if ( [ _PlaylistID isEqualToString: watchLaterPlaylistID_ ] )
        {
        ivarTag = TauMeTubeSubPanelSwitcherWatchLaterTag;
        needs = ( ( resultC = watchLaterC_ ) == nil );
        }

    if ( needs )
        {
        resultC = [ [ TauResultCollectionPanelViewController alloc ] initWithGTLCollectionObject: nil ticket: nil ];
        [ resultC setHostStack: self.hostStack ];

        GTLQueryYouTube* playlistListItemsQuery = [ GTLQueryYouTube queryForPlaylistItemsListWithPart: @"contentDetails,id,snippet,status" ];
        [ playlistListItemsQuery setPlaylistId: _PlaylistID ];
        [ playlistListItemsQuery setMaxResults: 20 ];

        [ [ TauDataService sharedService ].ytService
            executeQuery: playlistListItemsQuery completionHandler:
        ^( GTLServiceTicket* _Ticket, GTLYouTubePlaylistItemListResponse* _PlaylistItemListResp, NSError* _Error )
            {
            if ( _PlaylistItemListResp && !_Error )
                {
                [ _PlaylistItemListResp setProperty: ytChannelMineContentDetails_ forKey: @"hint" ];

                resultC.ytCollectionObject = _PlaylistItemListResp;
                resultC.ytTicket = _Ticket;
                }
            else
                DDLogRecoverable( @"%@", _Error );
            } ];

        switch ( ivarTag )
            {
            case TauMeTubeSubPanelSwitcherLikesTag:      likesC_ =      resultC; break;
            case TauMeTubeSubPanelSwitcherUploadsTag:    uploadsC_ =    resultC; break;
            case TauMeTubeSubPanelSwitcherHistoryTag:    historyC_ =    resultC; break;
            case TauMeTubeSubPanelSwitcherWatchLaterTag: watchLaterC_ = resultC; break;
            }
        }

    return resultC;
    }

@end // TauMeTubeStackPanelBaseViewController class