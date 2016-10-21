//
//  InventoryDetail1Controller.h
//  fqnp
//
//  Created by 周登峰 on 8/3/16.
//  Copyright © 2016 cnpdc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class InventoryController;
@interface InventoryDetailController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *textArrive;
@property (weak, nonatomic) IBOutlet UITextField *textAbsent;
@property (weak, nonatomic) IBOutlet UITextField *textOffset;
- (IBAction)btnSave:(UIButton *)sender;
@property(strong,nonatomic) NSDictionary *gather;
@property(weak,nonatomic) InventoryController *inventory;
- (IBAction)hideKeybord:(id)sender;
@end
