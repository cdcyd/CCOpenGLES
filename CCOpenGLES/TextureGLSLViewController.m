//
//  TextureGLSLViewController.m
//  CCOpenGLES
//
//  Created by wsk on 16/10/9.
//  Copyright © 2016年 cyd. All rights reserved.
//

#import "TextureGLSLViewController.h"
#import "ShaderManager.h"
#import "TextureManager.h"

#define BUFFER_OFFSET(i) ((char *)NULL + (i))

@interface TextureGLSLViewController (){
    GLuint _VBO;
    GLuint _textureID;
    
    GLKMatrix4 _modelViewProjectionMatrix;
    
    GLuint _uTexture0Index;
    int _uModelViewProjectionMatrixIndex;
}
@property(nonatomic, assign)GLuint program;
@end

@implementation TextureGLSLViewController

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
    
    [ShaderManager loadShader:@"TextureShader" progam:&_program];
    glBindAttribLocation(_program, GLKVertexAttribPosition, "position");
    glBindAttribLocation(_program, GLKVertexAttribTexCoord0, "texCoord0");
    
    [ShaderManager linkProgram:_program];
    _uTexture0Index = glGetUniformLocation(_program, "uTexture0");
    _uModelViewProjectionMatrixIndex = glGetUniformLocation(_program, "uModelViewProjectionMatrix");
    
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
    
    float aspect = fabs(self.view.bounds.size.width / self.view.bounds.size.height);
    GLKMatrix4 projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(65.0f), aspect, 0.1f, 100.0f);
    
    GLKMatrix4 modelviewMatrix = GLKMatrix4MakeTranslation(0.0f, 0.0f, -2.0f);
    _modelViewProjectionMatrix = GLKMatrix4Multiply(projectionMatrix, modelviewMatrix);
    
    [TextureManager loadTexture:&_textureID image:[UIImage imageNamed:@"texture256x256.jpg"]];
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, 4*sizeof(GLfloat), BUFFER_OFFSET(0));
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, 4*sizeof(GLfloat), BUFFER_OFFSET(2*sizeof(GLfloat)));
}

-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect{
    glClearColor(0xeb/255.f, 0xf5/255.f, 0xff/255.f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    glUseProgram(_program);
    
    glUniform1i(_uTexture0Index, 0);
    glUniformMatrix4fv(_uModelViewProjectionMatrixIndex, 1, 0, _modelViewProjectionMatrix.m);
    
    glDrawArrays(GL_TRIANGLES, 0, 6);
}

-(void)dealloc
{
    [EAGLContext setCurrentContext:((GLKView *)self.view).context];
    if (_VBO != 0){
        glDeleteBuffers(1,&_VBO);
        _VBO = 0;
    }
    
    if (_program != 0) {
        glDeleteProgram(_program);
        _program = 0;
    }
    
    if (_textureID != 0) {
        glDeleteTextures(1, &_textureID);
        _textureID = 0;
    }
    
    [EAGLContext setCurrentContext:nil];
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
