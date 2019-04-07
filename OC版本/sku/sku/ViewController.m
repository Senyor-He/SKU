//
//  ViewController.m
//  sku
//
//  Created by Ricky on 2019/4/7.
//  Copyright © 2019 Ricky. All rights reserved.
//

#import "ViewController.h"
#import "GoodsSpecWindow.h"

@interface ViewController ()

@property (nonatomic ,strong)GoodsSpecWindow * specWindow;//!<规格弹窗

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)showSpecWindow:(id)sender {
    NSString * path = [[NSBundle mainBundle]pathForResource:@"dataSource" ofType:@"txt"];
    NSString * string = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSData * data = [string dataUsingEncoding:NSUTF8StringEncoding];
    id obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSDictionary * result = obj[@"result"];
    //显示规格弹窗
    if (_specWindow == nil) {
        [[UIApplication sharedApplication].keyWindow addSubview:self.specWindow];
    }
    self.specWindow.attributeList = result[@"attributeList"];
    self.specWindow.skuData = result[@"skuData"];
    [self.specWindow showWindow];
}

- (GoodsSpecWindow *)specWindow
{
    if (_specWindow == nil) {
        _specWindow = [[GoodsSpecWindow alloc]initWithViewHeight:reallySize(920)];
    }
    return _specWindow;
}

@end
