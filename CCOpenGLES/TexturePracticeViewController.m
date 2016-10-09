//
//  TexturePracticeViewController.m
//  CCOpenGLES
//
//  Created by wsk on 16/10/9.
//  Copyright © 2016年 cyd. All rights reserved.
//

#import "TexturePracticeViewController.h"

#define BUFFER_OFFSET(i) ((char *)NULL + (i))

@interface TexturePracticeViewController ()
{
    GLuint  _VBO;
    GLfloat _rotation;
}

@property(nonatomic, strong)GLKBaseEffect *effect;

@end

@implementation TexturePracticeViewController

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
    
    self.effect = [[GLKBaseEffect alloc] init];
    self.effect.light0.enabled = GL_TRUE;
    self.effect.light0.diffuseColor = GLKVector4Make(0.8f, 0.8f, 0.8f, 1.0f);
    
    CGImageRef imageRef0 = [[UIImage imageNamed:@"picture256x256"] CGImage];
    GLKTextureInfo *textureInfo0 = [GLKTextureLoader textureWithCGImage:imageRef0 options:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], GLKTextureLoaderOriginBottomLeft, nil] error:NULL];
    self.effect.texture2d0.name = textureInfo0.name;
    self.effect.texture2d0.target = textureInfo0.target;
    glBindTexture(textureInfo0.target, textureInfo0.name);
    glTexParameteri(textureInfo0.target, GL_TEXTURE_WRAP_S, GL_REPEAT);
    glTexParameteri(textureInfo0.target, GL_TEXTURE_WRAP_T, GL_REPEAT);
    
    glEnable(GL_DEPTH_TEST);
    
    glGenBuffers(1, &_VBO);
    glBindBuffer(GL_ARRAY_BUFFER, _VBO);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertexs), vertexs, GL_STATIC_DRAW);
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 8*sizeof(GLfloat), BUFFER_OFFSET(0));
    
    glEnableVertexAttribArray(GLKVertexAttribNormal);
    glVertexAttribPointer(GLKVertexAttribNormal, 3, GL_FLOAT, GL_FALSE, 8*sizeof(GLfloat), BUFFER_OFFSET(3*sizeof(GLfloat)));
    
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, 8*sizeof(GLfloat), BUFFER_OFFSET(6*sizeof(GLfloat)));
}

- (void)update
{
    // 投影变换
    float aspect = fabs(self.view.bounds.size.width / self.view.bounds.size.height);
    GLKMatrix4 projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(65.0f), aspect, 0.1f, 100.0f);
    self.effect.transform.projectionMatrix = projectionMatrix;
    
    // 旋转变换
    GLKMatrix4 modelviewMatrix = GLKMatrix4MakeTranslation(0.0f, 0.0f, -3.0f);
    modelviewMatrix = GLKMatrix4Rotate(modelviewMatrix, _rotation, 1.0f, 0.0f, 0.0f);
    modelviewMatrix = GLKMatrix4Rotate(modelviewMatrix, _rotation, 0.0f, 1.0f, 0.0f);
    
    self.effect.transform.modelviewMatrix = modelviewMatrix;
    
    _rotation += self.timeSinceLastUpdate * 1.0f;
}

-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect{
    glClearColor(0xeb/255.f, 0xf5/255.f, 0xff/255.f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    [self.effect prepareToDraw];
    glDrawArrays(GL_TRIANGLES, 0, 36);
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
