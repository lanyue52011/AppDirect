//
//  MonitorDetailController.h
//  FQNPApp
//
//  Created by 周登峰 on 8/15/16.
//  Copyright © 2016 cnpdc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AbstractActionSheetPicker;
@interface MonitorDetailController : UIViewController
@property(copy,nonatomic) NSArray *station;
@property(copy,nonatomic) NSArray *points;

@property(copy,nonatomic) NSArray *batchNames;

@property(strong,nonatomic) NSDictionary *monitor;


//@property(weak,nonatomic) IBOutlet
@property (weak, nonatomic) IBOutlet UITextField *textStart;

@property (weak, nonatomic) IBOutlet UITextField *textPointName;

@property (weak, nonatomic) IBOutlet UITextField *textDirection;

@property (weak, nonatomic) IBOutlet UITextField *textLong;

@property (weak, nonatomic) IBOutlet UITextField *textYJLL;

@property (weak, nonatomic) IBOutlet UITextField *textDMWR;

@property (weak, nonatomic) IBOutlet UITextField *textQD;

@property (weak, nonatomic) IBOutlet UITextField *textQRJ;

@property (weak, nonatomic) IBOutlet UITextField *textBatchName;

@property (weak, nonatomic) IBOutlet UITextField *textCurrentTime;

@property (weak, nonatomic) IBOutlet UITextField *textMemo;

- (IBAction)selectStartPosition:(UITextField *)sender;
- (IBAction)selectEndPosition:(UITextField *)sender;

- (IBAction)positionChanged:(UITextField *)sender;
- (IBAction)selectBatchName:(UITextField *)sender;
- (IBAction)selectCurrentTime:(UIControl *)sender;
- (IBAction)hideKeybord:(id)sender;
- (IBAction)saveData:(UIButton *)sender;

@property (nonatomic, strong) AbstractActionSheetPicker *actionSheetPicker;
@end
