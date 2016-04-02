//
//  TauSearchDashboardController.m
//  Tau4Mac
//
//  Created by Tong G. on 4/2/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauSearchDashboardController.h"

// Private
@interface TauSearchDashboardController ()

@end // Private

// TauSearchDashboardController class
@implementation TauSearchDashboardController

#pragma mark - Generic Search Options

@synthesize searchVideoCheckBox, searchPlaylistCheckBox, searchChannelCheckBox;
@synthesize searchOrderPopUp, publishedAfterDatePicker, publishedBeforeDatePicker, regionCodesPopUp, languageCodesPopUp;

#pragma mark - Specific to YouTune Videos

@synthesize videoDefinitionSegControl, videoDurationSegControl, videoTypeSegControl, videoLicensePopUp, syndicatedVideoCheckBox;

#pragma mark - Specific to YouTune Channels

@synthesize channelTypeSegControl;

#pragma mark - Initializations

- ( void ) viewDidLoad
    {
    [ super viewDidLoad ];
    // Do view setup here.
    }

@end // TauSearchDashboardController class