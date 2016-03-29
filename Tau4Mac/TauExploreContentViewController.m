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
#import "TauExploreTabControl.h"
#import "TauMeTubePlayground.h"
#import "TauPlaylistResultsCollectionContentSubViewController.h"

// TauExploreContentSubViewController class
@interface TauExploreContentSubViewController : TauAbstractContentSubViewController

@property ( assign, readwrite ) TauExploreSubTabTag activedExploreTabViewTag;  // KVB compliant
@property ( strong, readonly ) NSViewController* activedExploreTabViewController;  // KVB compliant

@property ( weak ) IBOutlet TauExploreTabControl* exploreTabControl;

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

//@property ( strong, readwrite ) NSArray <GTLYouTubeChannel*>* channels;
@property ( strong, readwrite ) TauYouTubeChannelsCollection* channels;

@property ( strong, readonly ) NSArray <TauMeTubeTabItem*>* tabs_;
@property ( weak ) IBOutlet NSArrayController* tabsModelController_;

/****************************** MeTube ******************************/

@property ( strong, readonly ) NSViewController* MeTubeController_;

@property ( weak ) IBOutlet NSSplitViewController* splitViewController_;

@property ( strong, readonly ) NSSplitViewItem* playlistsOutlineSplitViewItem_;
@property ( strong, readonly ) NSSplitViewItem* collectionViewsPlaygroundSplitViewItem_;

// Wrapped guys below in xib for ease the feed of self.splitViewController_ (instance of NSSplitViewController)
@property ( weak ) IBOutlet NSViewController* wrapperOfPlaylistsOutline_;
@property ( weak ) IBOutlet NSViewController* wrapperOfMeTubePlayground_;

@property ( weak ) IBOutlet NSTableView* palylistsOutline_;
@property ( weak ) IBOutlet TauMeTubePlayground* MeTubePlayground_;

/****************************** Subscription ******************************/

@property ( strong, readonly ) NSViewController* subscriptionsController_;

@end // Private

// TauExploreContentSubViewController class
@implementation TauExploreContentSubViewController
    {
    TauYTDataServiceCredential __strong* channelMineCredential_;

    // Constraints caches
    NSArray <NSLayoutConstraint*>* activedPinEdgesCache_;
    }

#pragma mark - Initializations

- ( instancetype ) initWithCoder: ( NSCoder* )_Coder
    {
    if ( self = [ super initWithCoder: _Coder ] )
        priActivedExploreTabViewTag_ = TauExploreSubTabUnknownTag;
    return self;
    }

- ( void ) viewDidLoad
    {
    /************* Mutual Bindings between self and self.exploreTabControl *************/

    id lhsObject = nil; lhsObject = self;
    id rhsObject = nil; rhsObject = self.exploreTabControl;

    NSString* lhsKey = nil; lhsKey = TauKeyOfSel( @selector( activedExploreTabViewTag ) );
    NSString* rhsKey = nil; rhsKey = TauKeyOfSel( @selector( activedTabTag ) );

    [ lhsObject bind: lhsKey toObject: rhsObject withKeyPath: rhsKey options: nil ];
    [ rhsObject bind: rhsKey toObject: lhsObject withKeyPath: lhsKey options: nil ];

    /** Mutual Bindings between self.MeTubePlayground_ and self.tabsModelController_ **/

    lhsObject = self.MeTubePlayground_; lhsKey = TauKeyOfSel( @selector( selectedTabs ) );
    rhsObject = self.tabsModelController_; rhsKey = TauKeyOfSel( @selector( selectedObjects ) );

    [ lhsObject bind: lhsKey toObject: rhsObject withKeyPath: rhsKey options: nil ];
    [ rhsObject bind: rhsKey toObject: lhsObject withKeyPath: lhsKey options: nil ];

    /***/

    [ self setActivedExploreTabViewTag: TauExploreSubTabMeTubeTag ];
    }

TauDeallocBegin
    // Instances of TauExploreContentSubViewController and TauExploreTabControl will never be dealloced until the app is terminated,
    // so there is no need to unbind them explicitly.
TauDeallocEnd

#pragma mark - Overrides

