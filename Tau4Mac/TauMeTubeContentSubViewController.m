//
//  TauMeTubeContentSubViewController.m
//  Tau4Mac
//
//  Created by Tong G. on 3/29/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauMeTubeContentSubViewController.h"
#import "TauMeTubePlayground.h"
#import "TauPlaylistResultsCollectionContentSubViewController.h"

// Private
@interface TauMeTubeContentSubViewController ()

@property ( strong, readwrite ) TauYouTubeChannelsCollection* channels;

@property ( strong, readonly ) NSArray <TauMeTubeTabItem*>* tabs_;
@property ( weak ) IBOutlet NSArrayController* tabsModelController_;

@property ( strong, readonly ) NSViewController* MeTubeController_;

@property ( weak ) IBOutlet NSSplitViewController* splitViewController_;

@property ( strong, readonly ) NSSplitViewItem* playlistsOutlineSplitViewItem_;
@property ( strong, readonly ) NSSplitViewItem* collectionViewsPlaygroundSplitViewItem_;

// Wrapped guys below in xib for ease the feed of self.splitViewController_ (instance of NSSplitViewController)
@property ( weak ) IBOutlet NSViewController* wrapperOfPlaylistsOutline_;
@property ( weak ) IBOutlet NSViewController* wrapperOfMeTubePlayground_;

@property ( weak ) IBOutlet NSTableView* palylistsOutline_;
@property ( weak ) IBOutlet TauMeTubePlayground* MeTubePlayground_;

@end // Private

// TauMeTubeContentSubViewController class
@implementation TauMeTubeContentSubViewController
    {
    TauAPIServiceCredential __strong* channelMineCredential_;
    }

- ( void ) viewDidLoad
    {
    TauMutuallyBind( self.MeTubePlayground_, TauKVOStrictKey( selectedTabs ), self.tabsModelController_, TauKVOStrictKey( selectedObjects ) );

    /*************** Embedding the split view controller ***************/

    [ self.splitViewController_ addSplitViewItem: self.playlistsOutlineSplitViewItem_ ];
    [ self.splitViewController_ addSplitViewItem: self.collectionViewsPlaygroundSplitViewItem_ ];

    [ self addChildViewController: self.splitViewController_ ];
    [ self.view addSubview: [ self.splitViewController_.view configureForAutoLayout ] ];
    [ self.splitViewController_.view autoPinEdgesToSuperviewEdges ];

    /*************** Fetch the required channel info ***************/

    NSDictionary* operations =
        @{ TauTDSOperationMaxResultsPerPage : @1
         , TauTDSOperationRequirements : @{ TauTDSOperationRequirementMine : @"true" }
         , TauTDSOperationPartFilter : @"contentDetails,snippet,statistics,topicDetails"
         };

    id consumer = self;
    channelMineCredential_ = [ [ TauAPIService sharedService ] registerConsumer: consumer withMethodSignature: [ self methodSignatureForSelector: _cmd ] consumptionType: TauAPIServiceConsumptionChannelsType ];
    [ [ TauAPIService sharedService ]
        executeConsumerOperations: operations withCredential: channelMineCredential_ success: nil failure:
    ^( NSError* _Error )
        {
        DDLogRecoverable( @"Failed to fetch \"mine channel\" with error: {%@}", _Error );
        } ];
    }

TauDeallocBegin
    // self.MeTubePlayground_ and self.tabsModelController_ will never be dealloced until the app is terminated,
    // so there is no need to unbind them explicitly.
TauDeallocEnd

#pragma mark - Overrides

// Update the titlebar accessory view controller
+ ( NSSet <NSString*>* ) keyPathsForValuesAffectingTitlebarAccessoryViewControllerWhileActive
    {
    return [ NSSet setWithObjects: @"MeTubePlayground_.titlebarAccessoryViewControllerWhileActive", nil ];
    }

- ( NSTitlebarAccessoryViewController* ) titlebarAccessoryViewControllerWhileActive
    {
    return self.MeTubePlayground_.titlebarAccessoryViewControllerWhileActive;
    }

+ ( NSSet <NSString*>* ) keyPathsForValuesAffectingExposedToolbarItemsWhileActive
    {
    return [ NSSet setWithObjects: @"MeTubePlayground_.exposedToolbarItemsWhileActive", nil ];
    }

