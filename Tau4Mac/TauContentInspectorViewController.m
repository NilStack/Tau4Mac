//
//  TauContentInspectorViewController.m
//  Tau4Mac
//
//  Created by Tong G. on 3/23/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauContentInspectorViewController.h"



// ------------------------------------------------------------------------------------------------------------ //



// TauContentInspectorSectionView class
@interface TauContentInspectorSectionView : NSView
@end // TauContentInspectorSectionView class



// Private
@interface TauContentInspectorViewController ()

@property ( strong, readonly ) NSStackView* stackView_;

// These guys used for feeding the self.stackView_
@property ( weak ) IBOutlet NSView* noSelectionLabelSection_;
@property ( weak ) IBOutlet TauContentInspectorSectionView* singleContentTitleSection_;
@property ( weak ) IBOutlet TauContentInspectorSectionView* singleContentDescriptionSection_;
@property ( weak ) IBOutlet TauContentInspectorSectionView* singleContentActionSection_;
@property ( weak ) IBOutlet TauContentInspectorSectionView* singleContentMetaInfoSection_;

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

        [ priStackView_ addView: self.singleContentTitleSection_ inGravity: NSStackViewGravityTop ];
        [ priStackView_ addView: self.singleContentDescriptionSection_ inGravity: NSStackViewGravityCenter ];
        [ priStackView_ addView: self.singleContentActionSection_ inGravity: NSStackViewGravityCenter ];
        [ priStackView_ addView: self.singleContentMetaInfoSection_ inGravity: NSStackViewGravityBottom ];

        [ priStackView_ setVisibilityPriority: NSStackViewVisibilityPriorityMustHold forView: self.singleContentTitleSection_ ];
        [ priStackView_ setVisibilityPriority: NSStackViewVisibilityPriorityMustHold forView: self.singleContentActionSection_ ];
        [ priStackView_ setVisibilityPriority: NSStackViewVisibilityPriorityDetachOnlyIfNecessary forView: self.singleContentMetaInfoSection_ ];

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
    [ self.layer setBackgroundColor: [ NSColor whiteColor ].CGColor ];
    }

@end // TauContentInspectorSectionView class