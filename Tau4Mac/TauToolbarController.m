//
//  TauToolbarController.m
//  Tau4Mac
//
//  Created by Tong G. on 3/18/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauToolbarController.h"
#import "TauToolbarItem.h"

// Private
@interface TauToolbarController ()

@property ( strong, readonly ) NSSegmentedControl* segSwitcher_;
@property ( weak, readonly ) NSWindow* hostingMainWindow_;

@end // Private

NSString* const TauToolbarIdentifier                        = @"home.bedroom.TongKuo.Tau.Toolbar";

NSString* const TauToolbarAdaptiveSpaceItemIdentifier       = @"home.bedroom.TongKuo.Tau.Toolbar.AdaptiveSpaceItem";
NSString* const TauToolbarSwitcherItemIdentifier            = @"home.bedroom.TongKuo.Tau.Toolbar.SwitcherItem";
NSString* const TauToolbarUserProfileButtonItemIdentifier   = @"home.bedroom.TongKuo.Tau.Toolbar.UserProfileButtonItem";

// TauToolbarController class
@implementation TauToolbarController
    {
    NSToolbar __strong* priManagedToolbar_;
    NSSegmentedControl __strong* priSegSwitcher_;

    NSButton __strong* priUserProfilePopUpButton_;
    }

+ ( void ) initialize
    {
    if ( self == [ TauToolbarController class ] )
        [ self exposeBinding: TauKVOStrictKey( contentViewAffiliatedTo ) ];
    }

TauToolbarController static* sShared_;
+ ( instancetype ) sharedController
    {
    return [ [ self alloc ] init ];
    }

- ( instancetype ) init
    {
    if ( !sShared_ )
        if ( self = [ super init ] )
            sShared_ = self;

    return sShared_;
    }

- ( void ) awakeFromNib
    {
    }

@dynamic contentViewAffiliatedTo;
+ ( NSSet <NSString*>* ) keyPathsForValuesAffectingContentViewAffiliatedTo
    {
    return [ NSSet setWithObjects: @"segSwitcher_.cell.selectedSegment", nil ];
    }

- ( void ) setContentViewAffiliatedTo: ( TauContentViewTag )_New
    {
    [ self.segSwitcher_ selectSegmentWithTag: _New ];
    }

- ( TauContentViewTag ) contentViewAffiliatedTo
    {
    return [ self.segSwitcher_ selectedSegment ];
    }

@synthesize appearance = appearance_;
+ ( BOOL ) automaticallyNotifiesObserversOfAppearance
    {
    return NO;
    }

- ( void ) setAppearance: ( NSAppearance* )_New
    {
    if ( appearance_ != _New )
        {
        [ self willChangeValueForKey: @"appearance" ];
        appearance_ = _New;
        self.hostingMainWindow_.appearance = appearance_;
        [ self didChangeValueForKey: @"appearance" ];
        }
    }

- ( NSAppearance* ) appearance
    {
    return appearance_;
    }

@synthesize toolbarItems = toolbarItems_;
+ ( BOOL ) automaticallyNotifiesObserversOfToolbarItems
    {
    return NO;
    }

- ( void ) setToolbarItems: ( NSArray <TauToolbarItem*>* )_New
    {
    if ( toolbarItems_ != _New )
        {
        [ self willChangeValueForKey: @"toolbarItems" ];
        toolbarItems_ = _New;

        if ( !priManagedToolbar_ )
            {
            priManagedToolbar_ = [ [ NSToolbar alloc ] initWithIdentifier: TauToolbarIdentifier ];
            [ priManagedToolbar_ setDelegate: self ];
            [ priManagedToolbar_ setDisplayMode: NSToolbarDisplayModeIconOnly ];
            [ priManagedToolbar_ setAllowsUserCustomization: NO ];
            [ self.hostingMainWindow_ setToolbar: priManagedToolbar_ ];
            }
        else
            {
            // Removing all items
            while ( true )
                {
                if ( priManagedToolbar_.items.count )
                    [ priManagedToolbar_ removeItemAtIndex: 0 ];
                else
                    break;
                }

            // Re-arrange
            for ( int _Index = 0; _Index < toolbarItems_.count; _Index++ )
                [ priManagedToolbar_ insertItemWithItemIdentifier: toolbarItems_[ _Index ].identifier atIndex: _Index ];
            }

        [ self didChangeValueForKey: @"toolbarItems" ];
        }
    }

- ( NSArray <TauToolbarItem*>* ) toolbarItems
    {
    return toolbarItems_;
    }

@synthesize accessoryViewController = accessoryViewController_;
+ ( BOOL ) automaticallyNotifiesObserversOfAccessoryViewController
    {
    return NO;
    }

