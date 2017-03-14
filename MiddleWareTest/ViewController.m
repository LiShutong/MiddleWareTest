//
//  ViewController.m
//  MiddleWareTest
//
//  Created by wzy on 17/1/1.
//  Copyright © 2017年 baidu. All rights reserved.
//


#import "ViewController.h"
#import <BaiduMapMiddleWear/BMMComponent.h>
#import <MapKit/MapKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>


static NSString *const kAPIKey = @"AIzaSyBk0OMVmG-W6flRc6ftwoc3Tr1ryi2VN4w";

@interface ViewController ()<BMMMapViewDelegate> {
    BMMMapView *_bmmMapView;
    BOOL isUsedBaidu;
    CLLocationManager *_locationManage;
    id _services;

    BMKPolyline *polyline;
    BMKPolygon *polygon;
    NSMutableArray* annotaions;

}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    isUsedBaidu = NO;
    if (isUsedBaidu == NO) {
        [BMMBase setCountryCode:1];
    }
    [GMSServices provideAPIKey:kAPIKey];
    _services = [GMSServices sharedServices];
    _bmmMapView = (BMMMapView*)[BMMMapView getInstance];
    _bmmMapView.delegate = self;
    UIView *innerMapView = [_bmmMapView getInnerMapView];
    innerMapView.frame = self.view.frame;
    [self.view addSubview:innerMapView];
    [self.view sendSubviewToBack:innerMapView];
 
    _locationManage = [[CLLocationManager alloc] init];
    [_locationManage requestAlwaysAuthorization];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (IBAction)button1Action:(id)sender {
    [_bmmMapView setRotation:30];
    CLLocationDegrees latitude = 12;
    CLLocationDegrees longitude = 120;
    NSLog(@"google rotation : %d", _bmmMapView.rotation);
    [_bmmMapView setCenterCoordinate:CLLocationCoordinate2DMake(latitude, longitude) animated:YES];
    [_bmmMapView setOverlooking:-45];
    NSLog(@"google rotation : %d", _bmmMapView.rotation);
    NSLog(@"google coordination : %f, %f", _bmmMapView.centerCoordinate.latitude, _bmmMapView.centerCoordinate.longitude);
    NSLog(@"google overlooking : %d", _bmmMapView.overlooking);
    [_bmmMapView setZoomLevel:10];
    NSLog(@"google zoomlevel: %f", _bmmMapView.zoomLevel);
    BMKMapRect rect = [_bmmMapView visibleMapRect];
    NSLog(@"google origin: x %f, y %f, height %f, width %f", rect.origin.x, rect.origin.y, rect.size.height, rect.size.width);
    BMKCoordinateRegion region = [_bmmMapView region];
    NSLog(@"google origin: x %f, y %f, height %f, width %f", region.center.latitude, region.center.longitude, region.span.latitudeDelta, region.span.longitudeDelta);
    BMKMapRect rect_1;
    rect_1.origin.x = 19849647;
    rect_1.origin.y = 33959610;
    rect_1.size.height = 164687;
    rect_1.size.width = -24591;
    [_bmmMapView setVisibleMapRect:rect_1 animated:YES];
}

- (IBAction)button2Action:(id)sender {
    BMKMapStatus* mapStatus = [[BMKMapStatus alloc] init];
    mapStatus.fOverlooking = 0;
    mapStatus.fRotation = 30;
    mapStatus.fLevel = 10;
    mapStatus.targetGeoPt = CLLocationCoordinate2DMake(31.236799, 121.474775);
    //mapStatus.targetScreenPt = CGPointMake(0, 0);
    [_bmmMapView setMapStatus:mapStatus withAnimation:NO withAnimationTime:10];
}

- (IBAction)button3Action:(id)sender {
    
    BMKPointAnnotation *boat;
    
    boat = [[BMKPointAnnotation alloc] init];
    boat.title      = @"hello";
    boat.subtitle = @"hot";
    boat.coordinate = CLLocationCoordinate2DMake(49.081241,3.092350);

    annotaions = [NSMutableArray array];
    [annotaions addObject:boat];
    [_bmmMapView addAnnotations:annotaions];
    //[_bmmMapView removeAnnotations:annotaions];
    
    BMKCoordinateBounds bounds;
    bounds.northEast.latitude = 1;
    bounds.northEast.longitude = 2;
    bounds.southWest.latitude = 0;
    bounds.southWest.longitude = 0;
    [_bmmMapView annotationsInCoordinateBounds:bounds];
    BMKCoordinateBounds bounds_1;
    bounds_1.northEast.latitude = 49.091241;
    bounds_1.northEast.longitude = 3.192350;
    bounds_1.southWest.latitude = 49.071241;
    bounds_1.southWest.longitude = 3.072350;
    [_bmmMapView annotationsInCoordinateBounds:bounds_1];
    
}

