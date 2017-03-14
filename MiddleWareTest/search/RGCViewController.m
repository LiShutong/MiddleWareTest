//
//  RGCViewController.m
//  BaiduMapMiddleWearDemo
//
//  Created by Daniel Bey on 06/01/.
//  Copyright © 2017 Daniel Bey. All rights reserved.
//

#import "RGCViewController.h"
#import <BaiduMapMiddleWear/BMMComponent.h>

@interface RGCViewController ()
@end

extern BOOL isUseBaiduMap;

@implementation RGCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _rgcSearch = (BMMRGCSearch*)[BMMRGCSearch getInstance];
    _rgcSearch.delegate = self;
    self.bmmMapView.delegate = self;
    BMKReverseGeoCodeOption *option = [[BMKReverseGeoCodeOption alloc] init];
    if (isUseBaiduMap) {
        option.reverseGeoPoint = CLLocationCoordinate2DMake(39.916, 116.404);
    } else {
        option.reverseGeoPoint = CLLocationCoordinate2DMake(1.9019, 115.110966);
    }
    if (_rgcSearch) {
        BOOL ret = [_rgcSearch reverseGeoCode:option];
        NSLog(@"RGC请求发送的结果: %d", ret);
    }
}

- (void)onGetReverseGeoCodeResult:(BMMRGCSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error {
    if (error == BMK_SEARCH_NO_ERROR) {
        NSLog(@"response: error %d, BMKReverseGeoCodeResult: country: %@, province: %@, city: %@, district: %@, street: %@, streetNumber:%@, address: %@, lat: %f, lng: %f",
              error,
              result.addressDetail.country,
              result.addressDetail.province,
              result.addressDetail.city,
              result.addressDetail.district,
              result.addressDetail.streetName,
              result.addressDetail.streetNumber,
              
              result.address,
              result.location.latitude,
              result.location.longitude);
        
        for (BMKPoiInfo* poi in result.poiList) {
            NSLog(@"response pois: %@", poi.name);
        }
        NSString *rgcRet = [NSString stringWithFormat:@"address: %@, name: %@", result.address, ((BMKPoiInfo*)(result.poiList.firstObject)).name];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"RGC结果" message:rgcRet delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            [alertView show];
        });
        
    } else {
        NSLog(@"response errorcode: %d", error);
    }
}

@end
