//
//  TauSearchContentViewController.h
//  Tau4Mac
//
//  Created by Tong G. on 3/17/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauAbstractContentViewController.h"

// TauSearchContentViewController class
@interface TauSearchContentViewController : TauAbstractContentViewController <NSTextFieldDelegate>

#pragma mark - Outlets

@property ( weak ) IBOutlet NSSearchField* searchField;
@property ( weak ) IBOutlet NSButton* searchButton;

#pragma mark - Actions

- ( IBAction ) searchAction: ( id )_Sender;

@end // TauSearchContentViewController class