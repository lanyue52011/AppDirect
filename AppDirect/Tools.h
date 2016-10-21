//
//  Tools.h
//  fqnp
//
//  Created by 周登峰 on 7/27/16.
//  Copyright © 2016 cnpdc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import  <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface Tools : NSObject
+(NSString *)getBaseUrl;

+(UIImage *)reSizeImage:(UIImage *)image toScale:(float)scaleSize;
+(UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)size;
+(NSString *)stringToDateTIme:(NSString *) dateStr;
+(NSString *)submitByGet:(NSString *)path;
+(void)saveLoginInfo:(NSString *)userCode loginState:(NSString *)loginState;
+(NSString *)getLoginByCode:(NSString *)code;
+(NSString *)distance:(double)x1 y1:(double)y1 x2:(double)x2 y2:(double)y2;
+(NSString *)direction:(double)x1 y1:(double)y1 x2:(double)x2 y2:(double)y2;
@end
