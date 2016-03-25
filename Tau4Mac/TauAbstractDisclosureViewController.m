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

// Init

- ( void ) doAbstractInit_;

@end // Private

// TauAbstractDisclosureViewController class
@implementation TauAbstractDisclosureViewController
    {
    // Layout constraints cache
    NSMutableArray __strong* layoutConstraintsCache_;
    }

#pragma mark - Initializations

- ( instancetype ) initWithNibName: ( NSString* )_NibNameOrNil bundle: ( NSBundle* )_NibBundleOrNil
    {
    if ( self = [ super initWithNibName: _NibNameOrNil bundle: _NibBundleOrNil ] )
        [ self doAbstractInit_ ];
    return self;
    }

- ( instancetype ) initWithCoder: ( NSCoder* )_Coder
    {
    if ( self = [ super initWithCoder: _Coder ] )
        [ self doAbstractInit_ ];
    return self;
    }

- ( void ) viewDidLoad
    {
    [ super viewDidLoad ];

    [ [ self.headerView_ configureForAutoLayout ] setWantsLayer: YES ];
    [ [ self.headerView_ layer ] setBackgroundColor: [ NSColor controlColor ].CGColor ];
    }

#pragma mark - Overrides

- ( void ) setTitle: ( NSString* )_Title
    {
    [ super setTitle: _Title ];
    [ self.descField_ setStringValue: _Title ?: @"" ];
    }

#pragma mark - Actions

- ( IBAction ) toggleDisclosureAction: ( NSButton* )_Sender
    {
    self.isDisclosed = !isDisclosed_;
    }

#pragma mark - External KVB Compliant Properties

@synthesize showsHeader = showsHeader_;
+ ( BOOL ) automaticallyNotifiesObserversOfShowsHeader
    {
    return NO;
    }

- ( void ) setShowsHeader: ( BOOL )_Flag
    {
    if ( showsHeader_ != _Flag )
        {
        TAU_CHANGE_VALUE_FOR_KEY_of_SEL( @selector( showsHeader ),
         ( ^{
            showsHeader_ = _Flag;
            [ self setDisclosedView: disclosedView_ ];
            } ) );
        }
    }

- ( BOOL ) showsHeader
    {
    return showsHeader_;
    }

@dynamic toggleButtonTitle;
- ( NSString* ) toggleButtonTitle
    {
    return NSLocalizedString( @"Hide", @"Default toggel button title" );
    }

@dynamic toggleButtonAlternativeTitle;
- ( NSString* ) toggleButtonAlternativeTitle
    {
    return NSLocalizedString( @"Show", @"Default alternative toggel button title" );
    }

@synthesize isDisclosed = isDisclosed_;
+ ( BOOL ) automaticallyNotifiesObserversOfisDisclosed
    {
    return NO;
    }

- ( void ) setDisclosed: ( BOOL )_Flag
    {
    if ( isDisclosed_ == _Flag )
        return;

    TAU_CHANGE_VALUE_FOR_KEY_of_SEL( @selector( isDisclosed ),
     ( ^{
        isDisclosed_ = _Flag;

        if ( isDisclosed_ )
            {
            CGFloat distanceFromHeaderToBottom = -( NSHeight( disclosedView_.frame ) );

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
            ^( NSAnimationContext* _Ctx )
                {
                _Ctx.timingFunction = [ CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut ];

                // Animate the closing constraint to 0, causing the bottom of the header to be flush with the bottom of the overall disclosure view.
                self.closingConstraint.animator.constant = 0.f;
                self.toggelButton_.title = self.toggleButtonAlternativeTitle;
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
            ^( NSAnimationContext* _Ctx )
                {
                _Ctx.timingFunction = [ CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut ];

                // Animate the constraint to fit the disclosed view again
                // FIXME: NSHeight( disclosedView_.frame ) results in a wrong number (only be 0)
                self.closingConstraint.animator.constant -= NSHeight( disclosedView_.frame );
                self.toggelButton_.title = self.toggleButtonTitle;
                }

            completionHandler:
            ^( void )
                {
                DDLogDebug( @"Finished animation of \"consant\" property within {%@}", self.closingConstraint );

                // The constraint is no longer needed, we can remove it.
                [ self.view removeConstraint: self.closingConstraint ];
                } ];
            }
        } ) );
    }

- ( BOOL ) isDisclosed
    {
    return isDisclosed_;
    }

#pragma mark - Private

@synthesize headerView_;

@synthesize disclosedView = disclosedView_;
- ( void ) setDisclosedView: ( NSView* )_New
    {
    disclosedView_ = _New;
    [ self embedView_: disclosedView_ ];
    }

- ( void ) embedView_: ( NSView* )_View
    {
    if ( layoutConstraintsCache_.count > 0 )
        {
        [ self.view removeConstraints: layoutConstraintsCache_ ];
        [ layoutConstraintsCache_ removeAllObjects ];
        }

    [ self.disclosedView removeFromSuperview ];

    NSView* embedingView = self.disclosedView;
    [ self.view addSubview: [ embedingView configureForAutoLayout ] ];

    embedingView.wantsLayer = YES;
    embedingView.layer.backgroundColor = [ NSColor whiteColor ].CGColor;

    NSDictionary* viewsDict = NSDictionaryOfVariableBindings( headerView_, embedingView );

    [ layoutConstraintsCache_ addObjectsFromArray: [ NSLayoutConstraint constraintsWithVisualFormat: @"H:|[embedingView(>=0)]|" options: 0 metrics: nil views: viewsDict ] ];
    [ layoutConstraintsCache_ addObjectsFromArray: [ NSLayoutConstraint constraintsWithVisualFormat: [ NSString stringWithFormat: @"V:|%@[embedingView(>=0)]|", showsHeader_ ? @"[headerView_]" : @"" ] options: 0 metrics: nil views: viewsDict ] ];

    // add an optional constraint (but with a priority stronger than a drag), that the disclosing view
    [ layoutConstraintsCache_ addObjectsFromArray: [ NSLayoutConstraint constraintsWithVisualFormat: @"V:[embedingView]-(0@priority)-|" options: 0 metrics: @{ @"priority" : @( NSLayoutPriorityDefaultHigh ) } views: viewsDict ] ];

    [ self.view addConstraints: layoutConstraintsCache_ ];
    }

- ( NSView* ) disclosedView
    {
    return disclosedView_;
    }

// Init

- ( void ) doAbstractInit_
    {
    // Setting up the default values.
    // Bypassed the KVC, KVO and KVB mechanism
    isDisclosed_ = NO;
    showsHeader_ = YES;

    layoutConstraintsCache_ = [ NSMutableArray array ];
    }

@end // TauAbstractDisclosureViewController class