//
//  TauSearchObject.h
//  Tau4Mac
//
//  Created by Tong G. on 4/2/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

typedef NS_OPTIONS ( NSUInteger, TauSearchContentTypeMasks )
    { TauSearchContentVideoTypeMask    = 1
    , TauSearchContentPlaylistTypeMask = 1 << 1
    , TauSearchContentChannelTypeMask  = 1 << 2
    };

typedef NS_ENUM ( NSInteger, TauSearchContentOrder )
    { TauSearchContentDateOrder
    , TauSearchContentRatingOrder
    , TauSearchContentRelevanceOrder
    , TauSearchContentTitleOrder
    , TauSearchContentVideoCountOrder
    , TauSearchContentViewCountOrder
    };

typedef NS_ENUM ( NSUInteger, TauSearchVideoDefinition )
    { TauSearchVideoHighDefinition
    , TauSearchVideoStandardDefinition

    , TauSearchVideoAnyDefinition = NSUIntegerMax
    };

typedef NS_ENUM ( NSUInteger, TauSearchVideoDuration )
    { TauSearchVideoLongDuration
    , TauSearchVideoMediumDuration
    , TauSearchVideoShortDuration

    , TauSearchVideoAnyDuration = NSUIntegerMax
    };

typedef NS_ENUM ( NSUInteger, TauSearchVideoType )
    { TauSearchVideoEpisodeType
    , TauSearchVideoMovieType

    , TauSearchVideoAnyType = NSUIntegerMax
    };

typedef NS_ENUM ( NSUInteger, TauSearchVideoLicense )
    { TauSearchVideoAnyLicense
    , TauSearchVideoCreativeCommonsLicense
    , TauSearchVideoStandardYouTubeLicense
    };

typedef NS_ENUM ( NSUInteger, TauSearchChannelType )
    { TauSearchChannelOnlyShowType

    , TauSearchChannelAnyType = NSUIntegerMax
    };

// TauSearchObject class
@interface TauSearchObject : NSObject

#pragma mark - Generic Search Options

@property ( assign, readwrite ) TauSearchContentTypeMasks contentTypes;
@property ( assign, readwrite ) TauSearchContentOrder order;

@property ( copy, readwrite ) NSDate* publishedAfterDate;
@property ( copy, readwrite ) NSDate* publishedBeforeDate;

@property ( copy, readwrite ) NSString* ISORegionCode;
@property ( copy, readwrite ) NSString* ISOLanguageCode;

#pragma mark - Specific to YouTune Videos

@property ( assign, readwrite ) TauSearchVideoDefinition videoDefinition;
@property ( assign, readwrite ) TauSearchVideoDuration videoDuration;
@property ( assign, readwrite ) TauSearchVideoType videoType;
@property ( assign, readwrite ) TauSearchVideoLicense videoLicense;
@property ( assign, readwrite ) BOOL syndicatedVideo;

#pragma mark - Specific to YouTune Channels

@property ( assign, readwrite ) TauSearchChannelType channelType;

@end // TauSearchObject class