//
//  TauMainWindowController.m
//  Tau4Mac
//
//  Created by Tong G. on 3/3/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauMainWindowController.h"
#import "TauYouTubeEntryView.h"
#import "TauYTDataService.h"

#import "GTL/GTMOAuth2WindowController.h"

#import "TauTTYLogFormatter.h"

// Private Interfaces
@interface TauMainWindowController ()

@property ( strong, readonly ) GTMOAuth2WindowController* authWindow_;

@property ( strong, readonly ) NSSegmentedControl* segSwitcher_;

// Signning In
- ( void ) runSignInThenHandler_: ( void (^)( void ) )_Handler;

@end // Private Interfaces

NSString* const TauShouldSwitch2SearchSegmentNotif = @"Should.Switch2SearchSegment.Notif";
NSString* const TauShouldSwitch2MeTubeSegmentNotif = @"Should.Switch2MeTubeSegment.Notif";
NSString* const TauShouldSwitch2PlayerSegmentNotif = @"Should.Switch2PlayerSegment.Notif";

NSString* const TauShouldPlayVideoNotif = @"Should.PlayVideo.Notif";

NSString* const kRequester = @"kRequester";

@implementation TauMainWindowController
    {
    NSSegmentedControl __strong* priSegSwitcher_;

    NSButton __strong* priUserProfilePopUpButton_;
    NSPopover __strong* priUserProfilePopover_;

    FBKVOController __strong* kvoController_;
    }

#pragma mark - Initializations

- ( instancetype ) initWithCoder: ( NSCoder* )_Coder
    {
    if ( self = [ super initWithCoder: _Coder] )
        ;

    return self;
    }

- ( void ) windowDidLoad
    {
    [ super windowDidLoad ];

    [ self.toolbar setAllowsUserCustomization: NO ];

    [ NSApp setDelegate: self ];

    kvoController_ = [ [ FBKVOController alloc ] initWithObserver: self.contentViewController ];

TAU_SUPPRESS_UNDECLARED_SELECTOR_WARNING_BEGIN
    [ kvoController_ observe: self.segSwitcher_
                     keyPath: @"cell.selectedSegment"
                     options: NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                      action: @selector( selectedSegmentDidChange:observing: /* This selector was declared and implemented in TauMainWindowController class */ ) ];
TAU_SUPPRESS_UNDECLARED_SELECTOR_WARNING_COMMIT

    [ self.segSwitcher_ selectSegmentWithTag: TauPanelsSwitcherSearchTag ];

    [ [ NSNotificationCenter defaultCenter ]
        addObserver: self selector: @selector( shouldSwitch2PlayerSegment_: ) name: TauShouldSwitch2PlayerSegmentNotif object: nil ];
    }

- ( void ) shouldSwitch2PlayerSegment_: ( NSNotification* )_Notif
    {
    [ self.segSwitcher_ selectSegmentWithTag: TauPanelsSwitcherPlayerTag ];

    TauYouTubeEntryView* requester = _Notif.userInfo[ kRequester ];

    NSNotification* shouldPlayVideoNotif = [ NSNotification notificationWithName: TauShouldPlayVideoNotif object: self userInfo: @{ kGTLObject : requester.ytContent } ];
    [ [ NSNotificationCenter defaultCenter ] postNotification: shouldPlayVideoNotif ];
    }

#pragma mark - Conforms to <NSApplicationDelegate>

- ( void ) applicationDidFinishLaunching: ( NSNotification* )_Notif
    {
    if ( ![ [ TauYTDataService sharedService ] isSignedIn ] )
        [ self runSignInThenHandler_: nil ];
    }

- ( BOOL ) applicationShouldHandleReopen: ( NSApplication* )_Sender
                       hasVisibleWindows: ( BOOL )_Flag
    {
    if ( _Flag )
        [ self.window orderFront: self ];
    else
        [ self.window makeKeyAndOrderFront: self ];

    if ( !( [ TauYTDataService sharedService ].isSignedIn ) )
        [ self runSignInThenHandler_: nil ];

    return YES;
    }

#pragma mark - Conforms to <NSToolbarDelegate>

NSString* const kPanelsSwitcher = @"kPanelsSwitcher";
NSString* const kUserProfileButton = @"kUserProfileButton";

- ( NSArray <NSString*>* ) toolbarAllowedItemIdentifiers: ( NSToolbar* )_Toolbar
    {
    return @[ kPanelsSwitcher
            , NSToolbarFlexibleSpaceItemIdentifier
            , kUserProfileButton
            ];
    }

- ( NSArray <NSString*>* ) toolbarDefaultItemIdentifiers: ( NSToolbar* )_Toolbar
    {
    return @[ kPanelsSwitcher
            , NSToolbarFlexibleSpaceItemIdentifier
            , kUserProfileButton
            ];
    }

- ( NSToolbarItem* )  toolbar: ( NSToolbar* )_Toolbar
        itemForItemIdentifier: ( NSString* )_ItemIdentifier
    willBeInsertedIntoToolbar: ( BOOL )_Flag
    {
    NSToolbarItem* toolbarItem = nil;
    BOOL should = NO;

    NSString* identifier = _ItemIdentifier;
    NSString* label = nil;
    NSString* paleteLabel = nil;
    NSString* toolTip = nil;
    id content = nil;
    id target = self;
    SEL action = nil;
    NSMenu* repMenu = nil;

    if ( ( should = [ _ItemIdentifier isEqualToString: kPanelsSwitcher ] ) )
        content = self.segSwitcher_;

    if ( should )
        {
        toolbarItem = [ self _toolbarWithIdentifier: identifier
                                              label: label
                                        paleteLabel: paleteLabel
                                            toolTip: toolTip
                                             target: target
                                             action: action
                                        itemContent: content
                                            repMenu: repMenu ];
        }

    return toolbarItem;
    }

