//
//  TauMainWindowController.m
//  Tau4Mac
//
//  Created by Tong G. on 3/3/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauMainWindowController.h"
#import "TauYouTubeEntryView.h"
#import "TauUserProfileViewController.h"
#import "TauMainViewController.h"

#import "GTL/GTMOAuth2WindowController.h"

#import "TauTTYLogFormatter.h"

// Private Interfaces
@interface TauMainWindowController ()

@property ( strong, readonly ) GTMOAuth2WindowController* authWindow_;

@property ( strong, readonly ) NSSegmentedControl* segSwitcher_;
@property ( strong, readonly ) NSButton* userProfilePopUpButton_;
@property ( strong, readonly ) NSPopover* userProfilePopover_;;

// Signning In
- ( void ) runSignInThenHandler_: ( void (^)( void ) )_Handler;

// Logging
- ( void ) configureLogging_;

@end // Private Interfaces

NSString* const TauShouldSwitch2SearchSegmentNotif = @"Should.Switch2SearchSegment.Notif";
NSString* const TauShouldSwitch2MeTubeSegmentNotif = @"Should.Switch2MeTubeSegment.Notif";
NSString* const TauShouldSwitch2PlayerSegmentNotif = @"Should.Switch2PlayerSegment.Notif";

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
    [ kvoController_ observe: self.segSwitcher_ keyPath: @"cell.selectedSegment"
                     options: NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                      action: @selector( selectedSegmentDidChange:observing: ) ];
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
    [ self configureLogging_ ];

    if ( ![ [ TauDataService sharedService ] isSignedIn ] )
        [ self runSignInThenHandler_: nil ];
    }

- ( BOOL ) applicationShouldHandleReopen: ( NSApplication* )_Sender
                       hasVisibleWindows: ( BOOL )_Flag
    {
    if ( _Flag )
        [ self.window orderFront: self ];
    else
        [ self.window makeKeyAndOrderFront: self ];

    if ( !( [ TauDataService sharedService ].isSignedIn ) )
        [ self runSignInThenHandler_: nil ];

    return YES;
    }

#pragma mark - Conforms to <NSToolbarDelegate>

NSString* const kPanelsSwitcher = @"kPanelsSwitcher";
NSString* const kUserProfileButton = @"kUserProfileButton";

- ( NSArray <NSString*>* ) toolbarAllowedItemIdentifiers: ( NSToolbar* )_Toolbar
    {
    return @[ NSToolbarFlexibleSpaceItemIdentifier
            , kPanelsSwitcher
            , NSToolbarFlexibleSpaceItemIdentifier
            , kUserProfileButton
            ];
    }

- ( NSArray <NSString*>* ) toolbarDefaultItemIdentifiers: ( NSToolbar* )_Toolbar
    {
    return @[ NSToolbarFlexibleSpaceItemIdentifier
            , kPanelsSwitcher
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

    else if ( ( should = [ _ItemIdentifier isEqualToString: kUserProfileButton ] ) )
        content = self.userProfilePopUpButton_;

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
@dynamic userProfilePopUpButton_;
@dynamic userProfilePopover_;

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
        CGFloat segmentFixedWidth = 80.f;
        priSegSwitcher_ = [ [ NSSegmentedControl alloc ] initWithFrame: NSMakeRect( 0, 0, 248.f, 21.f ) ];
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
                    [ priSegSwitcher_ setLabel: NSLocalizedString( @"Search", nil ) forSegment: _Index ];
                    } break;

                case TauPanelsSwitcherMeTubeTag:
                    {
                    [ priSegSwitcher_ setLabel: NSLocalizedString( @"MeTube", nil ) forSegment: _Index ];
                    } break;

                case TauPanelsSwitcherPlayerTag:
                    {
                    [ priSegSwitcher_ setLabel: NSLocalizedString( @"Player", nil ) forSegment: _Index ];
                    } break;
                }
            }
        }

    return priSegSwitcher_;
    }

- ( NSButton* ) userProfilePopUpButton_
    {
    if ( !priUserProfilePopUpButton_ )
        {
        priUserProfilePopUpButton_ = [ [ NSButton alloc ] initWithFrame: NSMakeRect( 0, 0, 40.f, 22.f ) ];

        priUserProfilePopUpButton_.bezelStyle = NSTexturedRoundedBezelStyle;
        NSImage* image = [ NSImage imageNamed: @"tau-user-profile" ];
        image.size = NSMakeSize( 18.f, 18.f );
        priUserProfilePopUpButton_.image = image;
        priUserProfilePopUpButton_.imagePosition = NSImageOnly;
        priUserProfilePopUpButton_.action = @selector( pullDownContextMenuAction_: );
        priUserProfilePopUpButton_.target = self;
        }

    return priUserProfilePopUpButton_;
    }

