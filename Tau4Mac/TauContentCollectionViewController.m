//
//  TauContentCollectionViewController.m
//  Tau4Mac
//
//  Created by Tong G. on 3/22/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauContentCollectionViewController.h"
#import "TauContentInspectorViewController.h"
#import "TauContentCollectionItem.h"
#import "TauNormalFlowLayout.h"

// PriHasSelectedTransformer_ class
@interface PriHasSelectedTransformer_ : NSValueTransformer
@end

@implementation PriHasSelectedTransformer_

+ ( Class ) transformedValueClass
    {
    return [ NSNumber class ];
    }

- ( id ) transformedValue: ( id )_Value
    {
    return [ NSNumber numberWithNegateBool: [ ( NSArray* )_Value count ] == 1 ];
    }

@end // PriHasSelectedTransformer_ class



// ------------------------------------------------------------------------------------------------------------ //



// Private
@interface TauContentCollectionViewController ()

@property ( weak ) IBOutlet NSCollectionView* contentCollectionView_;

/*************** Embedding the split view controller ***************/

@property ( weak ) IBOutlet NSSplitViewController* splitViewController_;

// Wrapped guys above in xib for ease the feed of self.splitViewController_ (instance of NSSplitViewController)
@property ( strong, readonly ) NSSplitViewItem* contentCollectionSplitViewItem_;
@property ( strong, readonly ) NSSplitViewItem* contentInspectorSplitViewItem_;

// Feeding the split view items above
@property ( weak ) IBOutlet NSViewController* wrapperOfContentCollectionView_;
@property ( weak ) IBOutlet TauContentInspectorViewController* wrapperOfContentInspectorView_;

/***/

// Internal Actions

- ( void ) controlInspectorAction_: ( NSButton* )_Sender;

@end // Private



// ------------------------------------------------------------------------------------------------------------ //



// TauContentCollectionViewController class
@implementation TauContentCollectionViewController

#pragma mark - Initializations

NSString static* const kContentCollectionItemID = @"kContentCollectionItemID";

- ( void ) viewDidLoad
    {
    // Registering for data source of collection view
    [ self.contentCollectionView_ registerClass: [ TauContentCollectionItem class ] forItemWithIdentifier: kContentCollectionItemID ];
    [ self.contentCollectionView_ setCollectionViewLayout: [ [ TauNormalFlowLayout alloc ] init ] ];

    // Embeding the split view controller
    // Required setting up done in the IB Identity insepector
    NSSplitViewController* splitViewController = self.splitViewController_;
    [ splitViewController addSplitViewItem: self.contentCollectionSplitViewItem_ ];
    [ splitViewController addSplitViewItem: self.contentInspectorSplitViewItem_ ];

    [ self addChildViewController: splitViewController ];
    [ self.view addSubview: [ splitViewController.view configureForAutoLayout ] ];
    [ splitViewController.view autoPinEdgesToSuperviewEdges ];

    // Estanlishing bindings between inspector view and myself
    [ self.wrapperOfContentInspectorView_
            bind: TauKVOStrictKey( ytContents )
        toObject: self
     withKeyPath: TauKVOStrictKey( selectedItems )
         options: nil ];

    TauMutuallyBind( self, TauKVOStrictKey( inspectorCollapsed )
                   , self.contentInspectorSplitViewItem_, TauKVOStrictClassKeyPath( NSSplitViewItem, collapsed ) );

    //???: Automatically show/hide inspector
    //    [ self bind: TauKVOStrictKey( inspectorCollapsed )
    //       toObject: self
    //    withKeyPath: TauKVOStrictKey( selectedItems )
    //        options: @{ NSValueTransformerNameBindingOption : @"PriHasSelectedTransformer_" } ];

    [ self setInspectorCollapsed: NO ];
    }

TauDeallocBegin
    // Get rid of bindings
    [ self.wrapperOfContentInspectorView_ unbind: TauKVOStrictKey( ytContents ) ];

    TauMutuallyUnbind( self, TauKVOStrictKey( inspectorCollapsed )
                     , self.contentInspectorSplitViewItem_, TauKVOStrictClassKeyPath( NSSplitViewItem, collapsed )
                     );
