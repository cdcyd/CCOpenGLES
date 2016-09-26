//
//  CubeGLSLViewController.m
//  OpenGLGraphics
//
//  Created by wsk on 16/9/26.
//  Copyright © 2016年 cyd. All rights reserved.
//

#import "CubeGLSLViewController.h"
#import "ShaderManager.h"
#import "TextureManager.h"
#import <GLKit/GLKit.h>
#import <OpenGLES/ES1/gl.h>

#define BUFFER_OFFSET(i) ((char *)NULL + (i))

@interface CubeGLSLViewController ()<GLKViewDelegate>{
    GLuint _program;
    GLuint _VBO;
    GLuint _textureID;
    
    GLKMatrix4 _modelViewProjectionMatrix;
    GLKMatrix3 _normalMatrix;
    GLfloat _rotation;
    
    int _uModelViewProjectionMatrix;
    int _uNormalMatrix;
}

@property(nonatomic, strong)GLKView *glView;
@property(nonatomic, strong)EAGLContext *context;

@end

@implementation CubeGLSLViewController

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
    
    [ShaderManager loadShader:@"ShaderCube" progam:&_program];
    glBindAttribLocation(_program, GLKVertexAttribPosition, "aPosition");
    glBindAttribLocation(_program, GLKVertexAttribTexCoord0, "aTexCoord0");
    glBindAttribLocation(_program, GLKVertexAttribNormal, "aNormal");
    
    [ShaderManager linkProgram:_program];
    _uModelViewProjectionMatrix = glGetUniformLocation(_program, "uModelViewProjectionMatrix");
    _uNormalMatrix = glGetUniformLocation(_program, "uNormalMatrix");

    GLfloat vertexs[] = {
         0.5f, -0.5f, -0.5f,    1.0f,  0.0f,  0.0f,    
         0.5f,  0.5f, -0.5f,    1.0f,  0.0f,  0.0f,    
         0.5f, -0.5f,  0.5f,    1.0f,  0.0f,  0.0f,   
         0.5f, -0.5f,  0.5f,    1.0f,  0.0f,  0.0f,   
         0.5f,  0.5f,  0.5f,    1.0f,  0.0f,  0.0f,  
         0.5f,  0.5f, -0.5f,    1.0f,  0.0f,  0.0f,   
        
         0.5f,  0.5f, -0.5f,    0.0f,  1.0f,  0.0f,   
        -0.5f,  0.5f, -0.5f,    0.0f,  1.0f,  0.0f,   
         0.5f,  0.5f,  0.5f,    0.0f,  1.0f,  0.0f,   
         0.5f,  0.5f,  0.5f,    0.0f,  1.0f,  0.0f,    
        -0.5f,  0.5f, -0.5f,    0.0f,  1.0f,  0.0f,    
        -0.5f,  0.5f,  0.5f,    0.0f,  1.0f,  0.0f,    
        
        -0.5f,  0.5f, -0.5f,   -1.0f,  0.0f,  0.0f,  
        -0.5f, -0.5f, -0.5f,   -1.0f,  0.0f,  0.0f,   
        -0.5f,  0.5f,  0.5f,   -1.0f,  0.0f,  0.0f,   
        -0.5f,  0.5f,  0.5f,   -1.0f,  0.0f,  0.0f,   
        -0.5f, -0.5f, -0.5f,   -1.0f,  0.0f,  0.0f,   
        -0.5f, -0.5f,  0.5f,   -1.0f,  0.0f,  0.0f,  
        
        -0.5f, -0.5f, -0.5f,    0.0f, -1.0f,  0.0f,   
         0.5f, -0.5f, -0.5f,    0.0f, -1.0f,  0.0f,   
        -0.5f, -0.5f,  0.5f,    0.0f, -1.0f,  0.0f,   
        -0.5f, -0.5f,  0.5f,    0.0f, -1.0f,  0.0f,   
         0.5f, -0.5f, -0.5f,    0.0f, -1.0f,  0.0f,   
         0.5f, -0.5f,  0.5f,    0.0f, -1.0f,  0.0f,  
        
         0.5f,  0.5f,  0.5f,    0.0f,  0.0f,  1.0f,   
        -0.5f,  0.5f,  0.5f,    0.0f,  0.0f,  1.0f,    
         0.5f, -0.5f,  0.5f,    0.0f,  0.0f,  1.0f,    
         0.5f, -0.5f,  0.5f,    0.0f,  0.0f,  1.0f,   
        -0.5f,  0.5f,  0.5f,    0.0f,  0.0f,  1.0f,    
        -0.5f, -0.5f,  0.5f,    0.0f,  0.0f,  1.0f,    
        
         0.5f, -0.5f, -0.5f,    0.0f,  0.0f, -1.0f,   
        -0.5f, -0.5f, -0.5f,    0.0f,  0.0f, -1.0f,   
         0.5f,  0.5f, -0.5f,    0.0f,  0.0f, -1.0f,   
         0.5f,  0.5f, -0.5f,    0.0f,  0.0f, -1.0f,   
        -0.5f, -0.5f, -0.5f,    0.0f,  0.0f, -1.0f,   
        -0.5f,  0.5f, -0.5f,    0.0f,  0.0f, -1.0f,   
    };
    
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
    
    glUseProgram(_program);
    
    // 是透视投影变换
    float aspect = fabs(self.view.bounds.size.width / self.view.bounds.size.height);
    // 第一个参数是视角，第二个参数是视图宽高比
    GLKMatrix4 projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(65.0f), aspect, 0.1f, 100.0f);

    // 平移变换
    GLKMatrix4 modelViewMatrix = GLKMatrix4MakeTranslation(0.0f, 0.0f, -5.0f);
    modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, GLKMathDegreesToRadians(15.0f), 1.0f, 0.0f, 0.0f);
    modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, GLKMathDegreesToRadians(-30.0f), 0.0f, 1.0f, 0.0f);
   
    glUniformMatrix4fv(_uModelViewProjectionMatrix, 1, 0, GLKMatrix4Multiply(projectionMatrix, modelViewMatrix).m);
    glUniformMatrix3fv(_uNormalMatrix, 1, 0, GLKMatrix4GetMatrix3(GLKMatrix4InvertAndTranspose(modelViewMatrix, NULL)).m);
    const GLfloat glfLightAmbient1[4] = {0.1, 0.1, 0.1, 1.0};  
    const GLfloat glfLightAmbient2[4] = {0.4, 0.4, 0.4, 1.0};  
    const GLfloat glfLightDiffuse1[4] = {0, 0.8, 0.8, 1.0};  
    const GLfloat glfLightDiffuse2[4] = {0.8, 0.8, 0.8, 1.0};  
    const GLfloat glfLightSpecular1[4] = {0, 0.8, 0.8, 1.0};  
    const GLfloat glfLightSpecular2[4] = {0.8, 0.8, 0.8, 1.0};  
    const GLfloat glPosition1[4]={0,0,1,0};  
    const GLfloat glPosition2[4]={0.6,0.6,-0.6,1};  
    glLightfv(GL_LIGHT0, GL_AMBIENT,  glfLightAmbient1);  
    glLightfv(GL_LIGHT0, GL_DIFFUSE,  glfLightDiffuse1);  
    glLightfv(GL_LIGHT0, GL_SPECULAR, glfLightSpecular1);  
    glLightfv(GL_LIGHT0, GL_POSITION, glPosition1);  
    glLightfv(GL_LIGHT1, GL_AMBIENT,  glfLightAmbient2);  
    glLightfv(GL_LIGHT1, GL_DIFFUSE,  glfLightDiffuse2);  
    glLightfv(GL_LIGHT1, GL_SPECULAR, glfLightSpecular2);  
    glLightfv(GL_LIGHT1, GL_POSITION, glPosition2);  
    glLightModelf(GL_LIGHT_MODEL_TWO_SIDE,GL_TRUE);//两面照亮  
    glEnable(GL_LIGHTING);//启用光照  
    glEnable(GL_LIGHT0);  
    glEnable(GL_LIGHT1);//打开光源  
    glEnable(GL_COLOR_MATERIAL);//启用颜色追踪  
    
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
