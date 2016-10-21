//
//  TaskTypeListController.m
//  fqnp
//
//  Created by 周登峰 on 7/26/16.
//  Copyright © 2016 cnpdc. All rights reserved.
//

#import "TaskTypeListController.h"
#import "TaskListController.h"
#import "UIImage+Extension.h"
#import <QuartzCore/CALayer.h>

@interface TaskTypeListController ()
@property(strong,nonatomic) NSArray *taskType;
@end

@implementation TaskTypeListController

- (void)viewDidLoad {
    [super viewDidLoad];
       
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    //[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];

    //self.tableView.rowHeight = UITableViewAutomaticDimension;
    //self.tableView.estimatedRowHeight = 100.0;
    
   
   NSArray *taskDict=  @[@{@"Name":@"待办任务",@"url":@"/ETask/apitask?sysName=NEMS" ,@"img":@"task.png"},
      @{@"Name":@"已办任务",@"url":@"/ETask/apifinishtask?sysName=NEMS",@"img":@"finished.png"},
      @{@"Name":@"待阅任务",@"url":@"ETask/apireadlist?sysName=NEMS&isread=false",@"img":@"read.png"},
      @{@"Name":@"以阅任务",@"url":@"/ETask/apireadlist?sysName=NEMS&isread=true",@"img":@"readed.png"}
      ];
    self.taskType=taskDict;
    self.tableView.tableFooterView=[[UIView alloc]init];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return  20.0;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
    return 4;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;//[self.taskType count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    if(cell==nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
       

    }
    CALayer *cellImageLayer = cell.imageView.layer;
    [cellImageLayer setCornerRadius:9];
    [cellImageLayer setMasksToBounds:YES];
    NSInteger row=indexPath.section;
    
    cell.textLabel.text=[self.taskType[row] valueForKey:@"Name"];
   // cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    // Configure the cell...
   // NSString *path=[NSBundle mainBundle] initWithPath:
    
    UIImage *image=[UIImage imageNamed:[self.taskType[row] valueForKey:@"img"]];
    
   

    //CGSize size=CGSizeMake(30, 30);
    cell.imageView.image=image ;//circleImage];//[Tools reSizeImage:image toScale:0.4];
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 35;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
      NSIndexPath *indexPaht=[self.tableView indexPathForCell:sender];
    NSDictionary *selectItem=self.taskType[indexPaht.section];
    NSString *taskType= [selectItem valueForKey:@"Name"];
   // [segue.destinationViewController navigationItem].title=taskType;
    TaskListController *listVc=segue.destinationViewController;
    listVc.navigationItem.title=taskType;
    listVc.taskUrl=[selectItem valueForKey:@"url"];
}


@end
