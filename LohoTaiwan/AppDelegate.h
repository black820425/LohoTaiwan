//
//  AppDelegate.h
//  LohoTaiwan
//
//  Created by 黃柏恩 on 2017/9/20.
//  Copyright © 2017年 黃柏恩. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

