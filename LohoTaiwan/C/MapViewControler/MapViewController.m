//
//  MapViewController.m
//  LohoTaiwan
//
//  Created by 黃柏恩 on 2017/9/20.
//  Copyright © 2017年 黃柏恩. All rights reserved.
//
#import <Chameleon.h>
#import "Singleton.h"
#import "AppDelegate.h"
#import "MapKit/MapKit.h"
#import "CustomPickerView.h"
#import "MapViewController.h"
#import "CoreLocation/CoreLocation.h"
#import "DetailUITableViewController.h"

#define CapitalLoactionArray @{@"臺北市":@{@"latitude":@25.030759,@"longtiude":@121.545937},@"新北市":@{@"latitude":@25.013486,@"longtiude":@121.463999},@"基隆市":@{@"latitude":@25.123846,      @"longtiude":@121.717485},@"宜蘭縣":@{@"latitude":@24.731487,@"longtiude":@121.762523},@"桃園市":@{@"latitude":@24.997127,@"longtiude":@121.295983},@"臺中市":@{@"latitude":@24.145972,@"longtiude":@120.666141},@"花蓮縣":@{@"latitude":@23.994943,@"longtiude":@121.602418},@"新竹市":@{@"latitude":@24.783633,@"longtiude":@120.955805},@"苗栗縣":@{@"latitude":@24.558924,@"longtiude":@120.812060},@"彰化縣":@{@"latitude":@24.076782,@"longtiude":@120.564652},@"南投縣":@{@"latitude":@23.922000,@"longtiude":@120.680772},@"嘉義市":@{@"latitude":@23.477897,@"longtiude":@120.449154},@"臺東縣":@{@"latitude":@22.752185,@"longtiude":@121.113641},@"臺南市":@{@"latitude":@22.991622,@"longtiude":@120.185034},@"高雄市":@{@"latitude":@22.620663,@"longtiude":@120.312173},@"屏東縣":@{@"latitude":@22.666263,@"longtiude":@120.481918}}

#define NewTaipeiRegionlocationArray @{@"板橋區":@{@"latitude":@25.006140,@"longtiude":@121.456706},@"新莊區":@{@"latitude":@25.032048,@"longtiude":@121.429676},@"中和區":@{@"latitude":@24.997012,@"longtiude":@121.495813},@"永和區":@{@"latitude":@25.005789,@"longtiude":@121.513708},@"土城區":@{@"latitude":@24.965934,@"longtiude":@121.444856},@"樹林區":@{@"latitude":@24.990268,@"longtiude":@121.421339},@"三峽區":@{@"latitude":@24.933613,@"longtiude":@121.375233},@"鶯歌區":@{@"latitude":@24.955189,@"longtiude":@121.349049},@"三重區":@{@"latitude":@25.069777,@"longtiude":@121.487125},@"蘆洲區":@{@"latitude":@25.088310,@"longtiude":@121.473147},@"五股區":@{@"latitude":@25.085246,@"longtiude":@121.439232},@"泰山區":@{@"latitude":@25.059757,@"longtiude":@121.433011},@"林口區":@{@"latitude":@25.081036,@"longtiude":@121.382997},@"八里區":@{@"latitude":@25.145509,@"longtiude":@121.405930},@"淡水區":@{@"latitude":@25.172785,@"longtiude":@121.443197},@"三芝區":@{@"latitude":@25.254368,@"longtiude":@121.502428},@"石門區":@{@"latitude":@25.283470,@"longtiude":@121.570139},@"金山區":@{@"latitude":@25.216829,@"longtiude":@121.630560},@"萬里區":@{@"latitude":@25.177640,@"longtiude":@121.681287},@"汐止區":@{@"latitude":@25.073106,@"longtiude":@121.669668},@"瑞芳區":@{@"latitude":@25.101833,@"longtiude":@121.812198},@"貢寮區":@{@"latitude":@25.031493,@"longtiude":@121.930475},@"平溪區":@{@"latitude":@25.025681,@"longtiude":@121.758957},@"雙溪區":@{@"latitude":@25.031950,@"longtiude":@121.853052},@"新店區":@{@"latitude":@24.967832,@"longtiude":@121.540852},@"深坑區":@{@"latitude":@24.997495,@"longtiude":@121.620690},@"石碇區":@{@"latitude":@24.986457,@"longtiude":@121.657338},@"坪林區":@{@"latitude":@24.927178,@"longtiude":@121.711798},@"烏來區":@{@"latitude":@24.862337,@"longtiude":@121.547862}}

