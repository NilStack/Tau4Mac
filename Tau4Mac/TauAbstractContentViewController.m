//
//  TauAbstractContentViewController.m
//  Tau4Mac
//
//  Created by Tong G. on 3/17/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauAbstractContentViewController.h"
#import "TauViewsStack.h"

// Private
@interface TauAbstractContentViewController ()

@property ( strong, readwrite ) TauViewsStack* viewsStack;

- ( void ) doAbstractInit_;

@end // Private



// ------------------------------------------------------------------------------------------------------------ //



// TauAbstractContentViewController class
@implementation TauAbstractContentViewController
    {
    FBKVOController __strong* selfObservKVOController_;
    }

#pragma mark - Initializations

- ( instancetype ) initWithCoder: ( NSCoder* )_Coder
    {
    if ( self = [ super initWithCoder: _Coder ] )
        ;
    return self;
    }

- ( instancetype ) initWithNibName: ( NSString* )_NibNameOrNil bundle: ( NSBundle* )_NibBundleOrNil
    {
    if ( self = [ super initWithNibName: _NibNameOrNil bundle: _NibBundleOrNil ] )
        ;
    return self;
    }

// Instances of subclasses have to override this method
// to assign the initial backgroundViewController of viewsStack property
- ( void ) viewDidLoad
    {
    [ super viewDidLoad ];

    self.view.wantsLayer = YES;
    self.view.layer.backgroundColor = [ NSColor whiteColor ].CGColor;

    [ self.view configureForAutoLayout ];
    [ self.view autoSetDimension: ALDimensionWidth toSize: 0 relation: NSLayoutRelationGreaterThanOrEqual ];
    [ self.view autoSetDimension: ALDimensionHeight toSize: 0 relation: NSLayoutRelationGreaterThanOrEqual ];

    // self-observe the "activedSubViewController" key,
    // which will be affected by "viewsStack.currentView" => "viewsStack.backgroundViewController",
    // in this internal method
    [ self doAbstractInit_ ];
    }

#pragma mark - KVO Compliance

+ ( BOOL ) accessInstanceVariablesDirectly
    {
    return NO;
    }

#pragma mark - KVO Observable External Properties

@synthesize viewsStack;

@dynamic backgroundViewController;
- ( NSViewController <TauContentSubViewController>* ) backgroundViewController
    {
    return ( NSViewController <TauContentSubViewController>* )( self.viewsStack.backgroundViewController );
    }

- ( void ) setBackgroundViewController: ( NSViewController <TauContentSubViewController>* )_New
    {
    NSViewController* currentBg = [ [ self viewsStack ] backgroundViewController ];
    if ( currentBg )
        {
        NSUInteger index = [ self.childViewControllers indexOfObject: currentBg ];
        if ( index != NSNotFound )
            [ self removeChildViewControllerAtIndex: index ];
        }

    [ self addChildViewController: _New ];
    [ self.viewsStack setBackgroundViewController: _New ];
    }

@dynamic activedSubViewController;
+ ( NSSet <NSString*>* ) keyPathsForValuesAffectingActivedSubViewController
    {
    return [ NSSet setWithObjects: TauKVOStrictClassKeyPath( TauAbstractContentViewController, viewsStack.currentView ) , nil ];
    }

- ( NSViewController <TauContentSubViewController>* ) activedSubViewController
    {
    return ( NSViewController <TauContentSubViewController>* )( self.viewsStack.currentView );
    }

#pragma mark - View Stack Operations

- ( void ) pushContentSubView: ( NSViewController <TauContentSubViewController>* )_New
    {
    [ self.viewsStack.currentView addChildViewController: _New ];
    [ self.viewsStack pushView: _New ];
    }

- ( void ) popContentSubView
    {
    NSViewController* current = [ [ self viewsStack ] currentView ];
    NSViewController* beforeCurrent = [ [ self viewsStack ] viewBeforeCurrentView ];

    NSUInteger childIndex = [ beforeCurrent.childViewControllers indexOfObject: current ];
    [ beforeCurrent removeChildViewControllerAtIndex: childIndex ];

    [ self.viewsStack popView ];
    }

#pragma mark - Private

// Invoked in viewDidLoad
- ( void ) doAbstractInit_
    {
    self.viewsStack = [ [ TauViewsStack alloc ] init ];

    // FIXME: Potential memory leak caused by self-observing
    selfObservKVOController_ = [ [ FBKVOController alloc ] initWithObserver: self retainObserved: NO ];
    [ selfObservKVOController_ observe: self
                               keyPath: TauKVOStrictKey( activedSubViewController )
                               /* value of "activedSubViewController" key will be set in implementation of subclasses, 
                                * so we don't need the NSKeyValueObservingOptionInitial option here */
                               options: NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                                 block:
    ^( id _Nullable _Observer, id _Nonnull _Object, NSDictionary <NSString*, id>* _Nonnull _Change )
        {
        NSViewController <TauContentSubViewController>* new = _Change[ NSKeyValueChangeNewKey ];
        NSViewController <TauContentSubViewController>* old = _Change[ NSKeyValueChangeOldKey ];

        if ( old && ( ( __bridge void* )old != ( __bridge void* )[ NSNull null ] ) )
            {
            [ old.view removeFromSuperview ];

            if ( activedPinEdgesCache_ )
                {
                [ self.view removeConstraints: activedPinEdgesCache_ ];
                activedPinEdgesCache_ = nil;
                }
            }

        if ( new && ( ( __bridge void* )new != ( __bridge void* )[ NSNull null ] ) )
            {
            [ new.view setWantsLayer: YES ];
            [ self.view addSubview: [ new.view configureForAutoLayout ] ];
            activedPinEdgesCache_ = [ new.view autoPinEdgesToSuperviewEdges ];
            }
        else
            DDLogUnexpected( @"Unexpected new value: {%@}", new );
        } ];
    }

@end // TauAbstractContentViewController class