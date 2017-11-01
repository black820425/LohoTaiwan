//
//  DownloadData.m
//  LohoTaiwan
//
//  Created by 黃柏恩 on 2017/9/20.
//  Copyright © 2017年 黃柏恩. All rights reserved.
#import "AppDelegate.h"
#import "DownloadData.h"
#import <AFNetworking.h>

//台北市政府開放平台網址
#define TaipeiCityAttractionsURL @"http://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=36847f3f-deff-4183-a5bb-800737591de5"

//新北市政府開放平臺網址
#define NewTaipeiFoodURL @"http://data.ntpc.gov.tw/od/data/api/D9219E21-A743-4F98-A361-1FFBE8424D73?$format=json"
#define NewTaipeiAttractionsURL @"http://data.ntpc.gov.tw/od/data/api/A886239B-D7C1-4309-870F-E0F64D088025?$format=json"

//政府資料開放平臺網址
#define GovernmentFoodURL @"http://gis.taiwan.net.tw/XMLReleaseALL_public/restaurant_C_f.json"
#define GovernmentAttractionsURL  @"http://gis.taiwan.net.tw/XMLReleaseALL_public/scenic_spot_C_f.json"
#define GovernmentLeisureFarmURL @"http://data.coa.gov.tw/Service/OpenData/ODwsv/ODwsvAttractions.aspx"
#define GovernmentHotelBedAndBreakfastURL @"http://gis.taiwan.net.tw/XMLReleaseALL_public/hotel_C_f.json"
//#define GovernmentCultureExhibitionURL @"https://cloud.culture.tw/frontsite/trans/SearchShowAction.do?method=doFindTypeJ&category=6"

@implementation DownloadData
{
    NSManagedObjectContext *managedObjectContext;
    AFHTTPSessionManager *manager;
}

-(id)init {
    self = [super init];
    if (self) {
        manager = [AFHTTPSessionManager manager];
        //manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.requestSerializer = [AFJSONRequestSerializer serializer]; //請求的數據
        manager.responseSerializer = [AFJSONResponseSerializer serializer]; //回傳的數據
        ((AFJSONResponseSerializer *)manager.responseSerializer).removesKeysWithNullValues = YES;

        
        AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        managedObjectContext = appDelegate.persistentContainer.viewContext;
    }
    return  self;
}

-(void)GovernmentAttractionsData {
        [manager GET:GovernmentAttractionsURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if(responseObject != nil) {
                
                NSManagedObject *newJsonData = [NSEntityDescription insertNewObjectForEntityForName:@"GovernmentAttractionsData" inManagedObjectContext:managedObjectContext];
                [newJsonData setValue:responseObject forKey:@"governmentAttractionsData"];
                NSError *error;
                if (error) {
                    NSLog(@"%@",error);
                } else {
                    [managedObjectContext save:&error];
                    NSLog(@"GovernmentAttractionsData儲存成功");
                     [self GovernmentFoodData];
                }
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@",error);
            [self GovernmentAttractionsData];
        }];
}

-(void)GovernmentFoodData {
            [manager GET:GovernmentFoodURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if(responseObject != nil) {
                    NSManagedObject *newJsonData = [NSEntityDescription insertNewObjectForEntityForName:@"GovernmentFoodData" inManagedObjectContext:managedObjectContext];
                    [newJsonData setValue:responseObject forKey:@"governmentFoodData"];
                    NSError *error;
                    if (error) {
                        NSLog(@"%@",error);
                    } else {
                        [managedObjectContext save:&error];
                        NSLog(@"GovernmentFoodData儲存成功");
                        [self GovernmentLeisureFarmData];
                    }
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"%@",error);
                [self GovernmentFoodData];
            }];
}

-(void)GovernmentLeisureFarmData {
        [manager POST:GovernmentLeisureFarmURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if(responseObject != nil) {
                NSManagedObject *newJsonData = [NSEntityDescription insertNewObjectForEntityForName:@"GovernmentLeisureFarmData" inManagedObjectContext:managedObjectContext];
                [newJsonData setValue:responseObject forKey:@"governmentLeisureFarmData"];
                NSError *error;
                if (error) {
                    NSLog(@"%@",error);
                } else {
                    [managedObjectContext save:&error];
                    NSLog(@"GovernmentLeisureFarmData儲存成功");
                    [self GovernmentHotelBedAndBreakfastData];
                }
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@",error);
            [self GovernmentLeisureFarmData];
        }];
}

