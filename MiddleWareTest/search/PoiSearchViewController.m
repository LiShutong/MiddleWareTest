//
//  PoiSearchViewController.m
//  BaiduMapMiddleWearDemo
//
//  Created by Daniel Bey on 06/01/.
//  Copyright © 2017 Daniel Bey. All rights reserved.
//

#import "PoiSearchViewController.h"
#import <BaiduMapMiddleWear/BMMComponent.h>

@interface PoiSearchViewController () {
    BMKBoundSearchOption *_boundsOption;
    BMKCitySearchOption *_cityOption;
    BMKSuggestionSearchOption *_sugOption;
}

@end

extern BOOL isUseBaiduMap;

@implementation PoiSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _poiSearch = (BMMPoiSearch*)[BMMPoiSearch getInstance];
    _poiSearch.delegate = self;
    _sugSearch = (BMMSuggestionSearch*)[BMMSuggestionSearch getInstance];
    _sugSearch.delegate = self;
    self.bmmMapView.delegate = self;
    _boundsOption = [[BMKBoundSearchOption alloc] init];
    _cityOption = [[BMKCitySearchOption alloc] init];
    _sugOption = [[BMKSuggestionSearchOption alloc] init];
    if (isUseBaiduMap) {
        _boundsOption.leftBottom = CLLocationCoordinate2DMake(40.047722, 116.31327);
        _boundsOption.rightTop = CLLocationCoordinate2DMake(40.057284, 116.34351);
        _boundsOption.keyword = @"餐馆";
        _cityOption.city = @"北京";
        _cityOption.keyword = @"购物";
        _sugOption.cityname = @"北京";
        _sugOption.keyword = @"肉夹馍";
    } else {
        _boundsOption.leftBottom = CLLocationCoordinate2DMake(1.344976, 103.812119);
        _boundsOption.rightTop = CLLocationCoordinate2DMake(1.379696, 103.848565);
        _boundsOption.keyword = @"coffee";
        _sugOption.keyword = @"coffee";
    }
}

// Bounds POI 检索
- (IBAction)boundsPoiSearchAct:(UIButton *)sender {
    BOOL ret = [_poiSearch poiSearchInbounds:_boundsOption];
    NSLog(@"Bounds POI 检索 请求发送结果: %d", ret);
}

// City POI 检索
- (IBAction)cityPoiSearchAct:(UIButton *)sender {
    BOOL ret = [_poiSearch poiSearchInCity:_cityOption];
    if (isUseBaiduMap) {
        NSLog(@"Baidu 地图 City POI 请求发送结果: %d", ret);
    } else {
        NSLog(@"Google地图不支持City POI检索，请求发送结果: %d", ret);
    }
}

// Sug 检索
- (IBAction)sugSearchAct:(UIButton *)sender {
    BOOL ret = [_sugSearch suggestionSearch:_sugOption];
    if (isUseBaiduMap) {
        NSLog(@"Baidu地图Sug检索 请求发送结果: %d", ret);
    } else {
        NSLog(@"Google地图Sug检索，请求发送结果: %d", ret);
    }
}

- (void)onGetPoiSearchResult:(BMMPoiSearch *)searcher result:(BMKPoiResult *)poiResult errorCode:(BMKSearchErrorCode)errorCode {
    if (errorCode != BMK_SEARCH_NO_ERROR || poiResult == nil) {
        NSLog(@"POI检索出错");
    }
    //移除已添加的标注
    //dispatch_async(dispatch_get_main_queue(), ^{
        //[self.bmmMapView removeAnnotations:self.bmmMapView.annotations];
        
    NSLog(@"totalPoiNum %d", poiResult.totalPoiNum);
    NSLog(@"currPoiNum %d", poiResult.currPoiNum);
    NSLog(@"pageNum %d", poiResult.pageNum);
    NSLog(@"pageIndex %d", poiResult.pageIndex);
    NSLog(@"poiInfoList: \n");
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.bmmMapView removeAnnotations:self.bmmMapView.annotations];
    });
    dispatch_group_t group = dispatch_group_create();
    for (BMKPoiInfo* poi in poiResult.poiInfoList) {
        NSLog(@"  poi name %@", poi.name);
        NSLog(@"  poi address %@", poi.address);
        NSLog(@"  poi city %@", poi.city);
        NSLog(@"  poi phone %@", poi.phone);
        NSLog(@"  poi pt lat:%f lon:%f", poi.pt.latitude, poi.pt.longitude);
        NSLog(@"  ");
        dispatch_group_enter(group);
        //将POI检索的结果用Annotation画在地图上
        BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
        item.coordinate = poi.pt;
        item.title = poi.name;
        item.subtitle = poi.address;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.bmmMapView addAnnotation:item];
            dispatch_group_leave(group);
        });
    }
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [self.bmmMapView showAnnotations:self.bmmMapView.annotations animated:YES];
    });
}

- (void)onGetSuggestionResult:(BMMSuggestionSearch *)searcher result:(BMMSuggestionSearchResult *)result errorCode:(BMKSearchErrorCode)error {
    if (error != BMK_SEARCH_NO_ERROR || result == nil) {
        NSLog(@"Sug检索结果出错");
    }
    
    //移除已添加的标注
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.bmmMapView removeAnnotations:self.bmmMapView.annotations];
    });
    NSLog(@"Sug检索的结果个数: %ld", (long)result.count);
    dispatch_group_t group = dispatch_group_create();
    for (BMMSuggestionInfo *info in result.list) {
        NSLog(@"key: %@", info.key);
        NSLog(@"city: %@", info.city);
        NSLog(@"district: %@", info.district);
        NSLog(@"poiID: %@", info.poiId);
        NSLog(@"coordinate: %f, %f", info.pt.latitude, info.pt.longitude);
        if (info.pt.latitude == 0 || info.pt.longitude == 0) {
            NSLog(@"没有经纬度");
            continue;
        }
        dispatch_group_enter(group);
        //将SUG检索的结果用Annotation画在地图上
        BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
        item.coordinate = info.pt;
        item.title = info.key;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.bmmMapView addAnnotation:item];
            dispatch_group_leave(group);
        });
    }
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [self.bmmMapView showAnnotations:self.bmmMapView.annotations animated:YES];
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

@end
