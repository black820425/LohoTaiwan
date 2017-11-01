//
//  DetailUITableViewController.m
//  LohoTaiwan
//
//  Created by 黃柏恩 on 2017/9/26.
//  Copyright © 2017年 黃柏恩. All rights reserved.
#import "Singleton.h"
#import "AppDelegate.h"
#import "MapViewController.h"
#import "DetailTableViewCell.h"
#import "DetailUITableViewController.h"


#define ImageArray @[@"Name",@"Address",@"BusinessHours",@"PhoneNumber",@"Description"];

@interface DetailUITableViewController ()
{
    NSTimer *time;
    NSUserDefaults *defaults;

    NSArray *InfoArray;
    NSArray *imageArray;
    NSArray *activityTypeArry;
    NSArray *readNameAddArray;
    
    
    NSArray *dataArray;
    NSDictionary *dataDictionary;

    NSString *tel;
    NSString *keyName;
    NSString *addressKeyName;
    NSString *emptyDescriptionString;

}

@end

@implementation DetailUITableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    imageArray = ImageArray;
    
    emptyDescriptionString = @"目前無提供";
    //建立 NSUserDefault 使用
    defaults = [NSUserDefaults standardUserDefaults];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    activityTypeArry = [[Singleton object] activityTypeArray];
    
    [self searchInformation];
}
-(void)viewDidAppear:(BOOL)animated {
    [Singleton object].nameAddArray = nil;
}

