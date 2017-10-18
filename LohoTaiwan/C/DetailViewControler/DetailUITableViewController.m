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
    
    NSArray *imageArray;
    NSArray *InfoArray;
    NSArray *readNameAddArray;
    NSArray *activityTypeArry;
    
    NSUserDefaults *defaults;
}

@end

@implementation DetailUITableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    imageArray = ImageArray;
    defaults = [NSUserDefaults standardUserDefaults];
    
    activityTypeArry = [[Singleton object] activityType];
    [self searchInformation];
    
}

-(void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = false;
}

#pragma mark - Set add data to schedule 設定按鈕觸發時加入個人清單中
- (IBAction)addListBtn:(id)sender {
    UIAlertController *printMessageControler = [UIAlertController alertControllerWithTitle:@"加入成功" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:InfoArray[0] message:@"確定加入清單？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * OK = [UIAlertAction actionWithTitle:@"確定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSArray *array = [[defaults objectForKey:@"ListData"] mutableCopy];
        NSMutableArray *dataArray;
        if (array.count != 0) {
            dataArray = [[defaults objectForKey:@"ListData"] mutableCopy];
        } else {
            dataArray = [NSMutableArray new];
        }
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
    [alert addAction:Cancel];
    [alert addAction:OK];
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
//  DetailTableViewCell *cell = [[DetailTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Menu"];
    if(indexPath.section == 0 && indexPath.row < 4) {
        if (indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 3) {
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
        [[Singleton object] putNameAndAddressToMap:InfoArray[0] address:InfoArray[1]];
        MapViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MapViewController"];
        [self.navigationController pushViewController:vc animated:true];
//        UITabBarController *tbc = [self.storyboard instantiateViewControllerWithIdentifier:@"MainTabBar"];
//        tbc.selectedIndex=1;
//        [self presentViewController:tbc animated:true completion:nil];
    } else if(indexPath.section == 0 && indexPath.row == 3) {
        if(![InfoArray[3] containsString:@"目前無提供"]) {
        NSString *tel = [InfoArray[3] substringToIndex:13];
        NSLog(@"%@",tel);
            tel = [tel stringByReplacingOccurrencesOfString:@"-" withString:@""];
            tel = [tel stringByReplacingOccurrencesOfString:@"886" withString:@""];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:0%@",tel]] options:@{} completionHandler:nil];
        }
    }
}

//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if(indexPath.section == 0) {
//        return 150;
//    } else {
//        return 30;
//    }
//}

-(void)searchInformation {
    readNameAddArray = [[Singleton object] nameAddArray];
    NSString *Add = readNameAddArray[0];
    NSArray *dataArray;
    NSDictionary *dataDictionary;
    
    NSString *AddressName;
    NSArray *AddressNameArray = @[@"Add",@"Address"];
    NSString *activityTypeName;
    NSArray *activityTypeArray = [[Singleton object] activityType];
    activityTypeName = activityTypeArray[[[Singleton object] activity]];
    if([activityTypeName containsString:@"休閒農場"]) {
        AddressName = AddressNameArray[1];
    } else {
        AddressName = AddressNameArray[0];
    }
    
    if([Add containsString:@"新北市"]) {
        if([readNameAddArray[1] containsString:activityTypeArry[0]]) {
            dataArray = [[Singleton object] readnewTaipeiData:@"NewTaipeiAttractionsData" attributes:@"newTaipeiAttractionsData"];
            for(dataDictionary in dataArray) {
                if([dataDictionary[AddressName] containsString:readNameAddArray[0]]) {
                    if([dataDictionary[@"Name"] containsString:readNameAddArray[2]]) {
                        InfoArray = [self putInfoArray:dataDictionary];
                    }
                }
            }
        } else if([readNameAddArray[1] containsString:activityTypeArry[1]]) {
            dataArray = [[Singleton object] readnewTaipeiData:@"NewTaipeiFoodData" attributes:@"newTaipeiFoodData"];
            for(dataDictionary in dataArray) {
                if([dataDictionary[AddressName] containsString:readNameAddArray[0]]) {
                    if([dataDictionary[@"Name"] containsString:readNameAddArray[2]]) {
                        InfoArray = [self putInfoArray:dataDictionary];
                    }
                }
            }
        } else if([readNameAddArray[1] containsString:activityTypeArry[2]]) {
            dataArray = [[Singleton object] readGovernmentLeisureFarmData];
            for(dataDictionary in dataArray) {
                if([dataDictionary[AddressName] containsString:readNameAddArray[0]]) {
                    if([dataDictionary[@"Name"] containsString:readNameAddArray[2]]) {
                        InfoArray = [self putInfoArray:dataDictionary];
                    }
                }
            }
        } else if([readNameAddArray[1] containsString:activityTypeArry[3]]) {
            dataArray = [[Singleton object] readGovernmentData:@"GovernmentHotelBedAndBreakfastData" attributes:@"governmentHotelBedAndBreakfastData"];
            for(dataDictionary in dataArray) {
                if([dataDictionary[AddressName] containsString:readNameAddArray[0]]) {
                    if([dataDictionary[@"Name"] containsString:readNameAddArray[2]]) {
                        InfoArray = [self putInfoArray:dataDictionary];
                    }
                }
            }
        }
    } else {
        if([readNameAddArray[1] containsString:activityTypeArry[0]]) {
            dataArray = [[Singleton object] readGovernmentData:@"GovernmentAttractionsData" attributes:@"governmentAttractionsData"];
            for(dataDictionary in dataArray) {
                if([dataDictionary[AddressName] containsString:readNameAddArray[0]]) {
                    if([dataDictionary[@"Name"] containsString:readNameAddArray[2]]) {
                        InfoArray = [self putInfoArray:dataDictionary];
                    }
                }
            }
        } else if([readNameAddArray[1] containsString:activityTypeArry[1]]) {
            dataArray = [[Singleton object] readGovernmentData:@"GovernmentFoodData" attributes:@"governmentFoodData"];
            for(dataDictionary in dataArray) {
                if([dataDictionary[AddressName] containsString:readNameAddArray[0]]) {
                    if([dataDictionary[@"Name"] containsString:readNameAddArray[2]]) {
                        InfoArray = [self putInfoArray:dataDictionary];
                    }
                }
            }
        } else if([readNameAddArray[1] containsString:activityTypeArry[2]]) {
            dataArray = [[Singleton object] readGovernmentLeisureFarmData];
            for(dataDictionary in dataArray) {
                if([dataDictionary[AddressName] containsString:readNameAddArray[0]]) {
                    if([dataDictionary[@"Name"] containsString:readNameAddArray[2]]) {
                        InfoArray = [self putInfoArray:dataDictionary];
                    }
                }
            }
        } else if([readNameAddArray[1] containsString:activityTypeArry[3]]) {
            dataArray = [[Singleton object] readGovernmentData:@"GovernmentHotelBedAndBreakfastData" attributes:@"governmentHotelBedAndBreakfastData"];
            for(dataDictionary in dataArray) {
                if([dataDictionary[AddressName] containsString:readNameAddArray[0]]) {
                    if([dataDictionary[@"Name"] containsString:readNameAddArray[2]]) {
                        InfoArray = [self putInfoArray:dataDictionary];
                    }
                }
            }
        }
    }
    [Singleton object].nameAddArray = nil;
}

-(NSArray*)putInfoArray:(NSDictionary*)dataDictionary {
    NSString *desccrptionName = @"Description";
    NSString *value = dataDictionary[desccrptionName];
    if(value.length == 0) {
        desccrptionName = @"Toldescribe";
        value = dataDictionary[desccrptionName];
        if(value.length == 0) {
            desccrptionName = @"Introduction";
        }
    }
    NSString*openTimeName = @"Opentime";
    NSString *value2 = dataDictionary[openTimeName];
    if(value2.length == 0) {
        openTimeName = @"Serviceinfo";
    }
    NSString *addressName = @"Add";
    NSString *value3 = dataDictionary[addressName];
    if(value3.length == 0) {
        addressName = @"Address";
    }
    NSString *empty = @"目前無提供";
    NSString *name = dataDictionary[@"Name"];
    NSString *address =  dataDictionary[addressName];
    NSString *openTime = dataDictionary[openTimeName];
    NSString *tel = dataDictionary[@"Tel"];
    NSString *description = dataDictionary[desccrptionName];
    if(name.length == 0)
        name = empty;
    if(address.length == 0)
        address = empty;
    if(openTime.length == 0)
        openTime = empty;
    if(tel.length == 0)
        tel = empty;
    if(description.length == 0)
        description = empty;
        
    NSArray *InfosArray = @[name,
                           address,
                           openTime,
                           tel,
                           description];
    return  InfosArray;
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
