//
//  MultipleTextureGLSLViewController.m
//  CCOpenGLES
//
//  Created by wsk on 16/10/9.
//  Copyright © 2016年 cyd. All rights reserved.
//

#import "MultipleTextureGLSLViewController.h"
#import "ShaderManager.h"
#import "TextureManager.h"

#define BUFFER_OFFSET(i) ((char *)NULL + (i))

@interface MultipleTextureGLSLViewController (){
    GLuint _VBO;
    GLuint _texture0ID;
    GLuint _texture1ID;
    
    GLfloat _rotation;
    
    GLKMatrix4 _modelViewProjectionMatrix;
    GLKMatrix3 _normalMatrix;
    
    GLuint _uTexture0Index;
    GLuint _uTexture1Index;
    int _uModelViewProjectionMatrixIndex;
    int _uNormalMatrixIndex;
}
@property(nonatomic, assign)GLuint program;

@end

@implementation MultipleTextureGLSLViewController

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
    
    [ShaderManager loadShader:@"MultipleTextureShader" progam:&_program];
    glBindAttribLocation(_program, GLKVertexAttribPosition, "aPosition");
    glBindAttribLocation(_program, GLKVertexAttribNormal, "aNormal");
    glBindAttribLocation(_program, GLKVertexAttribTexCoord0, "texCoord0");
    glBindAttribLocation(_program, GLKVertexAttribTexCoord1, "texCoord1");
    
    [ShaderManager linkProgram:_program];
    
    _uModelViewProjectionMatrixIndex = glGetUniformLocation(_program, "uModelViewProjectionMatrix");
    _uNormalMatrixIndex = glGetUniformLocation(_program, "uNormalMatrix");
    _uTexture0Index = glGetUniformLocation(_program, "uTexture0");
    _uTexture1Index = glGetUniformLocation(_program, "uTexture1");
    
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
    
   
    glEnable(GL_DEPTH_TEST);
    
    glGenBuffers(1, &_VBO);
    glBindBuffer(GL_ARRAY_BUFFER, _VBO);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertexs), vertexs, GL_STATIC_DRAW);
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 8*sizeof(GLfloat), BUFFER_OFFSET(0));
    
    glEnableVertexAttribArray(GLKVertexAttribNormal);
    glVertexAttribPointer(GLKVertexAttribNormal, 3, GL_FLOAT, GL_FALSE, 8*sizeof(GLfloat), BUFFER_OFFSET(3*sizeof(GLfloat)));
    
    glActiveTexture(GL_TEXTURE0);
    [TextureManager loadTexture:&_texture0ID image:[UIImage imageNamed:@"picture256x256"]];
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, 8*sizeof(GLfloat), BUFFER_OFFSET(6*sizeof(GLfloat)));
   
    glActiveTexture(GL_TEXTURE1);
    [TextureManager loadTexture:&_texture1ID image:[UIImage imageNamed:@"mutpicture256x256"]];
    glEnableVertexAttribArray(GLKVertexAttribTexCoord1);
    glVertexAttribPointer(GLKVertexAttribTexCoord1, 2, GL_FLOAT, GL_FALSE, 8*sizeof(GLfloat), BUFFER_OFFSET(6*sizeof(GLfloat)));
}

- (void)update
{
    float aspect = fabs(self.view.bounds.size.width / self.view.bounds.size.height);
    GLKMatrix4 projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(65.0f), aspect, 0.1f, 100.0f);
  
    GLKMatrix4 modelviewMatrix = GLKMatrix4MakeTranslation(0.0f, 0.0f, -3.0f);
    modelviewMatrix = GLKMatrix4Rotate(modelviewMatrix, _rotation, -1.0f, 1.0f, -1.0f);
   
    _normalMatrix = GLKMatrix4GetMatrix3(GLKMatrix4InvertAndTranspose(modelviewMatrix, NULL));
    _modelViewProjectionMatrix = GLKMatrix4Multiply(projectionMatrix, modelviewMatrix);
    
    _rotation += self.timeSinceLastUpdate * 1.0f;
}

-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect{
    glClearColor(0xeb/255.f, 0xf5/255.f, 0xff/255.f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    glUseProgram(_program);
    
    glUniformMatrix4fv(_uModelViewProjectionMatrixIndex, 1, 0, _modelViewProjectionMatrix.m);
    glUniformMatrix3fv(_uNormalMatrixIndex, 1, 0, _normalMatrix.m);
    
    glUniform1i(_uTexture0Index, 0);
    glUniform1i(_uTexture1Index, 1);
    
    glDrawArrays(GL_TRIANGLES, 0, 36);
}

- (void)dealloc
{
    [EAGLContext setCurrentContext:((GLKView *)self.view).context];
    if (_VBO != 0){
        glDeleteBuffers (1,&_VBO);
        _VBO = 0;
    }
    if (_program != 0) {
        glDeleteProgram(_program);
        _program = 0;
    }
    
    if (_texture0ID != 0) {
        glDeleteTextures(1, &_texture0ID);
        _texture0ID = 0;
    }
    
    if (_texture1ID != 0) {
        glDeleteTextures(1, &_texture1ID);
        _texture1ID = 0;
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
