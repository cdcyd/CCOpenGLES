//
//  AppDelegate.h
//  CCOpenGLES
//
//  Created by wsk on 16/10/8.
//  Copyright © 2016年 cyd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