@interface MapViewController ()
<MKMapViewDelegate,CLLocationManagerDelegate,
UISearchBarDelegate,UIGestureRecognizerDelegate,UIActionSheetDelegate,CustomPickerViewDelegate>
{
    
    NSArray *dataArray;
    NSArray *nameAddarray;
    NSArray *activityTypeArry;
    NSArray *locationNameKeyArray;
    
    NSString *distance;
    NSString *keyName;
    NSString *addressKeyName;
    NSString *activityTypeName;
    NSString *capitalRegionName;
    NSString *seletedRegionName;
    MKDirectionsResponse *directionResponse;
    
    MKUserLocation *myuserlocation;
    CLLocationCoordinate2D coordinate;
    CLLocationManager *locationManager;
    
    MKUserTrackingButton *traceBtn;
    
    CustomPickerView *customPickerView;
}
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet MKMapView *MapView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *searchButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *selecteRegionButton;
@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    activityTypeArry = [[Singleton object] activityTypeArray];
    
    locationManager = [CLLocationManager new];
    //詢問使用者
    [locationManager requestAlwaysAuthorization];
    //設定準確性
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    //設定類型
    locationManager.activityType = CLActivityTypeOtherNavigation;
    //給授權者
    locationManager.delegate = self;
    //准許於背景執行
    //locationManager.allowsBackgroundLocationUpdates = true;
    locationManager.pausesLocationUpdatesAutomatically = false;
    //開始回報位置
    [locationManager startUpdatingLocation];
    
    traceBtn = [MKUserTrackingButton new];
    traceBtn.layer.borderWidth = 1;
    traceBtn.layer.cornerRadius = 5;
    traceBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    //traceBtn.layer.backgroundColor = UIColor(white: 1, alpha: 0.8).cgColor
    traceBtn.layer.backgroundColor = [[UIColor alloc] initWithWhite:1 alpha:0.8].CGColor;

    [traceBtn setMapView:self.MapView];
    traceBtn.translatesAutoresizingMaskIntoConstraints = true;
    self.MapView.userTrackingMode = MKUserTrackingModeFollow;
    [self.MapView addSubview:traceBtn];
    
    [self setToolBarInPickView];
    
    //使用 longPress 觸控給 MapView
//    UILongPressGestureRecognizer *longPress;
//    longPress.delegate = self;
//    longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longpressToGetLocation:)];
//    [self.MapView addGestureRecognizer:longPress];
    //設定初始 pickerView    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = false;
    if ([[Singleton object].nameAddArray firstObject] == nil) {
    }else {
        self.navigationItem.rightBarButtonItem = nil;
        [self putAnnotationFromDetailAddress];
        [Singleton object].nameAddArray = nil;
    }
}

-(NSString*)setPickViewCompent:(CustomPickerView *)customPickerView {
    return @"3";
}

-(void)setToolBarInPickView {
    customPickerView = [CustomPickerView new];
    customPickerView.DataSource = self;
    [self.view addSubview:customPickerView.pickerViewTextField];
    
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    toolBar.backgroundColor = [UIColor flatMintColor];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:
                                   UIBarButtonSystemItemDone target:self action:@selector(doneTouched)];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:
                                     UIBarButtonSystemItemCancel target:self action:@selector(cancelTouched)];
    
    // the middle button is to make the Done button align to right
    [toolBar setItems:[NSArray arrayWithObjects:cancelButton, [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],doneButton, nil]];
    customPickerView.pickerViewTextField.inputAccessoryView = toolBar;
}

