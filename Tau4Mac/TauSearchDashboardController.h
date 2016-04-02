//
//  TauSearchDashboardController.h
//  Tau4Mac
//
//  Created by Tong G. on 4/2/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

typedef NS_ENUM ( NSInteger, TauSearchContentOrder )
    { TauSearchContentDateOrder = 0
    , TauSearchContentRatingOrder = 1
    , TauSearchContentRelevanceOrder = 2
    , TauSearchContentTitleOrder = 3
    , TauSearchContentVideoCountOrder = 4
    , TauSearchContentViewCountOrder = 5
    };

typedef NS_ENUM ( NSUInteger, TauSearchVideoDefinition )
    { TauSearchVideoAnyDefinition
    , TauSearchVideoHighDefinition
    , TauSearchVideoStandardDefinition
    };

typedef NS_ENUM ( NSUInteger, TauSearchVideoDuration )
    { TauSearchVideoAnyDuration
    , TauSearchVideoLongDuration
    , TauSearchVideoMediumDuration
    , TauSearchVideoShortDuration
    };

typedef NS_ENUM ( NSUInteger, TauSearchVideoType )
    { TauSearchVideoAnyType
    , TauSearchVideoEpisodeType
    , TauSearchVideoMovieType
    };

typedef NS_ENUM ( NSUInteger, TauSearchVideoLicense )
    { TauSearchVideoAnyLicense
    , TauSearchVideoCreativeCommonsLicense
    , TauSearchVideoStandardYouTubeLicense
    };

typedef NS_ENUM ( NSUInteger, TauSearchChannelType )
    { TauSearchChannelAnyType
    , TauSearchChannelOnlyShowType
    };

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

@property ( copy, readonly ) GTLQueryYouTube* YouTubeQuery;

@end // TauSearchDashboardController class