//
//  TauExploreContentViewController.m
//  Tau4Mac
//
//  Created by Tong G. on 3/17/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauExploreContentViewController.h"
#import "TauViewsStack.h"
#import "TauAbstractContentSubViewController.h"
#import "TauToolbarController.h"
#import "TauToolbarItem.h"

// TauExploreContentSubViewController class
@interface TauExploreContentSubViewController : TauAbstractContentSubViewController
@end // TauExploreContentSubViewController class



// ------------------------------------------------------------------------------------------------------------ //



// Private
@interface TauExploreContentViewController ()

/********************* Embedding the split view controller *********************/

@property ( weak ) IBOutlet NSSplitViewController* splitViewController_;

@property ( strong, readonly ) NSSplitViewItem* playlistsOutlineSplitViewItem_;
@property ( strong, readonly ) NSSplitViewItem* collectionViewsPlaygroundSplitViewItem_;

// Wrapped guys below in xib for ease the feed of self.splitViewController_ (instance of NSSplitViewController)
@property ( weak ) IBOutlet NSViewController* wrapperOfPlaylistsOutline_;
@property ( weak ) IBOutlet NSViewController* wrapperOfCollectionViewsPlayground_;

/********************* Embedding the split view controller *********************/

@property ( weak ) IBOutlet TauExploreContentSubViewController* initialExploreContentSubViewController_;

@end // Private



// ------------------------------------------------------------------------------------------------------------ //



// TauExploreContentViewController class
@implementation TauExploreContentViewController

#pragma mark - Initializations

- ( void ) viewDidLoad
    {
    [ super viewDidLoad ];
    [ self.viewsStack setBackgroundViewController: self.initialExploreContentSubViewController_ ];

    /********************* Embedding the split view controller *********************/

    [ self.splitViewController_ addSplitViewItem: self.playlistsOutlineSplitViewItem_ ];
    [ self.splitViewController_ addSplitViewItem: self.collectionViewsPlaygroundSplitViewItem_ ];

    [ self addChildViewController: self.splitViewController_ ];
    [ self.view addSubview: [ self.splitViewController_.view configureForAutoLayout ] ];
    [ self.splitViewController_.view autoPinEdgesToSuperviewEdges ];

    /********************* Embedding the split view controller *********************/
    }

#pragma mark - Private

@synthesize playlistsOutlineSplitViewItem_ = priPlaylistsOutlineSplitViewItem_;
- ( NSSplitViewItem* ) playlistsOutlineSplitViewItem_
    {
    if ( !priPlaylistsOutlineSplitViewItem_ )
        {
        priPlaylistsOutlineSplitViewItem_ = [ NSSplitViewItem sidebarWithViewController: self.wrapperOfPlaylistsOutline_ ];
        [ priPlaylistsOutlineSplitViewItem_ setCanCollapse: NO ];
        }

    return priPlaylistsOutlineSplitViewItem_;
    }

@synthesize collectionViewsPlaygroundSplitViewItem_ = priCollectionViewsPlaygroundSplitViewItem_;
- ( NSSplitViewItem* ) collectionViewsPlaygroundSplitViewItem_
    {
    if ( !priCollectionViewsPlaygroundSplitViewItem_ )
        {
        priCollectionViewsPlaygroundSplitViewItem_ = [ NSSplitViewItem splitViewItemWithViewController: self.wrapperOfCollectionViewsPlayground_ ];
        [ priCollectionViewsPlaygroundSplitViewItem_ setCanCollapse: NO ];
        }

    return priCollectionViewsPlaygroundSplitViewItem_;
    }

@end // TauExploreContentViewController class



// ------------------------------------------------------------------------------------------------------------ //



// TauExploreContentSubViewController class
@implementation TauExploreContentSubViewController
@end // TauExploreContentSubViewController class