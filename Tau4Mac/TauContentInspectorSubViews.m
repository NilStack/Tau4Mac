//
//  TauContentInspectorSubViews.m
//  Tau4Mac
//
//  Created by Tong G. on 3/31/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauContentInspectorSubViews.h"

// Private
@interface TauContentInspectorNoSelectionSubView ()
@property ( weak ) IBOutlet NSView* noSelectionLabelSection_;
@end // Private

// TauContentInspectorNoSelectionSubView class
@implementation TauContentInspectorNoSelectionSubView
@end // TauContentInspectorNoSelectionSubView class



// ------------------------------------------------------------------------------------------------------------ //



// Private
@interface TauContentInspectorMultipleSelectionsSubView ()
@property ( weak ) IBOutlet NSView* multipleSelectionLabelSection_;
@end // Private

// TauContentInspectorMultipleSelectionsSubView class
@implementation TauContentInspectorMultipleSelectionsSubView
@end // TauContentInspectorMultipleSelectionsSubView class



// ------------------------------------------------------------------------------------------------------------ //



// PriContentTitleView_ class
@interface PriContentTitleSectionView_ : NSView
@property ( copy ) NSString* title;
@end

@implementation PriContentTitleSectionView_
    {
    NSTextFieldCell __strong* cell_;
    }

#pragma mark - Init

- ( instancetype ) initWithCoder: ( NSCoder* )_Coder
    {
    if ( self = [ super initWithCoder: _Coder ] )
        {
        cell_ = [ [ NSTextFieldCell alloc ] initTextCell: @"" ];
        [ cell_ setFont: [ NSFont fontWithName: @"PingFang SC Regular" size: 18.f ] ];
        [ cell_ setTextColor: [ NSColor colorWithSRGBRed: 51.f / 255 green: 51.f / 255 blue: 51.f / 255 alpha: 1.f ] ];
        [ cell_ setLineBreakMode: NSLineBreakByTruncatingTail ];
        [ cell_ setUsesSingleLineMode: YES ];
        [ cell_ setTruncatesLastVisibleLine: YES ];
        }

    return self;
    }

#pragma mark - Drawing

- ( void ) drawRect: ( NSRect )_DirtyRect
    {
    [ super drawRect: _DirtyRect ];
    [ cell_ drawWithFrame: NSInsetRect( _DirtyRect, 15.f, 10.f ) inView: self ];
    }

@dynamic title;
- ( void ) setTitle: ( NSString* )_New
    {
    [ cell_ setTitle: _New ];
    [ self setNeedsDisplay: YES ];
    }

- ( NSString* ) title
    {
    return cell_.title;
    }

@end // PriContentTitleView_ class



// ------------------------------------------------------------------------------------------------------------ //



// PriContentActionView_ class
@interface PriContentActionSectionView_ : NSView <NSSharingServiceDelegate, NSSharingServicePickerDelegate>

@property ( strong, readwrite ) GTLObject* YouTubeContent;
@property ( weak ) IBOutlet NSSegmentedControl* actionSegControl;

- ( IBAction ) actionSegControlClicked: ( id )_Sender;

@end

@implementation PriContentActionSectionView_

@synthesize YouTubeContent = YouTubeContent_;
- ( void ) setYouTubeContent: ( GTLObject* )_New
    {
    if ( YouTubeContent_ != _New )
        {
        YouTubeContent_ = _New;

        NSImage* segImage = nil;
        NSString* toolTip = nil;
        switch ( YouTubeContent_.tauContentType )
            {
            case TauYouTubeVideo:
                {
                segImage = [ NSImage imageNamed: @"tau-play-video" ];
                segImage.size = NSMakeSize( 11.f, 12.f );

                toolTip = NSLocalizedString( @"Play Video", nil );
                } break;

            case TauYouTubeChannel:
                {
                segImage = [ NSImage imageNamed: NSImageNameIconViewTemplate ];
                toolTip = NSLocalizedString( @"Show Channel", nil );
                } break;

            case TauYouTubePlayList:
                {
                segImage = [ NSImage imageNamed: NSImageNameListViewTemplate ];
                    toolTip = NSLocalizedString( @"Show Play List", nil );
                } break;

            case TauYouTubeUnknownContent:;
            }

        if ( segImage )
            {
            [ segImage setTemplate: YES ];
            [ self.actionSegControl setImage: segImage forSegment: 0 ];
            [ ( NSSegmentedCell* )( self.actionSegControl.cell ) setToolTip: toolTip forSegment: 0 ];
            }
        else
            DDLogUnexpected( @"segImage shouldn't be nil" );
        }
    }