- ( void ) setAccessoryViewController: ( NSTitlebarAccessoryViewController* )_New
    {
    if ( accessoryViewController_ != _New )
        {
        [ self willChangeValueForKey: @"accessoryViewController" ];
        accessoryViewController_ = _New;

        @try {
        if ( self.hostingMainWindow_.titlebarAccessoryViewControllers.count > 0 )
            [ self.hostingMainWindow_ removeTitlebarAccessoryViewControllerAtIndex: 0 ];

        [ self.hostingMainWindow_ insertTitlebarAccessoryViewController: accessoryViewController_ atIndex: 0 ];
        [ self didChangeValueForKey: @"accessoryViewController" ];
        } @catch ( NSException* _Ex )
            {
            DDLogUnexpected( @"%@", _Ex );
            }
        }
    }

- ( NSTitlebarAccessoryViewController* ) accessoryViewController
    {
    return accessoryViewController_;
    }

#pragma mark - Conforms to <NSToolbarDelegate>

- ( NSArray <NSString*>* ) toolbarAllowedItemIdentifiers: ( NSToolbar* )_Toolbar
    {
    return [ self.toolbarItems cocoaToolbarIdentifiers ];
    }

- ( NSArray <NSString*>* ) toolbarDefaultItemIdentifiers: ( NSToolbar* )_Toolbar
    {
    return [ self.toolbarItems cocoaToolbarIdentifiers ];
    }

- ( NSToolbarItem* )  toolbar: ( NSToolbar* )_Toolbar
        itemForItemIdentifier: ( NSString* )_ItemIdentifier
    willBeInsertedIntoToolbar: ( BOOL )_Flag
    {
    TauToolbarItem* tauToolbarItem = [ toolbarItems_ itemWithIdentifier: _ItemIdentifier ];

    if ( tauToolbarItem )
        {
        if ( [ tauToolbarItem isMemberOfClass: [ TauToolbarSwitcherItem class ] ] )
            tauToolbarItem.view = self.segSwitcher_;
        else if ( [ tauToolbarItem isMemberOfClass: [ TauToolbarUserProfileButtonItemIdentifier class ] ] )
            ; // TODO: tauToolbarItem.view = whatever;

        return tauToolbarItem.cocoaToolbarItemRep;
        }

    return nil;
    }

#pragma mark - Private Interfaces

@dynamic segSwitcher_;
- ( NSSegmentedControl* ) segSwitcher_
    {
    if ( !priSegSwitcher_ )
        {
        NSUInteger segmentCount = 3;
        CGFloat segmentFixedWidth = 34.f;
        priSegSwitcher_ = [ [ NSSegmentedControl alloc ] initWithFrame: NSMakeRect( 0, 0, 108.f, 22.f ) ];

        [ priSegSwitcher_ setSegmentCount: 3 ];
        [ priSegSwitcher_ setTrackingMode: NSSegmentSwitchTrackingSelectOne ];
        [ priSegSwitcher_ setSegmentStyle: NSSegmentStyleTexturedSquare ];

        for ( int _Index = 0; _Index < segmentCount; _Index++ )
            {
            [ priSegSwitcher_ setWidth: segmentFixedWidth forSegment: _Index ];
            [ priSegSwitcher_.cell setTag: ( TauContentViewTag )_Index forSegment: _Index ];

            switch ( _Index )
                {
                case TauSearchContentViewTag:
                    {
                    NSImage* image = [ NSImage imageNamed: @"tau-search-dark" ];
                    [ image setTemplate: YES ];
                    [ image setSize: NSMakeSize( 17.f, 15.f ) ];
                    [ priSegSwitcher_ setImage: image forSegment: _Index ];
                    [ priSegSwitcher_.cell setToolTip: NSLocalizedString( @"Search", nil ) forSegment: _Index ];
                    } break;

                case TauExploreContentViewTag:
                    {
                    NSImage* image = [ NSImage imageNamed: @"tau-explore-dark" ];
                    [ image setTemplate: YES ];
                    [ image setSize: NSMakeSize( 17.f, 17.f ) ];
                    [ priSegSwitcher_ setImage: image forSegment: _Index ];
                    [ priSegSwitcher_.cell setToolTip: NSLocalizedString( @"Search", nil ) forSegment: _Index ];
                    } break;

                case TauPlayerContentViewTag:
                    {
                    NSImage* image = [ NSImage imageNamed: @"tau-player-dark" ];
                    [ image setTemplate: YES ];
                    [ image setSize: NSMakeSize( 17.f, 14.f ) ];
                    [ priSegSwitcher_ setImage: image forSegment: _Index ];
                    [ priSegSwitcher_.cell setToolTip: NSLocalizedString( @"Search", nil ) forSegment: _Index ];
                    } break;
                }
            }
        }

    return priSegSwitcher_;
    }

NSString static* const kMainWindowIdentifier = @"tau-main-window";

@dynamic hostingMainWindow_;
- ( NSWindow* ) hostingMainWindow_
    {
    NSWindow* interestedWindow = nil;
    for ( NSWindow* _Window in NSApp.windows )
        {
        if ( [ _Window.identifier isEqualToString: kMainWindowIdentifier ] )
            {
            interestedWindow = _Window;
            break;
            }
        }

    return interestedWindow;
    }

@end // TauToolbarController class