#pragma mark - Set Annotation from
-(void)putAnnotationFromDetailAddress {
    activityTypeName = activityTypeArry[[[Singleton object] activity]];
    capitalRegionName = [Singleton object].nameAddArray[0];
    [self startReadDataFromCoreData];
    [self addAnnotationsToMap:dataArray addressName:capitalRegionName];
    NSLog(@"capitalRegionName資料為:%@",capitalRegionName);
    NSLog(@"[Singleton object].nameAddArray[2]資料為:%@",[Singleton object].nameAddArray[2]);
}

#pragma mark  - Setting UIGestureAction 設定觸控事件給 MapView 上後給予座標。
-(void)longpressToGetLocation:(UILongPressGestureRecognizer *)gestureRcognizer {
    if(gestureRcognizer.state != UIGestureRecognizerStateBegan)
        return;
    CGPoint touchPoint = [gestureRcognizer locationInView:self.MapView];
    CLLocationCoordinate2D location = [self.MapView convertPoint:touchPoint toCoordinateFromView:self.MapView];
    NSLog(@"%f,%f",location.latitude,location.longitude);
    
    //Remove annotation
    [_MapView removeAnnotations:_MapView.annotations];
    
    //Create annotation
    MKPointAnnotation *annotation = [MKPointAnnotation new];
    annotation.title = @"Hello";
    annotation.coordinate = location;
    [_MapView addAnnotation:annotation];
}

#pragma mark - Setting searchButtonAction 設定 searchButton 案件事件。
- (IBAction)searchButton:(id)sender {
    UISearchController *searchControler = [[UISearchController alloc] initWithSearchResultsController:nil];
    searchControler.searchBar.delegate = self;
    [self presentViewController:searchControler animated:true completion:nil];
}
#pragma mark - Setting UISearchController 設定搜尋功能給 MapView 再給予座標。
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    //Ignoring user
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    //Activity Indicator
    UIActivityIndicatorView *activityIndicator = [UIActivityIndicatorView new];
    activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    activityIndicator.center = self.view.center;
    activityIndicator.hidesWhenStopped = true;
    [activityIndicator startAnimating];
    
    [self.view addSubview:activityIndicator];
    
    //Hide search bar
    //[searchBar resignFirstResponder];
    [self dismissViewControllerAnimated:true completion:nil];
    
    //Create the search request
    MKLocalSearchRequest *searchRequest = [MKLocalSearchRequest new];
    searchRequest.naturalLanguageQuery = searchBar.text;
    
    MKLocalSearch *activeSearch = [[MKLocalSearch alloc] initWithRequest:searchRequest];
    
    [activeSearch startWithCompletionHandler:^(MKLocalSearchResponse * _Nullable response, NSError * _Nullable error) {
        
        [activityIndicator stopAnimating];
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        
        if(response == nil) {
            NSLog(@"ERROR");
        } else {
            //Remove annotation
            [_MapView removeAnnotations:_MapView.annotations];
            
            //Get location
            double latitude = response.boundingRegion.center.latitude;
            double longitude = response.boundingRegion.center.longitude;
            
            //Create annotation
            MKPointAnnotation *annotation = [MKPointAnnotation new];
            annotation.title = searchBar.text;
            annotation.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
            [_MapView addAnnotation:annotation];
            
            //Zooming in on annotation
            CLLocationCoordinate2D newcoordinate = CLLocationCoordinate2DMake(latitude, longitude);
            MKCoordinateSpan span = MKCoordinateSpanMake(0.1, 0.1);
            MKCoordinateRegion region = MKCoordinateRegionMake(newcoordinate, span);
            [_MapView setRegion:region animated:true];
        }
    }];
}

-(void)setMapRegion{
    MKCoordinateSpan span;
    MKCoordinateRegion region;
    CLLocationCoordinate2D newcoordinate;
    
    NSDictionary *capitalRegionDictionary = CapitalLoactionArray;
    
    newcoordinate = CLLocationCoordinate2DMake
    ([capitalRegionDictionary[capitalRegionName][@"latitude"] doubleValue],
     [capitalRegionDictionary[capitalRegionName][@"longtiude"] doubleValue]);
    
    span = MKCoordinateSpanMake(0.4,0.4);
    region = MKCoordinateRegionMake(newcoordinate, span);
    [_MapView setRegion:region animated:true];
}

