//
//  CubeViewController.m
//  OpenGLGraphics
//
//  Created by wsk on 16/9/9.
//  Copyright © 2016年 cyd. All rights reserved.
//

#import "CubeViewController.h"
#import <OpenGLES/ES2/glext.h>

#define BUFFER_OFFSET(i) ((char *)NULL + (i))

@interface CubeViewController ()<GLKViewDelegate>{
    GLuint _VBO;
}

@property(nonatomic, strong)GLKBaseEffect *effect;

@end

@implementation CubeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupGL];
}

-(void)setupGL{
    GLKView *view = (GLKView *)self.view;
    view.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    [EAGLContext setCurrentContext:view.context];
    
    GLfloat vertexs[] = {
         0.5f, -0.5f, -0.5f,    1.0f, 0.0f, 0.0f,    
         0.5f,  0.5f, -0.5f,    1.0f, 0.0f, 0.0f,    
         0.5f, -0.5f,  0.5f,    1.0f, 0.0f, 0.0f,   
         0.5f, -0.5f,  0.5f,    1.0f, 0.0f, 0.0f,   
         0.5f,  0.5f,  0.5f,    1.0f, 0.0f, 0.0f,  
         0.5f,  0.5f, -0.5f,    1.0f, 0.0f, 0.0f,   
        
         0.5f,  0.5f, -0.5f,    0.0f, 1.0f, 0.0f,   
        -0.5f,  0.5f, -0.5f,    0.0f, 1.0f, 0.0f,   
         0.5f,  0.5f,  0.5f,    0.0f, 1.0f, 0.0f,   
         0.5f,  0.5f,  0.5f,    0.0f, 1.0f, 0.0f,    
        -0.5f,  0.5f, -0.5f,    0.0f, 1.0f, 0.0f,    
        -0.5f,  0.5f,  0.5f,    0.0f, 1.0f, 0.0f,    
        
        -0.5f,  0.5f, -0.5f,   -1.0f, 0.0f, 0.0f,  
        -0.5f, -0.5f, -0.5f,   -1.0f, 0.0f, 0.0f,   
        -0.5f,  0.5f,  0.5f,   -1.0f, 0.0f, 0.0f,   
        -0.5f,  0.5f,  0.5f,   -1.0f, 0.0f, 0.0f,   
        -0.5f, -0.5f, -0.5f,   -1.0f, 0.0f, 0.0f,   
        -0.5f, -0.5f,  0.5f,   -1.0f, 0.0f, 0.0f,  
        
        -0.5f, -0.5f, -0.5f,    0.0f, -1.0f, 0.0f,   
         0.5f, -0.5f, -0.5f,    0.0f, -1.0f, 0.0f,   
        -0.5f, -0.5f,  0.5f,    0.0f, -1.0f, 0.0f,   
        -0.5f, -0.5f,  0.5f,    0.0f, -1.0f, 0.0f,   
         0.5f, -0.5f, -0.5f,    0.0f, -1.0f, 0.0f,   
         0.5f, -0.5f,  0.5f,    0.0f, -1.0f, 0.0f,  
        
         0.5f,  0.5f,  0.5f,    0.0f, 0.0f, 1.0f,   
        -0.5f,  0.5f,  0.5f,    0.0f, 0.0f, 1.0f,    
         0.5f, -0.5f,  0.5f,    0.0f, 0.0f, 1.0f,    
         0.5f, -0.5f,  0.5f,    0.0f, 0.0f, 1.0f,   
        -0.5f,  0.5f,  0.5f,    0.0f, 0.0f, 1.0f,    
        -0.5f, -0.5f,  0.5f,    0.0f, 0.0f, 1.0f,    
        
         0.5f, -0.5f, -0.5f,    0.0f, 0.0f, -1.0f,   
        -0.5f, -0.5f, -0.5f,    0.0f, 0.0f, -1.0f,   
         0.5f,  0.5f, -0.5f,    0.0f, 0.0f, -1.0f,   
         0.5f,  0.5f, -0.5f,    0.0f, 0.0f, -1.0f,   
        -0.5f, -0.5f, -0.5f,    0.0f, 0.0f, -1.0f,   
        -0.5f,  0.5f, -0.5f,    0.0f, 0.0f, -1.0f,   
    };
    
    self.effect = [[GLKBaseEffect alloc] init];
    self.effect.light0.enabled = GL_TRUE;
    self.effect.light0.diffuseColor = GLKVector4Make(0.8f, 0.8f, 0.8f, 1.0f);
    
    // 是透视投影变换
    float aspect = fabs(self.view.bounds.size.width / self.view.bounds.size.height);
    // 第一个参数是视角，第二个参数是视图宽高比
    GLKMatrix4 projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(65.0f), aspect, 0.1f, 100.0f);
    self.effect.transform.projectionMatrix = projectionMatrix;
    
    // 平移变换
    GLKMatrix4 modelViewMatrix = GLKMatrix4MakeTranslation(0.0f, 0.0f, -5.0f);
    // x轴15°
    modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, GLKMathDegreesToRadians(15.0f), 1.0f, 0.0f, 0.0f);
    // y轴-30°
    modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, GLKMathDegreesToRadians(-30.0f), 0.0f, 1.0f, 0.0f);
    self.effect.transform.modelviewMatrix = modelViewMatrix;
    
    glEnable(GL_DEPTH_TEST);
    
    glGenBuffers(1, &_VBO);
    glBindBuffer(GL_ARRAY_BUFFER, _VBO);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertexs), vertexs, GL_STATIC_DRAW);
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 6*sizeof(GLfloat), BUFFER_OFFSET(0));
    
    glEnableVertexAttribArray(GLKVertexAttribNormal);
    glVertexAttribPointer(GLKVertexAttribNormal, 3, GL_FLOAT, GL_FALSE, 6*sizeof(GLfloat), BUFFER_OFFSET(3*sizeof(GLfloat)));
}

-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect{
    
    glClearColor(0xeb/255.f, 0xf5/255.f, 0xff/255.f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    [self.effect prepareToDraw];
    
    glDrawArrays(GL_TRIANGLES, 0, 36);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
