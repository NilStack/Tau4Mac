//
//  TauYouTubeVideoInspector.m
//  Tau4Mac
//
//  Created by Tong G. on 4/19/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import <objc/message.h>
#import "TauYouTubeVideoInspector.h"

// ---------------------------------------------------
/// Required Headers

// PriYouTubeVideoMetaInfoView_ class
@interface PriYouTubeVideoMetaInfoView_ : NSScrollView

@property ( strong, readwrite ) GTLObject* YouTubeContent;

@property ( weak ) IBOutlet NSTextField* videoTitleField;
@property ( weak ) IBOutlet NSTextField* descriptionField;
@property ( weak ) IBOutlet NSTextField* channelField;
@property ( weak ) IBOutlet NSTextField* categoryField;

@property ( weak ) IBOutlet NSTextField* durationField;
@property ( weak ) IBOutlet NSTextField* dimensionField;
@property ( weak ) IBOutlet NSImageView* captionBadge;
@property ( weak ) IBOutlet NSImageView* licensedBadge;

@property ( weak ) IBOutlet NSTextField* viewCountField;
@property ( weak ) IBOutlet NSTextField* likesCountField;
@property ( weak ) IBOutlet NSTextField* dislikesCountField;

@end

// PriYouTubeVideoCommentsView_ class
@interface PriYouTubeVideoCommentsView_ : NSScrollView
@end

// ---------------------------------------------------



typedef NS_ENUM ( NSInteger, TauYouTubeVideoInspectorType )
    { TauYouTubeVideoMetaInfoInspector = 0
    , TauYouTubeVideoCommentsInspector = 1

    , TauYouTubeVideoUnknownInspector = -1
    };

// TauYouTubeVideoInspector class
@interface TauYouTubeVideoInspector ()

@property ( weak ) IBOutlet NSSegmentedControl* switcher_;
@property ( weak ) IBOutlet NSBox* horCuttingLine_;

@property ( weak ) IBOutlet PriYouTubeVideoMetaInfoView_* videoMetaInfoView_;
@property ( weak ) IBOutlet PriYouTubeVideoCommentsView_* commentsView_;

@property ( assign, readwrite ) TauYouTubeVideoInspectorType activedInspectorType;

@property ( strong, readonly ) NSMutableArray <NSLayoutConstraint*>* activedViewAutoPinedConstraints_;

@end

@implementation TauYouTubeVideoInspector

- ( instancetype ) initWithCoder: ( NSCoder* )_Coder
    {
    if ( self = [ super initWithCoder: _Coder ] )
        activedInspectorType_ = TauYouTubeVideoUnknownInspector;
    return self;
    }

- ( void ) awakeFromNib
    {
    [ self setActivedInspectorType: TauYouTubeVideoMetaInfoInspector ];
    }

@synthesize YouTubeContent = YouTubeContent_;
- ( void ) setYouTubeContent: ( GTLObject* )_New
    {
    YouTubeContent_ = _New;
    self.videoMetaInfoView_.YouTubeContent = YouTubeContent_;
    }

- ( GTLObject* ) YouTubeContent
    {
    return YouTubeContent_;
    }

@synthesize activedInspectorType = activedInspectorType_;
+ ( BOOL ) automaticallyNotifiesObserversOfActivedInspectorType
    {
    return NO;
    }

