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

#pragma mark - Properties

@property ( assign, readwrite, setter = setDisclosureVisible: ) BOOL isDisclosureVisible;

#pragma mark - Actions

- ( IBAction ) toggleDisclosureAction: ( id )_Sender;

@end // TauAbstractDisclosureViewController class