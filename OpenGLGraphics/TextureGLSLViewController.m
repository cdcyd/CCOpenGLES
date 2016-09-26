//
//  TextureGLSLViewController.m
//  OpenGLGraphics
//
//  Created by wsk on 16/9/8.
//  Copyright © 2016年 cyd. All rights reserved.
//

#import "TextureGLSLViewController.h"
#import "ShaderManager.h"
#import "TextureManager.h"
#import <GLKit/GLKit.h>

#define BUFFER_OFFSET(i) ((char *)NULL + (i))

@interface TextureGLSLViewController ()<GLKViewDelegate>{
    GLuint _program;
    GLuint _VBO;
    GLuint _textureID;
    
    GLKMatrix4 _modelViewProjectionMatrix;
    GLKMatrix3 _normalMatrix;
}

@property(nonatomic, strong)GLKView *glView;
@property(nonatomic, strong)EAGLContext *context;

@end

@implementation TextureGLSLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupGL];
}

-(void)setupGL{
    self.context = [[EAGLContext alloc]initWithAPI:kEAGLRenderingAPIOpenGLES3];
    self.glView = [[GLKView alloc]initWithFrame:self.view.bounds context:self.context];
    self.glView.delegate = self;
    [self.view addSubview:self.glView];
    
    [EAGLContext setCurrentContext:self.context];
    
    [ShaderManager loadShader:@"Shader" progam:&_program];
    glBindAttribLocation(_program, GLKVertexAttribPosition, "position");
    glBindAttribLocation(_program, GLKVertexAttribTexCoord0, "texCoord0");
    
    [ShaderManager linkProgram:_program];
    
    GLfloat vertexs[] = {
        -0.5f, 0.5f,     0.0f,1.0f,
         0.5f, 0.5f,     1.0f,1.0f,
        -0.5f,-0.5f,     0.0f,0.0f,
        -0.5f,-0.5f,     0.0f,0.0f,
         0.5f,-0.5f,     1.0f,0.0f,
         0.5f, 0.5f,     1.0f,1.0f
    };
    
    glGenBuffers(1, &_VBO);
    glBindBuffer(GL_ARRAY_BUFFER, _VBO);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertexs), vertexs, GL_STATIC_DRAW);
    
    [TextureManager loadTexture:&_textureID texture:[UIImage imageNamed:@"texture300x600"] texType:@"image"];
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, 4*sizeof(GLfloat), BUFFER_OFFSET(0));
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, 4*sizeof(GLfloat), BUFFER_OFFSET(2*sizeof(GLfloat)));
}

-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect{
    glClearColor(0xeb/255.f, 0xf5/255.f, 0xff/255.f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    glUseProgram(_program);
    glDrawArrays(GL_TRIANGLES, 0, 6);
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
