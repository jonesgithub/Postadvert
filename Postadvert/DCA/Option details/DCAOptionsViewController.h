//
//  DCAOptionsViewController.h
//  Stroff
//
//  Created by Ray on 1/24/13.
//  Copyright (c) 2013 Futureworkz. All rights reserved.
//

#import <UIKit/UIKit.h>

enum DCAOptionsType {
    DCAOptionsUnknow = 0,
    DCAOptionsSortBy = 1,
    DCAOptionsPropertyType = 2,
    DCAOptionSHDBEstate = 3,
    DCAOptionAdOwner = 4,
    DCAOptionUnitLevel = 5,
    DCAOptionFurnishing = 6,
    DCAOptionCondition = 7,
    DCAOptionLeaseTerm = 8,
    DCAOptionsLocation = 20
};

typedef NSInteger DCAOptionSourceType;
@interface DCAOptionsViewController : UITableViewController
{
    UIBarButtonItem *rightNavBtn;
}

@property (weak, nonatomic) IBOutlet id delegate;
@property (nonatomic) DCAOptionSourceType sourceType;
@property (nonatomic, strong) NSArray *intSource;
@property (nonatomic) NSInteger selectedIndex;
@property (nonatomic) NSMutableArray *selectedValues;
@property (nonatomic) BOOL  multiSelect;

- (id) initWithArray:(NSArray*)array DCAOptionType:(DCAOptionSourceType) sourceType_ selectedIndex:(NSInteger) selectedIndex;
- (id) initWithArray:(NSArray*)array DCAOptionType:(DCAOptionSourceType) sourceType_ selectedValues:(NSArray*) selectedValues_;

@end

@interface NSObject (DCAOptionsViewController)  
- (void) didSelectRowOfDCAOptionViewController:(DCAOptionsViewController*) dcaViewCtr;
@end 