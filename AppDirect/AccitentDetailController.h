//
//  AccitentDetailController.h
//  fqnp
//
//  Created by 周登峰 on 8/3/16.
//  Copyright © 2016 cnpdc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AccidentController;
@class AbstractActionSheetPicker;
@interface AccitentDetailController : UIViewController
@property(strong,nonatomic) NSDictionary *event;
@property(weak,nonatomic) AccidentController *accidentController;
- (IBAction)selectEventLevel:(UITextField *)sender;
- (IBAction)selectCurrentTime:(UITextField *)sender;
- (IBAction)btnSave:(UIButton *)sender;
@property (nonatomic, strong) AbstractActionSheetPicker *actionSheetPicker;

- (IBAction)btnSelectPicture:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UITextField *textSelectDate;
@property (weak, nonatomic) IBOutlet UITextField *textName;

@property(weak,nonatomic) IBOutlet UITextField *textLevel;
@property(weak,nonatomic) IBOutlet UITextView *textContent;
@property (weak, nonatomic) IBOutlet UITextField *textCurrentDate;
- (IBAction)hideKeybord:(id)sender;

@end
