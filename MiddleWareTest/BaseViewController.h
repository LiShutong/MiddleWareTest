//
//  BaseViewController.h
//  BaiduMapMiddleWearDemo
//
//  Created by Daniel Bey on 06/01/.
//  Copyright © 2017 Daniel Bey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapMiddleWear/BMMComponent.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>

@interface BaseViewController : UIViewController<BMMMapViewDelegate>

@property (nonatomic, strong) BMMMapView *bmmMapView;

@end
