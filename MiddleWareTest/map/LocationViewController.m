//
//  LocationViewController.m
//  BaiduMapMiddleWearDemo
//
//  Created by wzy on 17/1/8.
//  Copyright © 2017年 Daniel Bey. All rights reserved.
//

#import "LocationViewController.h"
#import <BaiduMapAPI_Location/BMKLocationComponent.h>

extern BOOL isUseBaiduMap;

@interface LocationViewController ()<BMKLocationServiceDelegate,CLLocationManagerDelegate> {
    BMKLocationService* _locService;
    CLLocationManager *_locationManage;
}

@end

@implementation LocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _locationManage = [[CLLocationManager alloc] init];
    [_locationManage requestAlwaysAuthorization];
    
    //使用百度地图时，需要自己定位，并更新地图
    if (isUseBaiduMap) {
        _locService = [[BMKLocationService alloc] init];
        _locService.delegate = self;
        [_locService startUserLocationService];
        
        BMKLocationViewDisplayParam *locationViewWithParam = [[BMKLocationViewDisplayParam alloc] init];
        locationViewWithParam.accuracyCircleFillColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.5];
        locationViewWithParam.accuracyCircleFillColor = [UIColor colorWithRed:0 green:1 blue:0 alpha:0.3];
        [self.bmmMapView updateLocationViewWithParam:locationViewWithParam];
    }
    
    self.bmmMapView.showsUserLocation = YES;//显示定位图层
    self.bmmMapView.userTrackingMode = BMKUserTrackingModeFollowWithHeading;//设置定位的状态
}

#pragma mark - BMKLocationServiceDelegate

/**
 *在地图View将要启动定位时，会调用此函数
 */
- (void)willStartLocatingUser
{
    NSLog(@"start locate");
}

/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    [self.bmmMapView updateLocationData:userLocation];
//    NSLog(@"heading is %@",userLocation.heading);
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    //    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    [self.bmmMapView updateLocationData:userLocation];
}

/**
 *在地图View停止定位后，会调用此函数
 */
- (void)didStopLocatingUser
{
    NSLog(@"stop locate");
}

/**
 *定位失败后，会调用此函数
 *@param error 错误号，参考CLError.h中定义的错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"location error");
}



@end
