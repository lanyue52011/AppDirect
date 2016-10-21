//
//  InventoryDetail1Controller.m
//  fqnp
//
//  Created by 周登峰 on 8/3/16.
//  Copyright © 2016 cnpdc. All rights reserved.
//

#import "InventoryDetailController.h"
#import "InventoryController.h"
#import "CommanHeader.h"

@interface InventoryDetailController ()

@end

@implementation InventoryDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textArrive.text=[NSString stringWithFormat:@"%@",[self.gather valueForKey:@"Arrive"]];
    self.textAbsent.text=[NSString stringWithFormat:@"%@",[self.gather valueForKey:@"Absent"]];
    self.textOffset.text=[NSString stringWithFormat:@"%@",[self.gather valueForKey:@"Offset"]];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)btnSave:(UIButton *)sender {
    NSMutableDictionary *temp=[self.gather mutableCopy];
    
    [temp setValue: self.textArrive.text forKey:@"Arrive"];
    [temp setValue:self.textAbsent.text forKey:@"Absent"];
    [temp setValue:self.textOffset.text forKey:@"Offset"];
    self.gather=temp;
    [self save];
}


-(void)save
{
   // [self hide];
    NSMutableDictionary *param=[[NSMutableDictionary alloc] init];
    param[@"name"]=[self.gather valueForKey:@"Name"];
    param[@"total"]=[self.gather valueForKey:@"Total"];
    param[@"arrive"]=[self.gather valueForKey:@"Arrive"];
    param[@"offset"]=[self.gather valueForKey:@"Offset"];
    param[@"absent"]=[self.gather valueForKey:@"Absent"];
    param[@"loginstate"]=[Tools getLoginByCode:@"loginState"];
    
    
    NSString *fullUrl=[[Tools getBaseUrl] stringByAppendingString:@"/mobile/apisavegather"];
    AFHTTPSessionManager *manger=[AFHTTPSessionManager manager];
    manger.responseSerializer=[AFHTTPResponseSerializer serializer];
    
    [manger GET:fullUrl parameters:param progress:nil success:^(NSURLSessionDataTask *  task, id  responseObject) {
        NSError *err;
        NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&err];
        
        NSString *res=[dict objectForKey:@"result"];
        
        //提示操作
        NSString *message=@"保存失败";
        if([res isEqualToString:@"ok"]){
            message=@"保存成功";
        }
        [self.inventory  refreshTableView];
        
         [self showMessageTips:message];

        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //
        NSLog(@"网络异常");
        [self showFailureTips:@"网络异常"];
    }];
    
}



-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
   
}

- (IBAction)hideKeybord:(id)sender {
    
    [self.textOffset resignFirstResponder];
    [self.textAbsent resignFirstResponder];
    [self.textArrive resignFirstResponder];
}
@end
