//
//  CustomPickerView.m
//  LohoTaiwan
//
//  Created by 黃柏恩 on 2017/10/27.
//  Copyright © 2017年 黃柏恩. All rights reserved.

#import "Singleton.h"
#import <Chameleon.h>
#import "CustomPickerView.h"

@implementation CustomPickerView
{
    NSInteger capitalReginNumber;
    NSString *compentNumber;
}

-(id)init {
    self = [super init];
    if(self) {
        self.activityTypeName = [Singleton object].activityTypeArray[0];
        self.capitalRegionName = [Singleton object].capitalNameArray[0];
        self.seletedRegionName = [Singleton object].taipeiRegionArray[0];

        self.delegate = self;
        self.pickerViewTextField = [[UITextField alloc] initWithFrame:CGRectZero];
        self.pickerViewTextField.inputView = self;
    }
    return  self;
}

-(void)setCustomPickerViewDataSource {
    compentNumber = [_DataSource setPickViewCompent:self];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    if([[_DataSource setPickViewCompent:self] containsString:@"2"]) {
        return 2;
    } else {
        return 3;
    }
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if([[_DataSource setPickViewCompent:self] containsString:@"2"]) {
        if(component == 0) {
            return [Singleton object].capitalNameArray.count;
        }
        if(component == 1) {
            switch (capitalReginNumber) {
                case 0:
                    return [Singleton object].taipeiRegionArray.count;
                case 1:
                    return [Singleton object].NewTaipeiRegionArray.count;
                case 2:
                    return [Singleton object].iIanRegionArray.count;
                case 3:
                    return [Singleton object].taoyuanRegionArray.count;
                case 4:
                    return [Singleton object].taichungRegionArray.count;
                case 5:
                    return [Singleton object].keelungRegionArray.count;
                case 6:
                    return [Singleton object].hualienRegionArray.count;
                case 7:
                    return [Singleton object].hsinchuRegionArray.count;
                case 8:
                    return [Singleton object].miaoliRegionArray.count;
                case 9:
                    return [Singleton object].changhuaRegionArray.count;
                case 10:
                    return [Singleton object].nantouRegionArray.count;
                case 11:
                    return [Singleton object].chiayiRegionArray.count;
                case 12:
                    return [Singleton object].taitungRegionArray.count;
                case 13:
                    return [Singleton object].tainanRegionArray.count;
                case 14:
                    return [Singleton object].kaohsiungRegionArray.count;
                default:
                    return [Singleton object].pingtungRegionArray.count;
                    break;
            }
        }
        return 0;
    } else if([[_DataSource setPickViewCompent:self] containsString:@"3"]) {
        if(component == 0) {
            return [Singleton object].capitalNameArray.count;
        }
        if(component == 1) {
            return [Singleton object].activityTypeArray.count;
        }
        if(component == 2) {
            switch (capitalReginNumber) {
                case 0:
                    return [Singleton object].taipeiRegionArray.count;
                case 1:
                    return [Singleton object].NewTaipeiRegionArray.count;
                case 2:
                    return [Singleton object].iIanRegionArray.count;
                case 3:
                    return [Singleton object].taoyuanRegionArray.count;
                case 4:
                    return [Singleton object].taichungRegionArray.count;
                case 5:
                    return [Singleton object].keelungRegionArray.count;
                case 6:
                    return [Singleton object].hualienRegionArray.count;
                case 7:
                    return [Singleton object].hsinchuRegionArray.count;
                case 8:
                    return [Singleton object].miaoliRegionArray.count;
                case 9:
                    return [Singleton object].changhuaRegionArray.count;
                case 10:
                    return [Singleton object].nantouRegionArray.count;
                case 11:
                    return [Singleton object].chiayiRegionArray.count;
                case 12:
                    return [Singleton object].taitungRegionArray.count;
                case 13:
                    return [Singleton object].tainanRegionArray.count;
                case 14:
                    return [Singleton object].kaohsiungRegionArray.count;
                default:
                    return [Singleton object].pingtungRegionArray.count;
                    break;
            }
        }
        return  0;
    } else {
        return 0;
    }
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if([[_DataSource setPickViewCompent:self] containsString:@"2"]) {
        if(component == 0) {
            return [Singleton object].capitalNameArray[row];
        }
        if(component == 1) {
            switch (capitalReginNumber) {
                case 0:
                    return [Singleton object].taipeiRegionArray[row];
                case 1:
                    return [Singleton object].NewTaipeiRegionArray[row];
                case 2:
                    return [Singleton object].iIanRegionArray[row];
                case 3:
                    return [Singleton object].taoyuanRegionArray[row];
                case 4:
                    return [Singleton object].taichungRegionArray[row];
                case 5:
                    return [Singleton object].keelungRegionArray[row];
                case 6:
                    return [Singleton object].hualienRegionArray[row];
                case 7:
                    return [Singleton object].hsinchuRegionArray[row];
                case 8:
                    return [Singleton object].miaoliRegionArray[row];
                case 9:
                    return [Singleton object].changhuaRegionArray[row];
                case 10:
                    return [Singleton object].nantouRegionArray[row];
                case 11:
                    return [Singleton object].chiayiRegionArray[row];
                case 12:
                    return [Singleton object].taitungRegionArray[row];
                case 13:
                    return [Singleton object].tainanRegionArray[row];
                case 14:
                    return [Singleton object].kaohsiungRegionArray[row];
                default:
                    return [Singleton object].pingtungRegionArray[row];
                    break;
            }
        }
        return 0;
    } else if([[_DataSource setPickViewCompent:self] containsString:@"3"]) {
        if(component == 0) {
            return [Singleton object].capitalNameArray[row];
        }
        if(component == 1) {
            return [Singleton object].activityTypeArray[row];
        }
        if(component == 2) {
            switch (capitalReginNumber) {
                case 0:
                    return [Singleton object].taipeiRegionArray[row];
                case 1:
                    return [Singleton object].NewTaipeiRegionArray[row];
                case 2:
                    return [Singleton object].iIanRegionArray[row];
                case 3:
                    return [Singleton object].taoyuanRegionArray[row];
                case 4:
                    return [Singleton object].taichungRegionArray[row];
                case 5:
                    return [Singleton object].keelungRegionArray[row];
                case 6:
                    return [Singleton object].hualienRegionArray[row];
                case 7:
                    return [Singleton object].hsinchuRegionArray[row];
                case 8:
                    return [Singleton object].miaoliRegionArray[row];
                case 9:
                    return [Singleton object].changhuaRegionArray[row];
                case 10:
                    return [Singleton object].nantouRegionArray[row];
                case 11:
                    return [Singleton object].chiayiRegionArray[row];
                case 12:
                    return [Singleton object].taitungRegionArray[row];
                case 13:
                    return [Singleton object].tainanRegionArray[row];
                case 14:
                    return [Singleton object].kaohsiungRegionArray[row];
                default:
                    return [Singleton object].pingtungRegionArray[row];
                    break;
            }
        }
        return 0;
    } else  {
        return 0;
    }
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if([[_DataSource setPickViewCompent:self] containsString:@"2"]) {
        if (component == 0) {
            capitalReginNumber = row;
            self.capitalRegionName = [Singleton object].capitalNameArray[row];
            [self reloadAllComponents];
            [self selectRow:0 inComponent:1 animated:YES];
            switch (capitalReginNumber) {
                case 0:
                    self.seletedRegionName = [Singleton object].taipeiRegionArray[0];
                    break;
                case 1:
                    self.seletedRegionName =  [Singleton object].NewTaipeiRegionArray[0];
                    break;
                case 2:
                    self.seletedRegionName =  [Singleton object].iIanRegionArray[0];
                    break;
                case 3:
                    self.seletedRegionName =  [Singleton object].taoyuanRegionArray[0];
                    break;
                case 4:
                    self.seletedRegionName =  [Singleton object].taichungRegionArray[0];
                    break;
                case 5:
                    self.seletedRegionName =  [Singleton object].keelungRegionArray[0];
                    break;
                case 6:
                    self.seletedRegionName =  [Singleton object].hualienRegionArray[0];
                    break;
                case 7:
                    self.seletedRegionName =  [Singleton object].hsinchuRegionArray[0];
                    break;
                case 8:
                    self.seletedRegionName =  [Singleton object].miaoliRegionArray[0];
                    break;
                case 9:
                    self.seletedRegionName =  [Singleton object].changhuaRegionArray[0];
                    break;
                case 10:
                    self.seletedRegionName =  [Singleton object].nantouRegionArray[0];
                    break;
                case 11:
                    self.seletedRegionName =  [Singleton object].chiayiRegionArray[0];
                    break;
                case 12:
                    self.seletedRegionName =  [Singleton object].taitungRegionArray[0];
                    break;
                case 13:
                    self.seletedRegionName =  [Singleton object].tainanRegionArray[0];
                    break;
                case 14:
                    self.seletedRegionName =  [Singleton object].kaohsiungRegionArray[0];
                    break;
                default:
                    self.seletedRegionName =  [Singleton object].pingtungRegionArray[0];
                    break;
            }
            NSLog(@"Hello");
            NSLog(@"%ld",(long)capitalReginNumber);
            NSLog(@"%@",self.capitalRegionName);
            NSLog(@"%@",self.seletedRegionName);
        }
        if(component == 1) {
            switch (capitalReginNumber) {
                case 0:
                    self.seletedRegionName = [Singleton object].taipeiRegionArray[row];
                    break;
                case 1:
                    self.seletedRegionName = [Singleton object].NewTaipeiRegionArray[row];
                    break;
                case 2:
                    self.seletedRegionName = [Singleton object].iIanRegionArray[row];
                    break;
                case 3:
                    self.seletedRegionName = [Singleton object].taoyuanRegionArray[row];
                    break;
                case 4:
                    self.seletedRegionName = [Singleton object].taichungRegionArray[row];
                    break;
                case 5:
                    self.seletedRegionName = [Singleton object].keelungRegionArray[row];
                    break;
                case 6:
                    self.seletedRegionName = [Singleton object].hualienRegionArray[row];
                    break;
                case 7:
                    self.seletedRegionName = [Singleton object].hsinchuRegionArray[row];
                    break;
                case 8:
                    self.seletedRegionName = [Singleton object].miaoliRegionArray[row];
                    break;
                case 9:
                    self.seletedRegionName = [Singleton object].changhuaRegionArray[row];
                    break;
                case 10:
                    self.seletedRegionName = [Singleton object].nantouRegionArray[row];
                    break;
                case 11:
                    self.seletedRegionName = [Singleton object].chiayiRegionArray[row];
                    break;
                case 12:
                    self.seletedRegionName = [Singleton object].taitungRegionArray[row];
                    break;
                case 13:
                    self.seletedRegionName = [Singleton object].tainanRegionArray[row];
                    break;
                case 14:
                    self.seletedRegionName = [Singleton object].kaohsiungRegionArray[row];
                    break;
                default:
                    self.seletedRegionName = [Singleton object].pingtungRegionArray[row];
                    break;
            }
        }
    } else if([[_DataSource setPickViewCompent:self] containsString:@"3"]) {
        if (component == 0) {
            capitalReginNumber = row;
            self.capitalRegionName = [Singleton object].capitalNameArray[row];
            [self reloadAllComponents];
            [self selectRow:0 inComponent:1 animated:YES];
            [self selectRow:0 inComponent:2 animated:YES];
            self.activityTypeName = [Singleton object].activityTypeArray[0];
            switch (capitalReginNumber) {
                case 0:
                    self.seletedRegionName = [Singleton object].taipeiRegionArray[0];
                    break;
                case 1:
                    self.seletedRegionName =  [Singleton object].NewTaipeiRegionArray[0];
                    break;
                case 2:
                    self.seletedRegionName =  [Singleton object].iIanRegionArray[0];
                    break;
                case 3:
                    self.seletedRegionName =  [Singleton object].taoyuanRegionArray[0];
                    break;
                case 4:
                    self.seletedRegionName =  [Singleton object].taichungRegionArray[0];
                    break;
                case 5:
                    self.seletedRegionName =  [Singleton object].keelungRegionArray[0];
                    break;
                case 6:
                    self.seletedRegionName =  [Singleton object].hualienRegionArray[0];
                    break;
                case 7:
                    self.seletedRegionName =  [Singleton object].hsinchuRegionArray[0];
                    break;
                case 8:
                    self.seletedRegionName =  [Singleton object].miaoliRegionArray[0];
                    break;
                case 9:
                    self.seletedRegionName =  [Singleton object].changhuaRegionArray[0];
                    break;
                case 10:
                    self.seletedRegionName =  [Singleton object].nantouRegionArray[0];
                    break;
                case 11:
                    self.seletedRegionName =  [Singleton object].chiayiRegionArray[0];
                    break;
                case 12:
                    self.seletedRegionName =  [Singleton object].taitungRegionArray[0];
                    break;
                case 13:
                    self.seletedRegionName =  [Singleton object].tainanRegionArray[0];
                    break;
                case 14:
                    self.seletedRegionName =  [Singleton object].kaohsiungRegionArray[0];
                    break;
                default:
                    self.seletedRegionName =  [Singleton object].pingtungRegionArray[0];
                    break;
            }
        }
        if(component == 1) {
            self.activityTypeName = [Singleton object].activityTypeArray[row];
        }
        if(component == 2) {
            switch (capitalReginNumber) {
                case 0:
                    self.seletedRegionName = [Singleton object].taipeiRegionArray[row];
                    break;
                case 1:
                    self.seletedRegionName = [Singleton object].NewTaipeiRegionArray[row];
                    break;
                case 2:
                    self.seletedRegionName = [Singleton object].iIanRegionArray[row];
                    break;
                case 3:
                    self.seletedRegionName = [Singleton object].taoyuanRegionArray[row];
                    break;
                case 4:
                    self.seletedRegionName = [Singleton object].taichungRegionArray[row];
                    break;
                case 5:
                    self.seletedRegionName = [Singleton object].keelungRegionArray[row];
                    break;
                case 6:
                    self.seletedRegionName = [Singleton object].hualienRegionArray[row];
                    break;
                case 7:
                    self.seletedRegionName = [Singleton object].hsinchuRegionArray[row];
                    break;
                case 8:
                    self.seletedRegionName = [Singleton object].miaoliRegionArray[row];
                    break;
                case 9:
                    self.seletedRegionName = [Singleton object].changhuaRegionArray[row];
                    break;
                case 10:
                    self.seletedRegionName = [Singleton object].nantouRegionArray[row];
                    break;
                case 11:
                    self.seletedRegionName = [Singleton object].chiayiRegionArray[row];
                    break;
                case 12:
                    self.seletedRegionName = [Singleton object].taitungRegionArray[row];
                    break;
                case 13:
                    self.seletedRegionName = [Singleton object].tainanRegionArray[row];
                    break;
                case 14:
                    self.seletedRegionName = [Singleton object].kaohsiungRegionArray[row];
                    break;
                default:
                    self.seletedRegionName = [Singleton object].pingtungRegionArray[row];
                    break;
            }
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
