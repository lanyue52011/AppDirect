//
//  MonitorController.m
//  fqnp
//
//  Created by 周登峰 on 7/27/16.
//  Copyright © 2016 cnpdc. All rights reserved.
//

#import "MonitorController.h"
#import "AFNetworking/AFHTTPSessionManager.h"
#import "Tools.h"
#import "MonitorDetailController.h"
@interface MonitorController ()

@end

@implementation MonitorController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.navigationItem.title=@"环境巡测";
    // Do any additional setup after loading the view.
  
    UIBarButtonItem *button=[[UIBarButtonItem alloc] initWithTitle:@"增加" style:UIBarButtonItemStylePlain target:self action:@selector(navigationAddMonitor:)];
    self.navigationItem.rightBarButtonItem=button;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"monitorCell"];
    [self initData];
}

-(void)navigationAddMonitor:(id)sender{
    MonitorDetailController *vc=[[MonitorDetailController alloc]init];
    vc.station=self.station;
    vc.points=self.points;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)initData{
    NSMutableDictionary *param=[[NSMutableDictionary alloc] init];
    param[@"loginstate"]=[Tools getLoginByCode:@"loginState"];
    
    
    NSString *fullUrl=[[Tools getBaseUrl] stringByAppendingString:@"/mobile/apimonitor"];
    AFHTTPSessionManager *manger=[AFHTTPSessionManager manager];
    manger.responseSerializer=[AFHTTPResponseSerializer serializer];
    
    [manger GET:fullUrl parameters:param progress:nil success:^(NSURLSessionDataTask *  task, id  responseObject) {
        NSError *err;
        NSDictionary *arr=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&err];
        //self.events=arr;
        
        self.station =[arr valueForKey:@"State"];
        self.points=[arr valueForKey:@"Source"];
        NSArray *data=[arr valueForKey:@"Data"];
        if([data count]>0){
            self.monitorKeys=[data valueForKey:@"Key"];
            self.monitors=data;
            [self.tableView reloadData];
        }
  
        
    } failure:^(NSURLSessionDataTask *  task, NSError *  error) {
        //
        NSLog(@"事故列表网络异常");
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return  20.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //#warning Incomplete implementation, return the number of sections
    return [self.monitorKeys count];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return self.monitorKeys[section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //return 1;//[self.taskType count];


    NSArray *data=[self.monitors[section] valueForKey:@"Value"];
    return [data count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 
    
    UITableViewCell *cell =  [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"monitorCell"];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    NSInteger row=indexPath.section;
    NSArray *data=[self.monitors[row] valueForKey:@"Value"];
    NSDictionary *dict=data[indexPath.row];
    
    cell.textLabel.text=[dict valueForKey:@"PointName"];
    cell.detailTextLabel.text=[NSString stringWithFormat:@"%@公里 %@ %@μGy/h", [dict valueForKey:@"Long"],[dict  valueForKey:@"Direction"],[dict  valueForKey:@"YJLL"]];
    
    return cell;
}
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 35;
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //NSIndexPath *indexPaht=[self.tableView indexPathForCell:sender];
    
    NSInteger row=indexPath.section;
    NSArray *data=[self.monitors[row] valueForKey:@"Value"];
    NSDictionary *dict=data[indexPath.row];
    //[segue.destinationViewController navigationItem].title=taskType;
    MonitorDetailController *vc=[[MonitorDetailController alloc]init];
    vc.station=self.station;
    vc.points=self.points;
    vc.monitor=dict;
    vc.batchNames=self.monitorKeys;
    
 
    if(vc!=nil){
        // self.navigationItem.title=taskType;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
