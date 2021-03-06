//
//  HDBListResultViewController.m
//  Stroff
//
//  Created by Ray on 2/4/13.
//  Copyright (c) 2013 Futureworkz. All rights reserved.
//

#import "HDBListResultViewController.h"
#import "UIImage+Resize.h"
#import "MBProgressHUD.h"
#import "HBBResultCellData.h"
#import "Constants.h"
#import "PostadvertControllerV2.h"
#import "DCAPickerViewController.h"
#import "NSData+Base64.h"
#import "CredentialInfo.h"
#import "UIImageView+URL.h"
#import "UserPAInfo.h"
#import "HDBResultDetailViewController.h"
@interface HDBListResultViewController ()

@end

@implementation HDBListResultViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIImage *image = [UIImage imageNamed:@"titleHDB.png"];
    image = [image resizedImage:self.lbTitle.frame.size interpolationQuality:0];
    [self.lbTitle setBackgroundColor:[UIColor colorWithPatternImage:image]];
    [self.lbNumFound setText:@"   0 propertie found"];
    [self.lbNumFound setBackgroundColor:[UIColor colorWithRed:90.0/255 green:85.0/255 blue:73.0/255 alpha:1]];
    [self.lbNumFound setTextColor:[UIColor whiteColor]];
    resultType = @"For Sale";

    
    //setup footview
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, 44)];
    [footerView setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth];
    footerView.autoresizesSubviews = YES;
    self.view.frame =[[UIScreen mainScreen] bounds];
    //self.tableView.frame = [[UIScreen mainScreen] bounds];
    [self.tableView setTableFooterView: footerView];
    // = [UIColor colorWithRed:235/255.0 green:247/255.0 blue:247/255.0 alpha:1];
    footerLoading = [[MBProgressHUD alloc]initWithView:self.tableView.tableFooterView];
    footerLoading.hasBackground = NO;
    footerLoading.mode = MBProgressHUDModeIndeterminate;
    footerLoading.autoresizingMask = footerView.autoresizingMask;
    footerLoading.autoresizesSubviews = YES;
    footerView = nil;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setLbTitle:nil];
    [self setTableView:nil];
    [self setLbNumFound:nil];
    [self setPullTableViewCtrl:nil];
    [self setPullTableViewCtrl:nil];
    [super viewDidUnload];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (hud) {
        if (hud.superview) {
            [hud removeFromSuperview];
        }
        hud = nil;
    }else
    {
        //the first time
        hud = [[MBProgressHUD alloc]initWithView:self.view];
        [self.view addSubview:hud];
        [hud showWhileExecuting:@selector(loadDataInBackground) onTarget:self withObject:nil animated:YES];
        
    }
}