#pragma mark - Private Interfaces
- ( NSToolbarItem* ) _toolbarWithIdentifier: ( NSString* )_Identifier
                                      label: ( NSString* )_Label
                                paleteLabel: ( NSString* )_PaleteLabel
                                    toolTip: ( NSString* )_ToolTip
                                     target: ( id )_Target
                                     action: ( SEL )_ActionSEL
                                itemContent: ( id )_ImageOrView
                                    repMenu: ( NSMenu* )_Menu
    {
    NSToolbarItem* newToolbarItem = [ [ NSToolbarItem alloc ] initWithItemIdentifier: _Identifier ];

    [ newToolbarItem setLabel: _Label ];
    [ newToolbarItem setPaletteLabel: _PaleteLabel ];
    [ newToolbarItem setToolTip: _ToolTip ];

    [ newToolbarItem setTarget: _Target ];
    [ newToolbarItem setAction: _ActionSEL ];

    if ( [ _ImageOrView isKindOfClass: [ NSImage class ] ] )
        [ newToolbarItem setImage: ( NSImage* )_ImageOrView ];

    else if ( [ _ImageOrView isKindOfClass: [ NSView class ] ] )
        [ newToolbarItem setView: ( NSView* )_ImageOrView ];

    if ( _Menu )
        {
        NSMenuItem* repMenuItem = [ [ NSMenuItem alloc ] init ];
        [ repMenuItem setSubmenu: _Menu ];
        [ repMenuItem setTitle: _Label ];
        [ newToolbarItem setMenuFormRepresentation: repMenuItem ];
        }

    return newToolbarItem;
    }

#pragma mark - Private Interfaces

@dynamic authWindow_;

@dynamic segSwitcher_;

- ( GTMOAuth2WindowController* ) authWindow_
    {
    NSBundle* frameworkBundle = [ NSBundle bundleForClass: [ GTMOAuth2WindowController class ] ];

    GTMOAuth2WindowController* authWindow = [ GTMOAuth2WindowController
        controllerWithScope: TauManageAuthScope
                   clientID: TauClientID
               clientSecret: TauClientSecret
           keychainItemName: TauKeychainItemName
             resourceBundle: frameworkBundle ];

    return authWindow;
    }

- ( NSSegmentedControl* ) segSwitcher_
    {
    if ( !priSegSwitcher_ )
        {
        NSUInteger segmentCount = 3;
        CGFloat segmentFixedWidth = 34.f;
        priSegSwitcher_ = [ [ NSSegmentedControl alloc ] initWithFrame: NSMakeRect( 0, 0, 108.f, 22.f ) ];
        [ priSegSwitcher_ setSegmentCount: 3 ];
        [ priSegSwitcher_ setTrackingMode: NSSegmentSwitchTrackingSelectOne ];

        for ( int _Index = 0; _Index < segmentCount; _Index++ )
            {
            [ priSegSwitcher_ setWidth: segmentFixedWidth forSegment: _Index ];
            [ priSegSwitcher_.cell setTag: ( TauPanelsSwitcherSegmentTag )_Index forSegment: _Index ];

            switch ( [ priSegSwitcher_.cell tagForSegment: _Index ] )
                {
                case TauPanelsSwitcherSearchTag:
                    {
                    NSImage* image = [ NSImage imageNamed: @"tau-search-dark" ];
                    [ image setTemplate: YES ];
                    [ image setSize: NSMakeSize( 17.f, 15.f ) ];
                    [ priSegSwitcher_ setImage: image forSegment: _Index ];
                    [ priSegSwitcher_.cell setToolTip: NSLocalizedString( @"Search", nil ) forSegment: _Index ];
                    } break;

                case TauPanelsSwitcherMeTubeTag:
                    {
                    NSImage* image = [ NSImage imageNamed: @"tau-explore-dark" ];
                    [ image setTemplate: YES ];
                    [ image setSize: NSMakeSize( 17.f, 17.f ) ];
                    [ priSegSwitcher_ setImage: image forSegment: _Index ];
                    [ priSegSwitcher_.cell setToolTip: NSLocalizedString( @"Search", nil ) forSegment: _Index ];
                    } break;

                case TauPanelsSwitcherPlayerTag:
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


// Signning in
- ( void ) runSignInThenHandler_: ( void (^)( void ) )_Handler
    {
    [ self.authWindow_ signInSheetModalForWindow: self.window completionHandler:
        ^( GTMOAuth2Authentication* _Auth, NSError* _Error )
            {
            if ( _Auth && !_Error )
                {
                [ [ TauYTDataService sharedService ].ytService setAuthorizer: _Auth ];
                if ( _Handler ) _Handler();
                }
            else
                {
                DDLogUserError( @"Auth Window was prematurely closed" );
                [ self.window orderOut: self ];
                }
            } ];
    }

// Signing Out
- ( void ) signOutAction: ( id )_Sender
    {
    [ TauYTDataService sharedService ].ytService.authorizer = nil;
    [ GTMOAuth2WindowController removeAuthFromKeychainForName: TauKeychainItemName ];
    [ self runSignInThenHandler_: nil ];
    }

@end
