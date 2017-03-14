//
//  AnnotationViewController.h
//  BaiduMapMiddleWearDemo
//
//  Created by Daniel Bey on 06/01/.
//  Copyright © 2017 Daniel Bey. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <BaiduMapMiddleWear/BMMComponent.h>
#import <MapKit/MapKit.h>
#import "BaseViewController.h"


@interface AnnotationViewController : BaseViewController {
    
    BMKPointAnnotation *_pointAnnotation;
    BMKPointAnnotation *_pointAnnotation1;
}

@end
