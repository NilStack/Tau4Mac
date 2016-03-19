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

- ( void ) doAbstractContentViewInit_;

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
    [ self doAbstractContentViewInit_ ];
    }

#pragma mark - KVO Compliance

+ ( BOOL ) accessInstanceVariablesDirectly
    {
    return NO;
    }

#pragma mark - KVO Observable External Properties

@synthesize viewsStack;
@dynamic activedSubViewController;
+ ( NSSet <NSString*>* ) keyPathsForValuesAffectingActivedSubViewController
    {
    return [ NSSet setWithObjects: @"viewsStack.currentView", nil ];
    }

- ( NSViewController <TauContentSubViewController>* ) activedSubViewController
    {
    return ( NSViewController <TauContentSubViewController>* )( self.viewsStack.currentView );
    }

#pragma mark - Private

// Invoked in viewDidLoad
- ( void ) doAbstractContentViewInit_
    {
    self.viewsStack = [ [ TauViewsStack alloc ] init ];

    selfObservKVOController_ = [ [ FBKVOController alloc ] initWithObserver: self ];
    [ selfObservKVOController_ observe: self
                               keyPath: activedSubViewController_kvoKey
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
            [ old removeFromParentViewController ];
            [ old.view removeFromSuperview ];

            if ( activedPinEdgesCache_ )
                {
                [ self.view removeConstraints: activedPinEdgesCache_ ];
                activedPinEdgesCache_ = nil;
                }
            }

        if ( new && ( ( __bridge void* )new != ( __bridge void* )[ NSNull null ] ) )
            {
            [ self addChildViewController: new ];
            [ self.view addSubview: new.view ];
            activedPinEdgesCache_ = [ new.view autoPinEdgesToSuperviewEdges ];
            }
        else
            DDLogUnexpected( @"Unexpected new value: {%@}", new );
        } ];
    }

@end // TauAbstractContentViewController class