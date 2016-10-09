//
//  TextureViewController.m
//  CCOpenGLES
//
//  Created by wsk on 16/10/8.
//  Copyright © 2016年 cyd. All rights reserved.
//

#import "TextureViewController.h"

#define BUFFER_OFFSET(i) ((char *)NULL + (i))

@interface TextureViewController ()
{
    GLuint _VBO;
}

@property(nonatomic, strong)GLKBaseEffect *baseEffect;

@end

@implementation TextureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupGL];
}

-(void)setupGL{
    GLKView *view = (GLKView *)self.view;
    view.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    [EAGLContext setCurrentContext:view.context];
    
    self.baseEffect = [[GLKBaseEffect alloc]init];
    self.baseEffect.useConstantColor = GL_TRUE;
    self.baseEffect.constantColor = GLKVector4Make(1.0f, 1.0f, 1.0f, 1.0f);
    
    GLfloat vertexs[] = {
        -0.5f, 0.5f, 0.0f,    0.0f,0.0f,
         0.5f, 0.5f, 0.0f,    1.0f,0.0f,
        -0.5f,-0.5f, 0.0f,    0.0f,1.0f,
        -0.5f,-0.5f, 0.0f,    0.0f,1.0f,
         0.5f,-0.5f, 0.0f,    1.0f,1.0f,
         0.5f, 0.5f, 0.0f,    1.0f,0.0f
    };
    
    glGenBuffers(1, &_VBO);
    glBindBuffer(GL_ARRAY_BUFFER, _VBO);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertexs), vertexs, GL_STATIC_DRAW);
    
    CGImageRef imageRef = [[UIImage imageNamed:@"texture256x256.jpg"] CGImage];
    GLKTextureInfo *textureInfo = [GLKTextureLoader 
                                   textureWithCGImage:imageRef 
                                   options:nil 
                                   error:NULL];
    self.baseEffect.texture2d0.name = textureInfo.name;
    self.baseEffect.texture2d0.target = textureInfo.target;
    
    float aspect = fabs(self.view.bounds.size.width / self.view.bounds.size.height);
    GLKMatrix4 projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(65.0f), aspect, 0.1f, 100.0f);
    self.baseEffect.transform.projectionMatrix = projectionMatrix;
    self.baseEffect.transform.modelviewMatrix = GLKMatrix4MakeTranslation(0.0f, 0.0f, -2.0f);
    
    glBindBuffer(GL_ARRAY_BUFFER, _VBO);
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 5 * sizeof(GLfloat), BUFFER_OFFSET(0));
    
    glBindBuffer(GL_ARRAY_BUFFER, _VBO);
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, 5 * sizeof(GLfloat), BUFFER_OFFSET(3*sizeof(GLfloat)));
}

-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect{
    
    glClearColor(0xeb/255.f, 0xf5/255.f, 0xff/255.f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    
    [self.baseEffect prepareToDraw];
    glDrawArrays(GL_TRIANGLES, 0, 6);
}

- (void)dealloc
{
    [EAGLContext setCurrentContext:((GLKView *)self.view).context];
    if (_VBO != 0){
        glDeleteBuffers (1,&_VBO);
        _VBO = 0;
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
