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

- ( void ) doAbstractContentViewInit_;

@end // Private

// TauAbstractContentViewController class
@implementation TauAbstractContentViewController
    {
    NSViewController <TauContentSubViewController> __weak* activedSubViewController_;
    }

#pragma mark - Initializations

- ( instancetype ) initWithCoder: ( NSCoder* )_Coder
    {
    if ( self = [ super initWithCoder: _Coder ] )
        [ self doAbstractContentViewInit_ ];
    return self;
    }

- ( instancetype ) initWithNibName: ( NSString* )_NibNameOrNil bundle: ( NSBundle* )_NibBundleOrNil
    {
    if ( self = [ super initWithNibName: _NibNameOrNil bundle: _NibBundleOrNil ] )
        [ self doAbstractContentViewInit_ ];
    return self;
    }

#pragma mark - KVO Compliance

+ ( BOOL ) accessInstanceVariablesDirectly
    {
    return NO;
    }

#pragma mark - KVO Observable External Properties

@synthesize activedSubViewController = activedSubViewController_;
+ ( BOOL ) automaticallyNotifiesObserversOfActivedSubViewController
    {
    return NO;
    }

- ( void ) setActivedSubViewController: ( NSViewController <TauContentSubViewController>* )_New
    {
    if ( activedSubViewController_ != _New )
        {
        if ( activedSubViewController_ )
            {
            [ activedSubViewController_ removeFromParentViewController ];
            [ activedSubViewController_.view removeFromSuperview ];
            [ self.view removeConstraints: activedPinEdgesCache_ ];
            }

        [ self addChildViewController: _New ];
        [ self.view addSubview: _New.view ];
        activedPinEdgesCache_ = [ _New.view autoPinEdgesToSuperviewEdges ];

        [ self willChangeValueForKey: activedSubViewController_kvoKey ];
        activedSubViewController_ = _New;
        [ self didChangeValueForKey: activedSubViewController_kvoKey ];
        }
    }

- ( void ) viewDidLoad
    {
    [ super viewDidLoad ];

    self.view.wantsLayer = YES;
    self.view.layer.backgroundColor = [ NSColor whiteColor ].CGColor;

    [ self.view configureForAutoLayout ];
    [ self.view autoSetDimension: ALDimensionWidth toSize: TAU_APP_MIN_WIDTH relation: NSLayoutRelationGreaterThanOrEqual ];
    [ self.view autoSetDimension: ALDimensionHeight toSize: TAU_APP_MIN_HEIGHT relation: NSLayoutRelationGreaterThanOrEqual ];
    }

#pragma mark - Private

- ( void ) doAbstractContentViewInit_
    {
    viewsStack_ = [ [ TauViewsStack alloc ] init ];
    }

@end // TauAbstractContentViewController class