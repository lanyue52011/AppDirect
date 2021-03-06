//
//  ViewController.m
//  fqnp
//
//  Created by 周登峰 on 7/26/16.
//  Copyright © 2016 cnpdc. All rights reserved.
//

#import <sys/socket.h>
#import <sys/time.h>
#import <sys/types.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import <netdb.h>
#import <time.h>
#import <pthread.h>

#import "LoginViewController.h"
#import "AuthHelper.h"
#import "TaskTypeListController.h"

#import "CommanHeader.h"


static void *thread_func(void *param);

// 以下是认证可能会用到的认证信息
short port = 443;                        //vpn设备端口号，一般为443
NSString *vpnIp =    @"218.66.15.178";  //vpn设备IP地址
NSString *userName = @"20134082";             //用户名认证的用户名
NSString *password = @"330597";                //用户名认证的密码
NSString *certName = @"";     //导入证书名字，如果服务端没有设置证书认证可以不设置
NSString *certPwd =  @"";          //证书密码，如果服务端没有设置证书
NSString *loginState=@"0";
@interface LoginViewController (PrivateMethod)

//http请求下载文件测试
- (void) httpRequest:(NSString *)url port:(short)port;

//http请求上传文件测试
- (void) uploadFile:(NSString *)url file:(NSString *)path;

@end

@implementation LoginViewController

@synthesize helper;

- (void)viewDidLoad
{
    [super viewDidLoad];
   // self.goHome.hidden=YES;
	// Do any additional setup after loading the view, typically from a nib.
    self.helper = [[AuthHelper alloc] initWithHostAndPort:vpnIp port:443 delegate:self];
    //关闭自动登陆的选项，建议设置为关闭的状态，自动登陆的选项开启的情况下，每次有网络请求的时候
    //都会探测用户是不是处于在线的状态，网络速度有所下降，支持IOS7的新版本的SDK对此做了优化，建议
    //显示的关闭该选项，用户可以调用vpn_query_status来查询状态，如果发现用户掉线可以调用vpn_relogin
    //来完成自动登陆
    // [helper setAuthParam:@AUTO_LOGIN_OFF_KEY param:@"true"];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) onCallBack:(const VPN_RESULT_NO)vpnErrno authType:(const int)authType
{
    switch (vpnErrno)
    {
        case RESULT_VPN_INIT_FAIL:
            say_err("Vpn Init failed!");
            break;
            
        case RESULT_VPN_AUTH_FAIL:
            [helper clearAuthParam:@SET_RND_CODE_STR];
            say_err("Vpn auth failed!");
            [self showFailureTips:@"用户名或密码错误，请重新输入！"];
            break;
            
        case RESULT_VPN_INIT_SUCCESS:
            say_log("Vpn init success!");
            break;
        case RESULT_VPN_AUTH_SUCCESS:
            [self startOtherAuth:authType];
            break;
        case RESULT_VPN_AUTH_LOGOUT:
            say_log("Vpn logout success!");
            break;
		case RESULT_VPN_OTHER:
			if (VPN_OTHER_RELOGIN_FAIL == (VPN_RESULT_OTHER_NO)authType) {
				say_log("Vpn relogin failed, maybe network error");
                [self showFailureTips:@"网络连接错误！"];

			}
			break;
            
        case RESULT_VPN_NONE:
            break;
            
        default:
            break;
    }
}

- (void) onReloginCallback:(const int)status result:(const int)result
{
    switch (status) {
        case START_RECONNECT:
            NSLog(@"vpn relogin start reconnect ...");
            break;
        case END_RECONNECT:
            NSLog(@"vpn relogin end ...");
            if (result == SUCCESS) {
                NSLog(@"Vpn relogin success!");
            } else {
                NSLog(@"Vpn relogin failed");
            }
            break;
        default:
            break;
    }
}

- (void) startOtherAuth:(const int)authType
{
    NSArray *paths = nil;
    switch (authType)
    {
        case SSL_AUTH_TYPE_CERTIFICATE:
            paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                        NSUserDomainMask, YES);
            
            if (nil != paths && [paths count] > 0)
            {
                NSString *dirPaths = [paths objectAtIndex:0];
                NSString *authPaths = [dirPaths stringByAppendingPathComponent:certName];
                NSLog(@"PATH = %@",authPaths);
                [helper setAuthParam:@CERT_P12_FILE_NAME param:authPaths];
                [helper setAuthParam:@CERT_PASSWORD param:certPwd];
            }
            say_log("Start Cert Auth!!!");
            break;
            
        case SSL_AUTH_TYPE_PASSWORD:
            say_log("Start Password Name Auth!!!");
            [helper setAuthParam:@PORPERTY_NamePasswordAuth_NAME param:userName];
            [helper setAuthParam:@PORPERTY_NamePasswordAuth_PASSWORD param:password];
            
            break;
        case SSL_AUTH_TYPE_NONE:
            say_log("Auth success!!!");
            [self GoHome];
            return;
        default:
            say_err("Other failed!!!");
            return;
    }
    [helper loginVpn:authType];
}

