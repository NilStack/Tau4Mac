//
//  TauUserProfileViewController.m
//  Tau4Mac
//
//  Created by Tong G. on 3/11/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauUserProfileViewController.h"

#import "GTL/GTMOAuth2Authentication.h"

// Private Interfaces
@interface TauUserProfileViewController ()

@end // Private Interfaces

// TauUserProfileViewController class
@implementation TauUserProfileViewController
    {
    GTMOAuth2Authentication __strong* authorizer_;
    }

- ( void ) viewDidLoad
    {
    [ super viewDidLoad ];
    }

#pragma mark - Dynamic Properties

- ( void ) setAuthorizer: ( GTMOAuth2Authentication* )_Authorizer
    {
    if ( authorizer_ != _Authorizer )
        {
        if ( !self.view )
            return;

        authorizer_ = _Authorizer;

        NSString* userEmail = authorizer_.userEmail;
        BOOL isSignedIn = ( userEmail != nil );

TAU_SUPPRESS_PERFORM_SELECTOR_LEAK_WARNING_BEGIN
        [ self.spinningIndicator performSelector: isSignedIn ? @selector( stopAnimation: ) : @selector( startAnimation: ) withObject: self ];
TAU_SUPPRESS_PERFORM_SELECTOR_LEAK_WARNING_COMMIT
        [ self.spinningIndicator setHidden: isSignedIn ];

        if ( isSignedIn )
            [ self.accountLabel setStringValue: authorizer_.userEmail ];

        [ self.accountLabel setHidden: !isSignedIn ];
        [ self.signOutButton setEnabled: isSignedIn ];
        }
    }

- ( GTMOAuth2Authentication* ) authorizer
    {
    return authorizer_;
    }

@end // TauUserProfileViewController class