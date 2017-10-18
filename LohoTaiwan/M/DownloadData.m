//
//  DownloadData.m
//  LohoTaiwan
//
//  Created by 黃柏恩 on 2017/9/20.
//  Copyright © 2017年 黃柏恩. All rights reserved.

#import "DownloadData.h"
#import <AFNetworking.h>
#import "AppDelegate.h"

#define GovernmentFoodURL @"http://gis.taiwan.net.tw/XMLReleaseALL_public/restaurant_C_f.json"
#define GovernmentAttractionsURL  @"http://gis.taiwan.net.tw/XMLReleaseALL_public/scenic_spot_C_f.json"
#define GovernmentLeisureFarmURL @"http://data.coa.gov.tw/Service/OpenData/ODwsv/ODwsvAttractions.aspx"
#define GovernmentHotelBedAndBreakfastURL @"http://gis.taiwan.net.tw/XMLReleaseALL_public/hotel_C_f.json"
//#define GovernmentCultureExhibitionURL @"https://cloud.culture.tw/frontsite/trans/SearchShowAction.do?method=doFindTypeJ&category=6"


#define NewTaipeiFoodURL @"http://data.ntpc.gov.tw/od/data/api/D9219E21-A743-4F98-A361-1FFBE8424D73?$format=json"
#define NewTaipeiAttractionsURL @"http://data.ntpc.gov.tw/od/data/api/A886239B-D7C1-4309-870F-E0F64D088025?$format=json"

@implementation DownloadData
{
    NSManagedObjectContext *managedObjectContext;
    AFHTTPSessionManager *manager;
}

-(id)init {
    self = [super init];
    if (self) {
        manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        managedObjectContext = appDelegate.persistentContainer.viewContext;
    }
    return  self;
}

-(void)GovernmentAttractionsData {
        [manager GET:GovernmentAttractionsURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if(responseObject != nil) {
                NSDictionary *array = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                NSDictionary *dArray = [[NSDictionary alloc] initWithDictionary:array[@"XML_Head"][@"Infos"]];
                NSArray *dataArray = dArray[@"Info"];
                NSLog(@"%lu",(unsigned long)dataArray.count);
    
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
                    NSDictionary *array = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                    NSDictionary *dArray = [[NSDictionary alloc] initWithDictionary:array[@"XML_Head"][@"Infos"]];
                    NSArray *dataArray = dArray[@"Info"];
                    NSLog(@"%lu",(unsigned long)dataArray.count);
    
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
                NSArray *array = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                NSLog(@"數量：%lu",(unsigned long)array.count);
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
            NSDictionary *array = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSDictionary *dArray = [[NSDictionary alloc] initWithDictionary:array[@"XML_Head"][@"Infos"]];
            NSArray *dataArray = dArray[@"Info"];
            NSLog(@"%lu",(unsigned long)dataArray.count);


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
                    NSArray *dataArray = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                    NSLog(@"資料數量為：%lu",(unsigned long)dataArray.count);
    
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
                NSArray *dataArray = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                NSLog(@"資料數量為：%lu",(unsigned long)dataArray.count);
    
                NSManagedObject *newJsonData = [NSEntityDescription insertNewObjectForEntityForName:@"NewTaipeiFoodData" inManagedObjectContext:managedObjectContext];
                [newJsonData setValue:responseObject forKey:@"newTaipeiFoodData"];
                NSError *error;
                if (error) {
                    NSLog(@"%@",error);
                } else {
                    [managedObjectContext save:&error];
                    NSLog(@"NewTaipeiFoodData儲存成功");
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"dimissAlertControler"
                                                                        object:nil
                                                                      userInfo:nil];
                }
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@",error);
            [self NewTaipeiFoodData];
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
