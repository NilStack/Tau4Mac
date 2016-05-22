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
    self.descriptionField.stringValue = snippetJson[ @"description" ];

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
        req.responseVerboseLevelMask |= TRSRestResponseVerboseFlagContentDetails;
        NSLog( @"%@", req );

        [ [ TauAPIService sharedService ] executeRestRequest: req
                                           completionHandler:
        ^( GTLObject* _Response, NSError* _Error )
            {
            if ( !_Error )
                {
                NSLog( @"%@", _Response.JSON );
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