//
//  UIPostCell.h
//  PostAdvert11
//
//  Created by Mtk Ray on 5/8/12.
//  Copyright (c) 2012 ray@futureworkz.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailViewController.h"
#import "OHAttributedLabel.h"
#import "AddCommentViewController.h"
@class PostCellContent;
@class LinkPreview;
@class LinkViewController;
@class ImageViewController;
@class ThumbnailPostCellView;
@class SDWebImageRootViewController;
@interface UIPostCell : UITableViewCell <UIActionSheetDelegate, OHAttributedLabelDelegate, AddCommentViewControllerDelegate>//< UITextViewDelegate>
{
    IBOutlet OHAttributedLabel *titlePost;
    IBOutlet OHAttributedLabel *textContent;
    IBOutlet UIView *clapComment;//bottom view cell
    IBOutlet LinkPreview *videoView;
    IBOutlet LinkPreview *linkView;
    IBOutlet ThumbnailPostCellView *thumbnailView;
    SDWebImageRootViewController *newController;
    ImageViewController *imageViewCtr;
    IBOutlet UIImageView *imgAvatar;
    IBOutlet UILabel *userName;
    IBOutlet UILabel *timeCreated;
    IBOutlet UILabel *numClap;
    IBOutlet UIButton *clapBtn;
    IBOutlet UIButton *commentBtn;
    IBOutlet UIButton *quickCommentBtn;
    IBOutlet UIView *botView;
    
    //internal var
    BOOL isDidDraw;
    BOOL isLoadContent;
    int  optionView;
}
@property (nonatomic, strong) IBOutlet OHAttributedLabel *titlePost;
@property (nonatomic, strong) IBOutlet OHAttributedLabel *textContent;
@property (nonatomic, strong) IBOutlet LinkPreview *videoView;
@property (nonatomic, strong) IBOutlet LinkPreview *linkView;
@property (nonatomic, strong) IBOutlet ThumbnailPostCellView *thumbnailView;
@property (nonatomic, strong) IBOutlet UIView *clapComment;
@property (nonatomic, strong) IBOutlet UIImageView *imgAvatar;
@property (nonatomic, strong) IBOutlet UILabel *userName;
@property (nonatomic, strong) IBOutlet UILabel *timeCreated;
@property (nonatomic, strong) IBOutlet UIButton *clapBtn;
@property (nonatomic, strong) IBOutlet UILabel *numClap;
@property (nonatomic, strong) IBOutlet UIButton *commentBtn;
@property (nonatomic, strong) IBOutlet UIButton *quickCommentBtn;
@property (nonatomic, strong) IBOutlet UIView *botView;

@property (nonatomic, strong) UIButton *clapIcon;
@property (nonatomic, strong) UIButton *commentIcon;
@property (nonatomic, strong) UILabel *numComment;
@property (nonatomic, strong) UIButton *dotBtn;


@property (nonatomic) BOOL isLoadContent;
@property (nonatomic) BOOL isShowFullText;

@property (nonatomic, strong) PostCellContent *content;
@property (nonatomic) Float32 height;
@property (nonatomic, strong) UINavigationController *navigationController;
@property (nonatomic)         BOOL isDidDraw;
@property (nonatomic, strong) NSIndexPath *indexPath;
- (void) updateCellWithContent:(PostCellContent *)content andOption:(int)opt;
//- (UIView*) drawContent;
- (CGRect) nextFrameWithSize:(CGSize) size fromFrame:(CGRect) frame withMaxY:(Float32) y;
//- (UIView*) createClapCommentFromPoint:(CGPoint) point;
- (void) clapButtonClicked:(id) sender;
- (NSString*) getYoutubeIDFromUrl:(NSString*) url;
- (void) plusButtonClicked;
- (void) commentButtonClick:(id) sender;
- (void) sendCommentWithText:(NSString*)str;
- (void) clap_UnClapPost;
- (void) loadNibFile;
- (void) updateView;
- (void) refreshClapCommentsView;
+ (Float32) getCellHeightWithContent:(PostCellContent*)content andOption:(int)opt;
@end
