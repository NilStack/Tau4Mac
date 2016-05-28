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

    NSString* resourceId = nil;

    if ( [ YouTubeContent_ isKindOfClass: [ GTLYouTubeSearchResult class ] ] )
        {
        NSString* idKey = nil;
        SEL sel = nil;
        switch ( YouTubeContent_.tauContentType )
            {
            case TauYouTubeVideo: idKey = @"videoId"; sel = @selector( videoRequestWithVideoIdentifier: ); break;
            case TauYouTubeChannel: idKey = @"channelId"; sel = @selector( channelRequestWithChannelIdentifier: ); break;
            case TauYouTubePlayList: idKey = @"playlistId"; sel = @selector( playlistRequestWithPlaylistIdentifier: ); break;
            default: {;}
            }

        resourceId = [ YouTubeContent_ JSON ][ @"id" ][ idKey ];
        TauRestRequest* req = objc_msgSend( [ TauRestRequest class ], sel, resourceId );
        req.responseVerboseLevelMask |= ( TRSRestResponseVerboseFlagContentDetails | TRSRestResponseVerboseFlagStatistics );
        NSLog( @"%@", req );

        [ [ TauAPIService sharedService ] executeRestRequest: req
                                           completionHandler:
        ^( GTLCollectionObject* _Response, NSError* _Error )
            {
            if ( !_Error )
                {
                NSDictionary* videoItemSnippetJson = _Response.items.firstObject.JSON[ @"snippet" ];
                NSDictionary* videoItemContentDetailsJson = _Response.items.firstObject.JSON[ @"contentDetails" ];
                NSDictionary* videoItemStatisticsJson = _Response.items.firstObject.JSON[ @"statistics" ];

                self.descriptionField.stringValue = videoItemSnippetJson[ @"description" ];

                /* The length of the video. The tag value is an ISO 8601 duration. 
                For example, for a video that is at least one minute long and less than one hour long, the duration is in the format PT#M#S,
                in which the letters PT indicate that the value specifies a period of time,
                and the letters M and S refer to length in minutes and seconds, respectively.
                The # characters preceding the M and S letters are both integers that specify the number of minutes (or seconds) of the video.
                For example, a value of PT15M33S indicates that the video is 15 minutes and 33 seconds long.

                If the video is at least one hour long, the duration is in the format PT#H#M#S,
                in which the # preceding the letter H specifies the length of the video in hours and all of the other details are the same as described above.
                If the video is at least one day long, the letters P and T are separated, and the value's format is P#DT#H#M#S.
                Please refer to the ISO 8601 specification for complete details. */
                NSString* iso8601Duration = videoItemContentDetailsJson[ @"duration" ];

                char const* stringToParse = [ iso8601Duration cStringUsingEncoding: NSASCIIStringEncoding ];

                int days = 0, hours = 0, minutes = 0, seconds = 0;
                char const* ptr = stringToParse;
                while ( *ptr )
                    {
                    if( *ptr == 'P' || *ptr == 'T' )
                        {
                        ptr++;
                        continue;
                        }

                    int value, charsRead;
                    char type;
                    if ( sscanf ( ptr, "%d%c%n", &value, &type, &charsRead ) != 2 )
                        ;  // handle parse error

                    if ( type == 'D' )      days = value;
                    else if ( type == 'H' ) hours = value;
                    else if ( type == 'M' ) minutes = value;
                    else if ( type == 'S' ) seconds = value;
                    else {;}  // handle invalid type

                    ptr += charsRead;
                    }

                NSTimeInterval interval = ( ( days * 24 + hours ) * 60 + minutes ) * 60 + seconds;
                self.durationField.stringValue = @( interval ).stringValue;
                self.categoryField.stringValue = @( [ videoItemSnippetJson[ @"categoryId" ] integerValue ] ).youtubeCategoryName;
                self.dimensionField.stringValue = [ videoItemContentDetailsJson[ @"dimension" ] uppercaseString ];

                self.viewCountField.stringValue = videoItemStatisticsJson[ @"viewCount" ] ?: NSLocalizedString( @"Uncounted", nil );
                self.likesCountField.stringValue = videoItemStatisticsJson[ @"likeCount" ] ?: NSLocalizedString( @"Uncounted", nil );
                self.dislikesCountField.stringValue = videoItemStatisticsJson[ @"dislikeCount" ] ?: NSLocalizedString( @"Uncounted", nil );
                }
            else
                DDLogLocalError( @"%@", _Error );
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