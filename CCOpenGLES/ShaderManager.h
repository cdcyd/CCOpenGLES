//
//  ShaderManager.h
//  CCOpenGLES
//
//  Created by wsk on 16/10/8.
//  Copyright © 2016年 cyd. All rights reserved.
//

#include <GLKit/GLKit.h>

@interface ShaderManager : NSObject

+ (BOOL)loadShader:(NSString *)shaderName progam:(GLuint *)program;

+ (BOOL)linkProgram:(GLuint )prog;

@end
