//
//  AppDelegate.h
//  MiddleWareTest
//
//  Created by wzy on 17/1/1.
//  Copyright © 2017年 baidu. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapMiddleWear/BMMComponent.h>




@interface AppDelegate : UIResponder <UIApplicationDelegate, BMKGeneralDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navigationController;

@end