TauDeallocEnd

@synthesize controlInspectorButton = priControlInspectorButton_;
- ( NSButton* ) controlInspectorButton
    {
    if ( !priControlInspectorButton_ )
        {
        priControlInspectorButton_ = [ [ NSButton alloc ] initWithFrame: NSMakeRect( 0, 0, 30.f, 29.f ) ];

        [ priControlInspectorButton_ setButtonType: NSToggleButton ];
        [ priControlInspectorButton_ setIdentifier: @"fucking-button" ];
        [ priControlInspectorButton_ setKeyEquivalent: @"0" ];
        [ priControlInspectorButton_ setKeyEquivalentModifierMask: NSAlternateKeyMask | NSCommandKeyMask ];

        [ priControlInspectorButton_ setTarget: self ];
        [ priControlInspectorButton_ setAction: @selector( controlInspectorAction_: ) ];

        NSImage* icon = [ NSImage imageNamed: @"tau-show-details-inspector" ];
        [ icon setSize: NSMakeSize( 13.f, 12.f ) ];
        [ icon setTemplate: YES ];

        [ priControlInspectorButton_ setBezelStyle: NSTexturedRoundedBezelStyle ];
        [ priControlInspectorButton_ setImage: icon ];
        [ priControlInspectorButton_ setImagePosition: NSImageOnly ];
        }

    return priControlInspectorButton_;
    }

@synthesize inspectorCollapsed = inspectorCollapsed_;
+ ( BOOL ) automaticallyNotifiesObserversOfInspectorCollapsed
    {
    return NO;
    }

- ( void ) setInspectorCollapsed: ( BOOL )_Flag
    {
    TauChangeValueForKVOStrictKey( inspectorCollapsed,
     ( ^{
        inspectorCollapsed_ = _Flag;
        [ self.controlInspectorButton setState: ( NSCellStateValue )!inspectorCollapsed_ ];
        } ) );
    }

- ( BOOL ) inspectorCollapsed
    {
    return inspectorCollapsed_;
    }

#pragma mark - Relay the Model Data

// Relay the model data from hosting content view controller to the internal collection view

- ( void ) reloadData
    {
    [ self.contentCollectionView_ reloadData ];
    }

#pragma mark - Relay the Controllers & Views State

@dynamic selectionIndexPaths;
+ ( NSSet <NSString*>* ) keyPathsForValuesAffectingSelectionIndexPaths
    {
    return [ NSSet setWithObjects: @"contentCollectionView_.selectionIndexPaths", nil ];
    }

- ( NSSet <NSIndexPath*>* ) selectionIndexPaths
    {
    return self.contentCollectionView_.selectionIndexPaths;
    }

- ( void ) setSelectionIndexPaths: ( NSSet <NSIndexPath*>* )_New
    {
    [ self.contentCollectionView_ setSelectionIndexPaths: _New ];
    }

@dynamic selectedItems;
+ ( NSSet <NSString*>* ) keyPathsForValuesAffectingSelectedItems
    {
    return [ NSSet setWithObjects: TauKVOStrictKey( selectionIndexPaths ), nil ];
    }

// In order to produce an unique array,
// result array will be derived from an internal ordered set,
- ( NSArray <NSCollectionViewItem*>* ) selectedItems
    {
    NSMutableOrderedSet* result = nil;

    TauAbstractResultCollection* relayedDataModel = [ self.relayDataSource contentCollectionViewRequiredData: self ];

    NSSet <NSIndexPath*>* newIndexPaths = self.selectionIndexPaths;

    // Extracting the corresponding model items
    // FIXME: this implementation should take into account both the sections and indexes within an index path
    for ( NSIndexPath* _IndexPath in newIndexPaths )
        {
        NSRange indexRange = NSMakeRange( 0, _IndexPath.length );
        NSUInteger* indexesBuffer = malloc( sizeof ( NSUInteger ) * indexRange.length );
        [ _IndexPath getIndexes: indexesBuffer range: NSMakeRange( 0, indexRange.length ) ];

        for ( int _Index = 0; _Index < indexRange.length; _Index++ )
            {
            if ( _Index == ( indexRange.length - 1 ) )
                {
                // Lazy initialization
                if ( !result )
                    result = [ NSMutableOrderedSet orderedSet ];

                [ result addObject: [ relayedDataModel.items objectAtIndex: indexesBuffer[ _Index ] ] ];
                }
            }

        free( indexesBuffer );
        }

    return result ? [ result array ] : @[];
    }