-(void)GoHome
{

    [self performSegueWithIdentifier:@"mainTab" sender:self];

    //[self testConnect];
}

- (IBAction)hideKeybord:(id)sender {
    
    [self.textUserName resignFirstResponder];
    [self.textPassword resignFirstResponder];
    //[self.textArrive resignFirstResponder];
}
- (IBAction)loginState0:(id)sender
{
    loginState=@"0";
     [self loginSVN];
}
- (IBAction)loginState1:(id)sender
{
    loginState=@"1";
    [self loginSVN];
}

-(BOOL)loginSVN{
    userName=self.textUserName.text;
    password=self.textPassword.text;
    
    if([userName length]<1){
        //return NO;
        [self showFailureTips:@"请输入用户名！"];
        return NO;
    }
    if([password length]<1){
        [self showFailureTips:@"请输入密码！"];
        return NO;
    }
    
    [Tools  saveLoginInfo:self.textUserName.text loginState:loginState];
   
    //设置认证参数 用户名和密码以数值map的形式传入
    [helper setAuthParam:@PORPERTY_NamePasswordAuth_NAME param:userName];
    [helper setAuthParam:@PORPERTY_NamePasswordAuth_PASSWORD param:password];
    //开始用户名密码认证
    [helper loginVpn:SSL_AUTH_TYPE_PASSWORD];
    return YES;
}

- (IBAction)logout:(id)sender
{
    //注销用户登陆
    //[helper logoutVpn];
    //[self.webView  loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://10.17.253.13:9999"]]];
}

-(IBAction)autoLogin:(id)sender
{
    //如果svpn已经注销了，就重新登陆
    if ([helper queryVpnStatus] == VPN_STATUS_LOGOUT)
    {
        NSLog(@"Svpn is logout!");
        [helper relogin];
    }
}

-(IBAction)requestRc:(id)sender
{
    //请求内网资源信息
    NSString *url = @"10.17.254.13";
    [self httpRequest:url port:9999];
    
    //开启线程上传文件
    //pthread_t thread;
    //pthread_create(&thread, NULL,thread_func, self);
}

-(void)testConnect{
    NSString *url = @"10.17.254.13";
    [self httpRequest:url port:9999];
}
//http请求下载文件测试
- (void) httpRequest:(NSString *)host port:(short)port
{
    NSAssert(host != nil, @"host is nil");
    
    int sockfd = socket(AF_INET, SOCK_STREAM, 0);
    if (sockfd == -1)
    {
        NSLog(@"socket failed int httpRequest!");
        return ;
    }
    char buffer[4096];
    struct sockaddr_in addr = {0};
    addr.sin_family = AF_INET;
    addr.sin_port = htons(port);
    in_addr_t inaddr = INADDR_NONE;
    //说明是ip地址形势
    if ((inaddr = inet_addr([host UTF8String])) != INADDR_NONE)
    {
        addr.sin_addr.s_addr = inaddr;
    }
    else
    {
        struct hostent *hostent = gethostbyname([host UTF8String]);
        if (hostent != NULL)
        {
            if ((hostent->h_addrtype == AF_INET) &&
                (hostent->h_addr_list != NULL))
            {
                inaddr = *((uint32_t *)(hostent->h_addr_list[0]));
            }
        }
        if (inaddr == INADDR_NONE)
        {
            NSLog(@"gethostbyname failed<%@>",host);
            goto failed;
        }
        addr.sin_addr.s_addr = inaddr;
    }
    if (connect(sockfd, (struct sockaddr *)&addr ,sizeof(struct sockaddr_in)) < 0)
    {
        NSLog(@"connect socket failed!");
        goto failed;
    }
    
    const char *httpRequeset =  "GET /typhoon/data2  HTTP/1.0\r\n"
    "Accept: application/xaml+xml\r\n"
    "Accept-Language: zh-cn\r\n"
    "Accept-Encoding: deflate\r\n"
    "User-Agent: Mozilla/4.0\r\n"
    "Host: %s\r\n"
    "Connection: close\r\n\r\n";
    
    snprintf(buffer, sizeof(buffer)-1 ,httpRequeset,[host UTF8String]);
    buffer[sizeof(buffer) -1] = 0;
    
    if (write(sockfd, buffer, strlen(buffer)) < 0)
    {
        NSLog(@"write failed");
        goto failed;
    }
    
    if (recv(sockfd, buffer, sizeof(buffer) - 1, 0) < 0)
    {
        NSLog(@"recv failed");
        goto failed;
    }
    
    NSLog(@"%s",buffer);
    
failed:
    if (sockfd != -1)
    {
        close(sockfd);
    }
}

