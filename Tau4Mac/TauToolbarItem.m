//
//  TauToolbarItem.m
//  Tau4Mac
//
//  Created by Tong G. on 3/19/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauToolbarItem.h"
#import "TauToolbarController.h"
#import "TAAdaptiveSpaceItem.h"

// Private
@interface TauToolbarItem ()

@property ( strong, readwrite ) id content_;

- ( NSToolbarItem* ) _toolbarItemWithIdentifier: ( NSString* )_Identifier
                                          label: ( NSString* )_Label
                                    paleteLabel: ( NSString* )_PaleteLabel
                                        toolTip: ( NSString* )_ToolTip
                                         target: ( id )_Target
                                         action: ( SEL )_ActionSEL
                                    itemContent: ( id )_ImageOrView
                                        repMenu: ( NSMenu* )_Menu;
@end // Private



// ------------------------------------------------------------------------------------------------------------ //



// TauToolbarItem class
@implementation TauToolbarItem

#pragma mark - Initializations

// Internal Designed Initializer
- ( instancetype ) initWithKeyValueDict: ( NSDictionary* )_KeyValueDict
    {
    if ( self = [ super init ] )
        {
        NSError* err = nil;
        for ( NSString* _Key in _KeyValueDict )
            {
            id validatedVal = [ _KeyValueDict objectForKey: _Key ];

            // val of _Key may be [ NSNull null ].
            // Replace them with nil in validation method
            if ( [ self validateValue: &validatedVal forKey: _Key error: &err ] )
                [ self setValue: validatedVal forKey: _Key ];
            else
                {
                if ( err )
                    DDLogFatal( @"Failure in validation of value of \"%@\" key: {%@}", _Key, err );
                }
            }
        }

    return self;
    }

- ( instancetype ) initWithIdentifier: ( NSString* )_Id label: ( NSString* )_Label image: ( NSImage* )_Image toolTip: ( NSString* )_Tooltip invocation: ( NSInvocation* )_Invocation
    {
    return [ self initWithKeyValueDict:
        @{ @"identifier" : _Id ?: [ NSNull null ]
         , @"label" : _Label ?: [ NSNull null ]
         , @"image" : _Image ?: [ NSNull null ]
         , @"toolTip" : _Tooltip ?: [ NSNull null ]
         , @"invocation" : _Invocation ?: [ NSNull null ]
         } ];
    }

- ( instancetype ) initWithIdentifier: ( NSString* )_Id label: ( NSString* )_Label view: ( NSView* )_View
    {
    return [ self initWithKeyValueDict:
        @{ @"identifier" : _Id ?: [ NSNull null ]
         , @"label" : _Label ?: [ NSNull null ]
         , @"view" : _View ?: [ NSNull null ]
         } ];
    }

#pragma mark - KVC

- ( BOOL ) validateValue: ( inout id _Nullable __autoreleasing* )_IOValue
                  forKey: ( NSString* )_Key
                   error: ( out NSError* _Nullable __autoreleasing* )_OutError
    {
    BOOL isUnspecified = !( *_IOValue ) || ( *_IOValue == [ NSNull null ] );

    // identifier is required for TauToolbarController,
    // so its validation is more complicated
    if ( [ _Key isEqualToString: @"identifier" ] )
        {
        // if value of "identifier" key is either nil or [ NSNull null ]
        if ( isUnspecified )
            {
            NSString* nounceID = TKNonce();

            DDLogNotice( @"Value of \"%@\" key was unspecified. %@ will use an automatic identifier for you: {%@}"
                       , _Key, NSStringFromClass( [ self class ] )
                       , nounceID
                       );

            *_IOValue = nounceID;
            return YES;
            }

        // if value of "identifier" key is not kind of NSString
        else if ( ![ ( *_IOValue ) isKindOfClass: [ NSString class ] ] && [ ( *_IOValue ) isKindOfClass: [ NSObject class ] ] )
            {
            DDLogNotice( @"Value of \"%@\" key doesn't have a value with correct type.", _Key );
            *_IOValue = [ *_IOValue description ] ?: @"";
            return YES;
            }
        }

    else if ( isUnspecified )
        {
        *_IOValue = nil;
        return YES;
        }

    return [ super validateValue: _IOValue forKey: _Key error: _OutError ];
    }

#pragma mark - Properties

@synthesize identifier, label, paleteLabel, toolTip, invocation, repMenu;

@dynamic view;
@dynamic image;

- ( void ) setView: ( NSView* )_View
    {
    self.content_ = _View;
    }

- ( NSView* ) view
    {
    if ( [ content_ isKindOfClass: [ NSView class ] ] )
        return ( NSView* )( content_ );
    return nil;
    }

- ( void ) setImage: ( NSImage* )_Image
    {
    self.content_ = _Image;
    }

- ( NSImage* ) image
    {
    if ( [ content_ isKindOfClass: [ NSImage class ] ] )
        return ( NSImage* )( content_ );
    return nil;
    }

@dynamic cocoaToolbarItemRep;
- ( NSToolbarItem* ) cocoaToolbarItemRep
    {
    if ( [ self isMemberOfClass: [ TauToolbarAdaptiveSpaceItem class ] ] )
        return [ [ TAAdaptiveSpaceItem alloc ] initWithItemIdentifier: identifier ];
    else
        return [ self _toolbarItemWithIdentifier: identifier label: label paleteLabel: paleteLabel toolTip: toolTip target: invocation.target action: invocation.selector itemContent: content_ repMenu: repMenu ];
    }

#pragma mark - Common Items

