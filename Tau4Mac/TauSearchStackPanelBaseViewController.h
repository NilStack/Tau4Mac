//
//  TauSearchStackPanelBaseViewController.h
//  Tau4Mac
//
//  Created by Tong G. on 3/5/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauAbstractStackViewItem.h"

// TauSearchStackPanelBaseViewController class
@interface TauSearchStackPanelBaseViewController : TauAbstractStackViewItem

#pragma mark - Outlets

@property ( weak ) IBOutlet NSSearchField* searchField;

@property ( weak ) IBOutlet NSButton* allRadioButton;
@property ( weak ) IBOutlet NSButton* videoRadioButton;
@property ( weak ) IBOutlet NSButton* playlistRadioButton;
@property ( weak ) IBOutlet NSButton* channelRadioButton;

#pragma mark - IBActions

- ( IBAction ) searchUserInputAction: ( id )_Sender;

@end // TauSearchStackPanelBaseViewController class