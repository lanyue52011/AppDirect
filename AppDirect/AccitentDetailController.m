//
//  AccitentDetailController.m
//  fqnp
//
//  Created by 周登峰 on 8/3/16.
//  Copyright © 2016 cnpdc. All rights reserved.
//

#import "AccitentDetailController.h"
#import "AccidentController.h"
#import "ActionSheetPicker.h"
#import "NSDate+TCUtils.h"
#import "UIKit+AFNetworking/UIImageView+AFNetworking.h"
#import "CommanHeader.h"
@interface AccitentDetailController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property(strong,nonatomic) UIImage *selectImage;
@property(strong,nonatomic) NSDictionary *level;
@end

@implementation AccitentDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *title=[self.event objectForKey:@"Name"];
    if(!title){
        title=@"新增事故";
    }
    self.navigationItem.title=title;
    
    self.level= [NSMutableDictionary dictionaryWithObjects:@[@"U",@"A",@"S",@"G"] forKeys:@[@"应急待命",@"厂房应急",@"场区应急",@"场外应急"]];
    if(self.event){
        [self initData];
    }
    
}

-(void)initData{
    if(self.event){
        self.textCurrentDate.text=[self.event objectForKey:@"CurrentTime"];
        NSString *levelName=[self.event objectForKey:@"Level"];
        if(levelName){
            for (id item in self.level) {
              //  [self.level k]
                if([self.level valueForKey:item]==levelName){
                    self.textLevel.text=item;
                }
            }
        }
       
        self.textName.text=[self.event objectForKey:@"Name"];
        self.textContent.text=[self.event objectForKey:@"Content"];
        NSString *imgUrl=[self.event objectForKey:@"FileName"];
        if(imgUrl){
        NSString *fullImageUrl=[NSString stringWithFormat:@"%@%@",[Tools getBaseUrl],imgUrl];
       
        NSURL *url=[NSURL URLWithString:fullImageUrl];
        [self.imageView setImageWithURL:url];
        }else{
            self.imageView.hidden=YES;
        }
        //[self imageView ]
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
  
    // Dispose of any resources that can be recreated.
}

//#pragma mark - 上传图片
- (void)uploadImageWithImage{
    //截取图片
   // NSData *imageData = UIImageJPEGRepresentation(image, 0.001);
    NSData *imageData= UIImagePNGRepresentation(self.selectImage);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
     manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    // 参数
    NSMutableDictionary *param=[[NSMutableDictionary alloc] init];
    param[@"name"]=self.textName.text;
    param[@"content"]=self.textContent.text;
    param[@"level"]=[self.level valueForKey:self.textLevel.text];
    param[@"currenttime"]=self.textCurrentDate.text;
    param[@"loginstate"]=[Tools getLoginByCode:@"loginState"];
    
    // 访问路径
    //NSString *stringURL =
    NSString *fullUrl=[[Tools getBaseUrl] stringByAppendingString:@"/mobile/apisaveaccident"];
    
    [manager POST:fullUrl parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        // 上传文件
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat            = @"yyyyMMddHHmmss";
        NSString *str                         = [formatter stringFromDate:[NSDate date]];
        NSString *fileName               = [NSString stringWithFormat:@"%@.png", str];
        
        [formData appendPartWithFileData:imageData name:@"photos" fileName:fileName mimeType:@"image/png"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSError *err;
        NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&err];
        
        NSString *res=[dict objectForKey:@"result"];
        
        //提示操作
        NSString *message=@"保存失败";
        if([res isEqualToString:@"ok"]){
            message=@"保存成功";
        }
        [self showMessageTips:message];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //DLog(@"上传失败")
    }];
}



- (IBAction)selectEventLevel:(UITextField *)sender {
    
    ActionStringDoneBlock done = ^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        NSLog(@"Block picker sucess: selectedValue = %@", selectedValue);
        if ([sender respondsToSelector:@selector(setText:)]) {
            [sender performSelector:@selector(setText:) withObject:selectedValue];
        }
    };
    ActionStringCancelBlock cancel = ^(ActionSheetStringPicker *picker) {
    
        NSLog(@"Block Picker Canceled");
    };
    NSArray *events = [self.level allKeys];
    ActionSheetStringPicker* picker = [[ActionSheetStringPicker alloc] initWithTitle:@"选择事故等级" rows:events initialSelection:0 doneBlock:done cancelBlock:cancel origin:sender];
    picker.tapDismissAction = TapActionCancel;
    [picker showActionSheetPicker];
    
}

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
    self.textCurrentDate.text=[format stringFromDate:selectedDate];
    //NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    formatter.dateFormat            = @"yyyyMMddHHmmss";
//    NSString *str                         = [formatter stringFromDate:[NSDate date]];
//    //may have originated from textField or barButtonItem, use an IBOutlet instead of element
//    self.textCurrentDate.text = [self.selectedDate description];
}


-(void)pickMediaForSource:(UIImagePickerControllerSourceType)sourceType{
    NSArray *mediaTypes=[UIImagePickerController availableMediaTypesForSourceType:sourceType];
    if([UIImagePickerController isSourceTypeAvailable:sourceType]&& [mediaTypes count] > 0){
        UIImagePickerController *picker=[[UIImagePickerController alloc]init];
        picker.mediaTypes=mediaTypes;
        picker.delegate=self;
        picker.allowsEditing=YES;
        picker.videoQuality=UIImagePickerControllerQualityTypeLow;//相片质量
        picker.sourceType=sourceType;
        [self presentViewController:picker animated:YES completion:NULL];
    }else{
        UIAlertController *alertController=[UIAlertController alertControllerWithTitle:@"error accessing media" message:@"unsupported media source." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction=[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (IBAction)btnSave:(UIButton *)sender {
    [self uploadImageWithImage];
}
- (IBAction)btnSelectPicture:(id)sender {
    //UIImagePickerControllerSourceTypeCamera 拍照或视频
    [self pickMediaForSource:UIImagePickerControllerSourceTypePhotoLibrary];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
   // self.lastChosenMediaType=info[UIImagePickerControllerMediaType];
   // if([self.lastChosenMediaType isEqual:(NSString *)kUTTypeImage]){
    //dispatch_async(dispatch_get_main_queue(), ^{
        self.selectImage=info[UIImagePickerControllerOriginalImage];
    
    //});
   
   // }else if([self.lastChosenMediaType isEqual:(NSString *)kUTTypeMovie]){
       // self.moveUrl=info[UIImagePickerControllerMediaURL];
    //}
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)displayImage{
    if(self.selectImage){
        self.imageView.hidden=NO;
        self.imageView.image=self.selectImage;
        
    }
}
-(void)viewDidAppear:(BOOL)animated{
    [self displayImage];
}
- (IBAction)hideKeybord:(id)sender {
    [self.textName resignFirstResponder];
    [self.textLevel resignFirstResponder];
    [self.textContent resignFirstResponder];
    //[self.textSelectDate resignFirstResponder];
    [self.textCurrentDate resignFirstResponder];
}
@end
