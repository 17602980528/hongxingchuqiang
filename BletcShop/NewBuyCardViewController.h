//
//  NewBuyCardViewController.h
//  BletcShop
//
//  Created by apple on 16/11/16.
//  Copyright © 2016年 bletc. All rights reserved.
//

#import <UIKit/UIKit.h>
enum OrderTypes{
    points,//红包
    Wares,//商户优惠券
    plat_Ware//平台优惠券
};
@interface NewBuyCardViewController : UIViewController
@property (nonatomic,retain)UITableView *myTable;

@property (nonatomic,retain)NSString *moneyString;
@property int orderInfoType;//1-买卡  2-续卡 3-充值 4-升级
@property enum OrderTypes Type;

@property (nonatomic,retain)NSString *allPoint;
@property int canUsePoint;
@property (nonatomic,retain)NSString *userCouponPrice;
@property (nonatomic,retain)UILabel *contentLabel;

@property (nonatomic , strong) NSDictionary *coup_dic;// 优惠券信息

@property (nonatomic , strong) NSDictionary *plat_coup_dic;// 平台优惠券信息

@property (nonatomic , strong) NSDictionary *card_dic;// 卡的信息
@property(nonatomic,strong)NSArray *cardListArray;

//@property(nonatomic,copy)NSString *pay_Type;

@property (nonatomic,copy)NSString *shop_name;// 店名
@property(nonatomic) NSInteger selectRow;
@end
