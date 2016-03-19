//
//  TauToolbarController.m
//  Tau4Mac
//
//  Created by Tong G. on 3/18/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauToolbarController.h"

// Private
@interface TauToolbarController ()
@property ( strong, readonly ) NSSegmentedControl* segSwitcher_;
@end // Private

NSString* const TauToolbarSwitcherItemIdentifier            = @"home.bedroom.TongKuo.Tau.Toolbar.SwitcherItem";
NSString* const TauToolbarUserProfileButtonItemIdentifier   = @"home.bedroom.TongKuo.Tau.Toolbar.UserProfileButtonItem";

// TauToolbarController class
@implementation TauToolbarController
    {
    NSSegmentedControl __strong* priSegSwitcher_;

    NSButton __strong* priUserProfilePopUpButton_;
    }

+ ( void ) initialize
    {
    if ( self == [ TauToolbarController class ] )
        [ self exposeBinding: contentViewAffiliatedTo_kvoKey ];
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
    [ self.managedToolbar setAllowsUserCustomization: NO ];
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

#pragma mark - Conforms to <NSToolbarDelegate>

- ( NSArray <NSString*>* ) toolbarAllowedItemIdentifiers: ( NSToolbar* )_Toolbar
    {
    return @[ // Items defined by Tau
              TauToolbarSwitcherItemIdentifier
            , TauToolbarUserProfileButtonItemIdentifier

              // Items defined by Cocoa
            , NSToolbarFlexibleSpaceItemIdentifier
            ];
    }

- ( NSArray <NSString*>* ) toolbarDefaultItemIdentifiers: ( NSToolbar* )_Toolbar
    {
    return @[ TauToolbarSwitcherItemIdentifier
            , NSToolbarFlexibleSpaceItemIdentifier
            , TauToolbarUserProfileButtonItemIdentifier
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

    if ( ( should = [ _ItemIdentifier isEqualToString: TauToolbarSwitcherItemIdentifier ] ) )
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

@end // TauToolbarController class