- ( GTLObject* ) YouTubeContent
    {
    return YouTubeContent_;
    }

@synthesize actionSegControl = actionSegControl_;
- ( void ) setActionSegControl: ( NSSegmentedControl* )_New
    {
    if ( actionSegControl_ != _New )
        {
        actionSegControl_ = _New;
        [ actionSegControl_ sendActionOn: NSLeftMouseDownMask ];
        }
    }

- ( NSSegmentedControl* ) actionSegControl
    {
    return actionSegControl_;
    }

- ( IBAction ) actionSegControlClicked: ( NSSegmentedControl* )_Sender
    {
    if ( _Sender.selectedSegment == 0 )
        [ self.YouTubeContent exposeMeOnBahalfOf: self ];
    else if ( _Sender.selectedSegment == 1 )
        {
        NSArray* sharingItems = @[ self.YouTubeContent.tauEssentialTitle, self.YouTubeContent.urlOnWebsite.absoluteString.stringByRemovingPercentEncoding ];
        NSSharingServicePicker* sharingServicePicker = [ [ NSSharingServicePicker alloc ] initWithItems: sharingItems ];
        [ sharingServicePicker setDelegate: self ];
        [ sharingServicePicker showRelativeToRect: _Sender.bounds ofView: _Sender preferredEdge: NSRectEdgeMaxY ];
        }
    }

#pragma mark - Conforms to <NSSharingServicePickerDelegate>

- ( NSArray <NSSharingService*>* ) sharingServicePicker: ( NSSharingServicePicker* )_SharingServicePicker
                                sharingServicesForItems: ( NSArray* )_Items
                                proposedSharingServices: ( NSArray <NSSharingService*>* )_ProposedServices
    {
    return _ProposedServices;
    }

- ( id <NSSharingServiceDelegate> ) sharingServicePicker: ( NSSharingServicePicker* )_SharingServicePicker
                               delegateForSharingService: ( NSSharingService* )_SharingService
    {
    return self;
    }

#pragma mark - Conforms to <NSSharingServiceDelegate>

- ( NSWindow* ) sharingService: ( NSSharingService* )_SharingService
     sourceWindowForShareItems: ( NSArray* )_Items
           sharingContentScope: ( NSSharingContentScope* )_SharingContentScope
    {
    return self.window;
    }

@end // PriContentActionView_ class



// ------------------------------------------------------------------------------------------------------------ //



// PriContentDescriptionSectionView_ class
@interface PriContentDescriptionSectionView_ : NSView <NSTextViewDelegate>

@property ( strong, readwrite ) GTLObject* YouTubeContent;

@property ( weak ) IBOutlet NSClipView* clipView_;
@property ( strong ) IBOutlet NSTextView* textView_;

@end

@implementation PriContentDescriptionSectionView_
@end // PriContentDescriptionSectionView_ class



// ------------------------------------------------------------------------------------------------------------ //



// Private
@interface TauContentInspectorSingleSelectionSubView ()

/*************** Embedding the split view controller ***************/

@property ( strong, readonly ) NSSplitViewController* splitInspectorViewController_;

// These guys will be used as fodder of the split inspector view controller above
@property ( strong, readonly ) NSSplitViewItem* singleContentTitleSectionItem_;
@property ( strong, readonly ) NSSplitViewItem* singleContentActionSectionItem_;
@property ( strong, readonly ) NSSplitViewItem* singleContentDescriptionSectionItem_;
@property ( strong, readonly ) NSSplitViewItem* singleContentInformationSectionItem_;

// These guys will be used as fodder of the split view items above
@property ( weak ) IBOutlet NSViewController* wrapperOfSingleContentTitleSectionView_;
@property ( weak ) IBOutlet NSViewController* wrapperOfSingleContentActionSectionView_;
@property ( weak ) IBOutlet NSViewController* wrapperOfSingleContentDescriptionSectionView_;
@property ( weak ) IBOutlet NSViewController* wrapperOfSingleContentInformationSectionView_;

/*************** Embedding the split view controller ***************/

@property ( weak ) IBOutlet PriContentTitleSectionView_* contentTitleSectionView_;
@property ( weak ) IBOutlet PriContentActionSectionView_* contentActionSectionView_;
@property ( weak ) IBOutlet PriContentDescriptionSectionView_* contentDescriptionSectionView_;

@end // Private

// TauContentInspectorSingleSelectionSubView class
@implementation TauContentInspectorSingleSelectionSubView

