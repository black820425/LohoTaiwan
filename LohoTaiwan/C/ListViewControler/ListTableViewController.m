//
//  ListTableViewController.m
//  LohoTaiwan
//
//  Created by 黃柏恩 on 2017/10/3.
//  Copyright © 2017年 黃柏恩. All rights reserved.
#import <Chameleon.h>
#import "Singleton.h"
#import "ViewController.h"
#import "ListTableViewController.h"
#import "DetailUITableViewController.h"
@interface ListTableViewController ()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic, strong) UITextField *pickerViewTextField;

@end

@implementation ListTableViewController
{
    NSArray *dataArray;
    NSString *AddressName;
    NSMutableArray *infosArray;
    
    UIPickerView *mypickerView;
    NSArray *activityTypeArray;
    NSArray *capitalRegionArray;
    NSString *capitalRegionName;
    NSString *newTaipeiRegionName;
    NSArray *newTaipeiRegionArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    capitalRegionArray = [[Singleton object] capitalName];
    activityTypeArray = [[Singleton object] activityType];
    newTaipeiRegionArray = [[Singleton object] TaipeiRegionArray];
    infosArray = [NSMutableArray new];
    [self readActivityTypeData];
    [self putInfoArray];
    [self startpickViewSetting];
    self.navigationController.navigationBar.hidden = false;
}
- (IBAction)searchBtn:(id)sender {
    [self.pickerViewTextField becomeFirstResponder];
    if(capitalRegionName == nil && newTaipeiRegionName == nil) {
        capitalRegionName = @"臺北市";
        newTaipeiRegionName = @"板橋區";
    }
}

-(void)startSearchRegion {
    if([capitalRegionName containsString:@"新北市"]) {
        if([activityTypeArray[[[Singleton object] activity]] containsString:@"景點"]) {
            dataArray = [[Singleton object] readnewTaipeiData:@"NewTaipeiAttractionsData" attributes:@"NewTaipeiAttractionsData"];
        } else if([activityTypeArray[[[Singleton object] activity]] containsString:@"餐飲"]) {
            dataArray = [[Singleton object] readnewTaipeiData:@"NewTaipeiFoodData" attributes:@"newTaipeiFoodData"];
        } else if([activityTypeArray[[[Singleton object] activity]] containsString:@"休閒農場"]) {
            dataArray = [[Singleton object] readGovernmentLeisureFarmData];
        } else {
            dataArray = [[Singleton object] readGovernmentData:@"GovernmentHotelBedAndBreakfastData" attributes:@"governmentHotelBedAndBreakfastData"];
        }
    } else {
        if([activityTypeArray[[[Singleton object] activity]] containsString:@"景點"]) {
            dataArray = [[Singleton object] readGovernmentData:@"GovernmentAttractionsData" attributes:@"governmentAttractionsData"];
        } else if([activityTypeArray[[[Singleton object] activity]] containsString:@"餐飲"]) {
            dataArray = [[Singleton object] readGovernmentData:@"GovernmentFoodData" attributes:@"governmentFoodData"];
        } else if([activityTypeArray[[[Singleton object] activity]] containsString:@"休閒農場"]) {
            dataArray = [[Singleton object] readGovernmentLeisureFarmData];
        } else {
            dataArray = [[Singleton object] readGovernmentData:@"GovernmentHotelBedAndBreakfastData" attributes:@"governmentHotelBedAndBreakfastData"];
        }
    }
    [self searchChooseRegion];
    [self.tableView reloadData];
}

-(void)searchChooseRegion {
    [infosArray removeAllObjects];
    for(NSDictionary *dataDictionary in dataArray) {
        if([dataDictionary[AddressName] containsString:@"新北市"]) {
            if([dataDictionary[AddressName] containsString:newTaipeiRegionName]) {
                NSArray *infoArray = [NSArray new];
                infoArray = @[dataDictionary[@"Name"],dataDictionary[AddressName]];
                [infosArray addObject:infoArray];
                infoArray = nil;
            }
        } else {
            if([dataDictionary[AddressName] containsString:capitalRegionName]) {
                NSArray *infoArray = [NSArray new];
                infoArray = @[dataDictionary[@"Name"],dataDictionary[AddressName]];
                [infosArray addObject:infoArray];
                infoArray = nil;
            }
        }
    }
    if(infosArray.count == 0) {
        [self showAlert];
    }
}

