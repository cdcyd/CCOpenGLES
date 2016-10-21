//
//  ViewController.m
//  CCOpenGLES
//
//  Created by wsk on 16/10/8.
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
    self.title = @"Learn OpenGL ES";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:nil];
    [[UITableViewHeaderFooterView appearance] setTintColor:[UIColor colorWithRed:0xeb/255.f green:0xf5/255.f blue:0xff/255.f alpha:1]];
    
    self.dataSource = @[@[@"TriangleViewController.三角形  GLKit",
                          @"QuadrilateralViewController.四边形  GLKit",
                          @"AnimationViewController.动    画  GLKit",
                          @"CubeViewController.立方体  GLKit",
                          @"LOGOViewController.LOGO   GLKit",
                          @"TextureViewController.纹    理  GLKit",
                          @"TexturePracticeViewController.纹理练习  GLKit",
                          @"MultipleTextureViewController.多重纹理  GLKit",
                          @"LightViewController.光    照  GLKit",
                          @"LightMaterialViewController.材质光照  GLKit",
                          @"SkyboxViewController.天 空 盒  GLKit"],
                        @[@"TriangleGLSLViewController.三角形  GLSL",
                          @"QuadrilateralGLSLViewController.四边形  GLSL",
                          @"AnimationGLSLViewController.动    画  GLSL",
                          @"CubeGLSLViewController.立方体  GLSL",
                          @"LOGOGLSLViewController.LOGO   GLSL",
                          @"TextureGLSLViewController.纹    理  GLSL",
                          @"MultipleTextureGLSLViewController.多重纹理  GLSL"]];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 25;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return @"GLSL";
    }
    if (section == 0) {
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