//上传文件的测试
- (void) uploadFile:(NSString *)url file:(NSString *)filename
{
    NSAssert(url != nil,  @"url is nil!");
    NSAssert(filename != nil, @"path is nil");
    
    NSString *value = @"7dda656083c";
    
    //创建request对象
    NSMutableURLRequest *request =
    [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                            cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
    
    //设置请求的方法
    [request setHTTPMethod:@"POST"];
    
    //设置http请求的content－type
    NSString *content =[[NSString alloc] initWithFormat:@"multipart/form-data; boundary=-----------%@",value];
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    
    NSData *bodyData = [self fileToBodyData:filename boundary:value];
    
    //设置数据的长度值
    [request setValue:[NSString stringWithFormat:@"%d",[bodyData length]] forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"200.200.72.19" forHTTPHeaderField:@"Host"];
    
    //设置body的的数据段
    [request setHTTPBody:bodyData];
    
    
    NSError *error = nil;
    NSURLResponse *response = nil;
    NSData *result = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (result != nil)  {
        NSString *outString = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"%@",outString);
    }
}

- (NSData *) fileToBodyData:(NSString *)filename boundary:(NSString *)boundary
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSData *data = nil;
    if (nil != paths && [paths count] > 0)
    {
        NSString *dirPaths = [paths objectAtIndex:0];
        NSString *authPaths = [dirPaths stringByAppendingPathComponent:filename];
        data = [NSData dataWithContentsOfFile:authPaths];
    }
    
    NSString *value1 = [NSString stringWithFormat:@"-------------%@\r\n",boundary];
    NSString *value2 = [NSString stringWithFormat:@"-------------%@--\r\n",boundary];
    NSMutableData *result = [NSMutableData data];
    
    NSString *format1 = @"Content-Disposition: form-data; name=\"file\"; filename=\"%@\"\r\nContent-Type: text/plain\r\n\r\n";
    NSString *tmpString = [NSString stringWithFormat:format1, filename];
    //添加boundary
    [result appendData:[value1 dataUsingEncoding:NSUTF8StringEncoding]];
    //添加xml的信息
    [result appendData:[tmpString dataUsingEncoding:NSUTF8StringEncoding]];
    //添加文件内容
    [result appendData:data];
    [result appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [result appendData:[value1 dataUsingEncoding:NSUTF8StringEncoding]];
    NSString *format2 =
    @"Content-Disposition: form-data; name=\"submit\"\r\n\r\n";
    [result appendData:[format2 dataUsingEncoding:NSUTF8StringEncoding]];
    [result appendData:[@"Submit\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [result appendData:[value2 dataUsingEncoding:NSUTF8StringEncoding]];
    
    return result;
}

//- (void)dealloc {
//    //[_webView release];
//    [_textUserName release];
//    [_textPassword release];
//    [_textUserName release];
//    [_goHome release];
//    [super dealloc];
//}

@end

//static void *thread_func(void *param)
//{
//    LoginViewController *controller = (LoginViewController *)param;
//    struct timeval start, end;
//    long ecl_time = 0;
//    
//    NSString *arrays[] =
//    {
//        @"test1K.txt", @"test5K.txt", @"test10K.txt", @"test20K.txt", @"test50K.txt", @"test100K.txt", @"test200K.txt", @"test500K.txt",
//        @"test1M.txt", @"test2M.txt",@"test5M.txt"
//        
//    };
//    for (int i=0; i< sizeof(arrays)/sizeof(NSString *); ++i)
//    {
//        gettimeofday(&start, NULL);
//        NSString *url = @"http://200.200.72.19/test/php/file.php";
//        [controller uploadFile:url file:arrays[i]];
//        gettimeofday(&end, NULL);
//        ecl_time =(end.tv_sec * 1000 + end.tv_usec/1000) -
//        (start.tv_sec *1000 + start.tv_usec/1000);
//        NSLog(@"%@ upload time:%ldms\r\n",arrays[i], ecl_time);
//    }
//    return NULL;
//}