-(void)startReadDataFromCoreData {
    NSArray *nameArray = @[@"Name",@"stitle"];
    NSArray *addressNameArray = @[@"Add",@"Address",@"address"];
    NSArray *latiLongtiNameKeyArray =@[@[@"Py",@"Px"],@[@"latitude",@"longitude"]];
    keyName = nameArray[0];
    addressKeyName = addressNameArray[0];
    locationNameKeyArray = latiLongtiNameKeyArray[0];
    
    [_MapView removeAnnotations:_MapView.annotations];
    //[self.MapView removeOverlays:self.MapView.overlays];
    
    if ([capitalRegionName containsString:@"新北市"] &&
        [activityTypeName containsString:activityTypeArry[0]]) {
        dataArray = [[Singleton object] readGovernmentData:
                     @"NewTaipeiAttractionsData" attributes:
                     @"newTaipeiAttractionsData"];
    } else if([capitalRegionName containsString:@"新北市"] &&
              [activityTypeName containsString:activityTypeArry[1]]) {
        dataArray = [[Singleton object] readGovernmentData:
                     @"NewTaipeiFoodData" attributes:
                     @"newTaipeiFoodData"];
    } else if([capitalRegionName containsString:@"臺北市"] &&
              [activityTypeName containsString:activityTypeArry[0]]) {
        dataArray = [[Singleton object] readGovernmentData:
                     @"TaipeiCityAttractionsData" attributes:
                     @"taipeiCityAttractionsData"];
        keyName = nameArray[1];
        addressKeyName = addressNameArray[2];
        locationNameKeyArray = latiLongtiNameKeyArray[1];
    } else {
        if([activityTypeName containsString:activityTypeArry[0]]) {
            dataArray = [[Singleton object] readGovernmentData:
                         @"GovernmentAttractionsData" attributes:
                         @"governmentAttractionsData"];
        } else if([activityTypeName containsString:activityTypeArry[1]]) {
            dataArray = [[Singleton object] readGovernmentData:
                         @"GovernmentFoodData" attributes:
                         @"governmentFoodData"];
        } else if([activityTypeName containsString:activityTypeArry[2]]) {
            dataArray = [[Singleton object] readGovernmentData:
                         @"GovernmentLeisureFarmData" attributes:
                         @"governmentLeisureFarmData"];
            addressKeyName = addressNameArray[1];
        } else if([activityTypeName containsString:activityTypeArry[3]]) {
            dataArray = [[Singleton object] readGovernmentData:
                         @"GovernmentHotelBedAndBreakfastData" attributes:
                         @"governmentHotelBedAndBreakfastData"];
        }
    }
    if([[Singleton object].nameAddArray firstObject] == nil) {
        [self setMapRegion];
        [self addAnnotationsToMap:dataArray addressName:capitalRegionName];
    }
}

