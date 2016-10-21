//
//  TaskListController.h
//  fqnp
//
//  Created by 周登峰 on 7/26/16.
//  Copyright © 2016 cnpdc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AFHTTPSessionManager;

@interface TaskListController : UITableViewController
@property(copy,nonatomic) NSMutableString *taskUrl;
@property(copy,nonatomic) NSArray *taskList;
@property(strong,nonatomic) AFHTTPSessionManager *manger;
@end
