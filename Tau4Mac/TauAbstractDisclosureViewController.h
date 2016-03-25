//
//  TauAbstractDisclosureViewController.h
//  Tau4Mac
//
//  Created by Tong G. on 3/24/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

// TauAbstractDisclosureViewController class
@interface TauAbstractDisclosureViewController : NSViewController

#pragma mark - Outlets

@property ( weak ) IBOutlet NSView* disclosedView;
@property ( weak ) IBOutlet NSView* closedView;

#pragma mark - External KVB Compliant Properties

@property ( assign, readwrite ) BOOL showsHeader;
@property ( assign, readwrite, setter = setDisclosed: ) BOOL isDisclosed;

@property ( strong, readonly ) NSString* toggleButtonTitle;
@property ( strong, readonly ) NSString* toggleButtonAlternativeTitle;

#pragma mark - Actions

- ( IBAction ) toggleDisclosureAction: ( id )_Sender;

@end // TauAbstractDisclosureViewController class