- ( NSArray <TauToolbarItem*>* ) exposedToolbarItemsWhileActive
    {
    return [ [ self MeTubePlayground_ ] exposedToolbarItemsWhileActive ];
    }

#pragma mark - Private

@synthesize tabs_ = priTabs_;
+ ( NSSet <NSString*>* ) keyPathsForValuesAffectingTabs_
    {
    return [ NSSet setWithObjects: TauKVOStrictKey( channels ), nil ];
    }

- ( NSArray <TauMeTubeTabItem*>* ) tabs_
    {
    if ( channels_.count > 0 )
        {
        if ( !priTabs_ )
            {
            GTLYouTubeChannelContentDetailsRelatedPlaylists* relatedPlaylists = [ channels_.firstObject valueForKeyPath: @"contentDetails.relatedPlaylists" ];
            priTabs_ =
                @[ [ [ TauMeTubeTabItem alloc ] initWithTitle: NSLocalizedString( @"Likes", @"\"Likes\" tab in MeTube outline view" ) playlistName: @"Liked Videos" playlistIdentifier: relatedPlaylists.likes viewController: [ [ TauPlaylistResultsCollectionContentSubViewController alloc ] initWithNibName: nil bundle: nil ] ]
                 , [ [ TauMeTubeTabItem alloc ] initWithTitle: NSLocalizedString( @"Uploads", @"\"Uploads\" tab in MeTube outline view" ) playlistName: @"Uploads" playlistIdentifier: relatedPlaylists.uploads viewController: [ [ TauPlaylistResultsCollectionContentSubViewController alloc ] initWithNibName: nil bundle: nil ] ]
                 , [ [ TauMeTubeTabItem alloc ] initWithTitle: NSLocalizedString( @"Watch History", @"\"Watch History\" tab in MeTube outline view" ) playlistName: @"Watch History" playlistIdentifier: relatedPlaylists.watchHistory viewController: [ [ TauPlaylistResultsCollectionContentSubViewController alloc ] initWithNibName: nil bundle: nil ] ]
                 , [ [ TauMeTubeTabItem alloc ] initWithTitle: NSLocalizedString( @"Watch Later", @"\"Watch Later\" tab in MeTube outline view" ) playlistName: @"Watch Later" playlistIdentifier: relatedPlaylists.watchLater viewController: [ [ TauPlaylistResultsCollectionContentSubViewController alloc ] initWithNibName: nil bundle: nil ] ]
                 ];
             }

        return priTabs_;
        }
    else
        return ( priTabs_ = nil );
    }

- ( NSUInteger ) countOfTabs_
    {
    return priTabs_.count;
    }

- ( NSArray <TauMeTubeTabItem*>* ) tabs_AtIndexes: ( NSIndexSet* )_Indexes
    {
    return [ priTabs_ objectsAtIndexes: _Indexes ];
    }

- ( void ) getTabs_: ( TauMeTubeTabItem* __unsafe_unretained* )_Buffer range: ( NSRange )_InRange
    {
    [ priTabs_ getObjects: _Buffer range: _InRange ];
    }

@synthesize channels = channels_;

@synthesize playlistsOutlineSplitViewItem_ = priPlaylistsOutlineSplitViewItem_;
- ( NSSplitViewItem* ) playlistsOutlineSplitViewItem_
    {
    if ( !priPlaylistsOutlineSplitViewItem_ )
        {
        priPlaylistsOutlineSplitViewItem_ = [ NSSplitViewItem sidebarWithViewController: self.wrapperOfPlaylistsOutline_ ];
        [ priPlaylistsOutlineSplitViewItem_ setCanCollapse: YES ];
        }

    return priPlaylistsOutlineSplitViewItem_;
    }

@synthesize collectionViewsPlaygroundSplitViewItem_ = priCollectionViewsPlaygroundSplitViewItem_;
- ( NSSplitViewItem* ) collectionViewsPlaygroundSplitViewItem_
    {
    if ( !priCollectionViewsPlaygroundSplitViewItem_ )
        {
        priCollectionViewsPlaygroundSplitViewItem_ = [ NSSplitViewItem splitViewItemWithViewController: self.wrapperOfMeTubePlayground_ ];
        [ priCollectionViewsPlaygroundSplitViewItem_ setCanCollapse: NO ];
        }

    return priCollectionViewsPlaygroundSplitViewItem_;
    }

@end // TauMeTubeContentSubViewController class