- (IBAction)button4Action:(id)sender {
    NSMutableArray<id<BMKOverlay>>* overlays = [NSMutableArray array];
    CLLocationCoordinate2D coords[10] = {0};
    coords[0].latitude = 45.003372;
    coords[0].longitude = -7.184460;
    
    coords[1].latitude = 30.040223;
    coords[1].longitude = 2.527454;
    
    coords[2].latitude = 36.641661;
    coords[2].longitude = -0.551986;
    
    polyline = [BMKPolyline polylineWithCoordinates:coords count:3];
    [overlays addObject:polyline];
    {
        CLLocationCoordinate2D coords[10] = {0};
        coords[0].latitude = 56.607496;
        coords[0].longitude = -3.759995;
    
        coords[1].latitude = 51.151342;
        coords[1].longitude = -1.123276;
    
        coords[2].latitude = 46.919772;
        coords[2].longitude = -0.551986;
    
        coords[3].latitude = 49.123756;
        coords[3].longitude = 11.049575;
    
        coords[4].latitude = 56.607496;
        coords[4].longitude = -3.759995;
        polygon = [BMKPolygon polygonWithCoordinates:coords count:5];
        [overlays addObject:polygon];
        
    }
    [_bmmMapView addOverlays:overlays];
    
}
- (IBAction)button5Action:(UIButton *)sender {
    if (polygon != nil) {
        [_bmmMapView removeOverlay:polygon];
        polygon = nil;
    }
    /* show Annotations */
    NSMutableArray* annotations = [NSMutableArray array];
    BMKPointAnnotation *boat;
    
    boat = [[BMKPointAnnotation alloc] init];
    boat.title      = @"hello";
    boat.subtitle = @"hot";
    boat.coordinate = CLLocationCoordinate2DMake(49.081241,3.092350);
    [annotations addObject:boat];
    [_bmmMapView addAnnotations:annotations];
    [_bmmMapView showAnnotations:annotations animated:true];
}

- (void)mapView:(BMMMapView *)mapView onClickedMap:(CLLocationCoordinate2D)coordinate {
    NSLog(@"tap map  --- lat: %lf, lon: %lf", coordinate.latitude, coordinate.longitude);
}

- (void)mapView:(BMMMapView *)mapView regionWillChangeAnimated:(BOOL)animated byUser:(BOOL)wasUserAction {
    NSLog(@"regionWillChangeAnimated  %d", wasUserAction);
}

- (void)mapView:(BMMMapView *)mapView regionDidChangeAnimated:(BOOL)animated byUser:(BOOL)wasUserAction {
    NSLog(@"regionDidChangeAnimated  %d", wasUserAction);
}

// 根据anntation生成对应的View
- (UIView *)mapView:(BMMMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    NSString *AnnotationViewID = @"renameMark";
    UIImageView *iview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"boat"]];
    iview.contentMode = UIViewContentModeScaleToFill;
    iview.frame = CGRectMake(0, 0, 128, 48);
    if (TRUE) {
        BMKPinAnnotationView *newAnnotation1 = (BMKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
        if (newAnnotation1 == nil) {
            NSLog(@"newAnnotation is nil");
            newAnnotation1 = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
            // 设置颜色
            ((BMKPinAnnotationView*)newAnnotation1).pinColor = BMKPinAnnotationColorPurple;
            // 从天上掉下效果
            ((BMKPinAnnotationView*)newAnnotation1).animatesDrop = YES;
            newAnnotation1.paopaoView = [[BMKActionPaopaoView alloc] initWithCustomView:iview];
            newAnnotation1.image = [UIImage imageNamed:@"boat"];
            // 设置可拖拽
            ((BMKPinAnnotationView*)newAnnotation1).draggable = YES;
        }
        newAnnotation1.annotation = annotation;
        NSLog(@"view for annotaion");
        return newAnnotation1;
    }
    return nil;
}

//根据overlay生成对应的View
- (id)mapView:(BMMMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay
{
    NSLog(@"viewForOverlay:  %@", overlay);
    if (TRUE) {
        if ([overlay isKindOfClass:[BMKPolyline class]])
        {
            BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
            polylineView.strokeColor = [UIColor redColor];
            polylineView.lineWidth = 8;
            NSLog(@"viewForOverlay:  %@", overlay);
            return polylineView;
        }
        if ([overlay isKindOfClass:[BMKPolygon class]])
        {
            NSLog(@"viewForOverlay:  %@", overlay);
            BMKPolygonView* polygonView = [[BMKPolygonView alloc] initWithOverlay:overlay];
            polygonView.strokeColor = [[UIColor redColor] colorWithAlphaComponent:1];
            polygonView.fillColor = [[UIColor cyanColor] colorWithAlphaComponent:0.5];
            polygonView.lineWidth = 5.0;
            [polygonView loadStrokeTextureImage:[UIImage imageNamed:@"arrowTexture.png" ]];
            return polygonView;
        }
    }
    
    return nil;
}

/**
 *当mapView新添加annotation views时，调用此接口
 *@param mapView 地图View
 *@param views 新添加的annotation views
 */
- (void)mapView:(BMMMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    NSLog(@"didAddAnnotationViews:  %@", views);
}

/**
 *当选中一个annotation views时，调用此接口
 *@param mapView 地图View
 *@param view 选中的annotation views
 */
- (void)mapView:(BMMMapView *)mapView didSelectAnnotationView:(UIView *)view {
    NSLog(@"didSelectAnnotationView:  %@", view);
}


/**
 *当取消选中一个annotation views时，调用此接口
 *@param mapView 地图View
 *@param view 取消选中的annotation views
 */
- (void)mapView:(BMMMapView *)mapView didDeselectAnnotationView:(UIView *)view {
    NSLog(@"didDeselectAnnotationView:  %@", view);
}




@end