// Update the titlebar accessory view controller through the relay of self.MeTubePlayground

+ ( NSSet <NSString*>* ) keyPathsForValuesAffectingTitlebarAccessoryViewControllerWhileActive
    {
    return [ NSSet setWithObjects: @"MeTubePlayground_.titlebarAccessoryViewControllerWhileActive", nil ];
    }

- ( NSTitlebarAccessoryViewController* ) titlebarAccessoryViewControllerWhileActive
    {
    return self.MeTubePlayground_.titlebarAccessoryViewControllerWhileActive;
    }

- ( NSArray <TauToolbarItem*>* ) exposedToolbarItemsWhileActive
    {
    return @[ [ TauToolbarItem switcherItem ]
            , [ TauToolbarItem adaptiveSpaceItem ]
            , [ [ TauToolbarItem alloc ] initWithIdentifier: nil label: nil view: self.exploreTabControl ]
            , [ TauToolbarItem flexibleSpaceItem ]
            ];
    }

#pragma mark - External KVB Compliant Properties

@synthesize activedExploreTabViewTag = priActivedExploreTabViewTag_;
+ ( BOOL ) automaticallyNotifiesObserversOfActivedExploreTabViewTag
    {
    return NO;
    }

- ( void ) setActivedExploreTabViewTag: ( TauExploreSubTabTag )_New
    {
    if ( priActivedExploreTabViewTag_ != _New )
        {
        TAU_CHANGE_VALUE_FOR_KEY( activedExploreTabViewTag,
         ( ^{
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
            } ) );

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
    return [ NSSet setWithObjects: TauKeyOfSel( @selector( activedExploreTabViewTag ) ), nil ];
    }

- ( NSViewController* ) activedExploreTabViewController
    {
    NSViewController* actived = nil;
    switch ( priActivedExploreTabViewTag_ )
        {
        case TauExploreSubTabMeTubeTag: actived = self.MeTubeController_; break;
        case TauExploreSubTabSubscriptionsTag: actived = self.subscriptionsController_; break;
        case TauExploreSubTabUnknownTag: DDLogNotice( @"Explore sub tab tag is unknown" ); break;
        }

    return actived;
    }

#pragma mark - Private

@synthesize channels = channels_;

@synthesize tabs_ = priTabs_;
+ ( NSSet <NSString*>* ) keyPathsForValuesAffectingTabs_
    {
    return [ NSSet setWithObjects: TauKeyOfSel( @selector( channels ) ), nil ];
    }

- ( NSArray <TauMeTubeTabItem*>* ) tabs_
    {
    if ( channels_.channels.count > 0 )
        {
        if ( !priTabs_ )
            {
            GTLYouTubeChannelContentDetailsRelatedPlaylists* relatedPlaylists = [ channels_.channels.firstObject valueForKeyPath: @"contentDetails.relatedPlaylists" ];
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

        NSDictionary* operations =
            @{ TauTDSOperationMaxResultsPerPage : @1
             , TauTDSOperationRequirements : @{ TauTDSOperationRequirementMine : @"true" }
             , TauTDSOperationPartFilter : @"contentDetails,snippet,statistics,topicDetails"
             };

        id consumer = self;

        channelMineCredential_ = [ [ TauYTDataService sharedService ] registerConsumer: consumer withMethodSignature: [ self methodSignatureForSelector: _cmd ] consumptionType: TauYTDataServiceConsumptionChannelsType ];
        [ [ TauYTDataService sharedService ] executeConsumerOperations: operations
                                                        withCredential: channelMineCredential_
                                                               success: nil
        failure: ^( NSError* _Error )
            {
            DDLogRecoverable( @"Failed to fetch \"mine channel\" due to {%@}", _Error );
            } ];
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
        priCollectionViewsPlaygroundSplitViewItem_ = [ NSSplitViewItem splitViewItemWithViewController: self.wrapperOfMeTubePlayground_ ];
        [ priCollectionViewsPlaygroundSplitViewItem_ setCanCollapse: NO ];
        }

    return priCollectionViewsPlaygroundSplitViewItem_;
    }

@end // TauExploreContentSubViewController class