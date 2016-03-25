//
//  TauContentInspectorViewController.m
//  Tau4Mac
//
//  Created by Tong G. on 3/23/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauContentInspectorViewController.h"
#import "TauAbstractDisclosureViewController.h"



// ------------------------------------------------------------------------------------------------------------ //



// TauContentInspectorSectionView class
@interface TauContentInspectorSectionView : NSView
@end // TauContentInspectorSectionView class



// Private
@interface TauContentInspectorViewController ()

@property ( strong, readonly ) NSStackView* stackView_;

// These guys used for feeding the self.stackView_
@property ( weak ) IBOutlet NSView* noSelectionLabelSection_;
@property ( weak ) IBOutlet TauAbstractDisclosureViewController* singleContentTitleDisclosureViewController_;
@property ( weak ) IBOutlet TauAbstractDisclosureViewController* singleContentDescriptionDisclosureViewController_;
@property ( weak ) IBOutlet TauAbstractDisclosureViewController* singleContentActionDisclosureViewController_;
@property ( weak ) IBOutlet TauAbstractDisclosureViewController* singleContentMetaInfoDisclosureViewController_;

@property ( weak ) IBOutlet NSArrayController* ytContentModelController_;

@end // Private



// ------------------------------------------------------------------------------------------------------------ //



// TauContentInspectorViewController class
@implementation TauContentInspectorViewController
    {
    // Layout Constraints Cache
    NSArray <NSLayoutConstraint*>* inspectorLayoutConstraintsCache_;
    }

#pragma mark - Initializations

- ( void ) viewDidLoad
    {
    [ super viewDidLoad ];
    // Do view setup here.

    NSLog( @"%@", self.stackView_ );
    }

- ( void ) dealloc
    {
    DDLogDebug( @"%@ got allocated", self );
    }

#pragma mark - External KVB Compliant Properties

@synthesize ytContents = ytContents_;
+ ( NSSet <NSString*>* ) keyPathsForValuesAffectingYtContents
    {
    return [ NSSet setWithObjects: TAU_KEY_OF_SEL( @selector( representedObject ) ), nil ];
    }

+ ( BOOL ) automaticallyNotifiesObserversOfYtContents
    {
    return NO;
    }

- ( void ) setYtContents: ( NSArray <GTLObject*>* )_New
    {
    if ( ytContents_ != _New )
        {
        TAU_CHANGE_VALUE_FOR_KEY_of_SEL( @selector( ytContents ),
         ( ^{
            ytContents_ = _New;
            } ) );
        }
    }

- ( NSArray <GTLObject*>* ) ytContents
    {
    return ytContents_;
    }

#pragma mark - Private

@synthesize stackView_ = priStackView_;
- ( NSStackView* ) stackView_
    {
    if ( !priStackView_ )
        {
        priStackView_ = [ [ NSStackView alloc ] initWithFrame: NSZeroRect ];

        [ priStackView_ addView: self.singleContentTitleDisclosureViewController_.view inGravity: NSStackViewGravityTop ];
        [ priStackView_ addView: self.singleContentActionDisclosureViewController_.view inGravity: NSStackViewGravityTop ];
        [ priStackView_ addView: self.singleContentDescriptionDisclosureViewController_.view inGravity: NSStackViewGravityCenter ];
        [ priStackView_ addView: self.singleContentMetaInfoDisclosureViewController_.view inGravity: NSStackViewGravityBottom ];

        [ priStackView_ setVisibilityPriority: NSStackViewVisibilityPriorityMustHold forView: self.singleContentTitleDisclosureViewController_.view ];
        [ priStackView_ setVisibilityPriority: NSStackViewVisibilityPriorityMustHold forView: self.singleContentActionDisclosureViewController_.view ];
        [ priStackView_ setVisibilityPriority: NSStackViewVisibilityPriorityDetachOnlyIfNecessary forView: self.singleContentDescriptionDisclosureViewController_.view ];
        [ priStackView_ setVisibilityPriority: NSStackViewVisibilityPriorityDetachOnlyIfNecessary - 1 forView: self.singleContentMetaInfoDisclosureViewController_.view ];

        priStackView_.orientation = NSUserInterfaceLayoutOrientationVertical;
        priStackView_.alignment = NSLayoutAttributeCenterX;
        priStackView_.spacing = 0.f;

        [ priStackView_ setHuggingPriority: NSLayoutPriorityDefaultHigh forOrientation: NSLayoutConstraintOrientationHorizontal ];

        [ self.view addSubview: [ priStackView_ configureForAutoLayout ] ];
        [ priStackView_ autoPinEdgesToSuperviewEdges ];
        }

    return priStackView_;
    }

@end // TauContentInspectorViewController class



// ------------------------------------------------------------------------------------------------------------ //



// TauContentInspectorSectionView class
@implementation TauContentInspectorSectionView : NSView

- ( void ) awakeFromNib
    {
    [ [ self configureForAutoLayout ] setWantsLayer: YES ];
    [ self.layer setBackgroundColor: [ NSColor whiteColor ].CGColor ];    }

- ( void ) drawRect: ( NSRect )_DirtyRect
    {
    [ super drawRect: _DirtyRect ];

    NSBezierPath* cuttingLinePath = [ NSBezierPath bezierPath ];

    NSRect bounds = self.bounds;
    CGFloat y = self.isFlipped ? NSMinY( bounds ) : NSMaxY( bounds );
    [ cuttingLinePath moveToPoint: NSMakePoint( NSMinX( bounds ), y ) ];
    [ cuttingLinePath lineToPoint: NSMakePoint( NSMaxX( bounds ), y ) ];

    cuttingLinePath.lineWidth = 1.5f;

    [ [ [ NSColor lightGrayColor ] colorWithAlphaComponent: .6f ] setStroke ];
    [ cuttingLinePath stroke ];
//    [ cuttingLinePath fill ];
    }

@end // TauContentInspectorSectionView class