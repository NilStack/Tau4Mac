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
    // TODO: Whatever to derive instance of GTLQueryYouTube from TauSearchQuery's
    return nil;
    }

@end // TauSearchQuery class