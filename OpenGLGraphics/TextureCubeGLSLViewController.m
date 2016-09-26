//
//  TextureCubeGLSLViewController.m
//  OpenGLGraphics
//
//  Created by wsk on 16/9/9.
//  Copyright © 2016年 cyd. All rights reserved.
//

#import "TextureCubeGLSLViewController.h"
#import "ShaderManager.h"
#import "TextureManager.h"
#import <OpenGLES/ES2/glext.h>

#define BUFFER_OFFSET(i) ((char *)NULL + (i))

@interface TextureCubeGLSLViewController ()<GLKViewDelegate>{
    GLuint _program;
    GLuint _VBO;
    GLuint _textureID;
    
    GLKMatrix4 _modelViewProjectionMatrix;
    GLKMatrix3 _normalMatrix;
    GLfloat _rotation;
    
    int _uModelViewProjectionMatrix;
    int _uNormalMatrix;
}
@end

@implementation TextureCubeGLSLViewController

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
         0.5f, -0.5f, -0.5f,    1.0f,  0.0f,  0.0f,    0.0f, 0.0f,
         0.5f,  0.5f, -0.5f,    1.0f,  0.0f,  0.0f,    3.0f, 0.0f, 
         0.5f, -0.5f,  0.5f,    1.0f,  0.0f,  0.0f,    0.0f, 3.0f,
         0.5f, -0.5f,  0.5f,    1.0f,  0.0f,  0.0f,    0.0f, 3.0f,
         0.5f,  0.5f,  0.5f,    1.0f,  0.0f,  0.0f,    3.0f, 3.0f,
         0.5f,  0.5f, -0.5f,    1.0f,  0.0f,  0.0f,    3.0f, 0.0f,
        
         0.5f,  0.5f, -0.5f,    0.0f,  1.0f,  0.0f,    3.0f, 0.0f,
        -0.5f,  0.5f, -0.5f,    0.0f,  1.0f,  0.0f,    0.0f, 0.0f,
         0.5f,  0.5f,  0.5f,    0.0f,  1.0f,  0.0f,    3.0f, 3.0f,
         0.5f,  0.5f,  0.5f,    0.0f,  1.0f,  0.0f,    3.0f, 3.0f,
        -0.5f,  0.5f, -0.5f,    0.0f,  1.0f,  0.0f,    0.0f, 0.0f,
        -0.5f,  0.5f,  0.5f,    0.0f,  1.0f,  0.0f,    0.0f, 3.0f,
        
        -0.5f,  0.5f, -0.5f,   -1.0f,  0.0f,  0.0f,    3.0f, 0.0f,
        -0.5f, -0.5f, -0.5f,   -1.0f,  0.0f,  0.0f,    0.0f, 0.0f,
        -0.5f,  0.5f,  0.5f,   -1.0f,  0.0f,  0.0f,    3.0f, 3.0f,
        -0.5f,  0.5f,  0.5f,   -1.0f,  0.0f,  0.0f,    3.0f, 3.0f,
        -0.5f, -0.5f, -0.5f,   -1.0f,  0.0f,  0.0f,    0.0f, 0.0f,
        -0.5f, -0.5f,  0.5f,   -1.0f,  0.0f,  0.0f,    0.0f, 3.0f,
        
        -0.5f, -0.5f, -0.5f,    0.0f, -1.0f,  0.0f,    0.0f, 0.0f,
         0.5f, -0.5f, -0.5f,    0.0f, -1.0f,  0.0f,    3.0f, 0.0f,
        -0.5f, -0.5f,  0.5f,    0.0f, -1.0f,  0.0f,    0.0f, 3.0f,
        -0.5f, -0.5f,  0.5f,    0.0f, -1.0f,  0.0f,    0.0f, 3.0f,
         0.5f, -0.5f, -0.5f,    0.0f, -1.0f,  0.0f,    3.0f, 0.0f,
         0.5f, -0.5f,  0.5f,    0.0f, -1.0f,  0.0f,    3.0f, 3.0f,
        
         0.5f,  0.5f,  0.5f,    0.0f,  0.0f,  1.0f,    3.0f, 3.0f,
        -0.5f,  0.5f,  0.5f,    0.0f,  0.0f,  1.0f,    0.0f, 3.0f,
         0.5f, -0.5f,  0.5f,    0.0f,  0.0f,  1.0f,    3.0f, 0.0f,
         0.5f, -0.5f,  0.5f,    0.0f,  0.0f,  1.0f,    3.0f, 0.0f,
        -0.5f,  0.5f,  0.5f,    0.0f,  0.0f,  1.0f,    0.0f, 3.0f,
        -0.5f, -0.5f,  0.5f,    0.0f,  0.0f,  1.0f,    0.0f, 0.0f,
        
         0.5f, -0.5f, -0.5f,    0.0f,  0.0f, -1.0f,    3.0f, 0.0f,
        -0.5f, -0.5f, -0.5f,    0.0f,  0.0f, -1.0f,    0.0f, 0.0f,
         0.5f,  0.5f, -0.5f,    0.0f,  0.0f, -1.0f,    3.0f, 3.0f,
         0.5f,  0.5f, -0.5f,    0.0f,  0.0f, -1.0f,    3.0f, 3.0f,
        -0.5f, -0.5f, -0.5f,    0.0f,  0.0f, -1.0f,    0.0f, 0.0f,
        -0.5f,  0.5f, -0.5f,    0.0f,  0.0f, -1.0f,    0.0f, 3.0f,
    };
    
    [ShaderManager loadShader:@"ShaderCube" progam:&_program];
    glBindAttribLocation(_program, GLKVertexAttribPosition, "aPosition");
    glBindAttribLocation(_program, GLKVertexAttribTexCoord0, "aTexCoord0");
    glBindAttribLocation(_program, GLKVertexAttribNormal, "aNormal");
    
    [ShaderManager linkProgram:_program];
    _uModelViewProjectionMatrix = glGetUniformLocation(_program, "uModelViewProjectionMatrix");
    _uNormalMatrix = glGetUniformLocation(_program, "uNormalMatrix");
    
    glGenBuffers(1, &_VBO);
    glBindBuffer(GL_ARRAY_BUFFER, _VBO);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertexs), vertexs, GL_STATIC_DRAW);
    
    [TextureManager loadTexture:&_textureID texture:[UIImage imageNamed:@"picture256x256"] texType:@"image"];
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 8*sizeof(GLfloat), BUFFER_OFFSET(0));
    
    glEnableVertexAttribArray(GLKVertexAttribNormal);
    glVertexAttribPointer(GLKVertexAttribNormal, 3, GL_FLOAT, GL_FALSE, 8*sizeof(GLfloat), BUFFER_OFFSET(3*sizeof(GLfloat)));
    
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, 8*sizeof(GLfloat), BUFFER_OFFSET(6*sizeof(GLfloat)));
}

