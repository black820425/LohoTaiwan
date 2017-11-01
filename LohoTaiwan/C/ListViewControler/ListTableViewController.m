//
//  ListTableViewController.m
//  LohoTaiwan
//
//  Created by 黃柏恩 on 2017/10/3.
//  Copyright © 2017年 黃柏恩. All rights reserved.
#import "Singleton.h"
#import <Chameleon.h>
#import "ViewController.h"
#import "CustomPickerView.h"
#import "ListTableViewController.h"
#import "DetailUITableViewController.h"
@interface ListTableViewController ()<CustomPickerViewDelegate>

@end

@implementation ListTableViewController
{
    UIPickerView *mypickerView;
    
    NSArray *dataArray;
    NSArray *activityTypeArray;
    NSMutableArray *infosArray;
    
    NSArray *nameKeyArray ;
    NSArray *addressKeyNameArray;

    NSString *nameKey;
    NSString *addressNameKey;
    NSString *capitalRegionName;
    NSString *seletedRegionName;
    
    NSInteger capitalReginNumber;
    
    CustomPickerView *customPickView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    infosArray = [NSMutableArray new];
    self.navigationController.navigationBar.hidden = false;
    
    
    capitalRegionName = [Singleton object].capitalNameArray[0];
    
    activityTypeArray = [[Singleton object] activityTypeArray];
    
    [self setToolBarInPickView];
    [self readActivityTypeData];
    [self putInfoArray];
}

-(NSString*)setPickViewCompent:(CustomPickerView *)customPickerView {
    return @"2";
}

-(void)setToolBarInPickView {
    customPickView = [CustomPickerView new];
    customPickView.DataSource = self;
    
    [self.view addSubview:customPickView.pickerViewTextField];
    
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    toolBar.backgroundColor = [UIColor flatMintColor];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:
                                   UIBarButtonSystemItemDone target:self action:@selector(doneTouched)];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:
                                     UIBarButtonSystemItemCancel target:self action:@selector(cancelTouched)];
    
    // the middle button is to make the Done button align to right
    [toolBar setItems:[NSArray arrayWithObjects:cancelButton, [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],doneButton, nil]];
    customPickView.pickerViewTextField.inputAccessoryView = toolBar;
}

#pragma mark - Set read datatype to give dataArray 設定選取得資料種類給 dataArray
-(void)readActivityTypeData {
    nameKeyArray = @[@"Name",@"stitle"];
    addressKeyNameArray = @[@"Add",@"Address",@"address"];
    
    nameKey = nameKeyArray[0];
    addressNameKey = addressKeyNameArray[0];
    
    if([activityTypeArray[[[Singleton object] activity]] containsString:activityTypeArray[0]]) {
        dataArray = [[Singleton object]
                     readGovernmentData:@"GovernmentAttractionsData"
                     attributes:@"governmentAttractionsData"];
    } else if([activityTypeArray[[[Singleton object] activity]] containsString:activityTypeArray[1]]) {
        dataArray = [[Singleton object]
                     readGovernmentData:@"GovernmentFoodData"
                     attributes:@"governmentFoodData"];
    } else if([activityTypeArray[[[Singleton object] activity]] containsString:activityTypeArray[2]]) {
        dataArray = [[Singleton object]
                     readGovernmentData:@"GovernmentLeisureFarmData"
                     attributes:@"governmentLeisureFarmData"];
        addressNameKey = addressKeyNameArray[1];
    } else {
        dataArray = [[Singleton object]
                     readGovernmentData:@"GovernmentHotelBedAndBreakfastData"
                     attributes:@"governmentHotelBedAndBreakfastData"];
    }
}

#pragma mark - Set data arrange to give infoArray 在總資料做整理再將數值給 infosArray.
-(void)putInfoArray {
    dispatch_async(dispatch_get_main_queue(), ^{
        for(NSDictionary *dataDictionary in dataArray) {
            if(![dataDictionary[addressNameKey] containsString:[Singleton object].capitalNameArray[0]] &&
               ![dataDictionary[addressNameKey] containsString:[Singleton object].capitalNameArray[1]]) {
                if([dataDictionary[addressNameKey] length] > 0) {
                    NSArray *infoArray = [NSArray new];
                    NSString *address = [dataDictionary[addressNameKey]
                                         stringByReplacingOccurrencesOfString:@" " withString:@""];
                    infoArray = @[dataDictionary[nameKey],address];
                    [infosArray addObject:infoArray];
                    infoArray = nil;
                }
            }
        }
        [self.tableView reloadData];
    });
}

