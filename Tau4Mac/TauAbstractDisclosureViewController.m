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

@property ( weak ) IBOutlet NSTextField* descField_;
@property ( weak ) IBOutlet NSButton* toggelButton_;

@property ( strong, readwrite ) NSLayoutConstraint* closingConstraint;   // layout constraint applied to this view controller when closed

@end // Private

// TauAbstractDisclosureViewController class
@implementation TauAbstractDisclosureViewController

#pragma mark - Initializations

- ( instancetype ) initWithNibName: ( NSString* )_NibNameOrNil bundle: ( NSBundle* )_NibBundleOrNil
    {
    if ( self = [ super initWithNibName: _NibNameOrNil bundle: _NibBundleOrNil ] )
        isDisclosureVisible_ = YES;
    return self;
    }

- ( instancetype ) initWithCoder: ( NSCoder* )_Coder
    {
    if ( self = [ super initWithCoder: _Coder ] )
        isDisclosureVisible_ = YES;
    return self;
    }

- ( void ) viewDidLoad
    {
    [ super viewDidLoad ];

    [ [ self.headerView_ configureForAutoLayout ] setWantsLayer: YES ];
    [ [ self.headerView_ layer ] setBackgroundColor: [ NSColor controlColor ].CGColor ];
    }

- ( void ) setTitle: ( NSString* )_Title
    {
    [ super setTitle: _Title ];
    [ self.descField_ setStringValue: _Title ?: @"" ];
    }

@synthesize isDisclosureVisible = isDisclosureVisible_;
+ ( BOOL ) automaticallyNotifiesObserversOfisDisclosureVisible
    {
    return NO;
    }

- ( void ) setDisclosureVisible: ( BOOL )_Flag
    {
    if ( isDisclosureVisible_ != _Flag )
        {
//        TAU_CHANGE_VALUE_FOR_KEY_of_SEL( @selector( isDisclosureVisible ),
//         ( ^{
            isDisclosureVisible_ = _Flag;

            if ( !isDisclosureVisible_ )
                {
                CGFloat distanceFromHeaderToBottom = NSMinY( self.view.bounds ) - NSMinY( headerView_.frame );

                if ( !self.closingConstraint )
                    {
                    // The closing constraint is going to tie the bottom of the header view to the bottom of the overall disclosure view.
                    // Initially, it will be offset by the current distance, but we'll be animating it to 0.
                    self.closingConstraint =
                        [ NSLayoutConstraint constraintWithItem: headerView_
                                                      attribute: NSLayoutAttributeBottom
                                                      relatedBy: NSLayoutRelationEqual
                                                         toItem: self.view
                                                      attribute: NSLayoutAttributeBottom
                                                     multiplier: 1.f
                                                       constant: distanceFromHeaderToBottom ];
                    }

                self.closingConstraint.constant = distanceFromHeaderToBottom;
                [ self.view addConstraint: self.closingConstraint ];
            
                [ NSAnimationContext runAnimationGroup:
                ^( NSAnimationContext* _Context )
                    {
                    _Context.timingFunction = [ CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut ];

                    NSLog( @"🍉%@", NSStringFromRect( disclosedView_.frame ) );

                    // Animate the closing constraint to 0, causing the bottom of the header to be flush with the bottom of the overall disclosure view.
                    self.closingConstraint.animator.constant = 0;
                    NSLog( @"🍊%@", NSStringFromRect( disclosedView_.frame ) );
                    self.toggelButton_.title = @"Show";
                    }

                completionHandler:
                ^( void )
                    {
                    DDLogDebug( @"Finished animation of \"consant\" property within {%@}", self.closingConstraint );
                    } ];
                }
            else
                {
                [ NSAnimationContext runAnimationGroup:
                ^( NSAnimationContext* _Context )
                    {
                    _Context.timingFunction = [ CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut ];

                    // Animate the constraint to fit the disclosed view again
                    NSLog( @"%g", self.closingConstraint.animator.constant );
                    NSLog( @"%@", NSStringFromRect( disclosedView_.frame ) );
                    NSLog( @"%@", NSStringFromRect( [ self.view frameForAlignmentRect: disclosedView_.frame ] ) );
                    self.closingConstraint.animator.constant -= NSHeight( disclosedView_.frame );
//                    self.closingConstraint.animator.constant = 0.f;
                    self.toggelButton_.title = @"Hide";
                    }

                completionHandler:
                ^( void )
                    {
                    DDLogDebug( @"Finished animation of \"consant\" property within {%@}", self.closingConstraint );

                    // The constraint is no longer needed, we can remove it.
                    [ self.view removeConstraint: self.closingConstraint ];

                    NSLog( @"%g", NSHeight( disclosedView_.frame ) );
                    } ];
                }
//            } ) );
        }
    }

- ( BOOL ) isDisclosureVisible
    {
    return isDisclosureVisible_;
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

        NSDictionary* viewsDict = NSDictionaryOfVariableBindings( headerView_, disclosedView_ );

        [ self.view addConstraints:
            [ NSLayoutConstraint constraintsWithVisualFormat: @"H:|[disclosedView_(>=0)]|"
                                                     options: 0
                                                     metrics: nil
                                                       views: viewsDict ] ];

        [ self.view addConstraints:
            [ NSLayoutConstraint constraintsWithVisualFormat: @"V:|[headerView_][disclosedView_(>=0)]|"
                                                     options: 0
                                                     metrics: nil
                                                       views: viewsDict ] ];

        // add an optional constraint (but with a priority stronger than a drag), that the disclosing view
        [ self.view addConstraints:
            [ NSLayoutConstraint constraintsWithVisualFormat: @"V:[disclosedView_]-(0@priority)-|"
                                                     options: 0
                                                     metrics: @{ @"priority" : @( NSLayoutPriorityDefaultHigh ) }
                                                       views: viewsDict ] ];
        }
    }

- ( NSView* ) disclosedView
    {
    return disclosedView_;
    }

#pragma mark - Actions

- ( IBAction ) toggleDisclosureAction: ( NSButton* )_Sender
    {
    self.isDisclosureVisible = !isDisclosureVisible_;
    }

@end // TauAbstractDisclosureViewController class