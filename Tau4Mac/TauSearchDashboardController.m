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
@synthesize limitPublishedDateCheckBox;
@synthesize searchOrderPopUp, publishedAfterDatePicker, publishedBeforeDatePicker, regionCodesPopUp, languageCodesPopUp;

#pragma mark - Specific to YouTune Videos

@synthesize videoDefinitionSegControl, videoDurationSegControl, videoTypeSegControl, videoLicensePopUp, syndicatedVideoCheckBox;

#pragma mark - Specific to YouTune Channels

@synthesize channelTypeSegControl;

#pragma mark - Initializations

NSString static* const kWorldWideItemTitle = @"World Wide";
NSString static* const kAnyLanguageItemTitle = @"Any";

- ( void ) viewDidLoad
    {
    [ super viewDidLoad ];
    // Do view setup here.

    [ searchOrderPopUp selectItemWithTag: TauSearchContentRelevanceOrder ];

    [ publishedAfterDatePicker setDateValue: [ NSDate dateWithTimeIntervalSince1970: 1108339200 ] ];
    [ publishedBeforeDatePicker setDateValue: [ NSDate date ] ];

    [ regionCodesPopUp removeAllItems ];
    [ regionCodesPopUp addItemWithTitle: NSLocalizedString( kWorldWideItemTitle, nil ) ];
    [ regionCodesPopUp addItemsWithTitles: [ NSLocale ISOCountryCodes ] ];

    [ languageCodesPopUp removeAllItems ];
    [ languageCodesPopUp addItemWithTitle: NSLocalizedString( kAnyLanguageItemTitle, nil ) ];
    [ languageCodesPopUp addItemsWithTitles: [ NSLocale ISOLanguageCodes ] ];
    }

#pragma mark - Compatible with GTL

@dynamic YouTubeQuery;
- ( GTLQueryYouTube* ) YouTubeQuery
    {
    GTLQueryYouTube* query = [ GTLQueryYouTube queryForSearchListWithPart: @"snippet" ];

    query.maxResults = 50;

    // Converting `type` field
    {
    NSMutableArray* types = [ @[] mutableCopy ];
    if ( [ searchVideoCheckBox state ] == NSOnState ) [ types addObject: @"video" ];
    if ( [ searchPlaylistCheckBox state ] == NSOnState ) [ types addObject: @"playlist" ];
    if ( [ searchChannelCheckBox state ] == NSOnState ) [ types addObject: @"channel" ];

    query.type = [ types componentsJoinedByString: @" " ];
    }

    // Converting `order` field
    {
    NSString* orderString = nil;
    switch ( searchOrderPopUp.selectedTag )
        {
        case TauSearchContentDateOrder: orderString = @"date"; break;
        case TauSearchContentRatingOrder: orderString = @"rating"; break;
        case TauSearchContentRelevanceOrder: orderString = @"relevance"; break;
        case TauSearchContentTitleOrder: orderString = @"title"; break;
        case TauSearchContentVideoCountOrder: orderString = @"videoCount"; break;
        case TauSearchContentViewCountOrder: orderString = @"viewCount"; break;
        }

    query.order = orderString;
    }

    {
    if ( limitPublishedDateCheckBox.state == NSOnState )
        {
        query.publishedAfter = [ GTLDateTime dateTimeWithDate: publishedAfterDatePicker.dateValue timeZone: [ NSTimeZone localTimeZone ] ];
        query.publishedBefore = [ GTLDateTime dateTimeWithDate: publishedBeforeDatePicker.dateValue timeZone: [ NSTimeZone localTimeZone ] ];
        }

    if ( ![ regionCodesPopUp.selectedItem.title isEqualToString: kWorldWideItemTitle ] )
        query.regionCode = [ [ [ regionCodesPopUp selectedItem ] title ] uppercaseString ];

    if ( ![ languageCodesPopUp.selectedItem.title isEqualToString: kAnyLanguageItemTitle ] )
        query.relevanceLanguage = [ [ [ languageCodesPopUp selectedItem ] title ] uppercaseString ];
    }

    if ( videoDefinitionSegControl.enabled )
        {
        // Converting `videoDefinition` field
        {
        NSString* videoDefString = nil;
        switch ( videoDefinitionSegControl.selectedSegment )
            {
            case TauSearchVideoAnyDefinition: videoDefString = @"any"; break;
            case TauSearchVideoHighDefinition: videoDefString = @"high"; break;
            case TauSearchVideoStandardDefinition: videoDefString = @"standard"; break;
            }

        query.videoDefinition = videoDefString;
        }

        // Converting `videoDuration` field
        {
        NSString* durationString = nil;
        switch ( videoDurationSegControl.selectedSegment )
            {
            case TauSearchVideoAnyDuration: durationString = @"any"; break;
            case TauSearchVideoLongDuration: durationString = @"long"; break;
            case TauSearchVideoMediumDuration: durationString = @"medium"; break;
            case TauSearchVideoShortDuration: durationString = @"short"; break;
            }

        query.videoDuration = durationString;
        }

        // Converting `videoType` field
        {
        NSString* videoTypeString = nil;
        switch ( videoTypeSegControl.selectedSegment )
            {
            case TauSearchVideoAnyType: videoTypeString = @"any"; break;
            case TauSearchVideoEpisodeType: videoTypeString = @"episode"; break;
            case TauSearchVideoMovieType: videoTypeString = @"movie"; break;
            }

        query.videoType = videoTypeString;
        }

        // Converting `videoLicense` field
        {
        NSString* license = nil;
        switch ( videoLicensePopUp.selectedTag )
            {
            case TauSearchVideoAnyLicense: license = @"any"; break;
            case TauSearchVideoCreativeCommonsLicense: license = @"creativeCommon"; break;
            case TauSearchVideoStandardYouTubeLicense: license = @"youtube"; break;
            }

        query.videoLicense = license;
        }

        // Converting `videoSyndicated` field
        query.videoSyndicated = syndicatedVideoCheckBox.state ? @"true" : nil;
        }

    if ( channelTypeSegControl.enabled )
        // Converting `channelType` field
        {
        NSString* channelTypeString = nil;
        switch ( channelTypeSegControl.selectedSegment )
            {
            case TauSearchChannelAnyType: channelTypeString = @"any"; break;
            case TauSearchChannelOnlyShowType: channelTypeString = @"show"; break;
            }

        query.channelType = channelTypeString;
        }

    return query;
    }

@end // TauSearchDashboardController class