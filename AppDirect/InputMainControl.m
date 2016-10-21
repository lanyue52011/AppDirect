//
//  InputMainControl.m
//  fqnp
//
//  Created by 周登峰 on 8/3/16.
//  Copyright © 2016 cnpdc. All rights reserved.
//

#import "InputMainControl.h"
#import "AccidentController.h"
#import "MonitorController.h"
#import "UIImage+Extension.h"
#import "InventoryController.h"

@implementation InputMainControl
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    NSArray *taskDict=  @[@{@"Name":@"事故录入",@"img":@"accident.png"},
                          @{@"Name":@"环境巡查",@"img":@"monitor.png"},
                          @{@"Name":@"集合清点",@"img":@"inventory.png"}
                          //@{@"Name":@"以阅任务",@"url":@"/ETask/apireadlist?sysName=NEMS&isread=true",@"img":@"readed.png"}
                          ];
    self.inputType=taskDict;
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
    return 3;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;//[self.taskType count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    NSInteger row=indexPath.section;
    
    cell.textLabel.text=[self.inputType[row] valueForKey:@"Name"];

    UIImage *image=[UIImage imageNamed:[self.inputType[row] valueForKey:@"img"]];

    cell.imageView.image=[image circleImage] ; //[Tools reSizeImage:image toScale:0.5]
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 35;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //NSIndexPath *indexPaht=[self.tableView indexPathForCell:sender];
    
    NSString *taskType= [self.inputType[indexPath.section] valueForKey:@"Name"];
    //[segue.destinationViewController navigationItem].title=taskType;
    UIViewController *vc=nil;
    if([taskType isEqualToString:@"事故录入"]){
        vc=[[AccidentController alloc]init];
    }else if([taskType isEqualToString:@"环境巡查"]){
         vc=[[MonitorController alloc]init];
    }else {
         vc=[[InventoryController alloc]init];
    }
    
    if(vc!=nil){
       // self.navigationItem.title=taskType;
    [self.navigationController pushViewController:vc animated:YES];
    }
}


@end
