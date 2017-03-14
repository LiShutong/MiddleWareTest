//
//  BaseViewController.m
//  BaiduMapMiddleWearDemo
//
//  Created by Daniel Bey on 06/01/.
//  Copyright © 2017 Daniel Bey. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController () {
    BMKCoordinateRegion originRegion;
}

@end

extern BOOL isUseBaiduMap;

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (isUseBaiduMap) {
        [BMMBase setCountryCode:0];
    } else {
        [BMMBase setCountryCode:1];
    }
    self.bmmMapView = (BMMMapView*)[BMMMapView getInstance];
    self.bmmMapView.delegate = self;
    UIView *innerMapView = [self.bmmMapView getInnerMapView];
    innerMapView.frame = self.view.frame;
    [self.view addSubview:innerMapView];
    [self.view sendSubviewToBack:innerMapView];
    
    if (isUseBaiduMap == NO) {
        //使用的是Apple MapKit需要自己使用手势处理地图缩放，以确保缩放时，地图中心点不变
        self.bmmMapView.zoomEnabled = NO;
        
        //add pinch gesture
        UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGestureAction:)];
        [innerMapView addGestureRecognizer:pinchGesture];
        
        //add double tap gesture
        UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapGestureAction:)];
        doubleTapGesture.numberOfTapsRequired = 2;
        [innerMapView addGestureRecognizer:doubleTapGesture];
    }
}

#pragma mark - 手势处理

- (void)pinchGestureAction:(UIPinchGestureRecognizer*) gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        originRegion = self.bmmMapView.region;
    }
    [self setRegionWithScale:gesture.scale animated:NO];
}

- (void)doubleTapGestureAction:(UITapGestureRecognizer*) gesture {
    if (gesture.state == UIGestureRecognizerStateEnded) {
        originRegion = self.bmmMapView.region;
        [self setRegionWithScale:2 animated:YES];
    }
}

- (void)setRegionWithScale:(CGFloat) scale animated:(BOOL) animated {
    CGFloat latDelta = originRegion.span.latitudeDelta / scale;
    CGFloat lonDelta = originRegion.span.longitudeDelta / scale;
    BMKCoordinateRegion region = BMKCoordinateRegionMake(originRegion.center, BMKCoordinateSpanMake(latDelta, lonDelta));
    [self.bmmMapView setRegion:region animated:animated];
}

@end
