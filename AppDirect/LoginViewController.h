//
//  ViewController.h
//  fqnp
//
//  Created by 周登峰 on 7/26/16.
//  Copyright © 2016 cnpdc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AuthHelper.h"
#import "sdkheader.h"
#import "sslvpnnb.h"

#define say_log(str) printf("[log]:%s,%s,%d:%s\n",__FILE__,__FUNCTION__,__LINE__,str)
#define say_err(err) printf("[log]:%s,%s,%d:%s,%s\n",__FILE__,__FUNCTION__,__LINE__,err,get_err())
#define get_err() ssl_vpn_get_err()

@interface LoginViewController : UIViewController<SangforSDKDelegate>
{
    AuthHelper *helper;

}
- (IBAction)hideKeybord:(id)sender;
@property (retain, nonatomic) IBOutlet UITextField *textUserName;

@property (retain, nonatomic) IBOutlet UITextField *textPassword;
@property (retain, nonatomic) IBOutlet UIButton *goHome;

@property (nonatomic, retain) AuthHelper *helper;




@end
