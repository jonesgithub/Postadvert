//
//  FriendsViewController.h
//  Postadvert
//
//  Created by Mtk Ray on 7/3/12.
//  Copyright (c) 2012 Futureworkz. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FriendsViewControllerDelegate;

@interface FriendsViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchDisplayDelegate>
{
    NSMutableArray *listFriendCellContent;
    NSMutableArray *filteredListContent;
    NSMutableArray *sectionedListContent;  // The content filtered into alphabetical sections.
    NSInteger totalFriends;
    NSInteger currentIndex_friend;
    BOOL isLoadData;
    long userID;
    NSString *userFullName;
}
@property (nonatomic, weak) id <FriendsViewControllerDelegate> delegate;
@property (nonatomic, weak) UINavigationController *navigationController;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *activityView;

- (NSInteger)getTotalFriends;
- (id)getFriendsFrom:(NSInteger)start count:(NSInteger)count;
- (id)initWithUserID:(long) userID_ fullName:(NSString*)fullname;
@end

@protocol FriendsViewControllerDelegate
- (void) friendsViewControllerDidSelectedRowWithInfo:(NSDictionary*)info;
@end