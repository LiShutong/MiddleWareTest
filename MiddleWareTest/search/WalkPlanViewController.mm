//
//  WalkPlanViewController.m
//  BaiduMapMiddleWearDemo
//
//  Created by Daniel Bey on 06/01/.
//  Copyright © 2017 Daniel Bey. All rights reserved.
//

#import "WalkPlanViewController.h"
#import <BaiduMapMiddleWear/BMMComponent.h>

@interface WalkPlanViewController ()
@end

extern BOOL isUseBaiduMap;

@implementation WalkPlanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _routeSearch = (BMMRoutePlanSearch*)[BMMRoutePlanSearch getInstance];
    _routeSearch.delegate = self;
    self.bmmMapView.delegate = self;
    BMKPlanNode *start = [[BMKPlanNode alloc] init];
    BMKPlanNode *end = [[BMKPlanNode alloc] init];
    if (isUseBaiduMap) {
        start.pt = CLLocationCoordinate2DMake(40.047392, 116.312226);//奎科大厦
        end.pt = CLLocationCoordinate2DMake(40.038108, 116.326438);//上地地铁站
    } else {
        start.pt = CLLocationCoordinate2DMake(1.358629, 103.80522);
        end.pt = CLLocationCoordinate2DMake(1.353204, 103.796363);
    }
    BMKWalkingRoutePlanOption *walkingOption = [[BMKWalkingRoutePlanOption alloc] init];
    walkingOption.from = start;
    walkingOption.to = end;
    [_routeSearch walkingSearch:walkingOption];
}

- (void)onGetWalkingRouteResult:(BMMRoutePlanSearch *)searcher result:(BMKWalkingRouteResult *)result errorCode:(BMKSearchErrorCode)error {
    if (error != BMK_SEARCH_NO_ERROR) {
        NSLog(@"步行路线规划有错误");
        return;
    }
    //[self.bmmMapView removeAnnotations:self.bmmMapView.annotations];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        BMKWalkingRouteLine* plan = (BMKWalkingRouteLine*)[result.routes objectAtIndex:0];
        BMKPointAnnotation *startAnnotation = [[BMKPointAnnotation alloc] init];
        startAnnotation.coordinate = plan.starting.location;
        startAnnotation.title = @"起点";
        BMKPointAnnotation *endAnnotation = [[BMKPointAnnotation alloc] init];
        endAnnotation.coordinate = plan.terminal.location;
        endAnnotation.title = @"终点";
        [self.bmmMapView addAnnotation:startAnnotation];
        [self.bmmMapView addAnnotation:endAnnotation];
        
        NSInteger size = [plan.steps count];
        int planPointCounts = 0;
        for (int i = 0; i < size; i++) {
            BMKWalkingStep* transitStep = [plan.steps objectAtIndex:i];
            //轨迹点总数累计
            planPointCounts += transitStep.pointsCount;
        }
        
        //轨迹点
        BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts];
        int i = 0;
        for (int j = 0; j < size; j++) {
            BMKWalkingStep* transitStep = [plan.steps objectAtIndex:j];
            int k=0;
            for(k=0;k<transitStep.pointsCount;k++) {
                temppoints[i].x = transitStep.points[k].x;
                temppoints[i].y = transitStep.points[k].y;
                i++;
            }
        }

        // 通过points构建BMKPolyline
        BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
        [self.bmmMapView addOverlay:polyLine]; // 添加路线overlay
        delete []temppoints;
        [self mapViewFitPolyLine:polyLine];
        
    });
    
    
}


// 标注的代理方法
- (UIView *)mapView:(BMMMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation {
    NSString *AnnotationViewID = @"renameMark";
    BMKPinAnnotationView *annotationView = (BMKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    if (annotationView == nil) {
        annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        // 设置颜色
        annotationView.pinColor = BMKPinAnnotationColorPurple;
    }
    annotationView.annotation = annotation;
    return annotationView;
}

//覆盖物的代理方法
- (id)mapView:(BMMMapView *)mapView viewForOverlay:(id<BMKOverlay>)overlay {
    if (![overlay isKindOfClass:[BMKPolyline class]]) {
        return nil;
    }
    if (isUseBaiduMap) {
        BMKPolylineView *polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.strokeColor = [UIColor blueColor];
        polylineView.lineWidth = 3.0;
        return polylineView;
    } else {
        BMMApplePolylineRenderer *polylineView = [[BMMApplePolylineRenderer alloc] initWithBMKOverlay:overlay];
        polylineView.strokeColor = [UIColor blueColor];
        polylineView.lineWidth = 3.0;
        return polylineView;
    }
    
    return nil;
}

//根据polyline设置地图范围
- (void)mapViewFitPolyLine:(BMKPolyline *) polyLine {
    CGFloat ltX, ltY, rbX, rbY;
    if (polyLine.pointCount < 1) {
        return;
    }
    BMKMapPoint pt = polyLine.points[0];
    ltX = pt.x, ltY = pt.y;
    rbX = pt.x, rbY = pt.y;
    for (int i = 1; i < polyLine.pointCount; i++) {
        BMKMapPoint pt = polyLine.points[i];
        if (pt.x < ltX) {
            ltX = pt.x;
        }
        if (pt.x > rbX) {
            rbX = pt.x;
        }
        if (pt.y > ltY) {
            ltY = pt.y;
        }
        if (pt.y < rbY) {
            rbY = pt.y;
        }
    }
    BMKMapRect rect;
    BMKMapPoint origin = {ltX, ltY};
    rect.origin = origin;
    BMKMapSize size = {rbX - ltX, rbY - ltY};
    rect.size = size;
    
    [self.bmmMapView setVisibleMapRect:rect animated:YES];
}

@end