- (void)update
{
    float aspect = fabs(self.view.bounds.size.width / self.view.bounds.size.height);
    GLKMatrix4 projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(65.0f), aspect, 0.1f, 100.0f);
    
    GLKMatrix4 modelviewMatrix = GLKMatrix4MakeTranslation(0.0f, 0.0f, -3.0f);
    modelviewMatrix = GLKMatrix4Rotate(modelviewMatrix, _rotation, 1.0f, 0.0f, 0.0f);
    modelviewMatrix = GLKMatrix4Rotate(modelviewMatrix, _rotation, 0.0f, 1.0f, 0.0f);
    
    _normalMatrix = GLKMatrix4GetMatrix3(GLKMatrix4InvertAndTranspose(modelviewMatrix, NULL));
    _modelViewProjectionMatrix = GLKMatrix4Multiply(projectionMatrix, modelviewMatrix);
    
    _rotation += self.timeSinceLastUpdate * 1.0f;
}

-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect{
    
    glEnable(GL_DEPTH_TEST);
    
    glClearColor(0xeb/255.f, 0xf5/255.f, 0xff/255.f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    glUseProgram(_program);
    
    glUniformMatrix4fv(_uModelViewProjectionMatrix, 1, 0, _modelViewProjectionMatrix.m);
    glUniformMatrix3fv(_uNormalMatrix, 1, 0, _normalMatrix.m);
    
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
