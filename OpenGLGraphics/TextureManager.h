//
//  TextureManager.h
//  OpenGLGraphics
//
//  Created by wsk on 16/9/26.
//  Copyright © 2016年 cyd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface TextureManager : NSObject

+ (void)loadTexture:(GLuint *)textureName texture:(UIImage *)texture texType:(NSString *)texType;

@end