#pragma mark - Setting Data from JsonData to MapViewAnnotation 設定找出 JsonData 裏的座標資料再給予 MapViewAnntation
-(void)addAnnotationsToMap:(NSArray*)dataArray addressName:(NSString*)capitalRegionName{
    if(seletedRegionName == NULL) {
        seletedRegionName = capitalRegionName;
    }
    NSMutableArray *annotationArray = [NSMutableArray new];
    NSLog(@"%@",capitalRegionName);
    NSLog(@"%@",seletedRegionName);
    NSLog(@"%@",activityTypeName);
    for(NSDictionary *dataDictionary in dataArray) {
        NSString *address = [dataDictionary[addressKeyName] stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        if([address containsString:capitalRegionName] && [address containsString:seletedRegionName]) {
            if([addressKeyName containsString:@"Address"]) {
                NSArray *CoordinateArray = @[[dataDictionary[@"Coordinate"] componentsSeparatedByString:@","]];
                NSArray *location =CoordinateArray[0];
                if([location[0] doubleValue] != 0 && [location[1] doubleValue] != 0) {
                    double latitude = [location[0] doubleValue];
                    double longitude = [location[1] doubleValue];
                    
                    CLLocationCoordinate2D Coordinate;
                    Coordinate.latitude = latitude;
                    Coordinate.longitude = longitude;
                    
                    MKPointAnnotation *annotation = [MKPointAnnotation new];
                    annotation.coordinate = Coordinate;
                    annotation.title = dataDictionary[keyName];
                    annotation.subtitle = dataDictionary[addressKeyName];
                    [annotationArray addObject:annotation];
                    annotation = nil;
                    
                    //Zooming in on annotation
                    if([[Singleton object].nameAddArray firstObject] != nil) {
                        CLLocationCoordinate2D newcoordinate = CLLocationCoordinate2DMake(latitude, longitude);
                        MKCoordinateSpan span = MKCoordinateSpanMake(0.02, 0.02);
                        MKCoordinateRegion region = MKCoordinateRegionMake(newcoordinate, span);
                        [_MapView setRegion:region animated:true];
                    }
                }
            } else if([dataDictionary[locationNameKeyArray[0]] doubleValue] != 0 && [dataDictionary[locationNameKeyArray[1]] doubleValue] != 0) {
                double latitude = [dataDictionary[locationNameKeyArray[0]] doubleValue];
                double longitude = [dataDictionary[locationNameKeyArray[1]] doubleValue];
                
                CLLocationCoordinate2D Coordinate;
                Coordinate.latitude = latitude;
                Coordinate.longitude = longitude;
                
                MKPointAnnotation *annotation = [MKPointAnnotation new];
                annotation.coordinate = Coordinate;
                annotation.title = dataDictionary[keyName];
                NSString *address = [dataDictionary[addressKeyName]
                                     stringByReplacingOccurrencesOfString:@" " withString:@""];
                annotation.subtitle = address;
                [annotationArray addObject:annotation];
                annotation = nil;
                
                //Zooming in on annotation
                if([[Singleton object].nameAddArray firstObject] != nil) {
                    CLLocationCoordinate2D newcoordinate = CLLocationCoordinate2DMake(latitude, longitude);
                    MKCoordinateSpan span = MKCoordinateSpanMake(0.02, 0.02);
                    MKCoordinateRegion region = MKCoordinateRegionMake(newcoordinate, span);
                    [_MapView setRegion:region animated:true];
                }
            }
        }
    }
    if(annotationArray.count == 0) {
        [self showAlert];
    } else {
        [self.MapView addAnnotations:annotationArray];
        dataArray = nil;
        annotationArray = nil;
    }
}

-(void)showAlert {
    UIAlertController *printMessageControler = [UIAlertController alertControllerWithTitle:@"查無相關資訊" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *done = [UIAlertAction actionWithTitle:@"確定" style:UIAlertActionStyleDefault handler:nil];
    [printMessageControler addAction:done];
    [self presentViewController:printMessageControler animated:YES completion:nil];
}

-(void)showDetail {
    [Singleton object].nameAddArray = nameAddarray;
    nameAddarray = nil;
    DetailUITableViewController *detailTableViewControler = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailUITableViewController"];
    [self.navigationController pushViewController:detailTableViewControler animated:true];
}

-(void)annotationInformation:(CLLocation*)location {
    [[CLGeocoder new] reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if(error) {
            NSLog(@"error%@",error);
        } else {
            //CLPlacemark *placeMark = placemarks[0];
            //NSLog(@"%@",placeMark);
        }
    }];
}

-(void)showRoute:(BOOL)value {
    MKPlacemark *endPlacemark = [[MKPlacemark alloc] initWithCoordinate:coordinate];
    MKMapItem *startItem = [MKMapItem mapItemForCurrentLocation];
    MKMapItem *endItem = [[MKMapItem alloc] initWithPlacemark:endPlacemark];
    MKDirectionsRequest *request = [MKDirectionsRequest new];
    directionResponse = [MKDirectionsResponse new];
    request.source = startItem;
    request.destination = endItem;
    //選擇導航模式 例：走路、開車
    request.transportType = MKDirectionsTransportTypeWalking;
    //是否開啟多個路徑模式
    //request.requestsAlternateRoutes = true;
    NSLog(@"endPlacemark:%@",endPlacemark);
    
    MKDirections *directions  = [[MKDirections alloc] initWithRequest:request];
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse * _Nullable response, NSError * _Nullable error) {
        if(error) {
            NSLog(@"%@",error);
        } else {
            directionResponse = response;
            NSLog(@"response:%@",response);
            MKRoute *route = directionResponse.routes[0];
            CLLocationDistance distanceInMeters = route.distance;
            NSTimeInterval seconds = route.expectedTravelTime;
            int minutes = seconds/60;
            if(distanceInMeters > 1000) {
                int miles = distanceInMeters/1000;
                //NSLog(@"計算出的距離為：%d公里又%g公尺",miles,distanceInMeters-(miles*1000));
                distance = [NSString stringWithFormat:@"%d公里%g公尺",miles,distanceInMeters-(miles*1000)];
            } else {
                //NSLog(@"計算出的距離為：%g公尺",distanceInMeters);
                distance = [NSString stringWithFormat:@"%g公尺",distanceInMeters];
            }
            if(minutes > 60) {
                //int hours = minutes/60;
                //NSLog(@"花費的時間為%d小時又%d分鐘",hours,minutes-(hours*60));
            } else
                //NSLog(@"花費的時間為%d分鐘",minutes);
            for (MKRoute *route in response.routes) {
                if (!value) {
                    [self.MapView addOverlay:route.polyline level:MKOverlayLevelAboveRoads];
                    CLLocationCoordinate2D userCoordinate;
                    userCoordinate = myuserlocation.coordinate;
                    
                    NSLog(@"startItem:%f",(userCoordinate.latitude+coordinate.latitude)/2);
                    NSLog(@"endItem:%f",(userCoordinate.longitude+coordinate.longitude)/2);
                    
                    CLLocationCoordinate2D newcoordinate;
                    MKCoordinateSpan span;
                    MKCoordinateRegion region;
                    newcoordinate.latitude = (userCoordinate.latitude+coordinate.latitude)/2;
                    newcoordinate.longitude = (userCoordinate.longitude+coordinate.longitude)/2;
                    span = MKCoordinateSpanMake((fabs(userCoordinate.latitude-coordinate.latitude)*1.3),
                                                fabs(userCoordinate.longitude-coordinate.longitude)*1.3);
                    region = MKCoordinateRegionMake(newcoordinate, span);
                    [_MapView setRegion:region animated:true];
                    CLLocation *location = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
                    [self annotationInformation:location];
                }
            }
            if(value){
                UIActionSheet *myActionSheet = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"距離:%@",distance] delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"詳細資訊", nil];
                [myActionSheet showInView:self.view];
            }

        }
    }];
}

