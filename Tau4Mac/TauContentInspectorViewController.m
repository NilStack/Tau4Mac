//
//  TauContentInspectorViewController.m
//  Tau4Mac
//
//  Created by Tong G. on 3/23/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauContentInspectorViewController.h"
#import "TauContentInspectorCandidates.h"

#import "TauYouTubeContentInspector.h"

// Private
@interface TauContentInspectorViewController ()

@property ( weak, readonly ) NSView* activedSelectionSubView_;

@property ( weak ) IBOutlet TauContentInspectorNoSelectionCandidate* noSelectionCandidate_;
@property ( weak ) IBOutlet TauContentInspectorSingleSelectionCandidate* singleSelectionCandidate_;
@property ( weak ) IBOutlet TauContentInspectorMultipleSelectionsCandidate* multipleSelectionCandidate_;

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

- ( NSView* ) selectionSubViewWithMode_: ( TauContentInspectorMode )_Mode
    {
    switch ( _Mode )
        {
        case TauContentInspectorNoSelectionMode: return [ self.noSelectionCandidate_ configureForAutoLayout ];
        case TauContentInspectorSingleSelectionMode: return [ self.singleSelectionCandidate_ configureForAutoLayout ];
        case TauContentInspectorMultipleSelectionsMode: return [ self.multipleSelectionCandidate_ configureForAutoLayout ];
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

    return cnt ? ( ( cnt == 1 ) ? TauContentInspectorSingleSelectionMode : TauContentInspectorMultipleSelectionsMode )
               : TauContentInspectorNoSelectionMode;
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