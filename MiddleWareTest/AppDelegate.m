
//
//  AppDelegate.m
//  BaiduMapMiddleWearDemo
//
//  Created by Daniel Bey on 06/01/.
//  Copyright © 2017 Daniel Bey. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <GoogleMaps/GoogleMaps.h>
//#import <AMapFoundationKit/AMapFoundationKit.h>
#import "RootViewController.h"
@import GooglePlaces;

BOOL isUseBaiduMap = YES;
BMKMapManager *_mapManager;

NSString *APIKEY = @"AIzaSyBk0OMVmG-W6flRc6ftwoc3Tr1ryi2VN4w";

const static NSString *GaoDeAPIKey = @"7d813ad90284c1397194f13b01273763";

@interface AppDelegate ()

@end

@implementation AppDelegate

@synthesize window;
@synthesize navigationController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //设置百度地图SDK中所有用到的经纬度均为国测局
    [BMKMapManager setCoordinateTypeUsedInBaiduMapSDK:BMK_COORDTYPE_COMMON];
    _mapManager = [[BMKMapManager alloc] init];
    BOOL ret = [_mapManager start:@"3hvdNYmDOG22K6H6l0FQyVGD1QG6FD48" generalDelegate:self];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    //配置Google地图的密钥
    [GMSServices provideAPIKey:APIKEY];
    [GMSServices sharedServices];
    [GMSPlacesClient provideAPIKey:APIKEY];
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    RootViewController *rootViewController = (RootViewController*)[storyBoard instantiateViewControllerWithIdentifier:@"RootViewController"];
    navigationController = [[UINavigationController alloc] initWithRootViewController:rootViewController];
    ViewController *viewController = [[ViewController alloc] init];
    [window setRootViewController:navigationController];
    [window makeKeyAndVisible];
    
    //配置高德地图的密匙
    //[self configureAPIKey];
    
    return YES;
}
//
//- (void)configureAPIKey
//{
//    if ([GaoDeAPIKey length] == 0)
//    {
//        NSString *reason = [NSString stringWithFormat:@"apiKey为空，请检查key是否正确设置。"];
//        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:reason delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        
//        [alert show];
//    }
//    
//    [AMapServices sharedServices].apiKey = (NSString *)GaoDeAPIKey;
//}

- (void)onGetNetworkState:(int)iError {
    if (0 == iError) {
        NSLog(@"联网成功");
    } else{
        NSLog(@"onGetNetworkState %d",iError);
    }
    
}

- (void)onGetPermissionState:(int)iError {
    if (0 == iError) {
        NSLog(@"授权成功");
    } else {
        NSLog(@"onGetPermissionState %d",iError);
    }
}


@end
