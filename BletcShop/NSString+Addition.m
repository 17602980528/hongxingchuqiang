//
//  NSString+Addition.m
//  RoySinaWeiboTest
//
//  Created by 智游集团 on 16/1/5.
//  Copyright © 2016年 Roy. All rights reserved.
//

#import "NSString+Addition.h"
#import "Base64.h"

#include <ifaddrs.h>
#include <arpa/inet.h>

@implementation NSString (Addition)
//获取一个没有空格的字符串
- (NSString *)noWhiteSpaceString
{
    NSString *resultStr = @"";
    
    NSArray *tempArr =  [self componentsSeparatedByString:@" "];
    
    for (NSString *tempStr in tempArr)
    {
        resultStr = [resultStr stringByAppendingString:tempStr];
    }
    
    return resultStr;
}

//判断一个字符串是否包含另一个字符串
- (BOOL)isContainSubString:(NSString *)aSubstr
{
    NSRange range =  [self rangeOfString:aSubstr];
    
    //[self containsString:<#(nonnull NSString *)#>]
    /*
    if (range.length <= 0)
    {
        return NO;
    }
     */
    
    if (range.location == NSNotFound)
    {
        return NO;
    }
    
    return YES;
}
#pragma mark  - 把新浪微博的时间转化为刚刚、3分钟前。。等格式
+ (NSString *)sinaWeiboCreatedAtString:(NSString *)date;
{
    NSString *weiboDateStr = @"";
    
    //创建时间格式器，并设置时间格式
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    
    NSString *formaterStr = @"yyyy-MM-dd HH:mm:ss";
    
    formater.dateFormat = formaterStr;
    
    //用时间格式器把指定的时间字符串 转化为相应格式的时间
    NSDate *weiboDate = [formater dateFromString:date];
    
    //日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSLog(@"=====%@",weiboDate);
    //根据日历判断 微博时间是否是在今天
    if ([calendar isDateInToday:weiboDate])
    {
        //返回今天什么时候发布的，比如3分钟前
        
        NSDate *currentDate = [NSDate date];
        
        //判断微博时间和当前时间的时间差,单位是秒
        double tempTimeInterval = [currentDate timeIntervalSinceDate:weiboDate];
        
        if(tempTimeInterval < 60)
        {
            weiboDateStr = @"刚刚";
        }
        else if ((tempTimeInterval/60.0 > 1) && (tempTimeInterval / 60.0 / 60.0 < 1))
        {
            weiboDateStr = [NSString stringWithFormat:@"%d分钟前",(int)tempTimeInterval/60];
        }
        else
        {
             weiboDateStr = [NSString stringWithFormat:@"%d小时前",(int)tempTimeInterval/60/60];
        }
            
    }
    else
    {
        //返回 年月日发布的
        formater.dateFormat = @"yyyy-MM-dd";
        
       weiboDateStr = [formater stringFromDate:weiboDate];
    }
    
    return weiboDateStr;
}

#pragma mark 解析微博来源
- (NSString *)sinaWeiboSourceString
{
    //<a href=\"http://app.weibo.com/t/feed/4fuyNj\" rel=\"nofollow\">\U5373\U523b\U7b14\U8bb0</a>
    
     NSString *resultStr = @"";
    
    //以字符“>”为节点，获取">"之前的字符串的范围
    NSRange aRange = [self rangeOfString:@">"];
    
    if (aRange.location != NSNotFound)
    {
        //NSMaxRange(aRange)获取某一个范围的大小
        
        //根据获取的范围大小，作为下一截字符串的起点，截取字符串
        NSRange range = NSMakeRange(NSMaxRange(aRange), self.length - NSMaxRange(aRange) - 4);
        
        //截取字符串
       resultStr = [self substringWithRange:range];
    }
    
    
    
    return resultStr;
}
/*获取文本的宽度*/
- (float)getTextHeightWithShowWidth:(float)width AndTextFont:(UIFont *)aFont AndInsets:(float)inset
{
    return ceil([self boundingRectWithSize:CGSizeMake(width - inset * 2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : aFont} context:nil].size.height) + inset * 2;
}

/**使用指定的正则表达式过滤字符串**/
- (NSArray <NSTextCheckingResult *> *)myMatchWithPattern:(NSString *)aPattern
{
    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:aPattern options:0 error:nil];
    
    if (regularExpression)
    {
        NSArray <NSTextCheckingResult *> *resultArray = [regularExpression matchesInString:self options:0 range:NSMakeRange(0, self.length)];
        
        return resultArray;
    }
    
    return nil;
}


+(NSString *)getTheNoNullStr:(id)str andRepalceStr:(NSString*)replace{
    NSString *string=nil;
    if (![str isKindOfClass:[NSNull class]]) {
        string =  [NSString stringWithFormat:@"%@",str];
        
        if (string.length ==0||(NSNull*)string == [NSNull null]||[string containsString:@"null"]) {
            string =replace;
        }
    }else{
        string =replace;
    }
    return string;
}

