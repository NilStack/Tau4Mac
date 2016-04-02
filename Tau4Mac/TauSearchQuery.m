//
//  TauSearchQuery.m
//  Tau4Mac
//
//  Created by Tong G. on 4/2/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauSearchQuery.h"

// TauSearchQuery class
@implementation TauSearchQuery

#pragma mark - Generic Search Options

@synthesize contentTypes, order, publishedAfterDate, publishedBeforeDate, ISORegionCode, ISOLanguageCode;

#pragma mark - Specific to YouTune Videos

@synthesize videoDefinition, videoDuration, videoType, videoLicense, syndicatedVideo;

#pragma mark - Specific to YouTune Channels

@synthesize channelType;

#pragma mark - Compatibility with GTL

@dynamic gtlSearchQuery;

- ( GTLQueryYouTube* ) gtlSearchQuery
    {
    GTLQueryYouTube* query = [ GTLQueryYouTube queryForSearchListWithPart: @"snippet" ];

    // Converting contentTypes field
    {
    NSMutableArray* types = [ @[] mutableCopy ];
    if ( contentTypes & TauSearchContentVideoTypeMask )
        [ types addObject: @"video" ];
    if ( contentTypes & TauSearchContentPlaylistTypeMask )
        [ types addObject: @"playlist" ];
    if ( contentTypes & TauSearchContentChannelTypeMask )
        [ types addObject: @"channel" ];

    query.type = [ types componentsJoinedByString: @" " ];
    }

    // Converting order field
    {
    NSString* orderString = nil;
    switch ( order )
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

    // Converting publishedAfterDate field
    query.publishedAfter = [ GTLDateTime dateTimeWithDate: publishedAfterDate timeZone: [ NSTimeZone localTimeZone ] ];

    // Converting publishedBeforeDate field
    query.publishedBefore = [ GTLDateTime dateTimeWithDate: publishedBeforeDate timeZone: [ NSTimeZone localTimeZone ] ];

    // Converting ISORegionCode field
    query.regionCode = [ ISORegionCode copy ];

    // Converting ISOLanguageCode field
    query.relevanceLanguage = [ ISOLanguageCode copy ];

    // Converting videoDefinition field
    {
    NSString* def = nil;
    switch ( videoDefinition )
        {
        case TauSearchVideoAnyDefinition: def = @"any"; break;
        case TauSearchVideoHighDefinition: def = @"high"; break;
        case TauSearchVideoStandardDefinition: def = @"standard"; break;
        }

    query.videoDefinition = def;
    }

    // Converting videoDuration field
    {
    NSString* duration = nil;
    switch ( videoDuration )
        {
        case TauSearchVideoAnyDuration: duration = @"any"; break;
        case TauSearchVideoLongDuration: duration = @"long"; break;
        case TauSearchVideoMediumDuration: duration = @"medium"; break;
        case TauSearchVideoShortDuration: duration = @"short"; break;
        }

    query.videoDuration = duration;
    }

    // Converting videoType field
    {
    NSString* videoTypeString = nil;
    switch ( videoType )
        {
        case TauSearchVideoAnyType: videoTypeString = @"any"; break;
        case TauSearchVideoEpisodeType: videoTypeString = @"episode"; break;
        case TauSearchVideoMovieType: videoTypeString = @"movie"; break;
        }

    query.videoType = videoTypeString;
    }

    // Converting videoLicense field
    {
    NSString* license = nil;
    switch ( videoLicense )
        {
        case TauSearchVideoAnyLicense: license = @"any"; break;
        case TauSearchVideoCreativeCommonsLicense: license = @"creativeCommon"; break;
        case TauSearchVideoStandardYouTubeLicense: license = @"youtube"; break;
        }

    query.videoLicense = license;
    }

    // Converting syndicatedVideo field
    query.videoSyndicated = syndicatedVideo ? @"true" : nil;

    // Converting channelType field
    {
    NSString* channelTypeString = nil;
    switch ( channelType )
        {
        case TauSearchChannelAnyType: channelTypeString = @"any"; break;
        case TauSearchChannelOnlyShowType: channelTypeString = @"show"; break;
        }

    query.channelType = channelTypeString;
    }

    return query;
    }

@end // TauSearchQuery class