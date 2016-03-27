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

// TauTabsAccessoryBarViewController class
@interface TauTabsAccessoryBarViewController : NSTitlebarAccessoryViewController
@end // TauTabsAccessoryBarViewController class



// ------------------------------------------------------------------------------------------------------------ //



// TauExploreContentSubViewController class
@interface TauExploreContentSubViewController : TauAbstractContentSubViewController

@property ( weak ) IBOutlet NSButton* MeTubeRecessedButton;
@property ( weak ) IBOutlet NSButton* subscriptionsRecessedButton;

@property ( weak ) IBOutlet TauTabsAccessoryBarViewController* tabsAccessoryBarViewController_;

- ( IBAction ) tabsSwitchedAction: ( id )_Sender;

@end // TauExploreContentSubViewController class



// ------------------------------------------------------------------------------------------------------------ //



// Private
@interface TauExploreContentViewController ()

/*************** Embedding the split view controller ***************/

@property ( weak ) IBOutlet NSSplitViewController* splitViewController_;

@property ( strong, readonly ) NSSplitViewItem* playlistsOutlineSplitViewItem_;
@property ( strong, readonly ) NSSplitViewItem* collectionViewsPlaygroundSplitViewItem_;

// Wrapped guys below in xib for ease the feed of self.splitViewController_ (instance of NSSplitViewController)
@property ( weak ) IBOutlet NSViewController* wrapperOfPlaylistsOutline_;
@property ( weak ) IBOutlet NSViewController* wrapperOfCollectionViewsPlayground_;

/*************** Embedding the split view controller ***************/



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

    /*************** Embedding the split view controller ***************/

    [ self.splitViewController_ addSplitViewItem: self.playlistsOutlineSplitViewItem_ ];
    [ self.splitViewController_ addSplitViewItem: self.collectionViewsPlaygroundSplitViewItem_ ];

    [ self addChildViewController: self.splitViewController_ ];
    [ self.view addSubview: [ self.splitViewController_.view configureForAutoLayout ] ];
    [ self.splitViewController_.view autoPinEdgesToSuperviewEdges ];

    /*************** Embedding the split view controller ***************/
    }

@synthesize tabs = priTabs_;
- ( NSArray <NSString*>* ) tabs
    {
    if ( !priTabs_ )
        priTabs_ = @[ @"Likes", @"Uploads", @"Watch History", @"Watch Later" ];
    return priTabs_;
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

#pragma mark - Overrides

- ( NSTitlebarAccessoryViewController* ) titlebarAccessoryViewControllerWhileActive
    {
    return self.tabsAccessoryBarViewController_;
    }

- ( IBAction ) tabsSwitchedAction: ( id )_Sender
    {
    if ( _Sender == self.MeTubeRecessedButton )
        {
        self.MeTubeRecessedButton.state = NSOnState;
        self.subscriptionsRecessedButton.state = NSOffState;
        }
    else if ( _Sender == self.subscriptionsRecessedButton )
        {
        self.MeTubeRecessedButton.state = NSOffState;
        self.subscriptionsRecessedButton.state = NSOnState;
        }
    }

@end // TauExploreContentSubViewController class



// ------------------------------------------------------------------------------------------------------------ //



// TauTabsAccessoryBarViewController class
@implementation TauTabsAccessoryBarViewController
@end // TauTabsAccessoryBarViewController class