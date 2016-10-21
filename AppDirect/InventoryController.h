//
//  InventoryController.h
//  fqnp
//
//  Created by 周登峰 on 7/27/16.
//  Copyright © 2016 cnpdc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InventoryController : UITableViewController
@property(strong,nonatomic) NSMutableArray *gathers;
-(void)refreshTableView;
@end
