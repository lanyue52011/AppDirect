//
//  MonitorDetailController.m
//  FQNPApp
//
//  Created by 周登峰 on 8/15/16.
//  Copyright © 2016 cnpdc. All rights reserved.
//

#import "MonitorDetailController.h"
#import "ActionSheetPicker.h"
#import "NSDate+TCUtils.h"
#import <MapKit/MapKit.h>
#import "CommanHeader.h"

@interface MonitorDetailController ()

@end

static  NSString *kPointName=@"PointName";
static  NSString *kDirection=@"Direction";
static  NSString *kLong=@"Long";
static  NSString *kYJLL=@"YJLL";
static  NSString *kDMWR=@"DMWR";
static  NSString *kQD=@"QD";
static  NSString *kQRJ=@"QRJ";
static  NSString *kBatchName=@"BatchName";
static  NSString *kCurrentTime=@"CurrentTime";
static  NSString *kMemo=@"Memo";

@implementation MonitorDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    if(self.monitor){
        [self initData];
    }
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initData{
    self.textStart.text=@"福清核电厂";
    
    self.textPointName.text=[self getValue:kPointName];

    
    self.textDirection.text=[self getValue:kDirection];
    self.textLong.text=[self getValue:kLong];
    self.textYJLL.text=[self getValue:kYJLL];
    self.textDMWR.text=[self getValue:kDMWR];
    self.textQD.text=[self getValue:kQD];
    self.textQRJ.text=[self getValue:kQRJ];
    
    self.textBatchName.text=[self getValue:kBatchName];
    
    self.textCurrentTime.text=[Tools stringToDateTIme:[self getValue:kCurrentTime]];
    
    self.textMemo.text=[self getValue:kMemo];
}

-(NSString *)getValue:(NSString *)key{
    NSString *v=  [self.monitor objectForKey:key];
    if([v isEqual:[NSNull null]]){
        return @"";
    }
    return v;
    
}

/**
 *  选择相对位置，默认福清核电
 *
 *  @param sender <#sender description#>
 */
- (IBAction)selectStartPosition:(UITextField *)sender {
    
    ActionStringDoneBlock done = ^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        NSLog(@"Block picker sucess: selectedValue = %@", selectedValue);
        if ([sender respondsToSelector:@selector(setText:)]) {
            [sender performSelector:@selector(setText:) withObject:selectedValue];
              [self positionChanged:nil];
        }
    };
    ActionStringCancelBlock cancel = ^(ActionSheetStringPicker *picker) {
        
        NSLog(@"Block Picker Canceled");
    };
    NSArray *startPosition = [self.station valueForKey:@"Name"];
    if([sender.text length]<1&&[startPosition count]>0){
        sender.text=startPosition[0];
    }
    ActionSheetStringPicker* picker = [[ActionSheetStringPicker alloc] initWithTitle:@"选择相对位置" rows:startPosition initialSelection:0 doneBlock:done cancelBlock:cancel origin:sender];
    picker.tapDismissAction = TapActionCancel;
    [picker showActionSheetPicker];
}

- (IBAction)selectEndPosition:(UITextField *)sender {
    ActionStringDoneBlock done = ^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        NSLog(@"Block picker sucess: selectedValue = %@", selectedValue);
        if ([sender respondsToSelector:@selector(setText:)]) {
            [sender performSelector:@selector(setText:) withObject:selectedValue];
             [self positionChanged:nil];
        }
    };
    ActionStringCancelBlock cancel = ^(ActionSheetStringPicker *picker) {
        
        NSLog(@"Block Picker Canceled");
    };
    NSArray *pointNames = [self.points valueForKey:@"Name"];
    if([sender.text length]<1&&[pointNames count]>0){
        sender.text=pointNames[0];
    }
    ActionSheetStringPicker* picker = [[ActionSheetStringPicker alloc] initWithTitle:@"选择点位" rows:pointNames initialSelection:0 doneBlock:done cancelBlock:cancel origin:sender];
    picker.tapDismissAction = TapActionCancel;
    [picker showActionSheetPicker];
    
}
/**
 *  点位变化计算距离
 *
 *  @param sender <#sender description#>
 */
- (IBAction)positionChanged:(UITextField *)sender {
    
    NSString *startName=  self.textStart.text;
    double long1=0,lat1=0,long2=0,lat2=0;
    if([startName length]>0){
    for (NSDictionary *item in self.station) {
        if([[item objectForKey:@"Name"] isEqual:startName]){
            long1=[[item objectForKey:@"Longitude"] doubleValue];
            lat1=[[item objectForKey:@"Longitude"] doubleValue];
        }
    }
    }
    
    NSString *pointName=self.textPointName.text;
    if([pointName length]>0){
        for (NSDictionary *entiry in self.points) {
            if([[entiry objectForKey:@"Name"] isEqual: pointName]){
                long2=[[entiry objectForKey:@"Longitude"] doubleValue];
                lat2=[[entiry objectForKey:@"Longitude"] doubleValue];
            }
        }
    }
    if(long1!=0&&lat1!=0&&long2!=0&&lat2!=0){
        
        self.textLong.text=[Tools distance:long1 y1:lat1 x2:long2 y2:lat2];
        self.textDirection.text=[Tools direction:long1 y1:lat1 x2:long2 y2:lat2];
    }
    
}
/**
 *  选择批次
 *
 *  @param sender <#sender description#>
 */