+ ( TauToolbarSwitcherItem* ) switcherItem { return [ [ TauToolbarSwitcherItem alloc ] init ]; }
+ ( TauToolbarFlexibleSpaceItem* ) flexibleSpaceItem { return [ [ TauToolbarFlexibleSpaceItem alloc ] init ]; }
+ ( TauToolbarFixedSpaceItem* ) fixedSpaceItem { return [ [ TauToolbarFixedSpaceItem alloc ] init ]; }
+ ( TauToolbarAdaptiveSpaceItem* ) adaptiveSpaceItem { return [ [ TauToolbarAdaptiveSpaceItem alloc ] init ]; }
+ ( TauToolbarUserProfileItem* ) userProfileItem { return [ [ TauToolbarUserProfileItem alloc ] init ]; }

#pragma mark - Private

@synthesize content_;

- ( NSToolbarItem* ) _toolbarItemWithIdentifier: ( NSString* )_Identifier
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

@end // TauToolbarItem class



// ------------------------------------------------------------------------------------------------------------ //



// TauToolbarSwitcherItem class
@implementation TauToolbarSwitcherItem : TauToolbarItem

TauToolbarSwitcherItem static* sSwitcherItem_;
- ( instancetype ) init
    {
    if ( !sSwitcherItem_ )
        {
        if ( self = [ super init ] )
            {
            self.identifier = TauToolbarSwitcherItemIdentifier;
            sSwitcherItem_ = self;
            }
        }

    return sSwitcherItem_;
    }

@end //TauToolbarSwitcherItem class

// TauToolbarFlexibleSpaceItem class
@implementation TauToolbarFlexibleSpaceItem : TauToolbarItem

TauToolbarFlexibleSpaceItem static* sFlexibleSpaceItem_;
- ( instancetype ) init
    {
    if ( !sFlexibleSpaceItem_ )
        {
        if ( self = [ super init ] )
            {
            self.identifier = NSToolbarFlexibleSpaceItemIdentifier;
            sFlexibleSpaceItem_ = self;
            }
        }

    return sFlexibleSpaceItem_;
    }

@end //TauToolbarFlexibleSpaceItem class

// TauToolbarFixedSpaceItem class
@implementation TauToolbarFixedSpaceItem : TauToolbarItem

TauToolbarFixedSpaceItem static* sFixedSpaceItem_;
- ( instancetype ) init
    {
    if ( !sFixedSpaceItem_ )
        {
        if ( self = [ super init ] )
            {
            self.identifier = NSToolbarSpaceItemIdentifier;
            sFixedSpaceItem_ = self;
            }
        }

    return sFixedSpaceItem_;
    }

@end // TauToolbarFixedSpaceItem class

// TauToolbarAdaptiveSpaceItem class
@implementation TauToolbarAdaptiveSpaceItem : TauToolbarItem

TauToolbarAdaptiveSpaceItem static* sAdaptiveSpaceItem_;
- ( instancetype ) init
    {
    if ( !sAdaptiveSpaceItem_ )
        {
        if ( self = [ super init ] )
            {
            self.identifier = TauToolbarAdaptiveSpaceItemIdentifier;
            sAdaptiveSpaceItem_ = self;
            }
        }

    return sAdaptiveSpaceItem_;
    }

@end // TauToolbarAdaptiveSpaceItem class

// TauUserProfileItem class
@implementation TauToolbarUserProfileItem : TauToolbarItem

TauToolbarUserProfileItem static* sUserProfileItem_;
- ( instancetype ) init
    {
    if ( !sUserProfileItem_ )
        {
        if ( self = [ super init ] )
            {
            self.identifier = TauToolbarUserProfileButtonItemIdentifier;
            sUserProfileItem_ = self;
            }
        }

    return sUserProfileItem_;
    }

@end // TauUserProfileItem class

// NSArray + TauToolbarItem
@implementation NSArray ( TauToolbarItem )

- ( NSArray <NSString*>* ) cocoaToolbarIdentifiers
    {
    NSMutableArray <NSString*>* identifiers = [ NSMutableArray arrayWithCapacity: self.count ];

    for ( TauToolbarItem* _Item in self )
        {
        if ( [ _Item isMemberOfClass: [ TauToolbarItem class ] ] )
            [ identifiers addObject: _Item.identifier ];

        else if ( [ _Item isMemberOfClass: [ TauToolbarAdaptiveSpaceItem class ] ] )
            [ identifiers addObject: TauToolbarAdaptiveSpaceItemIdentifier ];

        else if ( [ _Item isMemberOfClass: [ TauToolbarSwitcherItem class ] ] )
            [ identifiers addObject: TauToolbarSwitcherItemIdentifier ];

        else if ( [ _Item isMemberOfClass: [ TauToolbarFlexibleSpaceItem class ] ] )
            [ identifiers addObject: NSToolbarFlexibleSpaceItemIdentifier ];

        else if ( [ _Item isMemberOfClass: [ TauToolbarFixedSpaceItem class ] ] )
            [ identifiers addObject: NSToolbarSpaceItemIdentifier ];

        else if ( [ _Item isMemberOfClass: [ TauToolbarUserProfileItem class ] ] )
            [ identifiers addObject: TauToolbarUserProfileButtonItemIdentifier ];
        }

    return [ identifiers copy ];
    }

- ( TauToolbarItem* ) itemWithIdentifier: ( NSString* )_Identifier
    {
    for ( TauToolbarItem* _Item in self )
        if ( [ _Item.identifier isEqualToString: _Identifier ] )
            return _Item;

    return nil;
    }

- ( BOOL ) containsItemWithIdentifier: ( NSString* )_Identifier
    {
    for ( TauToolbarItem* _Item in self )
        if ( [ _Item.identifier isEqualToString: _Identifier ] )
            return YES;

    return NO;
    }

@end // NSArray + TauToolbarItem