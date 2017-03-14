//
//  BaseMapViewController.m
//  BaiduMapMiddleWearDemo
//
//  Created by Daniel Bey on 06/01/.
//  Copyright © 2017 Daniel Bey. All rights reserved.
//

#import "BaseMapViewController.h"

@implementation BaseMapViewController

/**
 *地图区域改变完成后会调用此接口
 *@param mapView 地图View
 *@param animated 是否动画
 *@param wasUserAction 是否用户行为
 */
- (void)mapView:(BMMMapView *)mapView regionDidChangeAnimated:(BOOL)animated byUser:(BOOL)wasUserAction {
    if (wasUserAction) {
        NSLog(@"region did change animated by user.");
    } else {
        NSLog(@"region did change animated by program.");
    }
}


/**
 *地图区域即将改变时会调用此接口
 *@param mapView 地图View
 *@param animated 是否动画
 *@param wasUserAction 是否用户行为
 */
- (void)mapView:(BMMMapView *)mapView regionWillChangeAnimated:(BOOL)animated byUser:(BOOL) wasUserAction {
    if (wasUserAction) {
        NSLog(@"region will change animated by user.");
    } else {
        NSLog(@"region will change animated by program.");
    }

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bmmMapView.delegate = self;
    [self.regionChangeBtn addTarget:self action:@selector(regionChangeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    CLLocationCoordinate2D coor;
    coor.latitude = 39.915;
    coor.longitude = 116.404;
    self.bmmMapView.centerCoordinate = coor;
    self.bmmMapView.zoomLevel = 18;
}
- (void)regionChangeBtnClick {
    
    BMKMapStatus* mapStatus = [[BMKMapStatus alloc] init];
    mapStatus.fOverlooking = 0;
    mapStatus.fRotation = 30;
    mapStatus.fLevel = 17;
    mapStatus.targetGeoPt = CLLocationCoordinate2DMake(1.358629, 103.80522);
    mapStatus.targetScreenPt = CGPointMake(0, 0);
    [self.bmmMapView setMapStatus:mapStatus withAnimation:NO withAnimationTime:10];
//    if (self.bmmMapView.zoomLevel <= 20) {
//        self.bmmMapView.zoomLevel ++ ;
//    }
}

@end