- (IBAction)selectBatchName:(UITextField *)sender {
    
    
//    ActionStringDoneBlock done = ^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
//        NSLog(@"Block picker sucess: selectedValue = %@", selectedValue);
//        if ([sender respondsToSelector:@selector(setText:)]) {
//            [sender performSelector:@selector(setText:) withObject:selectedValue];
//        }
//    };
//    ActionStringCancelBlock cancel = ^(ActionSheetStringPicker *picker) {
//        
//        NSLog(@"Block Picker Canceled");
//    };
//   
//    ActionSheetStringPicker* picker = [[ActionSheetStringPicker alloc] initWithTitle:@"选择批次" rows:self.batchNames initialSelection:0 doneBlock:done cancelBlock:cancel origin:sender];
//    picker.tapDismissAction = TapActionCancel;
//    [picker showActionSheetPicker];
    
}
/**
 *  选择时间
 *
 *  @param sender <#sender description#>
 */
- (IBAction)selectCurrentTime:(UIControl *)sender {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *minimumDateComponents = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    [minimumDateComponents setYear:2000];
    NSDate *minDate = [calendar dateFromComponents:minimumDateComponents];
    NSDate *maxDate = [NSDate date];
    
    
    _actionSheetPicker = [[ActionSheetDatePicker alloc] initWithTitle:@"" datePickerMode:UIDatePickerModeDate selectedDate:[NSDate date]
                                                               target:self action:@selector(dateWasSelected:element:) origin:sender];
    
    
    [(ActionSheetDatePicker *) self.actionSheetPicker setMinimumDate:minDate];
    [(ActionSheetDatePicker *) self.actionSheetPicker setMaximumDate:maxDate];
    
    [self.actionSheetPicker addCustomButtonWithTitle:@"Today" value:[NSDate date]];
    [self.actionSheetPicker addCustomButtonWithTitle:@"Yesterday" value:[[NSDate date] TC_dateByAddingCalendarUnits:NSCalendarUnitDay amount:-1]];
    self.actionSheetPicker.hideCancel = YES;
    [self.actionSheetPicker showActionSheetPicker];
}
- (void)dateWasSelected:(NSDate *)selectedDate element:(id)element {
    // self.selectedDate = selectedDate;
    
    NSDateFormatter *format=[[NSDateFormatter alloc]init];
    format.dateFormat=@"yyyy-MM-dd HH:mm:ss";
    self.textCurrentTime.text=[format stringFromDate:selectedDate];

}

-(void)saveData{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    // 参数
    NSMutableDictionary *param=[[NSMutableDictionary alloc] init];
    param[kPointName]=self.textPointName.text;
    param[kDirection]=self.textDirection.text;
    param[kLong]=self.textLong.text;
    param[kYJLL]=self.textYJLL.text;
    param[kDMWR]=self.textDMWR.text;
    param[kQD]=self.textQD.text;
    param[kQRJ]=self.textQRJ.text;
    param[kBatchName]=self.textBatchName.text;
    param[kCurrentTime]=self.textCurrentTime.text;
    param[kMemo]=self.textMemo.text;
    param[@"loginstate"]=[Tools getLoginByCode:@"loginState"];
    param[@"Userid"]=[Tools getLoginByCode:@"userCode"];
    
    // 访问路径
    //NSString *stringURL =
    NSString *fullUrl=[[Tools getBaseUrl] stringByAppendingString:@"/mobile/apisaveMonitor"];
    
    [manager GET:fullUrl parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSError *err;
        NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&err];
        
        NSString *res=[dict objectForKey:@"result"];
        
        //提示操作
        NSString *message=@"保存失败";
        if([res isEqualToString:@"ok"]){
            message=@"保存成功";
        }
        [self showMessageTips:message];
        //[self pre]
        NSLog(@"保存成功！");
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSLog(@"保存失败！");
    }];
}


/**
 *  点击非文本框隐藏键盘
 *
 *  @param sender <#sender description#>
 */
- (IBAction)hideKeybord:(id)sender {
    
    [self.textStart resignFirstResponder];
    
    [self.textPointName resignFirstResponder];
    
    [self.textDirection resignFirstResponder];
    
    [self.textLong resignFirstResponder];
    
    [self.textYJLL resignFirstResponder];
    
    [self.textDMWR resignFirstResponder];
    
    [self.textQD resignFirstResponder];
    
    [self.textQRJ resignFirstResponder];
    
    [self.textBatchName resignFirstResponder];
    
    [self.textCurrentTime resignFirstResponder];
    
    [self.textMemo resignFirstResponder];
}

- (IBAction)saveData:(UIButton *)sender {
    [self saveData];
}
@end