-(void)GovernmentHotelBedAndBreakfastData {
    [manager GET:GovernmentHotelBedAndBreakfastURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(responseObject != nil) {
            NSManagedObject *newJsonData = [NSEntityDescription insertNewObjectForEntityForName:@"GovernmentHotelBedAndBreakfastData" inManagedObjectContext:managedObjectContext];
            [newJsonData setValue:responseObject forKey:@"governmentHotelBedAndBreakfastData"];
            NSError *error;
            if (error) {
                NSLog(@"%@",error);
            } else {
                [managedObjectContext save:&error];
                NSLog(@"GovernmentHotelBedAndBreakfastData儲存成功");
                [self NewTaipeiAttractionsData];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        [self GovernmentHotelBedAndBreakfastData];
    }];
}

-(void)NewTaipeiAttractionsData {
            [manager GET:NewTaipeiAttractionsURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if(responseObject != nil) {
                    NSManagedObject *newJsonData = [NSEntityDescription insertNewObjectForEntityForName:@"NewTaipeiAttractionsData" inManagedObjectContext:managedObjectContext];
                    [newJsonData setValue:responseObject forKey:@"newTaipeiAttractionsData"];
                    NSError *error;
                    if (error) {
                        NSLog(@"%@",error);
                    } else {
                        [managedObjectContext save:&error];
                        NSLog(@"NewTaipeiAttractionsData儲存成功");
                        [self NewTaipeiFoodData];
                    }
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"%@",error);
                [self NewTaipeiAttractionsData];
            }];
}

-(void)NewTaipeiFoodData {
        [manager GET:NewTaipeiFoodURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if(responseObject != nil) {    
                NSManagedObject *newJsonData = [NSEntityDescription insertNewObjectForEntityForName:@"NewTaipeiFoodData" inManagedObjectContext:managedObjectContext];
                [newJsonData setValue:responseObject forKey:@"newTaipeiFoodData"];
                NSError *error;
                if (error) {
                    NSLog(@"%@",error);
                } else {
                    [managedObjectContext save:&error];
                    NSLog(@"NewTaipeiFoodData儲存成功");
                    [self TaipeiCityAttractionsData];
                }
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@",error);
            [self NewTaipeiFoodData];
        }];
}

-(void)TaipeiCityAttractionsData {
    [manager GET:TaipeiCityAttractionsURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"responseObject的資料為：%@",responseObject);
        if(responseObject != nil) {
            NSManagedObject *newJsonData = [NSEntityDescription insertNewObjectForEntityForName:@"TaipeiCityAttractionsData" inManagedObjectContext:managedObjectContext];
            [newJsonData setValue:responseObject forKey:@"taipeiCityAttractionsData"];
            NSError *error;
            if (error) {
                NSLog(@"%@",error);
            } else {
                [managedObjectContext save:&error];
                NSLog(@"TaipeiCityAttractionsData儲存成功");
                [[NSNotificationCenter defaultCenter] postNotificationName:@"dimissAlertControler"
                                                                    object:nil
                                                                  userInfo:nil];
            }
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        [self TaipeiCityAttractionsData];
    }];
}


//    [manager POST:GovernmentCultureExhibitionURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        if(responseObject != nil) {
//            NSArray *dataArray = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
//            NSLog(@"資料筆數為：%lu",(unsigned long)dataArray.count);
//
//            NSManagedObject *newJsonData = [NSEntityDescription insertNewObjectForEntityForName:@"GovernmentCultureExhibitionData" inManagedObjectContext:managedObjectContext];
//            [newJsonData setValue:responseObject forKey:@"governmentCultureExhibitionData"];
//            NSError *error;
//            if (error) {
//                NSLog(@"%@",error);
//            } else {
//                [managedObjectContext save:&error];
//                NSLog(@"儲存成功");
//            }
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"%@",error);
//    }];
//
@end
