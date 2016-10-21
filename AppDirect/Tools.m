//
//  Tools.m
//  fqnp
//
//  Created by 周登峰 on 7/27/16.
//  Copyright © 2016 cnpdc. All rights reserved.
//

#import "Tools.h"
#if TARGET_IPHONE_SIMULATOR//模拟器
 static NSString *baseUrl=@"http://192.168.1.103:9999";
#elif TARGET_OS_IPHONE//真机
 static NSString *baseUrl=@"http://10.17.254.13:9999";
#endif
#define PI 3.1415926

@implementation Tools

+(NSString *)getBaseUrl{
    
    
    return baseUrl;
}

/**
 *  图片缩放
 *
 *  @param image     <#image description#>
 *  @param scaleSize <#scaleSize description#>
 *
 *  @return <#return value description#>
 */

+(UIImage *)reSizeImage:(UIImage *)image toScale:(float)scaleSize{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.height*scaleSize,image.size.width*scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.height*scaleSize, image.size.width*scaleSize)];
    UIImage *scaleImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaleImage;
    
}

+(UIImage *)reSizeImage:(UIImage *)image  toSize:(CGSize)size{
    UIGraphicsBeginImageContext(CGSizeMake(size.height , size.width));
    [image drawInRect:CGRectMake(0, 0, size.height , size.width)];
    UIImage *toImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return toImage;
    
}

+(NSString *) stringToDateTIme:(NSString *)dateStr{
    NSRange range=NSMakeRange(6, 10);
    NSString *s=  [dateStr substringWithRange:range];
    NSInteger num=[s integerValue];
    
    NSDateFormatter *fromatter=[[NSDateFormatter alloc]init];
    [fromatter setDateStyle:NSDateFormatterMediumStyle];
    [fromatter setTimeStyle:NSDateFormatterLongStyle];
    [fromatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    NSDate *confromT=[NSDate dateWithTimeIntervalSince1970:num];
    NSString *timeStr=[fromatter stringFromDate:confromT];
    return timeStr;
    
}
+(NSString *)submitByGet:(NSString *)path{
    
    NSString *urlStr;
   // if (!IOS7_OR_LATER) {
      //  urlStr = [[baseUrl stringByAppendingString:path ] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //}else{
        urlStr = [[baseUrl stringByAppendingString:path ] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "].invertedSet];
   // }
    
    
    //NSError *err;
    NSURL *url=[NSURL URLWithString:urlStr] ;
    NSURLRequest *req=[NSURLRequest requestWithURL:url];
    NSData *data=[NSURLConnection sendSynchronousRequest:req returningResponse:nil error:nil];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}
+(void)saveLoginInfo:(NSString *)userCode loginState:(NSString *)loginState{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:userCode forKey:@"userCode"];
    [defaults setObject:loginState forKey:@"loginState"];
    [defaults synchronize];
}

+(NSString *)getLoginByCode:(NSString *)code{
      NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:code];
}

+(NSString *)distance:(double)lon1 y1:(double)lat1 x2:(double)lon2 y2:(double)lat2{
    
    double er = 6378137; // 6378700.0f;
    //ave. radius = 6371.315 (someone said more accurate is 6366.707)
    //equatorial radius = 6378.388
    //nautical mile = 1.15078
    double radlat1 = PI*lat1/180.0f;
    double radlat2 = PI*lat2/180.0f;
    //now long.
    double radlong1 = PI*lon1/180.0f;
    double radlong2 = PI*lon2/180.0f;
    if( radlat1 < 0 ) radlat1 = PI/2 + fabs(radlat1);// south
    if( radlat1 > 0 ) radlat1 = PI/2 - fabs(radlat1);// north
    if( radlong1 < 0 ) radlong1 = PI*2 - fabs(radlong1);//west
    if( radlat2 < 0 ) radlat2 = PI/2 + fabs(radlat2);// south
    if( radlat2 > 0 ) radlat2 = PI/2 - fabs(radlat2);// north
    if( radlong2 < 0 ) radlong2 = PI*2 - fabs(radlong2);// west
    //spherical coordinates x=r*cos(ag)sin(at), y=r*sin(ag)*sin(at), z=r*cos(at)
    //zero ag is up so reverse lat
    double x1 = er * cos(radlong1) * sin(radlat1);
    double y1 = er * sin(radlong1) * sin(radlat1);
    double z1 = er * cos(radlat1);
    double x2 = er * cos(radlong2) * sin(radlat2);
    double y2 = er * sin(radlong2) * sin(radlat2);
    double z2 = er * cos(radlat2);
    double d = sqrt((x1-x2)*(x1-x2)+(y1-y2)*(y1-y2)+(z1-z2)*(z1-z2));
    //side, side, side, law of cosines and arccos
    double theta = acos((er*er+er*er-d*d)/(2*er*er));
    double dist  = theta*er/1000;
    return [[NSString alloc] initWithFormat:@"%.3f",dist ];
    
}
+(NSString *)direction:(double)x1 y1:(double)y1 x2:(double)x2 y2:(double)y2{
    //[start ]
    double jd;
    double w1=y1/180*PI;
    double j1=x1/180*PI;
    double w2=y2/180*PI;
    double j2=x2/180*PI;
    if(j1==j2){
        if(w1>w2){
            jd=270;
        }else if(w1<w2){
            jd=90;
        }else{
            jd=-1;
        }
        
    }
    jd=4*pow(sin((w1-w2)/2), 2)-pow(sin((j1-j2)/2)*cos(w2), 2);
    jd=sqrt(jd);
    double temp=sin(fabs((j1-j2)/2))*(cos(w1)+cos(w2));
    jd=jd/temp;
    jd=atan(jd)/PI*180;
    if(j1>j2){
        if(w1>w2)jd+=180;
        else jd=180-jd;
        
    }else if(w1>w2) jd=360-jd;
    
    NSString *rec;
    double f=jd;
    if (f >= 348.75 ||f < 11.25)
    {
        rec = @"北(N)";
    }
    else if (f >= 11.25 && f < 33.75)
    {
        rec = @"东北偏北(NNE)";
    }
    else if (f >= 33.75 && f < 56.25)
    {
        rec = @"东北(NE)";
    }
    else if (f >= 56.25 && f < 78.75)
    {
        rec = @"东北偏东(ENE)";
    }
    else if (f >= 78.75 && f < 101.25)
    {
        rec = @"东(N)";
    }
    else if (f >= 101.25 && f < 123.75)
    {
        rec = @"东南偏东(ESE)";
    }
    else if (f >= 123.75 && f < 146.25)
    {
        rec = @"东南(SE)";
    }
    else if (f >= 146.25 && f < 168.75)
    {
        rec = @"东南偏南(SSE)";
    }
    else if (f >= 168.75 && f < 191.25)
    {
        rec = @"南(S)";
    }
    else if (f >= 191.25 && f < 213.75)
    {
        rec = @"西南偏南(SSW)";
    }
    else if (f >= 213.75 && f < 236.25)
    {
        rec = @"西南(SW)";
    }
    else if (f >= 236.25 && f < 258.75)
    {
        rec = @"西南偏西(WSW)";
    }
    else if (f >= 258.75 && f < 281.25)
    {
        rec = @"西(W)";
    }
    else if (f >= 281.25 && f < 303.75)
    {
        rec = @"西北偏西(WNW)";
    }
    else if (f >= 303.75 && f < 326.25)
    {
        rec = @"西北(NW)";
    }
    else if (f >= 326.25 && f < 348.75)
    {
        rec = @"西北偏北(NNW)";
    }
    
    return rec;
    
}



@end
