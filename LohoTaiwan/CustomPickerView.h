//
//  CustomPickerView.h
//  LohoTaiwan
//
//  Created by 黃柏恩 on 2017/10/27.
//  Copyright © 2017年 黃柏恩. All rights reserved.
@class CustomPickerView;

@protocol CustomPickerViewDelegate <NSObject>

-(NSString*)setPickViewCompent:(CustomPickerView*)customPickerView;

@end
#import <UIKit/UIKit.h>


@interface CustomPickerView : UIPickerView<UIPickerViewDelegate>

@property (nonatomic, strong)NSString *activityTypeName;

@property (nonatomic, strong)NSString *capitalRegionName;

@property (nonatomic, strong)NSString *seletedRegionName;

@property (nonatomic, strong)UITextField *pickerViewTextField;

@property(nonatomic) id<CustomPickerViewDelegate>DataSource;

-(void)setCustomPickerViewDataSource;

@end
