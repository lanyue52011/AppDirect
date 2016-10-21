//
//  UserInfoController.m
//  fqnp
//
//  Created by 周登峰 on 7/27/16.
//  Copyright © 2016 cnpdc. All rights reserved.
//

#import "UserInfoController.h"
#import "CommanHeader.h"

@interface UserInfoController ()
@property(copy,nonatomic) NSArray *userInfo;
@property(strong,nonatomic) NSString *userCode;
@property (weak, nonatomic) IBOutlet UITextField *textUserName;
@property (weak, nonatomic) IBOutlet UITextField *textDXTel;
@property (weak, nonatomic) IBOutlet UITextField *textPhone;
@property (weak, nonatomic) IBOutlet UITextField *textEmail;
@property (weak, nonatomic) IBOutlet UITextField *textOfficeTel;
@property(strong,nonatomic) NSString *signState;
@property(strong,nonatomic) NSDictionary *posts;
@end

@implementation UserInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
//        self.signState=[Tools getStringByUrl:[@"/signin/signState?" stringByAppendingFormat:@"userCode=%@&loginState=%@",[Tools getLoginByCode:@"userCode"],[Tools getLoginByCode:@"loginState"]]];
    NSMutableDictionary *param=[[NSMutableDictionary alloc] init];
    param[@"userCode"]=[Tools getLoginByCode:@"userCode"];
    param[@"loginState"]=[Tools getLoginByCode:@"loginState"];
    
    NSString *fullUrl=[[Tools getBaseUrl] stringByAppendingString:@"/signin/signState"];
    
    AFHTTPSessionManager *manger=[AFHTTPSessionManager manager];
    manger.responseSerializer=[AFHTTPResponseSerializer serializer];
    [manger GET:fullUrl parameters:param progress:nil success:^(NSURLSessionDataTask *  task, id   responseObject) {
        
        NSError *err;
        NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&err];
     
        if([[dict valueForKey:@"result"] isEqualToString:@"已签到"]){
                  // signButtonTitle=@"已签到";
            self.navigationItem.leftBarButtonItem.title=@"已签到";
        }
        
    } failure:^(NSURLSessionDataTask *  task, NSError *  error) {
        //
        NSLog(@"/signin/signState网络异常");
    }];
    NSString *signButtonTitle=@"签到";
    
    UIBarButtonItem *button=[[UIBarButtonItem alloc] initWithTitle:signButtonTitle style:UIBarButtonItemStyleDone target:self action:@selector(navigationLeftButton:)];
  
    UIBarButtonItem *rbutton=[[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self  action:@selector(navigationRightButton:)];
    self.navigationItem.title=@"我";
    self.navigationItem.leftBarButtonItem=button;
    self.navigationItem.rightBarButtonItem=rbutton;
    // Do any additional setup after loading the view.
    

    
   // self.userInfo=[Tools getJsonByUrl:[@"/user/userbycode?" stringByAppendingFormat:@"userid=%@", [Tools getLoginByCode:@"userCode"] ]];
    
    param=[[NSMutableDictionary alloc] init];
    param[@"userid"]=[Tools getLoginByCode:@"userCode"];
    //param[@"loginState"]=[Tools getLoginByCode:@"loginState"];
    
   fullUrl=[[Tools getBaseUrl] stringByAppendingString:@"/user/userbycode"];
    
  AFHTTPSessionManager  *manger1=[AFHTTPSessionManager manager];
    manger1.responseSerializer=[AFHTTPResponseSerializer serializer];
    [manger1 GET:fullUrl parameters:param progress:nil success:^(NSURLSessionDataTask *  task, id   responseObject) {
        
        NSError *err;
        NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&err];
        if([dict count]==1){
        self.userInfo=[dict allValues][0];
         [self setFieldValue:NO];
        }
        
    } failure:^(NSURLSessionDataTask *  task, NSError *  error) {
        //
        NSLog(@"/user/userbycode网络异常");
    }];
}

-(void)setFieldValue:(BOOL)enable{
    
  
    self.textUserName.text=[NSString stringWithFormat:@"%@",[self.userInfo valueForKey:@"Name"]];
    self.textDXTel.text=[NSString stringWithFormat:@"%@",[self.userInfo valueForKey:@"OfficePhone"]];
    self.textPhone.text=[NSString stringWithFormat:@"%@",[self.userInfo valueForKey:@"Phone"]];
    self.textEmail.text=[NSString stringWithFormat:@"%@",[self.userInfo valueForKey:@"Email"]];
    self.textOfficeTel.text=[NSString stringWithFormat:@"%@",[self.userInfo valueForKey:@"OfficeTel"]];
    [self setFieldEnable:enable];
}