- ( NSPopover* ) userProfilePopover_
    {
    if ( !priUserProfilePopover_ )
        {
        priUserProfilePopover_ = [ [ NSPopover alloc ] init ];
        priUserProfilePopover_.animates = YES;
        priUserProfilePopover_.behavior = NSPopoverBehaviorTransient;

        TauUserProfileViewController* userProfileViewController = [ [ TauUserProfileViewController alloc ] initWithNibName: nil bundle: nil ];
        [ userProfileViewController setAuthorizer: [ TauDataService sharedService ].ytService.authorizer ];
        priUserProfilePopover_.contentViewController = userProfileViewController;
        }

    return priUserProfilePopover_;
    }

- ( IBAction ) pullDownContextMenuAction_: ( id )_Sender;
    {
    [ self.userProfilePopover_ showRelativeToRect: NSZeroRect ofView: _Sender preferredEdge: NSRectEdgeMaxY ];
    }

// Signning in
- ( void ) runSignInThenHandler_: ( void (^)( void ) )_Handler
    {
    [ self.authWindow_ signInSheetModalForWindow: self.window completionHandler:
        ^( GTMOAuth2Authentication* _Auth, NSError* _Error )
            {
            if ( _Auth && !_Error )
                {
                [ [ TauDataService sharedService ].ytService setAuthorizer: _Auth ];
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
    [ ( ( TauMainViewController* )self.contentViewController ) cleanUp ];

    [ TauDataService sharedService ].ytService.authorizer = nil;
    [ GTMOAuth2WindowController removeAuthFromKeychainForName: TauKeychainItemName ];
    [ self runSignInThenHandler_: nil ];
    }

// Logging
- ( void ) configureLogging_
    {
    // Light Red
    NSColor* recoverableErrOutputColor = [ NSColor colorWithRed: 248 / 255.f green: 98 / 255.0 blue: 98 / 255.0 alpha: 1.f ];

    // Light Green
    NSColor* debugOutputColor = [ NSColor colorWithRed: 151 / 255.f green: 204 / 255.0 blue: 245 / 255.0 alpha: 1.f ];

    // Light Blue
    NSColor* infoOutputColor = [ NSColor colorWithRed: 184 / 255.f green: 233 / 255.0 blue: 134 / 255.0 alpha: 1.f ];

    // Light Orange
    NSColor* warningOutputColor = [ NSColor colorWithRed: 246 / 255.f green: 174 / 255.0 blue: 55 / 255.0 alpha: 1.f ];
    NSColor* verboseOutputColor = [ NSColor lightGrayColor ];

    // Configuring TTY Logger
    DDTTYLogger* sharedTTYLogger = [ DDTTYLogger sharedInstance ];
    DDASLLogger* sharedASLLogger = [ DDASLLogger sharedInstance ];

    [ sharedTTYLogger setLogFormatter: [ [ TauTTYLogFormatter alloc ] init ] ];
    [ sharedASLLogger setLogFormatter: [ [ TauTTYLogFormatter alloc ] init ] ];

    [ sharedTTYLogger setColorsEnabled: YES ];
    [ sharedTTYLogger setForegroundColor: recoverableErrOutputColor backgroundColor: nil forFlag: DDLogFlagRecoverable ];
    [ sharedTTYLogger setForegroundColor: debugOutputColor backgroundColor: nil forFlag: DDLogFlagDebug ];
    [ sharedTTYLogger setForegroundColor: infoOutputColor backgroundColor: nil forFlag: DDLogFlagInfo ];
    [ sharedTTYLogger setForegroundColor: warningOutputColor backgroundColor: nil forFlag: DDLogFlagWarning ];
    [ sharedTTYLogger setForegroundColor: verboseOutputColor backgroundColor: nil forFlag: DDLogFlagVerbose ];

    // Configuring file logger
    DDFileLogger* fileLogger = [ [ DDFileLogger alloc ] init ];

    fileLogger.rollingFrequency = 60 * 60 * 24 * 3; // Three day
    fileLogger.logFileManager.maximumNumberOfLogFiles = 10;

    [ DDLog addLogger: sharedTTYLogger ];
    [ DDLog addLogger: sharedASLLogger ];
    [ DDLog addLogger: fileLogger withLevel: DDLogLevelWarn ];
    }

@end