#pragma mark - Conforms to <NSCollectionViewDataSource>

- ( NSInteger ) numberOfSectionsInCollectionView: ( NSCollectionView* )_CollectionView
    {
    return 1;
    }

- ( NSInteger ) collectionView: ( NSCollectionView* )_CollectionView numberOfItemsInSection: ( NSInteger )_Section
    {
    return [ [ self.relayDataSource contentCollectionViewRequiredData: self ] count ];
    }

- ( NSCollectionViewItem* ) collectionView: ( NSCollectionView* )_CollectionView itemForRepresentedObjectAtIndexPath: ( NSIndexPath* )_IndexPath
    {
    NSCollectionViewItem* item = [ _CollectionView makeItemWithIdentifier: kContentCollectionItemID forIndexPath: _IndexPath ];
    item.representedObject = [ [ self.relayDataSource contentCollectionViewRequiredData: self ].items objectAtIndex: [ _IndexPath item ] ];
    return item;
    }

#pragma mark - Conforms to <NSCollectionViewDelegate>
// TODO:

#pragma mark - Conforms to <NSCollectionViewDelegateFlowLayout>
// TODO;

#pragma mark - Private

@synthesize contentCollectionSplitViewItem_ = priContentCollectionSplitViewItem_;
@synthesize contentInspectorSplitViewItem_ = priContentInspectorSplitViewItem_;

- ( NSSplitViewItem* ) contentCollectionSplitViewItem_
    {
    if ( !priContentCollectionSplitViewItem_ )
        {
        priContentCollectionSplitViewItem_ = [ NSSplitViewItem splitViewItemWithViewController: self.wrapperOfContentCollectionView_ ];
        [ priContentCollectionSplitViewItem_ setCanCollapse: NO ];

        /***/
        [ priContentCollectionSplitViewItem_ setMinimumThickness: TauVideoLayoutItemWidth + 65.f ];
        }

    return priContentCollectionSplitViewItem_;
    }

- ( NSSplitViewItem* ) contentInspectorSplitViewItem_
    {
    if ( !priContentInspectorSplitViewItem_ )
        {
        priContentInspectorSplitViewItem_ = [ NSSplitViewItem contentListWithViewController: self.wrapperOfContentInspectorView_ ];
        [ priContentInspectorSplitViewItem_ setCanCollapse: YES ];

        // TODO: Animate collapsed property of priContentInspectorSplitViewItem_
        //        CATransition* trans = [ [ CATransition alloc ] init ];
        //        [ trans setDuration: 2.f ];
        //        [ trans setType: kCATransitionMoveIn ];
        //        [ trans setSubtype: kCATransitionFromRight ];
        //        [ trans setStartProgress: 0.f ];
        //        [ trans setEndProgress: 1.f ];
        //        [ priContentInspectorSplitViewItem_ setAnimations: @{ @"collapsed" : trans } ];

        /***/
        [ priContentInspectorSplitViewItem_ setMaximumThickness: 600.f ];
        [ priContentInspectorSplitViewItem_ setMinimumThickness:
            TAU_APP_MIN_WIDTH - self.contentCollectionSplitViewItem_.minimumThickness - self.splitViewController_.splitView.dividerThickness ];
        }

    return priContentInspectorSplitViewItem_;
    }

// Internal Actions

- ( void ) controlInspectorAction_: ( NSButton* )_Sender
    {
    NSLog( @"%@", [ priContentInspectorSplitViewItem_ animations ] );
    [ self setInspectorCollapsed : ![ _Sender state ] ];
    }

@end // TauContentCollectionViewController class