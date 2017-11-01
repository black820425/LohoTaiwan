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
@interface ViewController()<UITableViewDelegate,UITableViewDataSource,NSXMLParserDelegate>

@end

@implementation ViewController
{
    NSTimer *time;
    NSMutableArray *activityTypeArry;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    NSArray *dataArray = [[Singleton object] readGovernmentData:@"TaipeiCityAttractionsData" attributes:@"taipeiCityAttractionsData"];
//    NSLog(@"%@",dataArray);

//    DownloadData *dowloadjsonData = [DownloadData new];
//    [dowloadjsonData TaipeiCityAttractionsData];
    
    activityTypeArry = [[[Singleton object] activityTypeArray]  mutableCopy];

    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *managedObjectContext = appDelegate.persistentContainer.viewContext;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"GovernmentAttractionsData"];
    NSError *error;
    NSArray *result = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    NSArray *governmentAttractionsDataArray = [result valueForKey:@"governmentAttractionsData"];
    //讀取 CoreData的資料
    if(governmentAttractionsDataArray.count == 0) {
        DownloadData *dowloadjsonData = [DownloadData new];
        [dowloadjsonData GovernmentAttractionsData];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"下載資料中" message:nil preferredStyle:UIAlertControllerStyleAlert];
        //Activity Indicator
//        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//        activityIndicator.frame = CGRectMake(self.view.frame.size.width/2,30,0,0);
//        [alert.view addSubview:activityIndicator];
//        activityIndicator.hidesWhenStopped = true;
//        [activityIndicator startAnimating];

        [self presentViewController:alert animated:YES completion:nil];
    }
    governmentAttractionsDataArray = nil;
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dimissAlertControler) name:@"dimissAlertControler" object:nil];
    
//    [managedObjectContext deleteObject:result[0]];
//    if (error) {
//        NSLog(@"%@",error);
//    } else {
//        [managedObjectContext save:&error];
//        NSLog(@"刪除成功");
//    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = true;
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
    NSArray *ActivityTypeArray = [[Singleton object] activityTypeArray];
    return ActivityTypeArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MainCell" forIndexPath:indexPath];
    cell.TextLabel.text = activityTypeArry[indexPath.row];
    
    UIImage *image = [self resizeImage:[UIImage imageNamed:activityTypeArry[indexPath.row]]];
    
    //cell.ImageView.image = [UIImage imageNamed:activityTypeArry[indexPath.row]];
    cell.backgroundView = [[UIImageView alloc] initWithImage:[image  stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0] ];
    return cell;
}

-(UIImage *)resizeImage:(UIImage*)inputImage {
    CGFloat maxLength = 1024.0;
    CGSize targetSize;
    UIImage *finalImage;
    
    //Check it is necessary to resiz.
    if(inputImage.size.width <= maxLength && inputImage.size.height <=maxLength) {
        finalImage = inputImage;
        targetSize = inputImage.size;
    } else {
        //We Will resize the input image.
        if(inputImage.size.width >= inputImage.size.height) {
            CGFloat ratio = inputImage.size.width / maxLength;
            targetSize = CGSizeMake(maxLength, inputImage.size.height / ratio);
        } else {
            // Height > Width
            CGFloat ratio = inputImage.size.height / maxLength;
            targetSize = CGSizeMake(inputImage.size.width / ratio,maxLength);
        }
    }
    
    UIGraphicsBeginImageContext(targetSize);
    [inputImage drawInRect:CGRectMake(0, 0, targetSize.width, targetSize.height)];
    
    finalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext(); //Important!!
    
    return finalImage;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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