/**
 
判断银行卡号是否正确
 @param cardNo 银行卡号
 @return <#return value description#>
 */
+ (BOOL) checkCardNo:(NSString*) cardNo{
    int oddsum = 0;     //奇数求和
    int evensum = 0;    //偶数求和
    int allsum = 0;
    int cardNoLength = (int)[cardNo length];
    int lastNum = [[cardNo substringFromIndex:cardNoLength-1] intValue];
    
    cardNo = [cardNo substringToIndex:cardNoLength - 1];
    for (int i = cardNoLength -1 ; i>=1;i--) {
        NSString *tmpString = [cardNo substringWithRange:NSMakeRange(i-1, 1)];
        int tmpVal = [tmpString intValue];
        if (cardNoLength % 2 ==1 ) {
            if((i % 2) == 0){
                tmpVal *= 2;
                if(tmpVal>=10)
                    tmpVal -= 9;
                evensum += tmpVal;
            }else{
                oddsum += tmpVal;
            }
        }else{
            if((i % 2) == 1){
                tmpVal *= 2;
                if(tmpVal>=10)
                    tmpVal -= 9;
                evensum += tmpVal;
            }else{
                oddsum += tmpVal;
            }
        }
    }
    
    allsum = oddsum + evensum;
    allsum += lastNum;
    if((allsum % 10) == 0)
        return YES;
    else
        return NO;
}


//判断是整数
+ (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string]; //定义一个NSScanner，扫描string
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}
//是否是小数
+ (BOOL)isPureFloat:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}


//字典转字符串
+ (NSString*)dictionaryToJson:(NSDictionary *)dic

{
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}
#pragma 手机号判断
+ (BOOL) isMobileNum:(NSString *)mobNum {
    //    电信号段:133/149/153/173/177/180/181/189
    //    联通号段:130/131/132/145/155/156/171/175/176/185/186
    //    移动号段:134/135/136/137/138/139/147/150/151/152/157/158/159/178/182/183/184/187/188
    //    虚拟运营商:170
    
    NSString *MOBILE = @"^1(3[0-9]|4[579]|5[0-35-9]|7[0135-8]|8[0-9])\\d{8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    
    return [regextestmobile evaluateWithObject:mobNum];
}
//获取label的宽度
+ (CGFloat)calculateRowWidth:(UILabel *)lable {
    NSDictionary *dic = @{NSFontAttributeName:lable.font};  //指定字号
    CGRect rect = [lable.text boundingRectWithSize:CGSizeMake(0,lable.height)/*计算宽度时要确定高度*/ options:NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading attributes:dic context:nil];
    return rect.size.width;
}



- (NSString *)stringByReversed
{
    NSMutableString *s = [NSMutableString string];
    for (NSUInteger i=self.length; i>0; i--) {
        [s appendString:[self substringWithRange:NSMakeRange(i-1, 1)]];
    }
    return s;
}
//获取当前时间的时间戳
+(NSString*)getCurrentTimestamp{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString*timeString = [NSString stringWithFormat:@"%0.f", a];//转为字符型
    return timeString;
}
+(NSString *)getSecretStringWithPhone:(NSString *)phone{
    NSString *sss= @"123456789";
    
    NSString *time=[NSString getCurrentTimestamp];
    NSString *sign=@"xyzabc";
    NSLog(@"time====%@",time);
    NSString *content=[NSString stringWithFormat:@"%@&%@",sign,time];
    
    NSString *phon = phone;
    
    
    NSMutableString *muta_s = [NSMutableString stringWithString:content];
    
    for (int i =0; i <phon.length; i ++) {
        
        char rr = [phon characterAtIndex:i];
        
        NSString *str =  [NSString stringWithFormat:@"%c",rr];
        
        [muta_s insertString:str atIndex:i*2+1];
        
    }
    
    NSString *new_str=[muta_s stringByReversed];
    
    NSLog(@"解密代码===%@",new_str);
    
    char a[100];
    
    memcpy(a, [new_str cStringUsingEncoding:NSASCIIStringEncoding], 2*[new_str length]);
    
    NSLog(@"a====%s ",a);
    
    //char a[]= "524527812035210&0c9b2a6z7y1x";        /*要加密的密码*/
    char b[]="cnconsum";     /*密钥*/
    int k;
    
    /*加密代码*/
    for(k=0;b[k]!='\0';k++)
        a[k]=a[k]^b[k];
    
    printf("You Password encrypted: %s\n",a);
    
    sss = [NSString stringWithCString:a encoding:NSUTF8StringEncoding];
    NSString *data_ =[sss base64EncodedString];
    
    NSLog(@"-----%@",data_);
    
    return data_;
}