-(void)startSearchRegion {
    nameKey = nameKeyArray[0];
    addressNameKey = addressKeyNameArray[0];
    
    if ([capitalRegionName containsString:@"新北市"] &&
         [activityTypeArray[[[Singleton object] activity]] containsString:@"景點"]){
        dataArray = [[Singleton object] readGovernmentData:@"NewTaipeiAttractionsData"
                                                attributes:@"newTaipeiAttractionsData"];
        [self searchChooseRegion];
    } else if([capitalRegionName containsString:@"新北市"] &&
                  [activityTypeArray[[[Singleton object] activity]] containsString:@"餐飲"]) {
        dataArray = [[Singleton object] readGovernmentData:@"NewTaipeiFoodData"
                                                attributes:@"newTaipeiFoodData"];
        [self searchChooseRegion];
    } else if([capitalRegionName containsString:@"臺北市"] &&
                  [activityTypeArray[[[Singleton object] activity]] containsString:@"景點"]){
        dataArray = [[Singleton object] readGovernmentData:@"TaipeiCityAttractionsData"
                                                attributes:@"taipeiCityAttractionsData"];
        nameKey = nameKeyArray[1];
        addressNameKey = addressKeyNameArray[2];
        [self searchChooseRegion];
    }
    else
    {
        if([activityTypeArray[[[Singleton object] activity]] containsString:@"景點"]) {
            dataArray = [[Singleton object] readGovernmentData:@"GovernmentAttractionsData"
                                                    attributes:@"governmentAttractionsData"];
        }else if([activityTypeArray[[[Singleton object] activity]] containsString:@"餐飲"]) {
            
            dataArray = [[Singleton object] readGovernmentData:@"GovernmentFoodData"
                                                    attributes:@"governmentFoodData"];
        }else if([activityTypeArray[[[Singleton object] activity]] containsString:@"休閒農場"]) {
            dataArray = [[Singleton object] readGovernmentData:@"GovernmentLeisureFarmData"
                                                    attributes:@"governmentLeisureFarmData"];
            addressNameKey = addressKeyNameArray[1];
        } else {
            dataArray = [[Singleton object] readGovernmentData:@"GovernmentHotelBedAndBreakfastData"
                                                    attributes:@"governmentHotelBedAndBreakfastData"];
        }
        [self searchChooseRegion];
    }
}
#pragma mark - Set searchRegion data to give infosArray 設定篩選的條件資料給 infosArray
-(void)searchChooseRegion{
    [infosArray removeAllObjects];
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *address;

        for(NSDictionary *dataDictionary in dataArray) {
            NSArray *infoArray = [NSArray new];
            if([dataDictionary[addressNameKey] containsString:capitalRegionName] &&
               [dataDictionary[addressNameKey] containsString:seletedRegionName]) {
                    address = [dataDictionary[addressNameKey] stringByReplacingOccurrencesOfString:@" " withString:@""];
                    infoArray = @[dataDictionary[nameKey],address];
                    [infosArray addObject:infoArray];
            }
            infoArray = nil;
        }
        if(infosArray.count == 0) {
            [self showAlert];
        }
        [self.tableView reloadData];
    });
}

#pragma mark - Setting pickerView 設定選擇地區按鈕與 pickView 的相關初始值
- (IBAction)searchBtn:(id)sender {
    [customPickView.pickerViewTextField becomeFirstResponder];
}

-(void)doneTouched {
    capitalRegionName = customPickView.capitalRegionName;
    seletedRegionName = customPickView.seletedRegionName;
    [customPickView.pickerViewTextField resignFirstResponder];
    [self startSearchRegion];
}

-(void)cancelTouched {
    [customPickView.pickerViewTextField resignFirstResponder];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return infosArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NSArray *array = infosArray[indexPath.row];
    cell.textLabel.text = array[0];
    cell.detailTextLabel.text =array[1];
    return  cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray *array = infosArray[indexPath.row];
    //nameAddarray[地址、種類、名字]
    NSArray *nameAddArray = @[array[1],activityTypeArray[[[Singleton object] activity]],array[0]];
    [Singleton object].nameAddArray = nameAddArray;
    
    DetailUITableViewController *detailTableViewControler =
    [self.storyboard instantiateViewControllerWithIdentifier:@"DetailUITableViewController"];
    [self.navigationController pushViewController:detailTableViewControler animated:true];
    
}

#pragma mark - Set Show alert to view 設定 AlertView
-(void)showAlert {
    UIAlertController *printMessageControler = [UIAlertController alertControllerWithTitle:@"查無相關資訊" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *done = [UIAlertAction actionWithTitle:@"確定" style:UIAlertActionStyleDefault handler:nil];
    [printMessageControler addAction:done];
    [self presentViewController:printMessageControler animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
