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

@property ( assign, readwrite ) TauExploreSubTabTag activedExploreTabViewTag;  // KVB compliant
@property ( strong, readonly ) NSViewController* activedExploreTabViewController;  // KVB compliant

@property ( weak ) IBOutlet NSButton* MeTubeRecessedButton;
@property ( weak ) IBOutlet NSButton* subscriptionsRecessedButton;

#pragma mark - Actions

- ( IBAction ) tabsSwitchedAction: ( id )_Sender;

@end // TauExploreContentSubViewController class



// ------------------------------------------------------------------------------------------------------------ //



// Private
@interface TauExploreContentViewController ()
@property ( weak ) IBOutlet TauExploreContentSubViewController* initialExploreContentSubViewController_;
@end // Private

// TauExploreContentViewController class
@implementation TauExploreContentViewController

#pragma mark - Initializations

- ( void ) viewDidLoad
    {
    [ super viewDidLoad ];
    [ self.viewsStack setBackgroundViewController: self.initialExploreContentSubViewController_ ];
    }

@end // TauExploreContentViewController class



// ------------------------------------------------------------------------------------------------------------ //



// Private
@interface TauExploreContentSubViewController ()

@property ( strong, readonly ) NSArray <NSString*>* tabs_;
@property ( weak ) IBOutlet TauTabsAccessoryBarViewController* tabsAccessoryBarViewController_;

/****************************** MeTube ******************************/

@property ( strong, readonly ) NSViewController* MeTubeController_;

@property ( weak ) IBOutlet NSSplitViewController* splitViewController_;

@property ( strong, readonly ) NSSplitViewItem* playlistsOutlineSplitViewItem_;
@property ( strong, readonly ) NSSplitViewItem* collectionViewsPlaygroundSplitViewItem_;

// Wrapped guys below in xib for ease the feed of self.splitViewController_ (instance of NSSplitViewController)
@property ( weak ) IBOutlet NSViewController* wrapperOfPlaylistsOutline_;
@property ( weak ) IBOutlet NSViewController* wrapperOfCollectionViewsPlayground_;

/****************************** Subscription ******************************/

@property ( strong, readonly ) NSViewController* subscriptionsController_;

@end // Private

// TauExploreContentSubViewController class
@implementation TauExploreContentSubViewController
    {
    NSArray <NSLayoutConstraint*>* activedPinEdgesCache_;
    }

- ( void ) viewDidLoad
    {
    [ self setActivedExploreTabViewTag: TauExploreSubTabMeTubeTag ];
    }

#pragma mark - Overrides

- ( NSTitlebarAccessoryViewController* ) titlebarAccessoryViewControllerWhileActive
    {
    return self.tabsAccessoryBarViewController_;
    }

#pragma mark - External KVB Compliant Properties

@synthesize activedExploreTabViewTag = priActivedExploreTabViewTag_;
- ( void ) setActivedExploreTabViewTag: ( TauExploreSubTabTag )_New
    {
    if ( priActivedExploreTabViewTag_ != _New )
        {
        [ self willChangeValueForKey: TAU_KEY_OF_SEL( @selector( activedExploreTabViewTag ) ) ];

        NSViewController* oldActived = self.activedExploreTabViewController;

        if ( oldActived )
            {
            [ oldActived removeFromParentViewController ];
            [ oldActived.view removeFromSuperview ];

            if ( activedPinEdgesCache_ )
                {
                [ self.view removeConstraints: activedPinEdgesCache_ ];
                activedPinEdgesCache_ = nil;
                }
            }

        priActivedExploreTabViewTag_ = _New;

        [ self didChangeValueForKey: TAU_KEY_OF_SEL( @selector( activedExploreTabViewTag ) ) ];

        // Value of self.activedContentViewController is derived from activedContentViewTag_ var.
        // We just assigned a new value to activedContentViewTag_,
        // so invocation of self.activedContentViewController results in a new value.
        NSViewController* newActived = self.activedExploreTabViewController;
        if ( newActived )
            {
            [ self addChildViewController: newActived ];
            [ self.view addSubview: newActived.view ];
            activedPinEdgesCache_ = [ newActived.view autoPinEdgesToSuperviewEdges ];
            }
        else
            DDLogUnexpected( @"Unexpected new value: {%@}.", newActived );
        }
    }

