//
//  TauAbstractDisclosureViewController.m
//  Tau4Mac
//
//  Created by Tong G. on 3/24/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauAbstractDisclosureViewController.h"

// Private
@interface TauAbstractDisclosureViewController ()

@property ( weak ) IBOutlet NSView* headerView_;

@end // Private

// TauAbstractDisclosureViewController class
@implementation TauAbstractDisclosureViewController

#pragma mark - Initializations

- ( void ) viewDidLoad
    {
    [ super viewDidLoad ];

    [ [ self.headerView_ configureForAutoLayout ] setWantsLayer: YES ];
    [ [ self.headerView_ layer ] setBackgroundColor: [ NSColor lightGrayColor ].CGColor ];
    }

@synthesize headerView_;
@synthesize disclosedView = disclosedView_;
- ( void ) setDisclosedView: ( NSView* )_New
    {
    if ( disclosedView_ != _New )
        {
        [ self.disclosedView removeFromSuperview ];
        disclosedView_ = _New;
        [ self.view addSubview: [ disclosedView_ configureForAutoLayout ] ];

        disclosedView_.wantsLayer = YES;
        disclosedView_.layer.backgroundColor = [ NSColor whiteColor ].CGColor;

        [ self.view addConstraints:
            [ NSLayoutConstraint constraintsWithVisualFormat: @"H:|[disclosedView_]|"
                                                     options: 0
                                                     metrics: nil
                                                       views: NSDictionaryOfVariableBindings( disclosedView_ ) ] ];

        [ self.view addConstraints:
            [ NSLayoutConstraint constraintsWithVisualFormat: @"V:[headerView_][disclosedView_]"
                                                     options: 0
                                                     metrics: nil
                                                       views: NSDictionaryOfVariableBindings( headerView_, disclosedView_ ) ] ];

        // add an optional constraint (but with a priority stronger than a drag), that the disclosing view
        [ self.view addConstraints:
            [ NSLayoutConstraint constraintsWithVisualFormat: @"V:[disclosedView_]-(0@priority)-|"
                                                     options: 0
                                                     metrics: @{ @"priority" : @( NSLayoutPriorityDefaultHigh ) }
                                                       views: NSDictionaryOfVariableBindings( disclosedView_ ) ] ];
        }
    }

- ( NSView* ) disclosedView
    {
    return disclosedView_;
    }

@end // TauAbstractDisclosureViewController class