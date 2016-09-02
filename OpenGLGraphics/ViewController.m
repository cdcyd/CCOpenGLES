//
//  ViewController.m
//  OpenGLGraphics
//
//  Created by wsk on 16/8/4.
//  Copyright © 2016年 cyd. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>

@interface ViewController ()
@property(nonatomic, strong)NSArray *dataSource;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource = @[@[@"TriangleGLSLViewController.三角形  GLSL",
                          @"TriangleAnimationGLSLViewController.三角形Animation  GLSL",
                          @"QuadrilateralGLSLViewController.四边形  GLSL",
                          @"TextureGLSLViewController.纹    理  GLSL"],
                        @[@"TriangleViewController.三角形  GLKit",
                          @"TriangleAnimationViewController.三角形Animation  GLKit",
                          @"QuadrilateralViewController.四边形  GLKit",
                          @"TextureViewController.纹    理  GLKit"]];
    [[UITableViewHeaderFooterView appearance] setTintColor:[UIColor colorWithRed:0xeb/255.f green:0xf5/255.f blue:0xff/255.f alpha:1]];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 25;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"GLSL";
    }
    if (section == 1) {
        return @"GLKit";
    }
    return @"";
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource[section] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = [[self.dataSource[indexPath.section][indexPath.row] componentsSeparatedByString:@"."] lastObject];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    const char *className = [[[self.dataSource[indexPath.section][indexPath.row] componentsSeparatedByString:@"."] firstObject] UTF8String];
    Class class = objc_getClass(className);
    id classInstance = [[class alloc]init];
    if (classInstance) {
        ((UIViewController *)classInstance).title = [[self.dataSource[indexPath.section][indexPath.row] componentsSeparatedByString:@"."] lastObject];
        [self.navigationController pushViewController:(UIViewController *)classInstance animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