#pragma mark - Setting pickerView 設定選擇地區按鈕與 pickView 的相關初始值
-(void)doneTouched {
    [self.pickerViewTextField resignFirstResponder];
    [self startSearchRegion];
}

-(void)cancelTouched {
    [self.pickerViewTextField resignFirstResponder];
}

-(void)startpickViewSetting {
    self.pickerViewTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.pickerViewTextField];
    
    mypickerView = [UIPickerView new];
    mypickerView.delegate = self;
    mypickerView.dataSource = self;
    
    self.pickerViewTextField.inputView = mypickerView;
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    toolBar.backgroundColor = [UIColor flatMintColor];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                target:self action:@selector(doneTouched)];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                  target:self action:@selector(cancelTouched)];
    // the middle button is to make the Done button align to right
    [toolBar setItems:[NSArray arrayWithObjects:cancelButton, [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                       doneButton, nil]];
    self.pickerViewTextField.inputAccessoryView = toolBar;
}

#pragma mark - Setting pickView delegate 設定 pickView 相關初始值
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    if([capitalRegionName containsString:@"新北市"]) {
        return 2;
    } else
        return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if(component == 0) {
        return capitalRegionArray.count;
    } else
        return newTaipeiRegionArray.count;
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if(component == 0) {
        return capitalRegionArray[row];
    } else
        return newTaipeiRegionArray[row];
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        capitalRegionName = [capitalRegionArray[row] stringByReplacingOccurrencesOfString:@"台" withString:@"臺"];
        [mypickerView reloadAllComponents];
    } else
        newTaipeiRegionName = newTaipeiRegionArray[row];
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
    NSArray *nameAddarray = @[array[1],activityTypeArray[[[Singleton object] activity]],array[0]];
    [Singleton object].nameAddArray = nameAddarray;
    DetailUITableViewController *detailTableViewControler = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailUITableViewController"];
    [self.navigationController pushViewController:detailTableViewControler animated:true];
}

-(void)readActivityTypeData {
    NSArray *AddressNameArray = @[@"Add",@"Address"];
    if([activityTypeArray[[[Singleton object] activity]] containsString:@"休閒農場"]) {
        AddressName = AddressNameArray[1];
    } else {
        AddressName = AddressNameArray[0];
    }
    if([activityTypeArray[[[Singleton object] activity]] containsString:@"景點"]) {
        dataArray = [[Singleton object] readGovernmentData:@"GovernmentAttractionsData" attributes:@"governmentAttractionsData"];
    } else if([activityTypeArray[[[Singleton object] activity]] containsString:@"餐飲"]) {
        dataArray = [[Singleton object] readGovernmentData:@"GovernmentFoodData" attributes:@"governmentFoodData"];
    } else if([activityTypeArray[[[Singleton object] activity]] containsString:@"休閒農場"]) {
        dataArray = [[Singleton object] readGovernmentLeisureFarmData];
    } else {
        dataArray = [[Singleton object] readGovernmentData:@"GovernmentHotelBedAndBreakfastData" attributes:@"governmentHotelBedAndBreakfastData"];
    }
}

-(void)putInfoArray {
    for(NSDictionary *dataDictionary in dataArray) {
        if(![dataDictionary[AddressName] containsString:@"新北市"]) {
            if([dataDictionary[AddressName] length] > 0) {
                NSArray *infoArray = [NSArray new];
                infoArray = @[dataDictionary[@"Name"],dataDictionary[AddressName]];
                [infosArray addObject:infoArray];
                infoArray = nil;
            }
        }

    }
}

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
