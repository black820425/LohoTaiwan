//
//  Singleton.h
//  LohoTaiwan
//
//  Created by 黃柏恩 on 2017/9/28.
//  Copyright © 2017年 黃柏恩. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface Singleton : NSObject

@property (nonatomic, assign)NSInteger activity;

@property (nonatomic, strong)NSArray *capitalName;

@property (nonatomic, strong)NSArray *activityType;

@property (nonatomic, strong)NSArray *nameAddArray;

@property (nonatomic, strong)NSArray *TaipeiRegionArray;

@property (nonatomic, strong)NSMutableArray *nameAndAddressArray;

+(instancetype) object;

-(void)putNameAndAddressToMap:(NSString*)name address:(NSString*)address;

-(NSArray*)readGovernmentData:(NSString*)entities attributes:(NSString*)attribute;

-(NSArray*)readGovernmentLeisureFarmData;

-(NSArray*)readnewTaipeiData:(NSString*)entities attributes:(NSString*)attribute;

@end
