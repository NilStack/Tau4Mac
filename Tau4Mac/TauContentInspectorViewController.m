//
//  TauContentInspectorViewController.m
//  Tau4Mac
//
//  Created by Tong G. on 3/23/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauContentInspectorViewController.h"
#import "TauContentInspectorSubViews.h"

// Private
@interface TauContentInspectorViewController ()

@property ( weak, readonly ) NSView* activedSelectionSubView_;

@property ( weak ) IBOutlet TauContentInspectorNoSelectionSubView* noSelectionSubView_;
@property ( weak ) IBOutlet TauContentInspectorSingleSelectionSubView* singleSelectionSubView_;
@property ( weak ) IBOutlet TauContentInspectorMultipleSelectionsSubView* multipleSelectionSubView_;

@property ( weak ) IBOutlet NSArrayController* ytContentModelController_;

@property ( strong, readonly ) FBKVOController* selfObservController_;

@end // Private



// ------------------------------------------------------------------------------------------------------------ //



// TauContentInspectorViewController class
@implementation TauContentInspectorViewController
    {
    // Layout Constraints Cache
    NSArray <NSLayoutConstraint*>* inspectorSubViewPinEdgesCache_;
    }

TauDeallocBegin
TauDeallocEnd

#pragma mark - Initializations

- ( void ) viewDidLoad
    {
    [ super viewDidLoad ];
    }

- ( NSView* ) selectionSubViewWithMode_: ( TauContentInspectorMode )_Mode
    {
    switch ( _Mode )
        {
        case TauContentInspectorNoSelectionMode: return [ self.noSelectionSubView_ configureForAutoLayout ];
        case TauContentInspectorSingleSelectionMode: return [ self.singleSelectionSubView_ configureForAutoLayout ];
        case TauContentInspectorMultipleSelectionsMode: return [ self.multipleSelectionSubView_ configureForAutoLayout ];
        }
    }

- ( void ) viewDidAppear
    {
    // Established a fucking retain-circle through the self-observing.
    // Will break it in viewDidDisappear
    [ self.selfObservController_ observe: self keyPath: TauKVOStrictKey( mode )
                                 options: NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld | NSKeyValueObservingOptionInitial
                                   block:
    ^( id _Nullable _Observer, id _Nonnull _Object, NSDictionary <NSString*, id>* _Nonnull _Change )
        {
        TauContentInspectorMode newMode = ( TauContentInspectorMode )( [ _Change[ NSKeyValueChangeNewKey ] integerValue ] );
        TauContentInspectorMode oldMode = ( TauContentInspectorMode )( [ _Change[ NSKeyValueChangeOldKey ] integerValue ] );

        if ( newMode != oldMode )
            {
            NSView* oldView = [ self selectionSubViewWithMode_: oldMode ];
            [ oldView removeFromSuperview ];

            if ( inspectorSubViewPinEdgesCache_.count > 0 )
                {
                [ self.view removeConstraints: inspectorSubViewPinEdgesCache_ ];
                inspectorSubViewPinEdgesCache_ = nil;
                }
            }

//        NSLog( @"New: %ld vs. Old: %ld", newMode, oldMode );

        if ( newMode == TauContentInspectorSingleSelectionMode )
            [ self.activedSelectionSubView_ setValue: self.YouTubeContents.firstObject forKey: @"YouTubeContent" ];

        [ self.view addSubview: self.activedSelectionSubView_ ];
        inspectorSubViewPinEdgesCache_ = [ self.activedSelectionSubView_ autoPinEdgesToSuperviewEdges ];
        } ];
    }

- ( void ) viewDidDisappear
    {
    // Break the retain-circle causing by the self-observing
    [ self.selfObservController_ unobserve: self keyPath: TauKVOStrictKey( mode ) ];
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

@dynamic mode;
+ ( NSSet <NSString*>* ) keyPathsForValuesAffectingMode
    {
    return [ NSSet setWithObjects: TauKVOStrictKey( YouTubeContents ), nil ];
    }

- ( TauContentInspectorMode ) mode
    {
    NSUInteger cnt = YouTubeContents_.count;

    if ( !cnt )
        return TauContentInspectorNoSelectionMode;
    else if ( cnt == 1 )
        return TauContentInspectorSingleSelectionMode;
    else
        return TauContentInspectorMultipleSelectionsMode;
    }

@synthesize selfObservController_ = priSelfObservController_;
- ( FBKVOController* ) selfObservController_
    {
    if ( !priSelfObservController_ )
        priSelfObservController_ = [ [ FBKVOController alloc ] initWithObserver: self retainObserved: NO ];
    return priSelfObservController_;
    }

#pragma mark - Private

@dynamic activedSelectionSubView_;
- ( NSView* ) activedSelectionSubView_
    {
    return [ self selectionSubViewWithMode_: self.mode ];
    }

@end // TauContentInspectorViewController class



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