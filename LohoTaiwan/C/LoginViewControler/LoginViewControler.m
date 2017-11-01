//
//  LonginViewControler.m
//  LohoTaiwan
//
//  Created by 黃柏恩 on 2017/10/17.
//  Copyright © 2017年 黃柏恩. All rights reserved.

#import "LoginViewControler.h"
//#import <FBSDKCoreKit/FBSDKCoreKit.h>
//#import <FBSDKLoginKit/FBSDKLoginKit.h>
@interface LoginViewControler ()

@end

@implementation LoginViewControler
- (void)viewDidLoad {
    [super viewDidLoad];
//    FBSDKLoginButton *FBBtn = [FBSDKLoginButton new];
//    FBBtn.center = self.view.center;
//    [self.view addSubview:FBBtn];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //if([FBSDKAccessToken currentAccessToken]) {
//        TabBarViewController *tabBarView = [self.storyboard instantiateViewControllerWithIdentifier:@"TabBarViewController"];
//        [self presentViewController:tabBarView animated:true completion:nil];
    //}
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
