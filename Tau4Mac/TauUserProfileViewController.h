//
//  TauUserProfileViewController.h
//  Tau4Mac
//
//  Created by Tong G. on 3/11/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

@class GTMOAuth2Authentication;

// TauUserProfileViewController class
@interface TauUserProfileViewController : NSViewController

@property ( weak ) IBOutlet NSProgressIndicator* spinningIndicator;
@property ( weak ) IBOutlet NSTextField* accountLabel;

@property ( weak ) IBOutlet NSButton* signInButton;
@property ( weak ) IBOutlet NSButton* signOutButton;

@property ( strong, readwrite ) GTMOAuth2Authentication* authorizer;

@end // TauUserProfileViewController class