#pragma mark - Setting mapView delegate 設定 mapView 相關初始值

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    myuserlocation = userLocation;
}

-(MKAnnotationView*)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if(annotation == mapView.userLocation) {
        return nil;
    }
    if(CA_IOS_VERSION(11)) {
        MKMarkerAnnotationView * mKMarkerAnnotationViewresult;
        mKMarkerAnnotationViewresult = [MKMarkerAnnotationView new];
        mKMarkerAnnotationViewresult.annotation = annotation;
        mKMarkerAnnotationViewresult.clusteringIdentifier = @"cluster";
        UIButton *button = [UIButton buttonWithType:UIButtonTypeInfoLight];
        //[button addTarget:self action:@selector(launchOptionMap)forControlEvents:UIControlEventTouchUpInside];
        mKMarkerAnnotationViewresult.rightCalloutAccessoryView = button;
        
        if ([activityTypeName containsString:activityTypeArry[0]]) {
            mKMarkerAnnotationViewresult.tintColor = [UIColor redColor];
        } else if([activityTypeName containsString:activityTypeArry[1]]){
            mKMarkerAnnotationViewresult.markerTintColor = [UIColor orangeColor];
        } else if([activityTypeName containsString:activityTypeArry[2]]) {
            mKMarkerAnnotationViewresult.markerTintColor = [UIColor flatGreenColor];
        } else {
            mKMarkerAnnotationViewresult.markerTintColor = [UIColor flatGrayColor];
        }
        
        if (self.navigationItem.rightBarButtonItem == nil) {
            mKMarkerAnnotationViewresult.canShowCallout = false;
        } else {
            mKMarkerAnnotationViewresult.canShowCallout = true;
        }
        return mKMarkerAnnotationViewresult;
    } else {
        MKPinAnnotationView *mKPinAnnotationViewresult = [MKPinAnnotationView new];
        mKPinAnnotationViewresult.annotation = annotation;
        mKPinAnnotationViewresult.clusteringIdentifier = @"cluster";
        UIButton *button = [UIButton buttonWithType:UIButtonTypeInfoLight];
        //[button addTarget:self action:@selector(launchOptionMap)forControlEvents:UIControlEventTouchUpInside];
        mKPinAnnotationViewresult.rightCalloutAccessoryView = button;
        
        if ([activityTypeName containsString:activityTypeArry[0]]) {
            mKPinAnnotationViewresult.tintColor = [UIColor redColor];
        } else if([activityTypeName containsString:activityTypeArry[1]]){
            mKPinAnnotationViewresult.tintColor = [UIColor orangeColor];
        } else if([activityTypeName containsString:activityTypeArry[2]]) {
            mKPinAnnotationViewresult.tintColor = [UIColor flatGreenColor];
        } else {
            mKPinAnnotationViewresult.tintColor = [UIColor flatGrayColor];
        }
        
        if (self.navigationItem.rightBarButtonItem == nil) {
            mKPinAnnotationViewresult.canShowCallout = false;
        } else {
            mKPinAnnotationViewresult.canShowCallout = true;
        }
        return mKPinAnnotationViewresult;
    }
}

