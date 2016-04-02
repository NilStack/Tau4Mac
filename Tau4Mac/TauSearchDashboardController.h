//
//  TauSearchDashboardController.h
//  Tau4Mac
//
//  Created by Tong G. on 4/2/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

// TauSearchDashboardController class
@interface TauSearchDashboardController : NSViewController

#pragma mark - Generic Search Options

@property ( weak ) IBOutlet NSButton* searchVideoCheckBox;
@property ( weak ) IBOutlet NSButton* searchPlaylistCheckBox;
@property ( weak ) IBOutlet NSButton* searchChannelCheckBox;

@property ( weak ) IBOutlet NSPopUpButton* searchOrderPopUp;
@property ( weak ) IBOutlet NSDatePicker* publishedAfterDatePicker;
@property ( weak ) IBOutlet NSDatePicker* publishedBeforeDatePicker;
@property ( weak ) IBOutlet NSPopUpButton* regionCodesPopUp;
@property ( weak ) IBOutlet NSPopUpButton* languageCodesPopUp;

#pragma mark - Specific to YouTune Videos

@property ( weak ) IBOutlet NSSegmentedControl* videoDefinitionSegControl;
@property ( weak ) IBOutlet NSSegmentedControl* videoDurationSegControl;
@property ( weak ) IBOutlet NSSegmentedControl* videoTypeSegControl;
@property ( weak ) IBOutlet NSPopUpButton* videoLicensePopUp;
@property ( weak ) IBOutlet NSButton* syndicatedVideoCheckBox;

#pragma mark - Specific to YouTune Channels

@property ( weak ) IBOutlet NSSegmentedControl* channelTypeSegControl;

@end // TauSearchDashboardController class