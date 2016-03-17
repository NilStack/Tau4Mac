//
//  TauResultCollectionPanelViewController.m
//  Tau4Mac
//
//  Created by Tong G. on 3/5/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauResultCollectionPanelViewController.h"
#import "TauEntriesCollectionViewController.h.h"
#import "TauAbstractStackPanelController.h"
#import "TauPlayerStackPanelBaseViewController.h"
#import "TauYouTubeEntryView.h"

// Private Interfaces
@interface TauResultCollectionPanelViewController ()
@property ( strong, readonly ) TauPlayerStackPanelBaseViewController* playerViewController_;
@end // Private Interfaces

// TauResultCollectionPanelViewController class
@implementation TauResultCollectionPanelViewController
    {
    TauEntriesCollectionViewController __strong* entriesCollectionViewController_;
    
    GTLCollectionObject __strong* ytCollectionObject_;
    GTLServiceTicket __strong* ytTicket_;

    TauPlayerStackPanelBaseViewController __strong* playerViewController_;
    }

#pragma mark - Initializations

- ( instancetype ) initWithGTLCollectionObject: ( GTLCollectionObject* )_CollectionObject
                                        ticket: ( GTLServiceTicket* )_Ticket
    {
    if ( self = [ super initWithNibName: nil bundle: nil ] )
        {
        ytCollectionObject_ = _CollectionObject;
        ytTicket_ = _Ticket;

        entriesCollectionViewController_ =
            [ [ TauEntriesCollectionViewController alloc ] initWithGTLCollectionObject: ytCollectionObject_ ticket: _Ticket ];
        }

    return self;
    }

- ( void ) viewDidLoad
    {
    [ self.view configureForAutoLayout ];

    [ self addChildViewController: entriesCollectionViewController_ ];
    [ self.view addSubview: entriesCollectionViewController_.view ];
    [ entriesCollectionViewController_.view autoPinEdgesToSuperviewEdges ];
    }

#pragma mark - IBAction

- ( IBAction ) pageAction: ( NSSegmentedControl* )_Sender
    {
    id pageToken = nil;
    SEL pageSelector = nil;

    switch ( _Sender.selectedSegment )
        {
        case TAU_PAGEER_PREV:
            {
            pageSelector = @selector( prevPageToken );
            } break;

        case TAU_PAGEER_NEXT:
            {
            pageSelector = @selector( nextPageToken );
            } break;
        }

    @try {
        if ( [ ytCollectionObject_ respondsToSelector: pageSelector ] )
            {
TAU_SUPPRESS_PERFORM_SELECTOR_LEAK_WARNING_BEGIN
            pageToken = [ ytCollectionObject_ performSelector: pageSelector ];
TAU_SUPPRESS_PERFORM_SELECTOR_LEAK_WARNING_COMMIT
            }

        if ( pageToken )
            {
            GTLQueryYouTube* newQuery = ytTicket_.originalQuery;
            newQuery.pageToken = pageToken;

            ytTicket_ = [ [ TauDataService sharedService ].ytService
                executeQuery: newQuery completionHandler:
            ^( GTLServiceTicket* _Ticket, GTLCollectionObject* _CollectionObject, NSError* _Error )
                {
                if ( _CollectionObject && !_Error )
                    {
                    ytCollectionObject_ = _CollectionObject;
                    ytTicket_ = _Ticket;

                    entriesCollectionViewController_.ytCollectionObject = ytCollectionObject_;
                    entriesCollectionViewController_.ytTicket = ytTicket_;
                    }
                else
                    DDLogRecoverable( @"%@", _Error );
                } ];
            }
        } @catch ( NSException* _Ex )
            {
            DDLogWarn( @"%@", _Ex );
            };
    }

- ( void ) whateverWithYouTubePlaylistID_: ( NSString* )_ytPlistID hint: ( GTLYouTubeChannelContentDetails* )_Hint
    {
    if ( !_ytPlistID )
        {
        DDLogUnexpected( @"YouTube play list ID must be not nil" );
        return;
        }

    // youtube.playlistItems.list
    GTLQueryYouTube* ytPlistItemsListQuery = [ GTLQueryYouTube queryForPlaylistItemsListWithPart: @"contentDetails,id,snippet,status" ];
    [ ytPlistItemsListQuery setPlaylistId: _ytPlistID ];
    [ ytPlistItemsListQuery setMaxResults: 20 ];

    [ [ TauDataService sharedService ].ytService
        executeQuery: ytPlistItemsListQuery completionHandler:
    ^( GTLServiceTicket* _Ticket, GTLYouTubePlaylistItemListResponse* _PlistItemsResp, NSError* _Error )
        {
        if ( _PlistItemsResp && !_Error )
            {
            [ _PlistItemsResp setProperty: _Hint forKey: @"hint" ];
            TauResultCollectionPanelViewController* c = [ [ TauResultCollectionPanelViewController alloc ] initWithGTLCollectionObject: _PlistItemsResp ticket: _Ticket ];
            c.hostStack = self.hostStack;

            [ self.hostStack pushView: c ];
            }
        } ];
    }