- ( void ) setActivedInspectorType: ( TauYouTubeVideoInspectorType )_New
    {
    if ( _New != activedInspectorType_ )
        {
        [ self willChangeValueForKey: TauKVOStrictKey( activedInspectorType ) ];
        activedInspectorType_ = _New;

        if ( priActivedViewAutoPinedConstraints_.count > 0 )
            {
            [ self removeConstraints: priActivedViewAutoPinedConstraints_ ];
            [ priActivedViewAutoPinedConstraints_ removeAllObjects ];
            }

        NSView* activingView = nil;
        switch ( activedInspectorType_ )
            {
            case TauYouTubeVideoMetaInfoInspector: activingView = self.videoMetaInfoView_; break;
            case TauYouTubeVideoCommentsInspector: activingView = self.commentsView_; break;
            case TauYouTubeVideoUnknownInspector: {;} break;
            }

        [ self.videoMetaInfoView_ removeFromSuperview ];
        [ self.commentsView_ removeFromSuperview ];

        [ self addSubview: activingView ];
        [ self.activedViewAutoPinedConstraints_ addObjectsFromArray: [ activingView autoPinEdgesToSuperviewEdgesWithInsets: NSEdgeInsetsZero excludingEdge: ALEdgeTop ] ];
        [ self.activedViewAutoPinedConstraints_ addObject: [ activingView autoPinEdge: ALEdgeTop toEdge: ALEdgeBottom ofView: self.horCuttingLine_ ] ];

        [ self didChangeValueForKey: TauKVOStrictKey( activedInspectorType ) ];
        }
    }

- ( TauYouTubeVideoInspectorType ) activedInspectorType
    {
    return activedInspectorType_;
    }

@synthesize activedViewAutoPinedConstraints_ = priActivedViewAutoPinedConstraints_;
- ( NSMutableArray <NSLayoutConstraint*>* ) activedViewAutoPinedConstraints_
    {
    if ( !priActivedViewAutoPinedConstraints_ )
        priActivedViewAutoPinedConstraints_ = [ NSMutableArray array ];
    return priActivedViewAutoPinedConstraints_;
    }

@end // TauYouTubeVideoInspector class



// ~~~ ------------------------------------------- ~~~

@implementation PriYouTubeVideoMetaInfoView_

@synthesize YouTubeContent = YouTubeContent_;
- ( void ) setYouTubeContent: ( GTLObject* )_New
    {
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
            if ( !_Error )
                {
                GTLYouTubeVideo* videoItem = _Response.items.firstObject;
                GTLYouTubeVideoSnippet* snippet = videoItem.snippet;
                GTLYouTubeVideoContentDetails* contentDetails = videoItem.contentDetails;
                GTLYouTubeVideoStatistics* statistics = videoItem.statistics;

                self.descriptionField.stringValue = snippet.descriptionProperty ?: NSLocalizedString( @"No Description", nil );

                NSString* iso8601Duration = contentDetails.duration;
                self.durationField.stringValue = iso8601Duration ? @( [ NSDate timeIntervalFromISO8601Duration: iso8601Duration ] ).stringValue : NSLocalizedString( @"Unknown", nil );
                self.categoryField.stringValue = @( [ [ snippet categoryId ] integerValue ] ).youtubeCategoryName;
                self.dimensionField.stringValue = [ [ contentDetails dimension ] uppercaseString ] ?: NSLocalizedString( @"Unknown", nil );

                NSNumber* viewCount = [ statistics viewCount ];
                NSNumber* likesCount = [ statistics likeCount ];
                NSNumber* dislikesCount = [ statistics dislikeCount ];

                NSString static* const uncoundedPlaceholder = @"Uncounted";
                self.viewCountField.stringValue = viewCount ? viewCount.stringValue : uncoundedPlaceholder;
                self.likesCountField.stringValue = likesCount ? likesCount.stringValue : uncoundedPlaceholder;
                self.dislikesCountField.stringValue = dislikesCount ? dislikesCount.stringValue : uncoundedPlaceholder;

                BOOL hasCaption = [ [ contentDetails caption ] boolValue ];
                BOOL isLicensed = [ [ contentDetails licensedContent ] boolValue ];

                self.captionBadge.image = [ NSImage imageNamed: hasCaption ? NSImageNameStatusAvailable : NSImageNameStatusUnavailable ];
                self.licensedBadge.image = [ NSImage imageNamed: isLicensed ? NSImageNameStatusAvailable : NSImageNameStatusUnavailable ];
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



@implementation PriYouTubeVideoCommentsView_
@end // PriYouTubeVideoCommentsView_ class