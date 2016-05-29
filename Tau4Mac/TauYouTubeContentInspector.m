//
//  TauYouTubeContentInspector.m
//  Tau4Mac
//
//  Created by Tong G. on 4/19/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import <objc/message.h>
#import "TauYouTubeContentInspector.h"
#import "TauBooleanStatusBadge.h"

// ---------------------------------------------------
/// Required Headers

@interface PriYouTubeContentInfoView_ : NSScrollView
@end
@implementation PriYouTubeContentInfoView_
@end

// PriYouTubeVideoMetaInfoView_ class
@interface PriYouTubeVideoMetaInfoView_ : PriYouTubeContentInfoView_

@property ( strong, readwrite ) GTLObject* YouTubeContent;

@property ( weak ) IBOutlet NSTextField* videoTitleField;
@property ( weak ) IBOutlet NSTextField* descriptionField;
@property ( weak ) IBOutlet NSTextField* channelField;
@property ( weak ) IBOutlet NSTextField* categoryField;

@property ( weak ) IBOutlet NSTextField* durationField;
@property ( weak ) IBOutlet NSTextField* dimensionField;
@property ( weak ) IBOutlet TauBooleanStatusBadge* captionBadge;
@property ( weak ) IBOutlet TauBooleanStatusBadge* licensedBadge;

@property ( weak ) IBOutlet NSTextField* viewCountField;
@property ( weak ) IBOutlet NSTextField* likesCountField;
@property ( weak ) IBOutlet NSTextField* dislikesCountField;

@end

// PriYouTubeChannelMetaInfoView_ class
@interface PriYouTubeChannelMetaInfoView_ : PriYouTubeContentInfoView_

@property ( strong, readwrite ) GTLObject* YouTubeContent;

@property ( weak ) IBOutlet NSTextField* videoTitleField;
@property ( weak ) IBOutlet NSTextField* descriptionField;
@property ( weak ) IBOutlet NSTextField* publishedAtField;

@property ( weak ) IBOutlet NSTextField* viewCountField;
@property ( weak ) IBOutlet NSTextField* commentsCountField;
@property ( weak ) IBOutlet NSTextField* subscribersCountField;
@property ( weak ) IBOutlet NSTextField* videosCountField;

@end // PriYouTubeChannelMetaInfoView_ class

// PriYouTubeVideoCommentsView_ class
@interface PriYouTubeVideoCommentsView_ : PriYouTubeContentInfoView_
@end

// ---------------------------------------------------



typedef NS_ENUM ( NSInteger, TauYouTubeContentInspectorType )
    { TauYouTubeMetaInfoInspector = 0
    , TauYouTubeCommentsInspector = 1

    , TauYouTubeVideoUnknownInspector = -1
    };

// TauYouTubeContentInspector class
@interface TauYouTubeContentInspector ()

@property ( weak ) IBOutlet NSSegmentedControl* switcher_;
@property ( weak ) IBOutlet NSBox* horCuttingLine_;

@property ( weak, readonly ) PriYouTubeContentInfoView_* currentMetaInfoView_;
@property ( weak ) IBOutlet PriYouTubeVideoMetaInfoView_* videoMetaInfoView_;
@property ( weak ) IBOutlet PriYouTubeChannelMetaInfoView_* channelMetaInfoView_;
@property ( weak ) IBOutlet PriYouTubeVideoCommentsView_* commentsView_;

@end

@implementation TauYouTubeContentInspector
@end // TauYouTubeContentInspector class



// ~~~ ------------------------------------------- ~~~

@implementation PriYouTubeVideoMetaInfoView_

