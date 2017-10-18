//
//  ViewController.m
//  LohoTaiwan
//
//  Created by 黃柏恩 on 2017/9/20.
//  Copyright © 2017年 黃柏恩. All rights reserved.
//
#import "Singleton.h"
#import "AppDelegate.h"
#import "DownloadData.h"
#import "ViewController.h"
#import "MainTableViewCell.h"
#import "LoginViewControler.h"
#import "ListTableViewController.h"
@interface ViewController()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation ViewController
{
    NSTimer *time;
    NSArray *activityTypeArry;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    activityTypeArry = [[Singleton object] activityType];
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *managedObjectContext = appDelegate.persistentContainer.viewContext;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"GovernmentAttractionsData"];
    NSError *error;
    NSArray *result = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    NSArray *governmentAttractionsDataArray = [result valueForKey:@"governmentAttractionsData"];
    if(governmentAttractionsDataArray.count == 0) {
        DownloadData *dowloadjsonData = [DownloadData new];
        [dowloadjsonData GovernmentAttractionsData];
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"下載資料中" message:nil preferredStyle:UIAlertControllerStyleAlert];
        //Activity Indicator
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityIndicator.frame = CGRectMake(self.view.frame.size.width/2,30,0,0);
        [alert.view addSubview:activityIndicator];
        activityIndicator.hidesWhenStopped = true;
        [activityIndicator startAnimating];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dimissAlertControler)
                                                 name:@"dimissAlertControler"
                                               object:nil];
//    [managedObjectContext deleteObject:result[0]];
//    if (error) {
//        NSLog(@"%@",error);
//    } else {
//        [managedObjectContext save:&error];
//        NSLog(@"刪除成功");
//    }
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = YES;
}

-(void)dimissAlertControler {
    
    [self dismissViewControllerAnimated:true completion:nil];
    UIAlertController *printMessageControler = [UIAlertController alertControllerWithTitle:@"下載完成" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    time = [NSTimer scheduledTimerWithTimeInterval:2 repeats:false block:^(NSTimer * _Nonnull timer) {
        [self dismissViewControllerAnimated:true completion:nil];
    }];
    [self presentViewController:printMessageControler animated:YES completion:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *ActivityTypeArray = [[Singleton object] activityType];
    return ActivityTypeArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MainCell" forIndexPath:indexPath];
    cell.ImageView.image = [UIImage imageNamed:activityTypeArry[indexPath.row]];
    cell.TextLabel.text = activityTypeArry[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [Singleton object].activity = indexPath.row;
    ListTableViewController *listTableViewControler = [self.storyboard
                                                           instantiateViewControllerWithIdentifier:@"ListTableViewController"];
    [self.navigationController pushViewController:listTableViewControler animated:true];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
