//
//  InventoryController.m
//  fqnp
//
//  Created by 周登峰 on 7/27/16.
//  Copyright © 2016 cnpdc. All rights reserved.
//

#import "InventoryController.h"
#import "Tools.h"
#import "AFHTTPSessionManager.h"
#import "InventoryDetailController.h"

@interface InventoryController ()

@end

@implementation InventoryController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"集合清点";
    // Do any additional setup after loading the view.
    
    self.tableView.tableFooterView=[[UIView alloc]init];
    
    NSMutableDictionary *param=[[NSMutableDictionary alloc] init];
    param[@"loginstate"]=[Tools getLoginByCode:@"loginState"];
    
    
    NSString *fullUrl=[[Tools getBaseUrl] stringByAppendingString:@"/mobile/Gatherlist"];
    AFHTTPSessionManager *manger=[AFHTTPSessionManager manager];
    manger.responseSerializer=[AFHTTPResponseSerializer serializer];
    
    [manger GET:fullUrl parameters:param progress:nil success:^(NSURLSessionDataTask *  task, id  responseObject) {
        NSError *err;
        NSMutableArray *arr=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&err];
        self.gathers=arr;
        if(![arr isEqual:[NSNull null]]){
            [self.tableView reloadData];
        }
        
    } failure:^(NSURLSessionDataTask *  task, NSError *  error) {
        //
        NSLog(@"集合清点列表网络异常");
    }];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"InCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)refreshTableView{
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //#warning Incomplete implementation, return the number of sections
    return 1;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.gathers count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   // UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InCell" forIndexPath:indexPath];
    
    UITableViewCell *cell =  [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"InCell"];
    NSInteger row=indexPath.row;
    NSDictionary *item=self.gathers[row];
    cell.textLabel.text=[item valueForKey:@"Name"];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    cell.detailTextLabel.text=[NSString stringWithFormat:@"已到:%@ 未到:%@ 已撤:%@",[item valueForKey:@"Arrive"],[item valueForKey:@"Absent"],[item valueForKey:@"Offset"]];
   // cell.accessoryType
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //NSIndexPath *indexPaht=[self.tableView indexPathForCell:sender];
        NSDictionary *item=self.gathers[indexPath.row];
    NSString *name= [item valueForKey:@"Name"];
    //[segue.destinationViewController navigationItem].title=taskType;
    InventoryDetailController *vc=[[InventoryDetailController alloc] init];
    //[vc storyboard]
    vc.gather=item;
    vc.navigationItem.title=name;
    vc.inventory=self;
    if(vc!=nil){
        // self.navigationItem.title=taskType;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
@end
