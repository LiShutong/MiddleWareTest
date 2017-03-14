//
//  WalkPlanViewController.h
//  BaiduMapMiddleWearDemo
//
//  Created by Daniel Bey on 06/01/.
//  Copyright © 2017 Daniel Bey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface WalkPlanViewController : BaseViewController <BMMRoutePlanSearchDelegate> {
    BMMRoutePlanSearch *_routeSearch;
}


@end
