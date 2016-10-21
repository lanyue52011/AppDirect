//
//  TaskListController.m
//  fqnp
//
//  Created by 周登峰 on 7/26/16.
//  Copyright © 2016 cnpdc. All rights reserved.
//

#import "TaskListController.h"
#import "Tools.h"
#import "AFHTTPSessionManager.h"


@interface TaskListController ()
@property(strong,nonatomic) UIFont *font;
//@property(weak,nonatomic) AFHTTPSessionManager *manger;
@end

@implementation TaskListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView=[[UIView alloc]init];

   
    //param[@"sysName"]=@"NEMS";
    
   
    NSString *fullUrl=[[Tools getBaseUrl] stringByAppendingString:self.taskUrl];
    
    [self loadDataByUrl:fullUrl];
    
   // self.taskList=[Tools getJsonByUrl:[url stringByAppendingString:path]];
  
}
-(void)loadDataByUrl:(NSString *)url{
    
    NSMutableDictionary *param=[[NSMutableDictionary alloc] init];
    param[@"userid"]=[Tools getLoginByCode:@"userCode"];
    param[@"loginstate"]=[Tools getLoginByCode:@"loginState"];
    
    AFHTTPSessionManager *manger=[AFHTTPSessionManager manager];
    manger.responseSerializer=[AFHTTPResponseSerializer serializer];
    
    [manger GET:url parameters:param progress:nil success:^(NSURLSessionDataTask *  task, id  responseObject) {
        NSError *err;
        NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&err];
        
        NSArray *arr=[dict objectForKey:@"result"];
        
        self.taskList=arr;
        if(![arr isEqual:[NSNull null]]){
            [self.tableView reloadData];
        }
        //[manger release];
        
    } failure:^(NSURLSessionDataTask *  task, NSError *  error) {
        //
        NSLog(@"网络异常");
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    return [self.taskList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailCell" forIndexPath:indexPath];
    
    // Configure the cell...
   //UIImage *img=[UIImage  imageNamed:@"first.png"];
    //cell.imageView.image=img;
   NSArray *arr=self.taskList[indexPath.row];
    cell.textLabel.text=[arr  valueForKey:@"Subject"] ;
    NSString *dateStr=[arr valueForKey:@"StartDate"];
   
  
 //   NSDate *d=[NSDate date]
    cell.detailTextLabel.text=[Tools stringToDateTIme:dateStr];//[NSString stringWithFormat:@"到达时间：%@",[Tools stringToDateTIme:dateStr]];
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