@synthesize YouTubeContent = YouTubeContent_;
- ( void ) setYouTubeContent: ( GTLObject* )_New
    {
    if ( _New.tauContentType != TauYouTubeVideo )
        {
        DDLogWarn( @"<%@: %p> has illegal type of YouTube content: %lu.", NSStringFromClass( [ _New class ] ), _New, _New.tauContentType );
        return;
        }

    YouTubeContent_ = _New;

    NSDictionary* json = [ YouTubeContent_ JSON ];
    NSDictionary* snippetJson = json[ @"snippet" ];

    self.videoTitleField.stringValue = snippetJson[ @"title" ];
    self.channelField.stringValue = snippetJson[ @"channelTitle" ];

    NSString* description = snippetJson[ @"description" ];
    description = ( description.length > 0 ) ? description : NSLocalizedString( @"No Description", nil );
    self.descriptionField.stringValue = description;

    if ( [ YouTubeContent_ isKindOfClass: [ GTLYouTubeSearchResult class ] ]
            || [ YouTubeContent_ isKindOfClass: [ GTLYouTubePlaylistItem class ] ] )
        {
        NSDictionary* videoIdDict = nil;

        if ( [ YouTubeContent_ isKindOfClass: [ GTLYouTubeSearchResult class ] ] )
            videoIdDict = [ YouTubeContent_ JSON ][ @"id" ];
        else if ( [ YouTubeContent_ isKindOfClass: [ GTLYouTubePlaylistItem class ] ] )
            videoIdDict = [ YouTubeContent_ JSON ][ @"snippet" ][ @"resourceId" ];

        TauRestRequest* req = [ TauRestRequest videoRequestWithVideoIdentifier: [ videoIdDict objectForKey: @"videoId" ] ];
        req.responseVerboseLevelMask |= ( TRSRestResponseVerboseFlagContentDetails | TRSRestResponseVerboseFlagStatistics );

        [ [ TauAPIService sharedService ] executeRestRequest: req
                                           completionHandler:
        ^( GTLYouTubeVideoListResponse* _Response, NSError* _Error )
            {
            if ( _Response && !_Error )
                {
                GTLYouTubeVideo* video = _Response.items.firstObject;
                GTLYouTubeVideoSnippet* snippet = video.snippet;
                GTLYouTubeVideoContentDetails* contentDetails = video.contentDetails;
                GTLYouTubeVideoStatistics* statistics = video.statistics;

                self.descriptionField.stringValue = snippet.descriptionProperty ?: TauUIUnknownPlaceholder;

                NSString* iso8601Duration = contentDetails.duration;
                self.durationField.stringValue = iso8601Duration ? @( [ NSDate timeIntervalFromISO8601Duration: iso8601Duration ] ).stringValue : TauUIUnknownPlaceholder;
                self.categoryField.stringValue = @( [ [ snippet categoryId ] integerValue ] ).youtubeCategoryName;
                self.dimensionField.stringValue = [ [ contentDetails dimension ] uppercaseString ] ?: TauUIUnknownPlaceholder;

                NSNumber* viewCount = [ statistics viewCount ];
                NSNumber* likesCount = [ statistics likeCount ];
                NSNumber* dislikesCount = [ statistics dislikeCount ];

                self.viewCountField.stringValue = viewCount ? viewCount.stringValue : TauUIUncountedPlaceholder;
                self.likesCountField.stringValue = likesCount ? likesCount.stringValue : TauUIUncountedPlaceholder;
                self.dislikesCountField.stringValue = dislikesCount ? dislikesCount.stringValue : TauUIUncountedPlaceholder;

                self.captionBadge.booleanStatus = [ [ contentDetails caption ] boolValue ];
                self.licensedBadge.booleanStatus = [ [ contentDetails licensedContent ] boolValue ];
                }
            else
                DDLogLocalError( @"failed fetching the details of a YouTube video due to {%@}.", _Error );
            } ];
        }
    }

- ( GTLObject* ) YouTubeContent
    {
    return YouTubeContent_;
    }

@end // PriYouTubeVideoMetaInfoView_ class



// ---------------------------------------------------



// PriYouTubeChannelMetaInfoView_ class
@implementation PriYouTubeChannelMetaInfoView_

@synthesize YouTubeContent = YouTubeContent_;
- ( void ) setYouTubeContent: ( GTLObject* )_New
    {
    if ( _New.tauContentType != TauYouTubeChannel )
        {
        DDLogWarn( @"<%@: %p> has illegal type of YouTube content: %lu.", NSStringFromClass( [ _New class ] ), _New, _New.tauContentType );
        return;
        }

    YouTubeContent_ = _New;

    if ( [ self isKindOfClass: [ GTLYouTubeChannel class ] ]
            || [ self isKindOfClass: [ GTLYouTubeSubscription class ] ] )
        {

        }
    }

- ( GTLObject* ) YouTubeContent
    {
    return YouTubeContent_;
    }

@end // PriYouTubeChannelMetaInfoView_ class



// ---------------------------------------------------



@implementation PriYouTubeVideoCommentsView_
@end // PriYouTubeVideoCommentsView_ class