#pragma mark - Initializations

- ( void ) awakeFromNib
    {
    [ [ self configureForAutoLayout ] addSubview: self.splitInspectorViewController_.view ];
    [ [ self.splitInspectorViewController_.view configureForAutoLayout ] autoPinEdgesToSuperviewEdges ];
    }

@synthesize YouTubeContent = YouTubeContent_;
- ( void ) setYouTubeContent: ( GTLObject* )_New
    {
    YouTubeContent_ = _New;

    NSString* title = YouTubeContent_.JSON[ @"snippet" ][ @"title" ];
    [ self.contentTitleSectionView_ setTitle: title ];
    [ self.contentTitleSectionView_ setToolTip: title ];

    [ self.contentActionSectionView_ setYouTubeContent: YouTubeContent_ ];
    [ self.contentDescriptionSectionView_ setYouTubeContent: YouTubeContent_ ];
    [ self.contentDescriptionSectionView_.clipView_ scrollToPoint: NSMakePoint( 0.f, -10.f ) ];
    }

- ( GTLObject* ) YouTubeContent
    {
    return YouTubeContent_;
    }

#pragma mark - Private

@synthesize splitInspectorViewController_ = priSplitInspectorViewController_;
- ( NSSplitViewController* ) splitInspectorViewController_
    {
    if ( !priSplitInspectorViewController_ )
        {
        priSplitInspectorViewController_ = [ [ NSSplitViewController alloc ] initWithNibName: nil bundle: nil ];
        priSplitInspectorViewController_.splitView.vertical = NO;
        priSplitInspectorViewController_.splitView.dividerStyle = NSSplitViewDividerStyleThin;

        [ priSplitInspectorViewController_ addSplitViewItem: self.singleContentTitleSectionItem_ ];
        [ priSplitInspectorViewController_ addSplitViewItem: self.singleContentActionSectionItem_ ];
        [ priSplitInspectorViewController_ addSplitViewItem: self.singleContentDescriptionSectionItem_ ];
        // [ priSplitInspectorViewController_ addSplitViewItem: self.singleContentInformationSectionItem_ ];
        }

    return priSplitInspectorViewController_;
    }

    // These guys used for feeding the split inspector view controller above
@synthesize singleContentTitleSectionItem_ = priSingleContentTitleSectionItem_;
- ( NSSplitViewItem* ) singleContentTitleSectionItem_
    {
    if ( !priSingleContentTitleSectionItem_ )
        {
        priSingleContentTitleSectionItem_ = [ NSSplitViewItem splitViewItemWithViewController: self.wrapperOfSingleContentTitleSectionView_ ];
        priSingleContentTitleSectionItem_.canCollapse = NO;
        priSingleContentTitleSectionItem_.minimumThickness = 40.f;
        priSingleContentTitleSectionItem_.maximumThickness = 40.f;
        }

    return priSingleContentTitleSectionItem_;
    }

@synthesize singleContentActionSectionItem_ = priSingleContentActionSectionItem_;
- ( NSSplitViewItem* ) singleContentActionSectionItem_
    {
    if ( !priSingleContentActionSectionItem_ )
        {
        priSingleContentActionSectionItem_ = [ NSSplitViewItem splitViewItemWithViewController: self.wrapperOfSingleContentActionSectionView_ ];

        priSingleContentActionSectionItem_.minimumThickness = 40.f;
        priSingleContentActionSectionItem_.maximumThickness = 40.f;
        }

    return priSingleContentActionSectionItem_;
    }

@synthesize singleContentDescriptionSectionItem_ = priSingleContentDescriptionSectionItem_;
- ( NSSplitViewItem* ) singleContentDescriptionSectionItem_
    {
    if ( !priSingleContentDescriptionSectionItem_ )
        priSingleContentDescriptionSectionItem_ = [ NSSplitViewItem splitViewItemWithViewController: self.wrapperOfSingleContentDescriptionSectionView_ ];
    return priSingleContentDescriptionSectionItem_;
    }

@synthesize singleContentInformationSectionItem_ = priSingleContentInformationSectionItem_;
- ( NSSplitViewItem* ) singleContentInformationSectionItem_
    {
    if ( !priSingleContentInformationSectionItem_ )
        priSingleContentInformationSectionItem_ = [ NSSplitViewItem splitViewItemWithViewController: self.wrapperOfSingleContentInformationSectionView_ ];
    return priSingleContentInformationSectionItem_;
    }

@end // TauContentInspectorSingleSelectionSubView class