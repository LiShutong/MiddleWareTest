//
//  OverlayViewController.m
//  BaiduMapMiddleWearDemo
//
//  Created by Daniel Bey on 06/01/.
//  Copyright © 2017 Daniel Bey. All rights reserved.
//

#import "OverlayViewController.h"

@interface OverlayViewController ()

@end
extern BOOL isUseBaiduMap;
@implementation OverlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bmmMapView.delegate = self;
    [self addOverlayView];
    self.bmmMapView.centerCoordinate = _polygon.coordinate;
    self.bmmMapView.zoomLevel = 10;
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 50)];
    btn.backgroundColor = [UIColor purpleColor];
    btn.alpha = 0.5;
    [btn addTarget:self action:@selector(btnclick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}
- (void) btnclick {
    
}

//添加内置覆盖物
- (void)addOverlayView {
    //添加多边形覆盖物
    if (_polygon == nil) {
        CLLocationCoordinate2D coords[4] = {0};
        coords[0].latitude = 39.915;
        coords[0].longitude = 116.404;
        coords[1].latitude = 39.815;
        coords[1].longitude = 116.404;
        coords[2].latitude = 39.815;
        coords[2].longitude = 116.504;
        coords[3].latitude = 39.915;
        coords[3].longitude = 116.504;
        _polygon = [BMKPolygon polygonWithCoordinates:coords count:4];
    }
    [self.bmmMapView addOverlay:_polygon];
    
    //添加多边形覆盖物
    if (_polygon2 == nil) {
        CLLocationCoordinate2D coords[5] = {0};
        coords[0].latitude = 39.965;
        coords[0].longitude = 116.604;
        coords[1].latitude = 39.865;
        coords[1].longitude = 116.604;
        coords[2].latitude = 39.865;
        coords[2].longitude = 116.704;
        coords[3].latitude = 39.905;
        coords[3].longitude = 116.654;
        coords[4].latitude = 39.965;
        coords[4].longitude = 116.704;
        _polygon2 = [BMKPolygon polygonWithCoordinates:coords count:5];
    }
    [self.bmmMapView addOverlay:_polygon2];

    //添加折线覆盖物
    if (_polyline == nil) {
        CLLocationCoordinate2D coords[5] = {0};
        coords[0].latitude = 39.965;
        coords[0].longitude = 116.404;
        coords[1].latitude = 39.925;
        coords[1].longitude = 116.454;
        coords[2].latitude = 39.955;
        coords[2].longitude = 116.494;
        coords[3].latitude = 39.905;
        coords[3].longitude = 116.554;
        coords[4].latitude = 39.965;
        coords[4].longitude = 116.604;
        _polyline = [BMKPolyline polylineWithCoordinates:coords count:5];
    }
    [self.bmmMapView addOverlay:_polyline];
}

/**
 *重要：Baidu Map:根据overlay生成对应的BMKOverlayView对象
 *重要：Apple MapKit:根据overlay生成对应的BMMApplePolylineRenderer对象 or BMMApplePolygonRenderer对象
 *重要：使用Apple MapKit时，目前仅支持polyline、polygon，必须返回BMMApplePolylineRenderer对象 or BMMApplePolygonRenderer对象
 *重要：使用Apple MapKit时，需要使用 - (instancetype)initWithBMKOverlay:(id <BMKOverlay>)overlay; 方法初始化BMMApplePolylineRenderer对象 or BMMApplePolygonRenderer对象
 *@param mapView 地图View
 *@param overlay 指定的BMKOverlay
 *@return 生成的BMKOverlayView对象(Baidu) or BMMApplePolylineRenderer对象(Apple) or BMMApplePolygonRenderer对象(Apple)
 */
- (id)mapView:(BMMMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay {
    if (isUseBaiduMap) {
        //使用百度地图，根据overlay生成对应的BMKPolylineView对象或BMKPolygonView对象，使用- (id)initWithOverlay:(id <BMKOverlay>)overlay; 方法初始化BMKPolylineView对象或BMKPolygonView对象；
        if ([overlay isKindOfClass:[BMKPolyline class]]) {
            BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
            polylineView.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:1];
            polylineView.lineWidth = 5.0;
            return polylineView;
        }
    
        if ([overlay isKindOfClass:[BMKPolygon class]]) {
            BMKPolygonView* polygonView = [[BMKPolygonView alloc] initWithOverlay:overlay];
            polygonView.strokeColor = [[UIColor alloc] initWithRed:0.0 green:0 blue:0.5 alpha:1];
            polygonView.fillColor = [[UIColor alloc] initWithRed:0 green:1 blue:1 alpha:0.2];
            polygonView.lineWidth = 2.0;
            polygonView.lineDash = (overlay == _polygon2);
            return polygonView;
        }
    } else {
        //使用google地图，根据overlay生成对应的BMMApplePolylineRenderer对象或BMMApplePolygonRenderer对象，- (instancetype)initWithBMKOverlay:(id <BMKOverlay>)overlay;  方法初始化BMMApplePolylineRenderer对象或BMMApplePolygonRenderer对象；
        if ([overlay isKindOfClass:[BMKPolygon class]]) {
            BMKPolygonView *googlePolygonRender =  [[BMKPolygonView alloc] initWithOverlay:overlay];
            googlePolygonRender.strokeColor = [UIColor orangeColor];
            googlePolygonRender.lineWidth = 3;
            googlePolygonRender.fillColor = [[UIColor cyanColor] colorWithAlphaComponent:0.5];
            return googlePolygonRender;
        }
        if ([overlay isKindOfClass:[BMKPolyline class]]) {
            BMKPolylineView *googlePolylineRender = [[BMKPolylineView alloc] initWithOverlay:overlay];
            googlePolylineRender.strokeColor = [UIColor redColor];
            googlePolylineRender.lineWidth = 3;
            return googlePolylineRender;
        }
    }
    
    return nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