- (void) viewDidDisappear:(BOOL)animated
{
    if (hud) {
        if (hud.superview) {
            [hud removeFromSuperview];
        }
        hud = nil;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return currentListResult.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HBBResultCellData *cellData = [currentListResult objectAtIndex:indexPath.section];
    if (indexPath.row == 0) {
        static NSString *CellIdentifier1 = @"HDBListResultCell1";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
        if (cell == nil) {
            
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:CellIdentifier1 owner:self options:nil];
            cell = [topLevelObjects objectAtIndex:0];
            topLevelObjects = nil;
            [cell setBackgroundColor:[UIColor colorWithRed:140.0/255 green:204.0/255 blue:211.0/255 alpha:1]];
            cell.backgroundView = [[UIView alloc] init];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        NSInteger index = 0;
        NSString *value =@"";
        //Property Status
        UILabel *status = (UILabel*)[cell viewWithTag:1];
        if ([property_status isEqualToString:@"r"]) {
            [status setText:@"For Rent"];
        }else
        {
            [status setText:@"For Sale"];
        }
        //Create
        UILabel *created = (UILabel*)[cell viewWithTag:2];
        index = [cellData.paraNames indexOfObject:@"created"];
        value = [NSData stringDecodeFromBase64String:[cellData.paraValues objectAtIndex:index]];
        [created setText:value];
        //thumb
        UIImageView *imagView = (UIImageView*)[cell viewWithTag:3];
        index = [cellData.paraNames indexOfObject:@"thumb"];
        value = [cellData.paraValues objectAtIndex:index];
        [imagView setImageWithURL:[NSURL URLWithString:value]];
        //Title
        UILabel *titleHDB = (UILabel*) [cell viewWithTag:4];
        index = [cellData.paraNames indexOfObject:@"block_no"];
        value = [cellData.paraValues objectAtIndex:index];
        
        index = [cellData.paraNames indexOfObject:@"street_name"];
        value = [NSString stringWithFormat:@"%@ %@",value, [cellData.paraValues objectAtIndex:index]];
        [titleHDB setText:value];
        //price
        UILabel *price = (UILabel*) [cell viewWithTag:12];
        if ([property_status isEqualToString:@"s"]) {
            index = [cellData.paraNames indexOfObject:@"price"];
        }else
        {
            index = [cellData.paraNames indexOfObject:@"monthly_rental"];
        }
        
        value = [cellData.paraValues objectAtIndex:index];
        [price setText:[NSString stringWithFormat:@"S$ %@", value]];
        //psf
        index = [cellData.paraNames indexOfObject:@"psf"];
        value = [cellData.paraValues objectAtIndex:index];
        
        [price setText:[NSString stringWithFormat:@"%@ (S$ %@ psf)",price.text, value]];
        
        
        //lease_term_valuation_price (unit_level)
        UILabel *lease_term_valuation_price = (UILabel*) [cell viewWithTag:5];
        if ([property_status isEqualToString:@"s"]) {
            index = [cellData.paraNames indexOfObject:@"valuation_price"];
            value = [NSString stringWithFormat:@"S$ %@ valuation", [cellData.paraValues objectAtIndex:index]];
        }else
        {
            index = [cellData.paraNames indexOfObject:@"lease_term"];
            value = [cellData.paraValues objectAtIndex:index];
        }
        
        //unit_level
        index = [cellData.paraNames indexOfObject:@"unit_level"];
        NSString *unit_level = [cellData.paraValues objectAtIndex:index];
        if (unit_level.length > 0) {
            value = [NSString stringWithFormat:@"%@ ( %@ )", value, unit_level];
        }
        [lease_term_valuation_price setText:value];
        //hdb_estate
        UILabel *hdb_estate = (UILabel*) [cell viewWithTag:6];
        index = [cellData.paraNames indexOfObject:@"hdb_estate"];
        value = [cellData.paraValues objectAtIndex:index];
        
        //furnishing
        index = [cellData.paraNames indexOfObject:@"furnishing"];
        NSString *furnishing = [cellData.paraValues objectAtIndex:index];
        if (! [furnishing isEqualToString:@""] ) {
            value = [value stringByAppendingFormat:@" ( %@ )", furnishing];
        }
        [hdb_estate setText:value];
        //size
        UILabel *size = (UILabel*) [cell viewWithTag:7];
        index = [cellData.paraNames indexOfObject:@"size"];
        value = [cellData.paraValues objectAtIndex:index];
        [size setText:[NSString stringWithFormat:@"%@ sqft",value]];
        float sqft = [value floatValue];
        float sqm = sqft * 0.092903;
        [size setText:[NSString stringWithFormat:@"%@ sqft / %0.02f sqm",value, sqm]];
        //building_completion
        UILabel *building_completion = (UILabel*) [cell viewWithTag:11];
        index = [cellData.paraNames indexOfObject:@"building_completion"];
        value = [cellData.paraValues objectAtIndex:index];
        [building_completion setText:[NSString stringWithFormat:@"%@ Completed", value]];
        //bedrooms
        UILabel *bedrooms = (UILabel*) [cell viewWithTag:8];
        index = [cellData.paraNames indexOfObject:@"bedrooms"];
        value = [cellData.paraValues objectAtIndex:index];
        [bedrooms setText:value];
        //washroom
        UILabel *washroom = (UILabel*) [cell viewWithTag:9];
        index = [cellData.paraNames indexOfObject:@"washroom"];
        value = [cellData.paraValues objectAtIndex:index];
        [washroom setText:value];

        return cell;
        
    }
    
    if (indexPath.row > 0) {
        static NSString *CellIdentifier2 = @"HDBListResultCell2";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
        if (cell == nil) {
            
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:CellIdentifier2 owner:self options:nil];
            cell = [topLevelObjects objectAtIndex:0];
            topLevelObjects = nil;
            [cell setBackgroundColor:[UIColor colorWithRed:140.0/255 green:204.0/255 blue:211.0/255 alpha:1]];
            cell.backgroundView = [[UIView alloc] init];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        NSInteger index;
        NSString *value;
        @try {
            //avartar
            UIImageView *avatar = (UIImageView*)[cell viewWithTag:3];
            [avatar setImageWithURL:[NSURL URLWithString:cellData.userInfo.avatarUrl]];
            // posted user
            UILabel *user_posted = (UILabel*)[cell viewWithTag:4];
            [user_posted setText:cellData.userInfo.fullName];
            
            
            //ad_owner
            UILabel *ad_owner = (UILabel*)[cell viewWithTag:5];
            index = [cellData.paraNames indexOfObject:@"ad_owner"];
            value = [cellData.paraValues objectAtIndex:index];
            [ad_owner setText:value];
        }
        @catch (NSException *exception) {
            
        }
        
        [self setClapCommentForCell:cell andData:cellData];
        return cell;
    }
    return nil;
}


#pragma mark - Table view delegate

- (float) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 141;
    }
    if (indexPath.row == 1) {
        return 82;
    }
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HBBResultCellData *cellData = [currentListResult objectAtIndex:indexPath.section];
    HDBResultDetailViewController *detailViewCtr = [[HDBResultDetailViewController alloc]initWithHDBID:cellData.hdbID userID:[[UserPAInfo sharedUserPAInfo]registrationID]];
    
    detailViewCtr.property_status = property_status;
    [self.navigationController pushViewController:detailViewCtr animated:YES];
}

