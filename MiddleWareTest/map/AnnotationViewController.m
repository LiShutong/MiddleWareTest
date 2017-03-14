//
//  AnnotationViewController.m
//  BaiduMapMiddleWearDemo
//
//  Created by Daniel Bey on 06/01/.
//  Copyright © 2017 Daniel Bey. All rights reserved.
//

#import "AnnotationViewController.h"
#import <BaiduMapMiddleWear/BMMComponent.h>

extern BOOL isUseBaiduMap;

@implementation AnnotationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bmmMapView.delegate = self;
    [self initializePointAnnotation];
    [self.bmmMapView addAnnotation: _pointAnnotation];
    [self.bmmMapView addAnnotation: _pointAnnotation1];
    self.bmmMapView.centerCoordinate = _pointAnnotation.coordinate;
    //[self.bmmMapView setZoomLevel:10];
//    [self.bmmMapView bringAnnotationToFront:_pointAnnotation];
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 50)];
    btn.backgroundColor = [UIColor purpleColor];
    btn.alpha = 0.5;
    [btn addTarget:self action:@selector(btnclick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    //[self.bmmMapView selectAnnotation:_pointAnnotation animated:YES];
}

- (void) btnclick {
    //[self.bmmMapView setImage:[UIImage imageNamed:@"boat"] forAnnotation:_pointAnnotation];
//    if (_pointAnnotation ==nil) {
//        return;
//    }
//    [self.bmmMapView removeAnnotation:_pointAnnotation];
//    //[self.bmmMapView deselectAnnotation:_pointAnnotation animated:YES];
    BMKMapStatus* mapStatus = [[BMKMapStatus alloc] init];
    mapStatus.fOverlooking = -30;
    mapStatus.fRotation = 45;
    //mapStatus.fLevel = 0;
    mapStatus.targetGeoPt = CLLocationCoordinate2DMake(31.236799, 121.474775);
    mapStatus.targetScreenPt = CGPointMake(0, 0);
    [self.bmmMapView setMapStatus:mapStatus withAnimation:NO withAnimationTime:0];
    
}

- (void) initializePointAnnotation {
    _pointAnnotation = [[BMKPointAnnotation alloc] init];
    CLLocationCoordinate2D coor;
    coor.latitude = 39.915;
    coor.longitude = 116.404;
    _pointAnnotation.coordinate = coor;
    _pointAnnotation.title = @"我在北京1";
    
    _pointAnnotation1 = [[BMKPointAnnotation alloc] init];
    CLLocationCoordinate2D coor1;
    coor1.latitude = 1.358629;
    coor1.longitude = 103.80522;
    _pointAnnotation1.coordinate = coor1;
    _pointAnnotation1.title = @"我在新加坡1";
    _pointAnnotation1.subtitle =@"google";
}

/**
 *根据BMKAnnotation生成对应的View
 *重要：Baidu需返回的view是 BMKAnnotationView 对象，Apple需返回的view是 BMMAppleAnnotationView 对象
 *重要：使用Apple MapKit时，需要使用 - (instancetype)initWithBMKAnnotation:reuseIdentifier:; 方法初始化BMMAppleAnnotationView对象
 *@param mapView 地图View
 *@param annotation 指定的BMKAnnotation标注
 *@return 生成的标注View。 重要：Baidu需返回的view是 BMKAnnotationView 对象，Apple需返回的view是 BMMAppleAnnotationView 对象
 */
- (UIView *)mapView:(BMMMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation {
    UIImageView *iview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"boat"]];
    iview.contentMode = UIViewContentModeScaleToFill;
    iview.frame = CGRectMake(0, 0, 128, 48);
    NSString *AnnotationViewID = @"renameMark";
    if (isUseBaiduMap) {
        //判断是否使用百度地图，当使用百度地图时，建立BMKPinAnnotationView对象，使用百度SDK的方法初始化，最终返回的view是 BMKAnnotationView 对象；
        BMKPinAnnotationView *annotationView = (BMKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
        if (annotationView == nil) {
            annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
            // 设置颜色
            if (annotation == _pointAnnotation) {
                ((BMKPinAnnotationView*)annotationView).pinColor = BMKPinAnnotationColorPurple;
                //annotationView.paopaoView = [[BMKActionPaopaoView alloc] initWithCustomView:iview];
            } else {
                ((BMKPinAnnotationView*)annotationView).pinColor = BMKPinAnnotationColorRed;
            }
            // 从天上掉下效果
            ((BMKPinAnnotationView*)annotationView).animatesDrop = YES;
            // 设置可拖拽
            ((BMKPinAnnotationView*)annotationView).draggable = YES;
        }
        annotationView.image = [UIImage imageNamed:@"arrow"];
        annotationView.annotation = annotation;
        return annotationView;
    } else {
        //判断使用apple地图时，创建BMMAppleAnnotationView对象并进行初始化；
        BMKPinAnnotationView *googleView = (BMKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
        if (googleView == nil) {
           googleView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
            if (annotation == _pointAnnotation) {
                ((BMKPinAnnotationView*)googleView).pinColor = BMKPinAnnotationColorPurple;
                //googleView.paopaoView = [[BMKActionPaopaoView alloc] initWithCustomView:iview];
            } else {
                ((BMKPinAnnotationView*)googleView).pinColor = BMKPinAnnotationColorPurple;
            }
        }
        googleView.image = [UIImage imageNamed:@"arrow"];
        googleView.annotation = annotation;
        return googleView;
    }
}

/**
 *当选中一个annotation views时，调用此接口
 *重要：Baidu返回的view是 BMKAnnotationView 对象，Apple返回的view是 BMMAppleAnnotationView 对象
 *@param mapView 地图View
 *@param view 选中的annotation views。重要：Baidu返回的view是 BMKAnnotationView 对象，Apple返回的view是 BMMAppleAnnotationView 对象
 */
- (void)mapView:(BMMMapView *)mapView didSelectAnnotationView:(UIView *)view {
    UIImageView *iview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"boat"]];
    iview.contentMode = UIViewContentModeScaleToFill;
    iview.frame = CGRectMake(0, 0, 128, 48);
    BMKPinAnnotationView *googleView = (BMKPinAnnotationView*)view;
    BMKPointAnnotation *annotation = googleView.annotation;
    //[self.bmmMapView setPaopaoView:iview forAnnotationView:annotation];
    UIImage *image = [UIImage imageNamed:@"boat"];
    [self.bmmMapView setImage:image forAnnotation:annotation];
}


/**
 *当mapView新添加annotation views时，调用此接口
 *重要：Baidu返回的view是 BMKAnnotationView 对象，Apple返回的view是 BMMAppleAnnotationView 对象
 *@param mapView 地图View
 *@param views 新添加的annotation views。重要：Baidu返回的view是 BMKAnnotationView 对象，Apple返回的view是 BMMAppleAnnotationView 对象
 */
- (void)mapView:(BMMMapView *)mapView didAddAnnotationViews:(NSArray<UIView *> *)views {
    NSLog(@"Add a new annotationview in mapview,and the annotation is %@",views);
}

/**
 *当取消选中一个annotation views时，调用此接口
 *重要：Baidu返回的view是 BMKAnnotationView 对象，Apple返回的view是 BMMAppleAnnotationView 对象
 *@param mapView 地图View
 *@param view 取消选中的annotation views。重要：Baidu返回的view是 BMKAnnotationView 对象，Apple返回的view是 BMMAppleAnnotationView 对象
 */
- (void)mapView:(BMMMapView *)mapView didDeselectAnnotationView:(UIView *)view {
    NSLog(@"didDeselectAnnotationView: %@", view);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
