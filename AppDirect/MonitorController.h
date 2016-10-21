//
//  MonitorController.h
//  fqnp
//
//  Created by 周登峰 on 7/27/16.
//  Copyright © 2016 cnpdc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MonitorController : UITableViewController

@property(strong,nonatomic) NSArray *station;

@property(strong,nonatomic) NSArray *points;

@property(strong,nonatomic) NSArray *monitorKeys;

@property(strong,nonatomic) NSArray *monitors;
@end
