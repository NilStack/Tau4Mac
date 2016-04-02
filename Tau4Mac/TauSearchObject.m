//
//  TauSearchObject.m
//  Tau4Mac
//
//  Created by Tong G. on 4/2/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauSearchObject.h"

// TauSearchObject class
@implementation TauSearchObject

#pragma mark - Generic Search Options

@synthesize contentTypes, order, publishedAfterDate, publishedBeforeDate, ISORegionCode, ISOLanguageCode;

#pragma mark - Specific to YouTune Videos

@synthesize videoDefinition, videoDuration, videoType, videoLicense, syndicatedVideo;

#pragma mark - Specific to YouTune Channels

@synthesize channelType;

@end // TauSearchObject class