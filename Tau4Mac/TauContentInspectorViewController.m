//
//  TauContentInspectorViewController.m
//  Tau4Mac
//
//  Created by Tong G. on 3/23/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauContentInspectorViewController.h"



// TauContentInspectorSectionView class
@interface TauContentInspectorSectionView : NSView
@end // TauContentInspectorSectionView class



// ------------------------------------------------------------------------------------------------------------ //



// Private
@interface TauContentInspectorViewController ()

@property ( weak ) IBOutlet NSView* noSelectionLabelSection_;

/*************** Embedding the split view controller ***************/

@property ( strong, readonly ) NSSplitViewController* splitInspectorViewController_;

// These guys used for feeding the split inspector view controller above
@property ( strong, readonly ) NSSplitViewItem* singleContentTitleSectionItem_;
@property ( strong, readonly ) NSSplitViewItem* singleContentActionSectionItem_;
@property ( strong, readonly ) NSSplitViewItem* singleContentDescriptionSectionItem_;
@property ( strong, readonly ) NSSplitViewItem* singleContentInformationSectionItem_;

// These guys used for feeding the split view items above
@property ( weak ) IBOutlet NSViewController* wrapperOfSingleContentTitleSectionView_;
@property ( weak ) IBOutlet NSViewController* wrapperOfSingleContentActionSectionView_;
@property ( weak ) IBOutlet NSViewController* wrapperOfSingleContentDescriptionSectionView_;
@property ( weak ) IBOutlet NSViewController* wrapperOfSingleContentInformationSectionView_;

/*************** Embedding the split view controller ***************/

@property ( weak ) IBOutlet NSArrayController* ytContentModelController_;

@end // Private



// ------------------------------------------------------------------------------------------------------------ //



// TauContentInspectorViewController class
@implementation TauContentInspectorViewController
    {
    // Layout Constraints Cache
    NSArray <NSLayoutConstraint*>* inspectorLayoutConstraintsCache_;
    }

TauDeallocBegin
TauDeallocEnd

#pragma mark - Initializations

- ( void ) viewDidLoad
    {
    [ super viewDidLoad ];

    [ self addChildViewController: self.splitInspectorViewController_ ];
    [ self.view addSubview: self.splitInspectorViewController_.view ];
    [ [ self.splitInspectorViewController_.view configureForAutoLayout ] autoPinEdgesToSuperviewEdges ];
    }

#pragma mark - External KVB Compliant Properties

@synthesize YouTubeContents = YouTubeContents_;
+ ( NSSet <NSString*>* ) keyPathsForValuesAffectingYouTubeContents
    {
    return [ NSSet setWithObjects: TauKVOStrictKey( representedObject ), nil ];
    }

+ ( BOOL ) automaticallyNotifiesObserversOfYouTubeContents
    {
    return NO;
    }

- ( void ) setYouTubeContents: ( NSArray <GTLObject*>* )_New
    {
    if ( YouTubeContents_ != _New )
        TauChangeValueForKVOStrictKey( YouTubeContents, ^{ YouTubeContents_ = _New; } );
    }

- ( NSArray <GTLObject*>* ) YouTubeContents
    {
    return YouTubeContents_;
    }

#pragma mark - Private

@synthesize splitInspectorViewController_ = priSplitInspectorViewController_;
- ( NSSplitViewController* ) splitInspectorViewController_
    {
    if ( !priSplitInspectorViewController_ )
        {
        priSplitInspectorViewController_ = [ [ NSSplitViewController alloc ] initWithNibName: nil bundle: nil ];
        priSplitInspectorViewController_.splitView.vertical = NO;
        priSplitInspectorViewController_.splitView.dividerStyle = NSSplitViewDividerStyleThin;

        [ priSplitInspectorViewController_ addSplitViewItem: self.singleContentTitleSectionItem_ ];
        [ priSplitInspectorViewController_ addSplitViewItem: self.singleContentActionSectionItem_ ];
        [ priSplitInspectorViewController_ addSplitViewItem: self.singleContentDescriptionSectionItem_ ];
        [ priSplitInspectorViewController_ addSplitViewItem: self.singleContentInformationSectionItem_ ];
        }

    return priSplitInspectorViewController_;
    }

    // These guys used for feeding the split inspector view controller above
@synthesize singleContentTitleSectionItem_ = priSingleContentTitleSectionItem_;
- ( NSSplitViewItem* ) singleContentTitleSectionItem_
    {
    if ( !priSingleContentTitleSectionItem_ )
        priSingleContentTitleSectionItem_ = [ NSSplitViewItem splitViewItemWithViewController: self.wrapperOfSingleContentTitleSectionView_ ];

    return priSingleContentTitleSectionItem_;
    }

@synthesize singleContentActionSectionItem_ = priSingleContentActionSectionItem_;
- ( NSSplitViewItem* ) singleContentActionSectionItem_
    {
    if ( !priSingleContentActionSectionItem_ )
        priSingleContentActionSectionItem_ = [ NSSplitViewItem splitViewItemWithViewController: self.wrapperOfSingleContentActionSectionView_ ];

    return priSingleContentActionSectionItem_;
    }

@synthesize singleContentDescriptionSectionItem_ = priSingleContentDescriptionSectionItem_;
- ( NSSplitViewItem* ) singleContentDescriptionSectionItem_
    {
    if ( !priSingleContentDescriptionSectionItem_ )
        priSingleContentDescriptionSectionItem_ = [ NSSplitViewItem splitViewItemWithViewController: self.wrapperOfSingleContentDescriptionSectionView_ ];

    return priSingleContentDescriptionSectionItem_;
    }

@synthesize singleContentInformationSectionItem_ = priSingleContentInformationSectionItem_;
- ( NSSplitViewItem* ) singleContentInformationSectionItem_
    {
    if ( !priSingleContentInformationSectionItem_ )
        priSingleContentInformationSectionItem_ = [ NSSplitViewItem splitViewItemWithViewController: self.wrapperOfSingleContentInformationSectionView_ ];

    return priSingleContentInformationSectionItem_;
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



// ------------------------------------------------------------------------------------------------------------ //



@interface TauTextViewAttributedStringTransformer : NSValueTransformer
@end

@implementation TauTextViewAttributedStringTransformer

+ ( Class ) transformedValueClass
    {
    return [ NSAttributedString class ];
    }

- ( id ) transformedValue: ( id )_Value
    {
    return [ [ NSAttributedString alloc ] initWithString: _Value attributes:
        @{ NSFontAttributeName : [ NSFont fontWithName: @"Helvetica Neue Light" size: 11.f ]
         , NSForegroundColorAttributeName : [ NSColor grayColor ]
         } ];
    }

@end