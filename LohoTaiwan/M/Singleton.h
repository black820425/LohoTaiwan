//
//  Singleton.h
//  LohoTaiwan
//
//  Created by 黃柏恩 on 2017/9/28.
//  Copyright © 2017年 黃柏恩. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

typedef void(^PassValueBlock)(NSArray*);

@interface Singleton : NSObject

@property (nonatomic, assign)NSInteger activity;

@property (nonatomic, strong)NSArray *capitalNameArray;

@property (nonatomic, strong)NSArray *nameAddArray;

@property (nonatomic, strong)NSArray *activityTypeArray;

@property (nonatomic, strong)NSArray *taipeiRegionArray;

@property (nonatomic, strong)NSArray *NewTaipeiRegionArray;

@property (nonatomic, strong)NSArray *iIanRegionArray;

@property (nonatomic, strong)NSArray *taoyuanRegionArray;

@property (nonatomic, strong)NSArray *taichungRegionArray;

@property (nonatomic, strong)NSArray *keelungRegionArray;

@property (nonatomic, strong)NSArray *hualienRegionArray;

@property (nonatomic, strong)NSArray *hsinchuRegionArray;

@property (nonatomic, strong)NSArray *miaoliRegionArray;

@property (nonatomic, strong)NSArray *changhuaRegionArray;

@property (nonatomic, strong)NSArray *nantouRegionArray;

@property (nonatomic, strong)NSArray *chiayiRegionArray;

@property (nonatomic, strong)NSArray *taitungRegionArray;

@property (nonatomic, strong)NSArray *tainanRegionArray;

@property (nonatomic, strong)NSArray *kaohsiungRegionArray;

@property (nonatomic, strong)NSArray *pingtungRegionArray;

@property (nonatomic, strong)NSArray *regionNameArray;

+(instancetype) object;

-(NSArray*)readGovernmentData:(NSString*)entities attributes:(NSString*)attribute;

-(void)readGovernmentData:(NSString*)entities attributes:(NSString*)attribute block:(PassValueBlock)array;

@end
