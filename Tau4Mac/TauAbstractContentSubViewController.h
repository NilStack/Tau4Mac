//
//  TauAbstractContentSubViewController.h
//  Tau4Mac
//
//  Created by Tong G. on 3/19/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauAbstractContentViewController.h"

// TauAbstractContentSubViewController class
@interface TauAbstractContentSubViewController : NSViewController <TauContentSubViewController>

@property ( weak, readonly ) TauAbstractContentViewController* masterContentViewController;

@property ( assign, readonly ) BOOL isBackground;

#pragma mark - View Stack Operations

- ( void ) popMe;

#pragma mark - Expecting Overrides

- ( void ) contentSubViewWillPop;
- ( void ) contentSubViewDidPop;

#pragma mark - Actions

- ( IBAction ) dismissAction: ( id )_Sender;

@end // TauAbstractContentSubViewController class