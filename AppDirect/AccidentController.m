//
//  AccidentController.m
//  fqnp
//
//  Created by 周登峰 on 7/27/16.
//  Copyright © 2016 cnpdc. All rights reserved.
//

#import "AccidentController.h"
#import "AFHTTPSessionManager.h"
#import "AccitentDetailController.h"
#import "Tools.h"


@interface AccidentController ()

@end

@implementation AccidentController

- (void)viewDidLoad {
    [super viewDidLoad];
    
      self.tableView.tableFooterView=[[UIView alloc]init];
    
     self.navigationItem.title=@"事故列表";
       UIBarButtonItem *button=[[UIBarButtonItem alloc] initWithTitle:@"增加" style:UIBarButtonItemStylePlain target:self action:@selector(navigationAddEvent:)];
    self.navigationItem.rightBarButtonItem=button;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"eventCell"];
    
 
    
    NSMutableDictionary *param=[[NSMutableDictionary alloc] init];
    param[@"loginstate"]=[Tools getLoginByCode:@"loginState"];
    
    
    NSString *fullUrl=[[Tools getBaseUrl] stringByAppendingString:@"/mobile/accidentlist"];
    AFHTTPSessionManager *manger=[AFHTTPSessionManager manager];
    manger.responseSerializer=[AFHTTPResponseSerializer serializer];
    
    [manger GET:fullUrl parameters:param progress:nil success:^(NSURLSessionDataTask *  task, id  responseObject) {
        NSError *err;
        NSMutableArray *arr=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&err];
        self.events=arr;
        if(![arr isEqual:[NSNull null]]){
            [self.tableView reloadData];
        }
        
    } failure:^(NSURLSessionDataTask *  task, NSError *  error) {
        //
        NSLog(@"事故列表网络异常");
    }];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)navigationAddEvent:(id)sender{
    // self.navigationItem.title=taskType;
    AccitentDetailController *vc=[[AccitentDetailController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //#warning Incomplete implementation, return the number of sections
    return 1;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.events count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell =  [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"eventCell"];
    NSInteger row=indexPath.row;
    NSDictionary *item=self.events[row];
    cell.textLabel.text=[item valueForKey:@"Name"];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    cell.detailTextLabel.text=[item valueForKey:@"CurrentTime"];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //NSIndexPath *indexPaht=[self.tableView indexPathForCell:sender];
    NSDictionary *item=self.events[indexPath.row];
    NSString *name= [item valueForKey:@"Name"];
    //[segue.destinationViewController navigationItem].title=taskType;
    AccitentDetailController *vc=[[AccitentDetailController alloc] init];
    //[vc storyboard]
    vc.event=item;
    vc.navigationItem.title=name;
    vc.accidentController=self;
    if(vc!=nil){
        // self.navigationItem.title=taskType;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
-(void)refreshTableView{
    [self.tableView reloadData];
}


@end
