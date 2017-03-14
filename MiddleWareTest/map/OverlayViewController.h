//
//  OverlayViewController.h
//  BaiduMapMiddleWearDemo
//
//  Created by Daniel Bey on 06/01/.
//  Copyright © 2017 Daniel Bey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import <BaiduMapMiddleWear/BMMComponent.h>
#import <MapKit/MapKit.h>


@interface OverlayViewController :BaseViewController {
    BMKPolygon *_polygon;
    BMKPolygon *_polygon2;
    BMKPolyline *_polyline;
}

@end