- ( TauExploreSubTabTag ) activedExploreTabViewTag
    {
    return priActivedExploreTabViewTag_;
    }

@dynamic activedExploreTabViewController;
+ ( NSSet <NSString*>* ) keyPathsForValuesAffectingActivedExploreTabViewController
    {
    return [ NSSet setWithObjects: TAU_KEY_OF_SEL( @selector( activedExploreTabViewTag ) ), nil ];
    }

- ( NSViewController* ) activedExploreTabViewController
    {
    NSViewController* actived = nil;
    switch ( priActivedExploreTabViewTag_ )
        {
        case TauExploreSubTabMeTubeTag: actived = self.MeTubeController_;   break;
        case TauExploreSubTabSubscriptionsTag: actived = self.subscriptionsController_;   break;

        case TauExploreSubTabUnknownTag: DDLogNotice( @"Explore sub tab tag is unknown" );  break;
        }

    return actived;
    }

#pragma mark - Actions

- ( IBAction ) tabsSwitchedAction: ( id )_Sender
    {
    if ( _Sender == self.MeTubeRecessedButton )
        {
        self.MeTubeRecessedButton.state = NSOnState;
        self.subscriptionsRecessedButton.state = NSOffState;
        [ self setActivedExploreTabViewTag: TauExploreSubTabMeTubeTag ];
        }
    else if ( _Sender == self.subscriptionsRecessedButton )
        {
        self.MeTubeRecessedButton.state = NSOffState;
        self.subscriptionsRecessedButton.state = NSOnState;
        [ self setActivedExploreTabViewTag: TauExploreSubTabSubscriptionsTag ];
        }
    }

#pragma mark - Private

@synthesize tabs_ = priTabs_;
- ( NSArray <NSString*>* ) tabs
    {
    if ( !priTabs_ )
        priTabs_ = @[ @"Likes", @"Uploads", @"Watch History", @"Watch Later" ];
    return priTabs_;
    }

@synthesize MeTubeController_ = priMeTubeController_;
- ( NSViewController* ) MeTubeController_
    {
    if ( !priMeTubeController_ )
        {
        priMeTubeController_ = [ [ NSViewController alloc ] initWithNibName: nil bundle: nil ];

        NSView* priMeTubeView = [ [ NSView alloc ] initWithFrame: NSZeroRect ];
        [ priMeTubeView setWantsLayer: YES ];
        [ priMeTubeController_ setView: [ priMeTubeView configureForAutoLayout ] ];

        /*************** Embedding the split view controller ***************/

        [ self.splitViewController_ addSplitViewItem: self.playlistsOutlineSplitViewItem_ ];
        [ self.splitViewController_ addSplitViewItem: self.collectionViewsPlaygroundSplitViewItem_ ];

        [ priMeTubeController_ addChildViewController: self.splitViewController_ ];
        [ priMeTubeController_.view addSubview: [ self.splitViewController_.view configureForAutoLayout ] ];
        [ self.splitViewController_.view autoPinEdgesToSuperviewEdges ];

        /*************** Embedding the split view controller ***************/
        }

    return priMeTubeController_;
    }

@synthesize subscriptionsController_ = priSubscriptionsController_;
- ( NSViewController* ) subscriptionsController_
    {
    if ( !priSubscriptionsController_ )
        {
        priSubscriptionsController_ = [ [ NSViewController alloc ] initWithNibName: nil bundle: nil ];

        NSView* priSubscView = [ [ NSView alloc ] initWithFrame: NSZeroRect ];
        [ priSubscView setWantsLayer: YES ];
        [ priSubscriptionsController_ setView: [ priSubscView configureForAutoLayout ] ];
        }

    return priSubscriptionsController_;
    }


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

@end // TauExploreContentSubViewController class



// ------------------------------------------------------------------------------------------------------------ //



// TauTabsAccessoryBarViewController class
@implementation TauTabsAccessoryBarViewController
@end // TauTabsAccessoryBarViewController class