- ( IBAction ) ytEntryViewUserInteraction: ( TauYouTubeEntryView* )_Sender
    {
    if ( !_Sender )
        {
        DDLogRecoverable( @"%@ must not be nil", _Sender);
        return;
        }

    switch ( _Sender.type )
        {
        case TauYouTubeVideoView:
        case TauYouTubePlayListItemView:
            {
            NSNotification* shouldSwitchToPlayerSegNotif = [ NSNotification notificationWithName: TauShouldSwitch2PlayerSegmentNotif object: self userInfo: @{ kRequester : _Sender } ];
            [ [ NSNotificationCenter defaultCenter ] postNotification: shouldSwitchToPlayerSegNotif ];
            } break;

        case TauYouTubeChannelView:
        case TauYouTubePlayListView:
            {
            Class expectedClass = [ GTLYouTubeSearchResult class ];
            if ( ![ _Sender.ytContent isKindOfClass: expectedClass ] )
                {
                DDLogUnexpected( @"Sender's ytContent property must be kind of %@", NSStringFromClass( expectedClass ) );
                break;
                }

            GTLYouTubeSearchResult* ytSearchRes = ( GTLYouTubeSearchResult* )( _Sender.ytContent );
            GTLYouTubeResourceId* identifier = ytSearchRes.identifier;
            NSString* kind = identifier.kind;
            if ( [ kind isEqualToString: @"youtube#playlist" ] )
                {
                [ self whateverWithYouTubePlaylistID_: identifier.JSON[ @"playlistId" ] hint: nil ];
                return;
                }

            NSString* channelID = ytSearchRes.identifier.JSON[ @"channelId" ];
            if ( channelID )
                {
                // youtube.channel.list
                GTLQueryYouTube* ytChannelListQuery = [ GTLQueryYouTube queryForChannelsListWithPart: @"snippet,contentDetails" ];
                [ ytChannelListQuery setIdentifier: channelID ];
                [ ytChannelListQuery setMaxResults: 1 ];

                [ [ TauDataService sharedService ].ytService
                    executeQuery: ytChannelListQuery completionHandler:
                ^( GTLServiceTicket* _Ticket, GTLYouTubeChannelListResponse* _ChannelListResp, NSError* _Error )
                    {
                    if ( _ChannelListResp && !_Error )
                        {
                        GTLYouTubeChannel* channel = _ChannelListResp.items.firstObject;
                        GTLYouTubeChannelContentDetails* channelContentDetails = channel.contentDetails;
                        NSString* uploadsPlaylistID = channelContentDetails.relatedPlaylists.uploads;
                        [ self whateverWithYouTubePlaylistID_: uploadsPlaylistID hint: channelContentDetails ];
                        }
                    else
                        DDLogRecoverable( @"Failed to execute %@ due to: <%@>", _Ticket.originalQuery, _Error );
                    } ];
                }
            } break;

        case TauYouTubeUnknownView:
            {
            DDLogRecoverable( @"Unkown View" );
            } break;
        }
    }

- ( IBAction ) dismissAction: ( id )_Sender
    {
    [ self.hostStack popView ];
    }

#pragma mark - Dynamic Properties

@dynamic ytCollectionObject;
@dynamic ytTicket;

- ( void ) setYtCollectionObject: ( GTLCollectionObject* )_CollectionObject
    {
    if ( ytCollectionObject_ != _CollectionObject )
        {
        ytCollectionObject_ = _CollectionObject;
        [ self.ytTicket cancelTicket ];
        self.ytTicket = nil;
        entriesCollectionViewController_.ytCollectionObject = ytCollectionObject_;
        }
    }

- ( GTLCollectionObject* ) ytCollectionObject
    {
    return ytCollectionObject_;
    }

- ( void ) setYtTicket: ( GTLServiceTicket* )_Ticket
    {
    if ( ytTicket_ != _Ticket )
        {
        ytTicket_ = _Ticket;
        entriesCollectionViewController_.ytTicket = ytTicket_;
        }
    }

- ( GTLServiceTicket* ) ytTicket
    {
    return ytTicket_;
    }

#pragma mark - Private Interfaces

@dynamic playerViewController_;

- ( TauPlayerStackPanelBaseViewController* ) playerViewController_
    {
    if ( !playerViewController_ )
        {
        playerViewController_ = [ [ TauPlayerStackPanelBaseViewController alloc ] initWithNibName: nil bundle: nil ];
        playerViewController_.hostStack = self.hostStack;
        }

    return playerViewController_;
    }

@end // TauResultCollectionPanelViewController class