+(NSString *)getSecretStringWithRandCode:(NSString *)sign  andTimestamp:(NSString*)time;
{
    NSString *sss= @"";
    
//    NSString *time=[NSString getCurrentTimestamp];
//    NSString *sign=@"xyzabc";
//    NSLog(@"time====%@",time);
//    NSString *content=[NSString stringWithFormat:@"%@&%@",sign,time];
//    
//    NSString *phon = phone;
    
    
    NSMutableString *muta_s = [NSMutableString stringWithString:time];
    
    for (int i =0; i <sign.length; i ++) {
        
        char rr = [sign characterAtIndex:i];
        
        NSString *str =  [NSString stringWithFormat:@"%c",rr];
        
        [muta_s insertString:str atIndex:i*2+1];
        
    }
    
    NSString *new_str=[muta_s stringByReversed];
    
//    NSLog(@"解密代码===%@",new_str);
    
    char a[100];
    
    memcpy(a, [new_str cStringUsingEncoding:NSASCIIStringEncoding], 2*[new_str length]);
    
//    NSLog(@"a====%s ",a);
    
    //char a[]= "524527812035210&0c9b2a6z7y1x";        /*要加密的密码*/
    char b[]="cnconsum";     /*密钥*/
    int k;
    
    /*加密代码*/
    for(k=0;b[k]!='\0';k++)
        a[k]=a[k]^b[k];
    
//    printf("You Password encrypted: %s\n",a);
    
    sss = [NSString stringWithCString:a encoding:NSUTF8StringEncoding];
    NSString *data_ =[sss base64EncodedString];
    
//    NSLog(@"-----%@",data_);
    
    return data_;
}
+(NSString*)getRandomCode{
    
    
    NSInteger randomNum = arc4random()%6+5;
    
    NSString *string = [[NSString alloc]init];
    
    for (int i = 0; i < randomNum; i++) {
        
        int number = arc4random() % 36;
        if (number < 10) {
            int figure = arc4random() % 10;
            NSString *tempString = [NSString stringWithFormat:@"%d", figure];
            string = [string stringByAppendingString:tempString];
        }else {
            int figure = (arc4random() % 26) + 97;
            char character = figure;
            NSString *tempString = [NSString stringWithFormat:@"%c", character];
            string = [string stringByAppendingString:tempString];
        }
    }
    return string;
    
    
    
    
}


+ (UIImage*)setThumbnailFromImage:(UIImage*)image {
    
    CGSize originImageSize = image.size;
    
    CGRect newRect =CGRectMake(0,0,40,40);
    
    //根据当前屏幕scaling factor创建一个透明的位图图形上下文(此处不能直接从UIGraphicsGetCurrentContext获取,原因是UIGraphicsGetCurrentContext获取的是上下文栈的顶,在drawRect:方法里栈顶才有数据,其他地方只能获取一个nil.详情看文档)
    
    UIGraphicsBeginImageContextWithOptions(newRect.size,NO,0.0);
    
    //保持宽高比例,确定缩放倍数
    
    //(原图的宽高做分母,导致大的结果比例更小,做MAX后,ratio*原图长宽得到的值最小是40,最大则比40大,这样的好处是可以让原图在画进40*40的缩略矩形画布时,origin可以取=(缩略矩形长宽减原图长宽*ratio)/2 ,这样可以得到一个可能包含负数的origin,结合缩放的原图长宽size之后,最终原图缩小后的缩略图中央刚好可以对准缩略矩形画布中央)
    
    float ratio =MAX(newRect.size.width/ originImageSize.width, newRect.size.height/ originImageSize.height);
    
    //创建一个圆角的矩形UIBezierPath对象
    
    UIBezierPath*path = [UIBezierPath bezierPathWithRoundedRect:newRect cornerRadius:5.0];
    
    //用Bezier对象裁剪上下文
    
    [path addClip];
    
    //让image在缩略图范围内居中()
    
    CGRect projectRect;
    
    projectRect.size.width= originImageSize.width* ratio;
    
    projectRect.size.height= originImageSize.height* ratio;
    
    projectRect.origin.x= (newRect.size.width- projectRect.size.width) /2;
    
    projectRect.origin.y= (newRect.size.height- projectRect.size.height) /2;
    
    //在上下文中画图
    
    [image drawInRect:projectRect];
    
    //从图形上下文获取到UIImage对象,赋值给thumbnai属性
    
    UIImage*smallImg =UIGraphicsGetImageFromCurrentImageContext();
    
//    self.thumbnail= smallImg;
    
    //清理图形上下文(用了UIGraphicsBeginImageContext需要清理)
    
    UIGraphicsEndImageContext();
    
    
    return smallImg;
}

//必须在有网的情况下才能获取手机的IP地址
+ (NSString *)deviceIPAdress {
    NSString *address = @"an error occurred when obtaining ip address";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    success = getifaddrs(&interfaces);
    
    if (success == 0) { // 0 表示获取成功
        
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if( temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in  *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    freeifaddrs(interfaces);
    
    NSLog(@"手机的IP是：%@", address);
    
    return address;
}


@end