#pragma mark PullTableView
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    [_pullTableViewCtrl scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (isLoadData) {
        return;
    }
    
    [self.pullTableViewCtrl scrollViewDidScroll:scrollView];
	if (([scrollView contentOffset].y + scrollView.frame.size.height) + self.tableView.tableFooterView.frame.size.height >= [scrollView contentSize].height - cCellHeight - 100) {
        NSLog(@"scrolled to bottom");
        
        if (! isLoadData) {
            if (! footerLoading.superview) {
                [self.tableView.tableFooterView addSubview:footerLoading];
            }
            [footerLoading showWhileExecuting:@selector(loadMoreData) onTarget:self withObject:nil animated:YES];
        }
        return;
	}
	if ([scrollView contentOffset].y == scrollView.frame.origin.y) {
        NSLog(@"scrolled to top ");
        
	}
    
    
}

- (void) pullToUpdate
{
    if (!loadingHideView) {
        loadingHideView = [[MBProgressHUD alloc]init];
        loadingHideView.hasBackground = NO;
        loadingHideView.mode = MBProgressHUDModeIndeterminate;
    }
    
    isLoadData = YES;
    [loadingHideView showWhileExecuting:@selector(addNewData) onTarget:self withObject:nil animated:YES];
}

#pragma mark - background function

- (void) loadDataInBackground
{
    totalResultCount = 100;
    resultType = @"For Sale";
    currentListResult = [[NSMutableArray alloc] init];
    [self initAndLoadData];
    [self parseData];
    [self getData];
    //[self demoData];
    [self.tableView reloadData];
    
}