-(void)setFieldEnable:(BOOL)enable{
    
    self.textOfficeTel.enabled=enable;
    self.textUserName.enabled=enable;
    self.textDXTel.enabled=enable;
    self.textPhone.enabled=enable;
    self.textEmail.enabled=enable;
    self.textOfficeTel.enabled=enable;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)navigationLeftButton:(UIBarButtonItem *)sender{
    
    if([sender.title isEqualToString:@"签到"]){
        NSMutableDictionary *param=[[NSMutableDictionary alloc] init];
        param[@"usercode"]=[Tools getLoginByCode:@"userCode"];
       // param[@"loginState"]=[Tools getLoginByCode:@"loginState"];
        
        NSString *fullUrl=[[Tools getBaseUrl] stringByAppendingString:@"/postuser/getpostsbyusercode"];
        
        AFHTTPSessionManager *manger=[AFHTTPSessionManager manager];
        manger.responseSerializer=[AFHTTPResponseSerializer serializer];
        [manger GET:fullUrl parameters:param progress:nil success:^(NSURLSessionDataTask *  task, id   responseObject) {
            NSError *err;
            NSArray *postArr=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&err];
            if([postArr count]==1){
            //直接签到
               NSDictionary *temp=postArr[0];
                [self signByPost:[NSString stringWithFormat:@"%@",[temp valueForKey:@"PostId"]]];
            }else{
//多个岗位选择签到
                UIAlertController *alertContorl=[UIAlertController alertControllerWithTitle:@"请选择签到岗位" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
                
                NSMutableDictionary *muPost=[[NSMutableDictionary alloc]init];
              
                for (NSDictionary *item in postArr) {
                    [muPost setObject:[item valueForKey:@"PostId"] forKey:[item valueForKey:@"PostName"]];
 
                    UIAlertAction *action=[UIAlertAction  actionWithTitle:[item valueForKey:@"PostName"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [self signByPost:[self.posts valueForKey:action.title]];
                    }];
                    [alertContorl addAction:action];
                    
                }
                self.posts=muPost;
       
                [self presentViewController:alertContorl animated:YES completion:nil];
            }
            
        } failure:^(NSURLSessionDataTask *  task, NSError *  error) {
            //
            NSLog(@"网络异常");
        }];
    }
    
}


-(void)signByPost:(NSString *)postId{
    NSMutableDictionary *param=[[NSMutableDictionary alloc] init];
    param[@"postid"]=postId;
    param[@"userid"]=[Tools getLoginByCode:@"userCode"];
    param[@"loginState"]=[Tools getLoginByCode:@"loginState"];
    
    NSString *fullUrl=[[Tools getBaseUrl] stringByAppendingString:@"/signin/signinbyphone"];
    
    AFHTTPSessionManager *manger=[AFHTTPSessionManager manager];
     manger.responseSerializer=[AFHTTPResponseSerializer serializer];
    [manger GET:fullUrl parameters:param progress:nil success:^(NSURLSessionDataTask *  task, id   responseObject) {
        NSError *err;
        NSDictionary *resuDict=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&err];
        NSString *message=@"签到失败";
        if([[resuDict objectForKey:@"result"] isEqualToString:@"ok"]){
            message=@"签到成功";
            self.navigationItem.leftBarButtonItem.title=@"已签到";
        }
        [self showMessageTips:message];
        
    } failure:^(NSURLSessionDataTask *  task, NSError *  error) {
        //
        NSLog(@"网络异常");
    }];

}

- (IBAction)hideKeybord:(id)sender {
 
    [self.textDXTel resignFirstResponder];
    [self.textEmail resignFirstResponder];
    [self.textPhone resignFirstResponder];
    [self.textUserName resignFirstResponder];
    [self.textOfficeTel resignFirstResponder];
    
}

-(IBAction)navigationRightButton:(UIBarButtonItem *)sender{
    if([sender.title isEqualToString:@"保存"])
    {
      
        NSMutableArray *dict=[self.userInfo  mutableCopy];
        //保存操作
        
        [dict setValue:self.textDXTel.text forKey:@"OfficePhone"];
        [dict setValue:self.textUserName.text forKey:@"Name"];
        [dict setValue:self.textPhone.text forKey:@"Phone"];
        [dict setValue:self.textEmail.text forKey:@"Email"];
        [dict setValue:self.textOfficeTel.text forKey:@"OfficeTel"];
        self.userInfo=dict;
        
        if([self saveUserInfo]){
             sender.title=@"编辑";
            [self setFieldEnable:NO];
        };
       
    }else{
        sender.title=@"保存";
        [self setFieldEnable:YES];
    }
    
}
/**
 *  隐藏键盘
 *
 *  @param touches <#touches description#>
 *  @param event   <#event description#>
 */
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.textDXTel resignFirstResponder];
    [self.textUserName resignFirstResponder];
    [self.textPhone resignFirstResponder];
    [self.textEmail resignFirstResponder];
    [self.textOfficeTel resignFirstResponder];
}
/**
 *  保存用户信息
 *
 *  @return <#return value description#>
 */
-(BOOL)saveUserInfo
{
    NSString *pathUrl=@"/user/save?";
    NSDictionary *dict=(NSDictionary *)self.userInfo;
    for (NSString *key in [dict allKeys]) {
        NSString *value=[dict valueForKey:key];
        if([value isEqual:nil]||[value isEqual:[NSNull null]]){
            value=@"";
        }
        pathUrl=[pathUrl stringByAppendingFormat:@"&%@=%@",key,value];
    }
    NSString *res=[Tools submitByGet:pathUrl];
    //提示操作
    NSString *message=@"保存失败";
    if([res isEqualToString:@"1"]){
        message=@"保存成功";
    }
    
    //保存提示
    [self showMessageTips:message];

    return [res isEqualToString:@"1"];
}


@end
