//
//  PoiSearchViewController.h
//  BaiduMapMiddleWearDemo
//
//  Created by Daniel Bey on 06/01/.
//  Copyright © 2017 Daniel Bey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface PoiSearchViewController : BaseViewController <BMMPoiSearchDelegate, BMMSuggestionSearchDelegate> {
    BMMPoiSearch *_poiSearch;
    BMMSuggestionSearch *_sugSearch;
}

- (IBAction)boundsPoiSearchAct:(UIButton *)sender;

- (IBAction)cityPoiSearchAct:(UIButton *)sender;
- (IBAction)sugSearchAct:(UIButton *)sender;

@end