#pragma mark - Set add data to schedule 設定按鈕觸發時加入個人清單中
- (IBAction)addListBtn:(id)sender {
    UIAlertController *printMessageControler =
    [UIAlertController alertControllerWithTitle:@"加入成功" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertController *alert =
    [UIAlertController alertControllerWithTitle:@"確定加入清單" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction * OK =
    [UIAlertAction actionWithTitle:@"確定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSArray *array = [[defaults objectForKey:@"ListData"] mutableCopy];
        NSMutableArray *dataArray;
        
        if (array.count != 0) {
            dataArray = [[defaults objectForKey:@"ListData"] mutableCopy];
        } else { dataArray = [NSMutableArray new]; }
        
        NSArray *nameAddArray = @[InfoArray[1],readNameAddArray[1],InfoArray[0],@"none"];
        [dataArray addObject:nameAddArray];
        [defaults setObject:dataArray forKey:@"ListData"];
        [defaults synchronize];
        NSLog(@"%@",nameAddArray);
        NSLog(@"%@",dataArray);
        dataArray = nil;
        time = [NSTimer scheduledTimerWithTimeInterval:1 repeats:false block:^(NSTimer * _Nonnull timer) {
            [self dismissViewControllerAnimated:true completion:nil];
        }];
        [self presentViewController:printMessageControler animated:YES completion:nil];
    }];
    
    UIAlertAction * Cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:OK];
    [alert addAction:Cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0) {
        return 4;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];

    if(indexPath.section == 0 && indexPath.row < 4) {
        if (indexPath.row == 0) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        if (indexPath.row == 1 && readNameAddArray.count == 3) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        if ( indexPath.row == 3 && ![tel containsString:emptyDescriptionString]) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
       cell.ImageView.image = [UIImage imageNamed:imageArray[indexPath.row]];
       cell.TextLabel.text = InfoArray[indexPath.row];
        return cell;
        
    } else if(indexPath.section == 1){
        cell.ImageView.image = [UIImage imageNamed:imageArray[4]];
        cell.TextLabel.text = InfoArray[4];
        return cell;
        
    } else
        return cell;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(section == 0) {
        return @"資訊：";
    } else{
        return @"描述：";
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.section == 0 && indexPath.row == 0) {
        NSString *name = [InfoArray[0] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
        NSString *urlAddress = [NSString stringWithFormat:@"https://www.google.com.tw/search?q=%@",name];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlAddress] options:@{} completionHandler:nil];
        
    } else if(indexPath.section == 0 && indexPath.row == 1) {
        if (readNameAddArray.count == 3) {
            [Singleton object].nameAddArray = readNameAddArray;
            MapViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MapViewController"];
            [self.navigationController pushViewController:vc animated:true];
        }
    } else if(indexPath.section == 0 && indexPath.row == 3) {
        
        if(![InfoArray[3] containsString:emptyDescriptionString]) {
        NSString *tel = [InfoArray[3] substringToIndex:13];
        NSLog(@"%@",tel);
            tel = [tel stringByReplacingOccurrencesOfString:@"-" withString:@""];
            tel = [tel stringByReplacingOccurrencesOfString:@"886" withString:@""];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:0%@",tel]] options:@{} completionHandler:nil];
        }
    }
}
#pragma mark - Search data from nameAddArray in CoreData 搜尋從陣列 nameAddArray 找出 CoreData裏指定的資料
-(void)searchInformation {
    //讀取指定的資料
    readNameAddArray = [[Singleton object] nameAddArray];
    NSLog(@"readNameAddArray資料內容為:%@",readNameAddArray);

    NSArray *nameArray = @[@"Name",@"stitle"];
    NSArray *addressNameArray = @[@"Add",@"Address",@"address"];
    //臺北市的名稱 Key 為 stitle
    //臺北市的地址 Key 為 address
    //休閒農場的地址 Key 為 Address
    keyName = nameArray[0];
    addressKeyName = addressNameArray[0];

    if([readNameAddArray[0] containsString:@"新北市"] && [readNameAddArray[1] containsString:activityTypeArry[0]]) {
        dataArray = [[Singleton object] readGovernmentData:@"NewTaipeiAttractionsData" attributes:@"newTaipeiAttractionsData"];
        
    } else if([readNameAddArray[0] containsString:@"新北市"] && [readNameAddArray[1] containsString:activityTypeArry[1]]) {
        dataArray = [[Singleton object] readGovernmentData:@"NewTaipeiFoodData" attributes:@"newTaipeiFoodData"];
        
    } else if([readNameAddArray[0] containsString:@"臺北市"] && [readNameAddArray[1] containsString:activityTypeArry[0]]) {
        keyName = nameArray[1];
        addressKeyName = addressNameArray[2];
        dataArray = [[Singleton object]
                     readGovernmentData:@"TaipeiCityAttractionsData" attributes:@"taipeiCityAttractionsData"];
    } else {
            if([readNameAddArray[1] containsString:activityTypeArry[0]]) {
                dataArray = [[Singleton object] readGovernmentData:@"GovernmentAttractionsData" attributes:@"governmentAttractionsData"];
                
            } else if([readNameAddArray[1] containsString:activityTypeArry[1]]) {
                dataArray = [[Singleton object] readGovernmentData:@"GovernmentFoodData" attributes:@"governmentFoodData"];
                
            } else if([readNameAddArray[1] containsString:activityTypeArry[2]]) {
                addressKeyName = addressNameArray[1];
                dataArray = [[Singleton object] readGovernmentData:@"GovernmentLeisureFarmData" attributes:@"governmentLeisureFarmData"];
                
            } else if([readNameAddArray[1] containsString:activityTypeArry[3]]) {
                dataArray = [[Singleton object] readGovernmentData:@"GovernmentHotelBedAndBreakfastData" attributes:@"governmentHotelBedAndBreakfastData"];
            }
    }
    [self putDataArrayInfosArray];
}
#pragma mark - Set dataArray pick data to infoArray 從 dataArray 取出指定的資料給 infoArray
-(void)putDataArrayInfosArray{
    for (NSString *data in readNameAddArray) {
        NSLog(@"readNameAddArray資料為:%@",data);
    }
    for(dataDictionary in dataArray) {
        NSString *address = [dataDictionary[addressKeyName] stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        if([address containsString:readNameAddArray[0]]) {
            if([dataDictionary[keyName] containsString:readNameAddArray[2]]) {
                InfoArray = [self putInfoArray:dataDictionary];
            }
        }
    }
}
#pragma mark - Set dataDictionary data pick selecte data to return infosArray 取出 dataDictionary 指定的資料並用陣列回傳
-(NSArray*)putInfoArray:(NSDictionary*)dataDictionary {
    NSString *openTime;
    NSString *description;
    
    NSArray *telephoneArray = @[@"Tel"];
    NSArray *openTimeNameArray = @[@"Opentime",@"MEMO_TIME"];
    NSArray *desccrptionNameArray = @[@"Description",@"Toldescribe",@"Introduction",@"xbody"];
       
        //讀取 dataDictionary 電話資訊
        if([dataDictionary[telephoneArray[0]] length] == 0 ||
           dataDictionary[telephoneArray[0]] == NULL) {
            tel = emptyDescriptionString;
        } else {
            tel = dataDictionary[telephoneArray[0]];
        }
    
        //讀取 dataDictionary 開放時間資訊
        if([dataDictionary[openTimeNameArray[0]] length] == 0 ||
           dataDictionary[openTimeNameArray[0]] == NULL) {
            
            if ([dataDictionary[openTimeNameArray[1]] length] == 0 ||
                dataDictionary[openTimeNameArray[1]] == NULL) {
                openTime = emptyDescriptionString;
            } else {
                openTime = dataDictionary[openTimeNameArray[1]];
            }
        } else {
            openTime = dataDictionary[openTimeNameArray[0]];
        }
    
        //讀取 dataDictionary 描述資訊
        if([dataDictionary[desccrptionNameArray[0]] length] == 0 ||
           dataDictionary[desccrptionNameArray[0]] == NULL) {
            
            if ([dataDictionary[desccrptionNameArray[1]] length] == 0 ||
                dataDictionary[desccrptionNameArray[1]] == NULL) {
                
                if ([dataDictionary[desccrptionNameArray[2]] length] == 0 ||
                    dataDictionary[desccrptionNameArray[2]] == NULL) {
                    
                    if ([dataDictionary[desccrptionNameArray[3]] length] == 0 ||
                        dataDictionary[desccrptionNameArray[3]] == NULL) {
                        description = emptyDescriptionString;
                    } else {
                        description = dataDictionary[desccrptionNameArray[3]];
                    }
                    description = emptyDescriptionString;
                } else {
                    description = dataDictionary[desccrptionNameArray[2]];
                }
            }else {
                description = dataDictionary[desccrptionNameArray[1]];
            }
        } else {
            description = dataDictionary[desccrptionNameArray[0]];
        }
        
    //放置讀取資訊到 InfosArray 並回傳
    NSLog(@"%@",readNameAddArray[2]);
    NSLog(@"%@",readNameAddArray[0]);
    NSLog(@"%@",openTime);
    NSLog(@"%@",tel);
    NSLog(@"%@",description);
    NSArray *infosArray = @[
                            readNameAddArray[2],
                            readNameAddArray[0],
                            openTime,
                            tel,
                            description];
    return  infosArray;
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
