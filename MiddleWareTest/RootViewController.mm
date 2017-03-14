//
//  RootViewController.mm
//  BaiduMapMiddleWearDemo
//
//  Created by Daniel Bey on 06/01/.
//  Copyright © 2017 Daniel Bey. All rights reserved.
//

#import "RootViewController.h"

extern BOOL isUseBaiduMap;
@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _demoNameArray = [[NSArray alloc]initWithObjects:
                      @"基本地图功能",
                      @"Annotation功能",
                      @"Overlay绘制",
                      @"定位功能",
                      @"POI搜索功能",
                      @"RGC功能",
                      @"步行路线规划功能",
                      nil];
    _viewControllerArray = [[NSArray alloc]initWithObjects:
                            @"BaseMapViewController",
                            @"AnnotationViewController",
                            @"OverlayViewController",
                            @"LocationViewController",
                            @"PoiSearchViewController",
                            @"RGCViewController",
                            @"WalkPlanViewController",
                            nil];
    self.title = @"百度地图中间件DEMO";
    
    // 设置使用Baidu地图还是Apple地图
    NSArray *segmentedArray = [NSArray arrayWithObjects:@"Baidu",@"Google",nil];
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]initWithItems:segmentedArray];
    segmentedControl.frame = CGRectMake(0, 0, 100, 30);
    segmentedControl.selectedSegmentIndex = 0;
    segmentedControl.tintColor = [UIColor colorWithRed:0/255.0 green:0/255.0  blue:0/255.0  alpha:0.7];
    [segmentedControl addTarget:self action:@selector(indexDidChangeForSegmentedControl:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:segmentedControl];
}

- (void)indexDidChangeForSegmentedControl:(UISegmentedControl *)segment {
    isUseBaiduMap = segment.selectedSegmentIndex == 0;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _demoNameArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"BaiduMapApiDemoCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [_demoNameArray objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:[_viewControllerArray objectAtIndex:indexPath.row]];
    viewController.title = [_demoNameArray objectAtIndex:indexPath.row];
    UIBarButtonItem *customLeftBarButtonItem = [[UIBarButtonItem alloc] init];
    customLeftBarButtonItem.title = @"返回";
    
    self.navigationItem.backBarButtonItem = customLeftBarButtonItem;
    [self.navigationController pushViewController:viewController animated:YES];
}


@end