- (void) setNumFound:(NSNumber*) num
{
    NSInteger numFound = num.integerValue;
    if (numFound > 1) {
        [self.lbNumFound setText:[NSString stringWithFormat:@"   %d properties found", numFound]];
    }
    else
    {
            [self.lbNumFound setText:[NSString stringWithFormat:@"   %d propertie found", numFound]];
    }

}
- (void) getData
{
    //function searchHDB($property_status, $keywords, $property_type, $hdb_owner, $hdb_estate, $bedrooms_from, $bedrooms_to, $washrooms_from, $washrooms_to, $price_from, $price_to, $size_from, $size_to, $valuation_from, $valuation_to, $lease_term_from, $lease_term_to, $completion_from, $completion_to, $unit_level, $furnishing, $condition, $limit, $hdb_id = 0, $psf_from, $psf_to, $user_id, $sort_type, $start, $scroll = 'down', $is_save = 0, $base64_image = false) 

    id data;
    NSString *functionName;
    NSArray *paraNames;
    NSMutableArray *paraValues = [[NSMutableArray alloc]init];
    functionName = @"searchHDB";
    paraNames = [NSArray arrayWithObjects:@"property_status", @"keywords", @"property_type", @"hdb_owner", @"hdb_estate", @"bedrooms_from", @"bedrooms_to", @"washrooms_from", @"washrooms_to", @"price_from", @"price_to", @"size_from", @"size_to", @"valuation_from", @"valuation_to", @"lease_term_from", @"lease_term_to", @"completion_from", @"completion_to", @"unit_level", @"furnishing", @"condition", @"limit", @"hdb_id",@"psf_from",@"psf_to", @"user_id", @"sort_type", @"start", @"scroll", @"is_save",  nil];
    //paraValues = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%ld", [UserPAInfo sharedUserPAInfo].registrationID], [NSString stringWithFormat:@"%d",self.infoChatting.parent_id],self.message.text, @"5", nil];
    
    //property_status
    [paraValues addObject:property_status];
    //keyWorlds
    NSString *keyWorlds = [[NSUserDefaults standardUserDefaults] valueForKey:@"keyWorlds"];
    if (! keyWorlds) {
        keyWorlds = @"";
    }
    [paraValues addObject:keyWorlds];
    
    //
    int index = 0;
    NSString *value;
    NSArray *from_to;
    //property_type
    index = [mainFiles indexOfObject:@"HDB Type"];
    value = [mainFilesValues objectAtIndex:index];
    [paraValues addObject:value];
    //hdb_owner
    index = [mainFiles indexOfObject:@"Ad Owner"];
    value = [mainFilesValues objectAtIndex:index];
    [paraValues addObject:value];
    //hdb_estate
    index = [mainFiles indexOfObject:@"HDB Estate"];
    value = [mainFilesValues objectAtIndex:index];
    [paraValues addObject:value];
    //bedrooms_from
    index = [mainFiles indexOfObject:@"Bedrooms"];
    value = [mainFilesValues objectAtIndex:index];
    from_to = [value componentsSeparatedByString:@"____"];
    //bedrooms_to
    if (from_to.count == 2) {
        [paraValues addObjectsFromArray:from_to];
    }else{
        [paraValues addObject:@"0"];
        [paraValues addObject:@"0"];
    }
    //washrooms_from
    index = [mainFiles indexOfObject:@"Washrooms"];
    value = [mainFilesValues objectAtIndex:index];
    from_to = [value componentsSeparatedByString:@"____"];
    //washrooms_to
    if (from_to.count == 2) {
        [paraValues addObjectsFromArray:from_to];
    }else{
        [paraValues addObject:@"0"];
        [paraValues addObject:@"0"];
    }
    //price_from
    index = [mainFiles indexOfObject:@"Price"];
    if (index == NSIntegerMax) {
        index = [mainFiles indexOfObject:@"Monthly Rental"];
    }
    value = [mainFilesValues objectAtIndex:index];
    //price_to
    from_to = [value componentsSeparatedByString:@"____"];
    if (from_to.count == 2) {
        [paraValues addObjectsFromArray:from_to];
    }else{
        [paraValues addObject:@"0"];
        [paraValues addObject:@"0"];
    }
    //size_from
    index = [mainFiles indexOfObject:@"Size"];
    value = [mainFilesValues objectAtIndex:index];
    //size_to
    from_to = [value componentsSeparatedByString:@"____"];
    if (from_to.count == 2) {
        [paraValues addObjectsFromArray:from_to];
    }else{
        [paraValues addObject:@"0"];
        [paraValues addObject:@"0"];
    }
    //valuation_from
    index = [mainFiles indexOfObject:@"Val'n Price"];
    value = [mainFilesValues objectAtIndex:index];
    //valuation_to
    from_to = [value componentsSeparatedByString:@"____"];
    if (from_to.count == 2) {
        [paraValues addObjectsFromArray:from_to];
    }else{
        [paraValues addObject:@"0"];
        [paraValues addObject:@"0"];
    }
    //lease_term_from
    index = [mainFiles indexOfObject:@"Lease Term"];
    if (index == NSIntegerMax) {
        [paraValues addObject:@"0"];
        [paraValues addObject:@"0"];
    }else
    {
#warning waiting for wb
        [paraValues addObject:@"0"];
        [paraValues addObject:@"0"];
    }
    
    //lease_term_to
    
    
    //completion_from
    index = [mainFiles indexOfObject:@"Constructed"];
    if (from_to.count == 2) {
        [paraValues addObjectsFromArray:from_to];
    }else{
        [paraValues addObject:@"0"];
        [paraValues addObject:@"0"];
    }
    //completion_to
    //unit_level
    index = [mainFiles indexOfObject:@"Unit Level"];
    value = [mainFilesValues objectAtIndex:index];
    [paraValues addObject:value];
    //furnishing
    index = [mainFiles indexOfObject:@"Furnishing"];
    value = [mainFilesValues objectAtIndex:index];
    [paraValues addObject:value];
    //condition
    index = [mainFiles indexOfObject:@"Condition"];
    value = [mainFilesValues objectAtIndex:index];
    [paraValues addObject:value];
    //limit
    value = @"5";
    [paraValues addObject:value];
    //hdb_id
    value = @"0";
    [paraValues addObject:value];
    //psf from
    index = [mainFiles indexOfObject:@"PSF"];
    value = [mainFilesValues objectAtIndex:index];
    from_to = [value componentsSeparatedByString:@"____"];
    //psf to
    if (from_to.count == 2) {
        [paraValues addObjectsFromArray:from_to];
    }else{
        [paraValues addObject:@"0"];
        [paraValues addObject:@"0"];
    }
    
    //user_id
    [paraValues addObject:[NSString stringWithFormat:@"%ld", [UserPAInfo sharedUserPAInfo].registrationID]];
    //sort_type
    [paraValues addObject:sortByValue];
    //start
    value = [[NSUserDefaults standardUserDefaults] objectForKey:@"start"];
    [paraValues addObject:value];
    //scroll
    value = [[NSUserDefaults standardUserDefaults] objectForKey:@"scroll"];
    [paraValues addObject:value];
    //is_save
    value = @"0";
    [paraValues addObject:value];

    // replace "Any" - > ""
    for (int i = 0; i < paraValues.count; i++) {
        NSString *myValue = [paraValues objectAtIndex:i];
        if ([myValue isEqualToString:@"Any"]) {
            [paraValues replaceObjectAtIndex:i withObject:@""];
        }
        if ([myValue isEqualToString:@"Select One"]) {
            [paraValues replaceObjectAtIndex:i withObject:@""];
        }
    }
    data = [[PostadvertControllerV2 sharedPostadvertController] jsonObjectFromWebserviceWithFunctionName: functionName parametterName:paraNames parametterValue:paraValues];
    
    for (NSDictionary *dict in data) {
        if (![dict isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        
        NSString *count = [dict objectForKey:@"count"];
        NSNumber *num = [NSNumber numberWithInteger:count.integerValue];
        [self performSelectorOnMainThread:@selector(setNumFound:) withObject:num waitUntilDone:NO];
        
        HBBResultCellData *cellData = [[HBBResultCellData alloc]init];
        cellData.hdbID = [[dict objectForKey:@"id"] integerValue];
        cellData.timeCreated = [NSData stringDecodeFromBase64String:[dict objectForKey:@"created"]];
        cellData.titleHDB = [dict objectForKey:@"block_no"];
        NSString *title = [dict objectForKey:@"street_name"];
        cellData.titleHDB = [cellData.titleHDB stringByAppendingString:title];
        
        //author
        NSDictionary *authorDict = [dict objectForKey:@"author"];
        cellData.userInfo = [[CredentialInfo alloc]init];
        if ([authorDict isKindOfClass:[NSDictionary class]]) {
            cellData.userInfo = [[CredentialInfo alloc]initWithDictionary:authorDict];
        }
        
        for (NSString *key in cellData.paraNames) {
            id object = [dict objectForKey:key];
            if (object != nil) {
                [cellData.paraValues addObject: object];
            }
        }
        
        [currentListResult addObject:cellData];
    }
    isLoadData = NO;
}

- (void) addNewData
{
    isLoadData = YES;
    NSUserDefaults *database = [NSUserDefaults standardUserDefaults];
    NSString *start = [NSString stringWithFormat:@"%d", currentListResult.count];
    [database setValue:start forKey:@"start"];
    [database setValue:@"up" forKey:@"scroll"];
    [self getData];
    [self.tableView reloadData];
    [self.pullTableViewCtrl performSelector:@selector(stopLoading)];
}

- (void) loadMoreData
{
    isLoadData = YES;
    NSUserDefaults *database = [NSUserDefaults standardUserDefaults];
    NSString *start = [NSString stringWithFormat:@"%d", currentListResult.count];
    [database setValue:start forKey:@"start"];
    [database setValue:@"down" forKey:@"scroll"];
    [self getData];
    [self.tableView reloadData];
}

- (void) demoData
{
    for (int i =0; i< 5; i++) {
        HBBResultCellData *cellData = [[HBBResultCellData alloc]init];
        cellData.timeCreated = [NSDate date];
        cellData.titleHDB = @"Title here";
        cellData.description = @"Descrition here";
        NSArray *array = [NSArray arrayWithObjects:@"http://res.vtc.vn/media/vtcnews/2012/08/25/VTP33jpg1345887771.jpg", @"http://res.vtc.vn/media/vtcnews/2012/08/25/VTP33jpg1345887771.jpg", nil];
        cellData.images = [[NSMutableArray alloc]init];
        [cellData.images addObject:array];
        
        [currentListResult addObject:cellData];
    }
}

- (void) initAndLoadData
{
    NSString *plistPathForStaticDCA = [[NSBundle mainBundle] pathForResource:@"DCA" ofType:@"plist"];
    staticData = [NSDictionary dictionaryWithContentsOfFile:plistPathForStaticDCA];
    staticData = [NSDictionary dictionaryWithDictionary: [staticData objectForKey:@"HDB Search"]];
    NSDictionary *dict;
    NSUserDefaults *database = [[NSUserDefaults alloc]init];
    property_status = [database objectForKey:@"property_status"];
    if ([property_status isEqualToString:@"s"] || [property_status isEqualToString:@"S"] || [property_status isEqualToString:@"Sale"] || [property_status isEqualToString:@"sale"]) {
        property_status = @"s";
    }else
        property_status =@"r";
    
    if ([property_status isEqualToString:@"s"]) {
        dict = [NSDictionary dictionaryWithDictionary: [staticData objectForKey:@"Sale"]];
    }else
        dict = [NSDictionary dictionaryWithDictionary: [staticData objectForKey:@"Rent"]];
    
    if([property_status isEqualToString: @"s"])
    {
            //init
            mainFiles = [[NSMutableArray alloc] initWithArray:[dict objectForKey:@"Main Fields"]];
            moreOptions = [dict objectForKey:@"More Options"];
    }
    if ([property_status isEqualToString:@"r"])
    {
            //init
            mainFiles = [[NSMutableArray alloc] initWithArray:[dict objectForKey:@"Main Fields"]];
            moreOptions = [dict objectForKey:@"More Options"];
    }
    [mainFiles addObjectsFromArray:moreOptions];
    mainFilesValues = [[NSMutableArray alloc]init];
    for (NSString *key in mainFiles) {
        NSString *value = [[NSUserDefaults standardUserDefaults] objectForKey:key];
        if (!value) {
            value = @"";
        }
        [mainFilesValues addObject:value];
        
        
    }
    sortByValue = [[NSUserDefaults standardUserDefaults] objectForKey:@"Sort By"];
}

- (void) parseData
{
    for (int i =0; i < mainFiles.count; i++) {
        NSString *key = [mainFiles objectAtIndex:i];
        NSString *value = [mainFilesValues objectAtIndex:1];
        // HDB Type
        //HDB Estate
        if ([key isEqualToString:@"HDB Estate"]) {
            value = [value stringByReplacingOccurrencesOfString:@", " withString:@"HDB_ESTATE"];
            [mainFilesValues replaceObjectAtIndex:i withObject:value];
            continue;
        }
        
        // Sort by
        //Filters
//        if ([[self tableView:tableView titleForHeaderInSection:indexPath.section] isEqualToString:@"Filters"]) {
//            if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
//                cell.accessoryType = UITableViewCellAccessoryNone;
//            }
//            else
//                cell.accessoryType = UITableViewCellAccessoryCheckmark;
//        }
        
        {
            if ([key isEqualToString:@"Price"] || [key isEqualToString:@"Monthly Rental"] || [key isEqualToString:@"Size"] || [key isEqualToString:@"Bedrooms"] || [key isEqualToString:@"Val'n Price"] || [key isEqualToString:@"Washrooms"] || [key isEqualToString:@"Constructed"] || [key isEqualToString:@"PSF"]) {
                NSString *value = [mainFilesValues objectAtIndex:i];
                value = [value stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
                NSArray *array = [value componentsSeparatedByString:@" to "];
                NSInteger start = 0;
                NSInteger end = 0;
                UIDCAPickerControllerSourceType sourceType = pickerTypeUnknow;
                
                NSArray *listValues;
                //Price
                if ([key isEqualToString:@"Price"]) {
                    listValues = [staticData objectForKey:@"Price"];
                    sourceType = pickerTypePrice;
                }
                //Monthly Rental
                if ([key isEqualToString:@"Monthly Rental"]) {
                    listValues = [staticData objectForKey:@"Price"];
                    sourceType = pickerTypePrice;
                }
                //Size
                if ([key isEqualToString:@"Size"]) {
                    listValues = [staticData objectForKey:@"Size"];
                    sourceType = pickerTypeSize;
                }
                //Bedrooms
                if ([key isEqualToString:@"Bedrooms"]) {
                    listValues = [staticData objectForKey:@"Bedrooms"];
                    sourceType = pickerTypeBedrooms;
                }
                // Val'n Price
                if ([key isEqualToString:@"Val'n Price"]) {
                    listValues = [staticData objectForKey:@"Price"];
                    sourceType = pickerTypeValnSize;
                }
                //Washrooms
                if ([key isEqualToString:@"Washrooms"]) {
                    listValues = [staticData objectForKey:@"Washrooms"];
                    sourceType = pickerTypeWashrooms;
                }
                //Constructed
                if ([key isEqualToString:@"Constructed"]) {
                    listValues = [staticData objectForKey:@"Constructed"];
                    sourceType = pickerTypeConstructed;
                }
                //{SF
                if ([key isEqualToString:@"PSF"]) {
                    listValues = [staticData objectForKey:@"PSF"];
                    sourceType = pickerTypePSF;
                }
                if (array.count == 1) {
                    array = [value componentsSeparatedByString:@" and "];
                    if (array.count == 1) {
                        if ([[array objectAtIndex:0] isEqual:@"Any"]) {
                            start = -1;
                            end = -1;
                        }
                        else
                        {
                            end = [listValues indexOfObject:[array objectAtIndex:0] ];
                            start = end;
                        }
                        
                    }
                    
                }
                if (array.count >=2) {
                    start = [listValues indexOfObject:[array objectAtIndex:0] ];
                    end = [listValues indexOfObject:[array objectAtIndex:1]];
                    if ([[array objectAtIndex:1] isEqual:@"above"]) {
                        end = -1;
                    }
                    if ([[array objectAtIndex:1] isEqual:@"below"]) {
                        end = start;
                        start = -1;
                    }
                }
                //
                NSString *startValue, *endValue;
                if (start >= 0) {
                    startValue = [listValues objectAtIndex:start];
                }else
                    startValue = @"Any";
                if (end >=0) {
                    endValue = [listValues objectAtIndex:end];
                }else
                    endValue = @"Any";
                if (sourceType == pickerTypeSize) {
                    NSArray *values = [startValue componentsSeparatedByString:@" ("];
                    startValue = [values objectAtIndex:0];
                    values = [endValue componentsSeparatedByString:@" ("];
                    endValue = [values objectAtIndex:0];
                }
                
                NSArray *needToDeletes = [NSArray arrayWithObjects:@" sqft", @" Bedrooms", @" Bedroom", @" Washrooms", @" Washroom", @"S$", nil];
                for (NSString *strDeleted in needToDeletes) {
                    startValue = [startValue stringByReplacingOccurrencesOfString:strDeleted withString:@""];
                    endValue = [endValue stringByReplacingOccurrencesOfString:strDeleted withString:@""];
                }
                [mainFilesValues replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%@____%@", startValue, endValue]];
                continue;
            }
        }
        //}
        
        
        //Add Owner
        
        //Unit Level
        
        
        //Furnishing
        
        //Condition
        
        
        // Lease Term
    }
    
}

- (void) setClapCommentForCell:(UITableViewCell*)cell andData:(HBBResultCellData*)cellData
{
    UILabel *numClap = (UILabel*)[cell viewWithTag:12];
    UIButton *clapBtn = (UIButton*)[cell viewWithTag:8];
    UILabel *_numComment = (UILabel*)[cell viewWithTag:14];
    UIButton *commentBtn = (UIButton*)[cell viewWithTag:10];
    UIButton *_dotBtn = (UIButton*)[cell viewWithTag:9];
    UIImageView *_commentIcon = (UIImageView*)[cell viewWithTag:13];
    UIImageView *_clapIcon = (UIImageView*)[cell viewWithTag:11];
    NSInteger totalClap = 0, totalComment = 0, totalView = 0, index;
    BOOL isClap = NO;
    NSString *value = @"";
    //clap_info
    NSDictionary *clap_info;
    index = [cellData.paraNames indexOfObject:@"clap_info"];
    clap_info = [cellData.paraValues objectAtIndex:index];
    isClap = [[clap_info objectForKey:@"is_clap"]boolValue];
        //total_claps
    totalClap = [[clap_info objectForKey:@"total_claps"]integerValue];
    //total_comments
    index = [cellData.paraNames indexOfObject:@"total_comments"];
    value = [cellData.paraValues objectAtIndex:index];
    totalComment = [value integerValue];
    //total_views
    index = [cellData.paraNames indexOfObject:@"total_views"];
    value = [cellData.paraValues objectAtIndex:index];
    totalView = [value integerValue];
    
    numClap.text = [NSString stringWithFormat:@"%d", totalClap];
    NSString *clapBtTitle = isClap ? @"Unclap" : @"Clap";
    [clapBtn setTitle:clapBtTitle forState:UIControlStateNormal];
    [clapBtn setTitle:clapBtTitle forState:UIControlStateHighlighted];
    _numComment.text = [NSString stringWithFormat:@"%d", totalComment];
    
    //set action
    index = [currentListResult indexOfObject:cellData];
    NSNumber *num = [NSNumber numberWithInteger:index];
    [[NSUserDefaults standardUserDefaults] setValue:num forKey:@"cellData"];
    [clapBtn addTarget:self action:@selector(insertClap) forControlEvents:UIControlEventTouchUpInside];
    [commentBtn addTarget:self action:@selector(commentBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    //Update location
    float y = 3;
    [clapBtn sizeToFit];
    [commentBtn sizeToFit];
    [_dotBtn sizeToFit];
    CGRect frame = clapBtn.frame;
    frame.origin.x = CELL_CONTENT_MARGIN_LEFT;
    frame.origin.y = y;
    clapBtn.frame = frame;
    
    frame = _dotBtn.frame;
    frame.origin.x = clapBtn.frame.origin.x + clapBtn.frame.size.width + 3;
    frame.origin.y = -y;
    _dotBtn.frame = frame;
    
    frame = commentBtn.frame;
    frame.origin.x = _dotBtn.frame.origin.x + _dotBtn.frame.size.width + 3;
    frame.origin.y = y;
    commentBtn.frame = frame;
    
    float width = 288 - CELL_CONTENT_MARGIN_RIGHT;
    if (totalComment) {
        [_numComment sizeToFit];
        width -= _numComment.frame.size.width;
        frame = _numComment.frame;
        //width -= frame.size.width;
        frame.origin.x = width;
        frame.origin.y = y;
        _numComment.frame = frame;
        
        //[_commentIcon sizeToFit];
        width -= (_commentIcon.frame.size.width + 3);
        frame =_commentIcon.frame;
        frame.origin.x = width;
        frame.origin.y = y;
        _commentIcon.frame = frame;
        
        _commentIcon.hidden = NO;
        _numComment.hidden = NO;
        width -= 5;
    }else{
        _numComment.hidden = YES;
        _commentIcon.hidden = YES;
    }
    
    if (totalClap) {
        numClap.hidden = NO;
        _clapIcon.hidden = NO;
        
        [numClap sizeToFit];
        width -= numClap.frame.size.width;
        frame = numClap.frame;
        //width -= frame.size.width;
        frame.origin.x = width;
        frame.origin.y = y;
        numClap.frame = frame;
        
        //[_clapIcon sizeToFit];
        width -= (_clapIcon.frame.size.width + 3);
        frame =_clapIcon.frame;
        frame.origin.x = width;
        frame.origin.y = y;
        _clapIcon.frame = frame;
    }else
    {
        numClap.hidden = YES;
        _clapIcon.hidden = YES;
    }
    
}

- (void) insertClap
{
    // hdbClap($user_id, $hdb_id)
    
    id data;
    NSString *functionName;
    NSArray *paraNames;
    NSArray *paraValues;
    HBBResultCellData *cellData;
    NSNumber *num = [[NSUserDefaults standardUserDefaults] objectForKey:@"cellData"];
    cellData = [currentListResult objectAtIndex:num.integerValue];
    functionName = @"hdbClap";
    paraNames = [NSArray arrayWithObjects:@"user_id", @"hdb_id", nil];
    paraValues = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%ld", [UserPAInfo sharedUserPAInfo].registrationID], [NSString stringWithFormat:@"%d", cellData.hdbID], nil];
    data = [[PostadvertControllerV2 sharedPostadvertController] jsonObjectFromWebserviceWithFunctionName:functionName parametterName:paraNames parametterValue:paraValues];
    
    @try {
        NSInteger isClap = [[data objectForKey:@"clap"] integerValue];
        NSInteger totalClap = [[data objectForKey:@"total_clap"] integerValue];
        //Update clap
        
        NSInteger index = [cellData.paraNames indexOfObject:@"clap_info"];
        NSDictionary *clapInfo = [cellData.paraValues objectAtIndex:index];
        [clapInfo setValue:[NSString stringWithFormat:@"%d", totalClap] forKey:@"total_claps"];
        [clapInfo setValue:[NSString stringWithFormat:@"%d", isClap] forKey:@"is_clap"];
        [cellData.paraValues replaceObjectAtIndex:index withObject:clapInfo];
        
        [self.tableView reloadData];
        
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
}

- (void) commentBtnClicked:(id)sender
{
    NSNumber *num = [[NSUserDefaults standardUserDefaults] objectForKey:@"cellData"];
    
    HBBResultCellData *cellData = [currentListResult objectAtIndex:num.integerValue];
    HDBResultDetailViewController *detailViewCtr = [[HDBResultDetailViewController alloc]initWithHDBID:cellData.hdbID userID:[[UserPAInfo sharedUserPAInfo]registrationID]];
    detailViewCtr.showKeyboard = YES;
    detailViewCtr.property_status = property_status;
    [self.navigationController pushViewController:detailViewCtr animated:YES];
}
@end
