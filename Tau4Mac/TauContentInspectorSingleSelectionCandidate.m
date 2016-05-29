//
//  TauContentInspectorSingleSelectionCandidate.m
//  Tau4Mac
//
//  Created by Tong G. on 4/19/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import <objc/message.h>
#import "TauContentInspectorSingleSelectionCandidate.h"
#import "TauBooleanStatusBadge.h"



// --------------------------------------------------------------------------
#pragma mark - Interfaces of Private Views -
// --------------------------------------------------------------------------



@interface PriYouTubeContentView_ : NSScrollView
@property ( strong, readwrite ) GTLObject* YouTubeContent;
@end
@implementation PriYouTubeContentView_
    {
    GTLObject __strong* YouTubeContent_;
    }

@synthesize YouTubeContent = YouTubeContent_;

@end

// PriYouTubeVideoMetaInfoView_ class
@interface PriYouTubeVideoMetaInfoView_ : PriYouTubeContentView_

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
@interface PriYouTubeChannelMetaInfoView_ : PriYouTubeContentView_

@property ( weak ) IBOutlet NSTextField* videoTitleField;
@property ( weak ) IBOutlet NSTextField* descriptionField;
@property ( weak ) IBOutlet NSTextField* publishedAtField;

@property ( weak ) IBOutlet NSTextField* viewCountField;
@property ( weak ) IBOutlet NSTextField* commentsCountField;
@property ( weak ) IBOutlet NSTextField* subscribersCountField;
@property ( weak ) IBOutlet NSTextField* videosCountField;

@end // PriYouTubeChannelMetaInfoView_ class

// PriYouTubeCommentsView_ class
@interface PriYouTubeCommentsView_ : PriYouTubeContentView_
@end



// ---------------------------------------------------------------------------------
#pragma mark - Implementation of TauContentInspectorSingleSelectionCandidate class -
// ---------------------------------------------------------------------------------



typedef NS_ENUM ( NSInteger, TauContentInspectorSingleSelectionCandidateType )
    { TauYouTubeMetaInfoInspector = 0
    , TauYouTubeCommentsInspector = 1

    , TauYouTubeVideoUnknownInspector = -1
    };

// TauContentInspectorSingleSelectionCandidate class
@interface TauContentInspectorSingleSelectionCandidate ()

@property ( weak ) IBOutlet NSSegmentedControl* switcher_;
@property ( weak ) IBOutlet NSBox* horCuttingLine_;

// The result (one of videoMetaInfoView_, channelMetaInfoView_, playlistMetaInfoView_)
// of this property will be derived from self.YouTubeContent
@property ( weak, readonly ) PriYouTubeContentView_* currentMetaInfoView_;

@property ( weak ) IBOutlet PriYouTubeVideoMetaInfoView_* videoMetaInfoView_;
@property ( weak ) IBOutlet PriYouTubeChannelMetaInfoView_* channelMetaInfoView_;
@property ( weak ) IBOutlet PriYouTubeCommentsView_* commentsView_;

@end

@implementation TauContentInspectorSingleSelectionCandidate

@synthesize YouTubeContent = YouTubeContent_;
- ( void ) setYouTubeContent: ( GTLObject* )_New
    {
    YouTubeContent_ = _New;

    // TODO:
    }

- ( GTLObject* ) YouTubeContent
    {
    return YouTubeContent_;
    }

@end // TauContentInspectorSingleSelectionCandidate class



// --------------------------------------------------------------------------
#pragma mark - Implementation of Private Views -
// --------------------------------------------------------------------------



@implementation PriYouTubeVideoMetaInfoView_

- ( void ) setYouTubeContent: ( GTLObject* )_New
    {
    if ( _New.tauContentType != TauYouTubeVideo )
        {
        DDLogWarn( @"<%@: %p> has illegal type of YouTube content: %lu.", NSStringFromClass( [ _New class ] ), _New, _New.tauContentType );
        return;
        }
    
    [ super setYouTubeContent: _New ];

    self.YouTubeContent = _New;

    NSDictionary* json = [ self.YouTubeContent JSON ];
    NSDictionary* snippetJson = json[ @"snippet" ];

    self.videoTitleField.stringValue = snippetJson[ @"title" ];
    self.channelField.stringValue = snippetJson[ @"channelTitle" ];

    NSString* description = snippetJson[ @"description" ];
    description = ( description.length > 0 ) ? description : NSLocalizedString( @"No Description", nil );
    self.descriptionField.stringValue = description;

    if ( [ self.YouTubeContent isKindOfClass: [ GTLYouTubeSearchResult class ] ]
            || [ self.YouTubeContent isKindOfClass: [ GTLYouTubePlaylistItem class ] ] )
        {
        NSDictionary* videoIdDict = nil;

        if ( [ self.YouTubeContent isKindOfClass: [ GTLYouTubeSearchResult class ] ] )
            videoIdDict = [ self.YouTubeContent JSON ][ @"id" ];
        else if ( [ self.YouTubeContent isKindOfClass: [ GTLYouTubePlaylistItem class ] ] )
            videoIdDict = [ self.YouTubeContent JSON ][ @"snippet" ][ @"resourceId" ];

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

@end // PriYouTubeVideoMetaInfoView_ class



// ---------------------------------------------------



// PriYouTubeChannelMetaInfoView_ class
@implementation PriYouTubeChannelMetaInfoView_

- ( void ) setYouTubeContent: ( GTLObject* )_New
    {
    if ( _New.tauContentType != TauYouTubeChannel )
        {
        DDLogWarn( @"<%@: %p> has illegal type of YouTube content: %lu.", NSStringFromClass( [ _New class ] ), _New, _New.tauContentType );
        return;
        }

    [ super setYouTubeContent: _New ];

    if ( [ self isKindOfClass: [ GTLYouTubeChannel class ] ]
            || [ self isKindOfClass: [ GTLYouTubeSubscription class ] ] )
        {

        }
    }

@end // PriYouTubeChannelMetaInfoView_ class



// ---------------------------------------------------



@implementation PriYouTubeCommentsView_
@end // PriYouTubeCommentsView_ class