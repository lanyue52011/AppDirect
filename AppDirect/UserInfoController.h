//
//  UserInfoController.h
//  fqnp
//
//  Created by 周登峰 on 7/27/16.
//  Copyright © 2016 cnpdc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserInfoController : UIViewController
-(IBAction)navigationLeftButton:(UIBarButtonItem *)sender;
-(IBAction)navigationRightButton:(UIBarButtonItem *)sender;
//@property(copy,nonatomic) NSString *postId;

-(void)signByPost:(NSString *)postId;
- (IBAction)hideKeybord:(id)sender;
@end
