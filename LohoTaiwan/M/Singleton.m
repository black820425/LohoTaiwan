//
//  Singleton.m
//  LohoTaiwan
//
//  Created by 黃柏恩 on 2017/9/28.
//  Copyright © 2017年 黃柏恩. All rights reserved.
//
#import "Singleton.h"
#import "AppDelegate.h"

@implementation Singleton
{
    NSManagedObjectContext *managedObjectContext;
    NSFetchRequest *fetchRequest;
    NSArray *result;
    NSArray *dataArray;
}

- (id)init {
    self = [super init];
    if(self) {
        self.nameAndAddressArray = [NSMutableArray new];
        
        AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        managedObjectContext = appDelegate.persistentContainer.viewContext;
        
        self.activityType = @[@"景點",@"餐飲",@"休閒農場",@"民宿旅館"];
        
        self.capitalName = @[@"台北市",@"新北市",@"宜蘭縣",@"桃園市",@"台中市",@"基隆市",@"花蓮縣",@"新竹市",
                             @"苗栗縣",@"彰化縣",@"南投縣",@"嘉義市",@"台東縣",@"台南市",@"高雄市",@"屏東縣"];
        
        self.TaipeiRegionArray = @[@"板橋區",@"新莊區",@"中和區",@"永和區",@"土城區",@"樹林區",
                                   @"三峽區",@"鶯歌區",@"三重區",@"蘆洲區",@"五股區",@"泰山區",
                                   @"林口區",@"八里區",@"淡水區",@"三芝區",@"石門區",@"金山區",
                                   @"萬里區",@"汐止區",@"瑞芳區",@"貢寮區",@"平溪區",@"雙溪區",
                                   @"新店區",@"深坑區",@"石碇區",@"坪林區",@"烏來區"];
    }
    return self;
}

+(instancetype)object
{
    static Singleton *singletonObject = nil;
    if(singletonObject == nil)
    {
        singletonObject = [[Singleton alloc]init];
    }
    return singletonObject;
}

-(void)putNameAndAddressToMap:(NSString*)name address:(NSString*)address {
    if([name  isEqual: @"nil"] && [address  isEqual: @"nil"]) {
        [self.nameAndAddressArray removeAllObjects];
    } else {
        [self.nameAndAddressArray addObject:name];
        [self.nameAndAddressArray addObject:address];
    }

}

-(NSArray*)readGovernmentData:(NSString*)entities attributes:(NSString*)attribute {
    NSError *error;
    fetchRequest = [[NSFetchRequest alloc] initWithEntityName:entities];
    result = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if([result valueForKey:attribute] != nil) {
        NSArray *governmentAttractionsData = [result valueForKey:attribute];
        if(governmentAttractionsData.count != 0) {
            NSDictionary *governmentAttractionsDataArray = [NSJSONSerialization JSONObjectWithData:governmentAttractionsData[0] options:NSJSONReadingMutableContainers error:nil];
            NSDictionary *InfosArray = [[NSDictionary alloc] initWithDictionary:governmentAttractionsDataArray[@"XML_Head"][@"Infos"]];
            dataArray = InfosArray[@"Info"];
        }
    }
    return dataArray;
}

-(NSArray*)readGovernmentLeisureFarmData {
    NSError *error;
    fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"GovernmentLeisureFarmData"];
    result = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if([result valueForKey:@"governmentLeisureFarmData"] != nil) {
        NSArray *governmentLeisureFarmDataArray = [result valueForKey:@"governmentLeisureFarmData"];
        if(governmentLeisureFarmDataArray.count != 0) {
            dataArray = [NSJSONSerialization JSONObjectWithData:governmentLeisureFarmDataArray[0]
                                                       options:NSJSONReadingMutableLeaves error:nil];
        }
    }
    return dataArray;
}

-(NSArray*)readnewTaipeiData:(NSString*)entities attributes:(NSString*)attribute {
    NSError *error;
    fetchRequest = [[NSFetchRequest alloc] initWithEntityName:entities];
    result = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if([result valueForKey:attribute] != nil) {
        NSArray *newTaipeiAttractionsDataArray = [result valueForKey:attribute];
        if(newTaipeiAttractionsDataArray.count != 0) {
            dataArray = [NSJSONSerialization JSONObjectWithData:newTaipeiAttractionsDataArray[0] options:NSJSONReadingMutableLeaves error:nil];
        }
    }
    return dataArray;
}

@end
