//
//  DownloadData.h
//  LohoTaiwan
//
//  Created by 黃柏恩 on 2017/9/20.
//  Copyright © 2017年 黃柏恩. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DownloadData : NSObject <NSXMLParserDelegate>

-(void)GovernmentFoodData;

-(void)GovernmentAttractionsData;

-(void)GovernmentLeisureFarmData;

-(void)GovernmentHotelBedAndBreakfastData;


-(void)NewTaipeiFoodData;

-(void)NewTaipeiAttractionsData;


-(void)TaipeiCityAttractionsData;

@end
