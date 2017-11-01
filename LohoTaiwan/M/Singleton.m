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
    NSArray *result;
    NSArray *dataArray;
    NSFetchRequest *fetchRequest;
    NSManagedObjectContext *managedObjectContext;
}

- (id)init {
    self = [super init];
    if(self) {
        AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        managedObjectContext = appDelegate.persistentContainer.viewContext;
        
        self.activityTypeArray = @[@"景點",@"餐飲",@"休閒農場",@"民宿旅館"];
        
        self.capitalNameArray =@[@"臺北市",@"新北市",@"宜蘭縣",@"桃園市",@"臺中市",@"基隆市",@"花蓮縣",@"新竹市",
                                              @"苗栗縣",@"彰化縣",@"南投縣",@"嘉義市",@"臺東縣",@"臺南市",@"高雄市",@"屏東縣"];
        
        self.regionNameArray =  @[
                                  @"taipeiRegionArray",@"NewTaipeiRegionArray",@"iIanRegionArray",@"taoyuanRegionArray",
                                  @"taichungRegionArray",@"keelungRegionArray",@"hualienRegionArray",@"hsinchuRegionArray"
                                  ,@"miaoliRegionArray",@"changhuaRegionArray",@"nantouRegionArray",@"chiayiRegionArray",
                                  @"taitungRegionArray",@"tainanRegionArray",@"kaohsiungRegionArray",@"pingtungRegionArray"];
        
        self.taipeiRegionArray =@[
                                  @"中正區",@"大同區",@"中山區",@"松山區",@"大安區",@"萬安區",
                                  @"信義區",@"士林區",@"北投區",@"內湖區",@"南港區",@"文山區"];
        
        self.NewTaipeiRegionArray =@[
          @"板橋區",@"新莊區",@"中和區",@"永和區",@"土城區",@"樹林區",@"三峽區",
          @"鶯歌區",@"三重區",@"蘆洲區",@"五股區",@"泰山區",@"林口區",@"八里區",
          @"淡水區",@"三芝區",@"石門區",@"金山區",@"萬里區",@"汐止區",@"瑞芳區",
          @"貢寮區",@"平溪區",@"雙溪區",@"新店區",@"深坑區",@"石碇區",@"坪林區",@"烏來區"];
        
        self.iIanRegionArray = @[@"頭城鎮",@"礁溪鄉",@"壯圍鄉",@"員山鄉",@"羅東鎮",
                                 @"蘇澳鎮",@"五結鄉",@"三星鄉",@"冬山鄉",@"大同鄉",@"南澳鄉"];
        
        self.taoyuanRegionArray = @[
                                    @"桃園區",@"龜山區",@"八德區",@"大溪區",@"蘆竹區",@"大園區",
                                    @"中壢區",@"龍潭區",@"平鎮區",@"楊梅區",@"新屋區",@"觀音區",@"復興區"];
        
        self.taichungRegionArray = @[@"中區",@"東區",@"南區",@"西區",@"北區",@"北屯區",
                                     @"西屯區",@"南屯區",@"太平區",@"大里區",@"霧峰區",@"烏日區",
                                     @"豐原區",@"后里區",@"石岡區",@"東勢區",@"新社區",@"潭子區",
                                     @"大雅區",@"神岡區",@"大肚區",@"沙鹿區",@"龍井區",@"梧棲區",
                                     @"清水區",@"大甲區",@"外埔區",@"大安區",@"和平區"];
        
        self.keelungRegionArray = @[@"仁愛區",@"中正區",@"信義區",@"中山區",@"安樂區",@"暖暖區",@"七堵區"];
        
        self.hualienRegionArray = @[
                                    @"鳳林鎮",@"玉里鎮",@"新城鄉",@"吉安鄉",@"壽豐鄉",@"光復鄉",
                                    @"豐濱鄉",@"瑞穗鄉",@"富里鄉",@"秀林鄉",@"萬榮鄉",@"卓溪鄉"];
        
        self.hsinchuRegionArray = @[@"東區",@"北區",@"香山區"];
        
        self.miaoliRegionArray = @[@"頭份市",@"竹南鎮",@"後龍鎮",@"通霄鎮",@"苑裡鎮",
                                   @"卓蘭鎮",@"造橋鄉",@"西湖鄉",@"頭屋鄉",@"公館鄉",@"銅鑼鄉",
                                   @"三義鄉",@"大湖鄉",@"獅潭鄉",@"三灣鄉",@"南庄鄉",@"泰安鄉"];
        
        self.changhuaRegionArray = @[
                                     @"員林市",@"和美鎮",@"鹿港鎮",@"溪湖鎮",@"二林鎮",@"田中鎮",
                                     @"北斗鎮",@"花壇鄉",@"芬園鄉",@"大村鄉",@"永靖鄉",@"伸港鄉",
                                     @"線西鄉",@"福興鄉",@"秀水鄉",@"埔鹽鄉",@"大城鄉",@"芳苑鄉",
                                     @"竹塘鄉",@"社頭鄉",@"二水鄉",@"田尾鄉",@"埤頭鄉",@"溪州鄉"];
        
        self.nantouRegionArray = @[
                                   @"埔里鎮",@"草屯鎮",@"竹山鎮",@"集集鎮",@"名間鄉",@"鹿谷鄉",
                                   @"中寮鄉",@"魚池鄉",@"國姓鄉",@"水里鄉",@"信義鄉",@"仁愛鄉"];
        
        self.chiayiRegionArray = @[@"東區",@"西區"];
        
        self.taitungRegionArray = @[
                                    @"成功鎮",@"關山鎮",@"長濱鄉",@"池上鄉",@"東河鄉",
                                    @"鹿野鄉",@"卑南鄉",@"大武鄉",@"綠島鄉",@"太麻里鄉",
                                    @"海端鄉",@"延平鄉",@"金峰鄉",@"達仁鄉",@"蘭嶼鄉"];
        
        self.tainanRegionArray = @[
                                   @"中西區",@"東區",@"南區",@"北區",@"安平區",@"安南區",@"永康區",@"歸仁區",@"新化區",
                                   @"左鎮區",@"玉井區",@"楠西區",@"南化區",@"仁德區",@"關廟區",@"龍崎區",@"官田區",@"麻豆區",
                                   @"佳里區",@"西港區",@"七股區",@"將軍區",@"學甲區",@"北門區",@"新營區",@"後壁區",@"白河區",
                                   @"東山區",@"六甲區",@"下營區",@"柳營區",@"鹽水區",@"善化區",@"大內區",@"山上區",@"新市區",
                                   @"安定區"];
        
        self.kaohsiungRegionArray = @[
                                      @"楠梓區",@"左營區",@"鼓山區",@"三民區",@"鹽埕區",@"前金區",@"新興區",@"苓雅區",@"前鎮區",
                                      @"旗津區",@"小港區",@"鳳山區",@"大寮區",@"鳥松區",@"林園區",@"仁武區",@"大樹區",@"大社區",
                                      @"岡山區",@"路竹區",@"橋頭區",@"梓官區",@"彌陀區",@"永安區",@"燕巢區",@"田寮區",@"阿蓮區",
                                      @"茄萣區",@"湖內區",@"旗山區",@"美濃區",@"內門區",@"杉林區",@"甲仙區",@"六龜區",@"茂林區",
                                      @"桃源區",@"那瑪夏區",];
        
        self.pingtungRegionArray = @[
                                     @"潮州鎮",@"東港鎮",@"恆春鎮",@"萬丹鄉",@"崁頂鄉",@"新園鄉",@"林邊鄉",@"南州鄉",@"琉球鄉",
                                     @"枋寮鄉",@"枋山鄉",@"車城鄉",@"滿州鄉",@"高樹鄉",@"九如鄉",@"鹽埔鄉",@"里港鄉",@"內埔鄉",
                                     @"竹田鄉",@"長治鄉",@"麟洛鄉",@"萬巒鄉",@"新埤鄉",@"佳冬鄉",@"霧台鄉",@"泰武鄉",@"瑪家鄉",
                                     @"來義鄉",@"春日鄉",@"獅子鄉",@"牡丹鄉",@"三地門鄉"];
        
        
        

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

-(NSArray*)readGovernmentData:(NSString*)entities attributes:(NSString*)attribute {
    NSError *error;
    fetchRequest = [[NSFetchRequest alloc] initWithEntityName:entities];
    result = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if([result valueForKey:attribute] != nil) {
        NSArray *governmentAttractionsData = [result valueForKey:attribute];
        
        if(governmentAttractionsData.count != 0) {
            
            if([entities isEqualToString:@"GovernmentLeisureFarmData"] ||
               [entities containsString:@"NewTaipei"]) {
                dataArray = governmentAttractionsData[0];
                
            } else if([entities containsString:@"TaipeiCity"]){
                NSDictionary *array = governmentAttractionsData[0];
                NSArray *resultsArray = array[@"result"][@"results"];
                dataArray = resultsArray;
                
            } else {
                NSDictionary *governmentAttractionsDataArray = governmentAttractionsData[0];
                NSDictionary *InfosArray = governmentAttractionsDataArray[@"XML_Head"][@"Infos"];
                dataArray = InfosArray[@"Info"];
            }
        }
    }
    return dataArray;
}

-(void)readGovernmentData:(NSString*)entities attributes:(NSString*)attribute block:(PassValueBlock)array {
    NSError *error;
    fetchRequest = [[NSFetchRequest alloc] initWithEntityName:entities];
    result = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if([result valueForKey:attribute] != nil) {
        NSArray *governmentAttractionsData = [result valueForKey:attribute];
        
        if(governmentAttractionsData.count != 0) {
            
            if([entities isEqualToString:@"GovernmentLeisureFarmData"] ||
               [entities containsString:@"NewTaipei"]) {
                dataArray = governmentAttractionsData[0];
                
            } else if([entities containsString:@"TaipeiCity"]){
                NSDictionary *array = governmentAttractionsData[0];
                NSArray *resultsArray = array[@"result"][@"results"];
                dataArray = resultsArray;
                
            } else {
                NSDictionary *governmentAttractionsDataArray = governmentAttractionsData[0];
                NSDictionary *InfosArray = governmentAttractionsDataArray[@"XML_Head"][@"Infos"];
                dataArray = InfosArray[@"Info"];
            }
        }
    }
    if (array) {
        array(dataArray);
    }
}

@end