-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    //NSLog(@"didSelectAnnotationView:%f,%f",view.annotation.coordinate.latitude,view.annotation.coordinate.longitude);
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    if(![view.annotation.subtitle containsString:@"more"]){
        nameAddarray = [NSArray new];
        nameAddarray = @[view.annotation.subtitle,activityTypeName,view.annotation.title,@"nonShowMap"];
        
        [self.MapView removeOverlays:self.MapView.overlays];
        coordinate = CLLocationCoordinate2DMake(view.annotation.coordinate.latitude,view.annotation.coordinate.longitude);

        [self showRoute:true];
    }
}
-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolyline *route = overlay;
        MKPolylineRenderer *routeRenderer = [[MKPolylineRenderer alloc] initWithPolyline:route];
        routeRenderer.strokeColor = [UIColor blueColor];
        routeRenderer.lineWidth = 5.0;
        return routeRenderer;
    } else
        return  nil;
}

-(void)mapViewDidFailLoadingMap:(MKMapView *)mapView withError:(NSError *)error {
    NSLog(@"mapViewDidFailLoadingMap:%@",error);
}

-(void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error {
    NSLog(@"mapViewdidFailToLocateUserWithError:%@",error);
}

#pragma mark - Set UIActionSheet 設定 ActionSheet 按鈕執行動作
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
            case 0:
            //[self showRoute:false];
            [self showDetail];
            break;
            case 1:
            //[self showDetail];
            break;
            default:
            break;
    }
}

#pragma mark - Setting chooseRegionButton 設定選擇地區按鈕與 PickView 的相關初始值
- (IBAction)chooseRegion:(id)sender {
    [customPickerView.pickerViewTextField becomeFirstResponder];
    //設定到 pickView 上選擇地區的初始值
}
-(void)doneTouched {
    activityTypeName = customPickerView.activityTypeName;
    capitalRegionName = customPickerView.capitalRegionName;
    seletedRegionName = customPickerView.seletedRegionName;
    [self startReadDataFromCoreData];
    [customPickerView.pickerViewTextField resignFirstResponder];
}
-(void)cancelTouched {
    [customPickerView.pickerViewTextField resignFirstResponder];
}

-(void)didReceiveMemoryWarning {
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
