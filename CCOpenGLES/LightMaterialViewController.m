//
//  LightMaterialViewController.m
//  CCOpenGLES
//
//  Created by wsk on 2016/10/18.
//  Copyright © 2016年 cyd. All rights reserved.
//

#import "LightMaterialViewController.h"
#import "sphereLight.h"

@interface LightMaterialViewController ()
{
    GLuint _vertexID;
    GLuint _normalID;
    GLuint _textureID;
    GLfloat _rotation;
}
@property(nonatomic, strong)GLKBaseEffect *effect;

@end

@implementation LightMaterialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupGL];
}

-(void)setupGL{
    GLKView *view = (GLKView *)self.view;
    view.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    [EAGLContext setCurrentContext:view.context];
    
    glGenBuffers(1, &_vertexID);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexID);
    glBufferData(GL_ARRAY_BUFFER, sizeof(sphereLightVerts), sphereLightVerts, GL_STATIC_DRAW);
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 3*sizeof(GLfloat), 0);
    
    glGenBuffers(1, &_normalID);
    glBindBuffer(GL_ARRAY_BUFFER, _normalID);
    glBufferData(GL_ARRAY_BUFFER, sizeof(sphereLightNormals), sphereLightNormals, GL_STATIC_DRAW);
    
    glEnableVertexAttribArray(GLKVertexAttribNormal);
    glVertexAttribPointer(GLKVertexAttribNormal, 3, GL_FLOAT, GL_FALSE, 3*sizeof(GLfloat), 0);
    
    glGenBuffers(1, &_textureID);
    glBindBuffer(GL_ARRAY_BUFFER, _textureID);
    glBufferData(GL_ARRAY_BUFFER, sizeof(sphereLightTexCoords), sphereLightTexCoords, GL_STATIC_DRAW);
    
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, 2*sizeof(GLfloat), 0);
    
    self.effect = [[GLKBaseEffect alloc] init];
    
    CGImageRef imageRef0 = [[UIImage imageNamed:@"Earth512x256.jpg"] CGImage];
    GLKTextureInfo *textureInfo0 = [GLKTextureLoader textureWithCGImage:imageRef0 options:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], GLKTextureLoaderOriginBottomLeft, nil] error:NULL];
    self.effect.texture2d0.name = textureInfo0.name;
    self.effect.texture2d0.target = textureInfo0.target;
    glBindTexture(textureInfo0.target, textureInfo0.name);
    glTexParameteri(textureInfo0.target, GL_TEXTURE_WRAP_S, GL_REPEAT);
    glTexParameteri(textureInfo0.target, GL_TEXTURE_WRAP_T, GL_REPEAT);
    
    self.effect.light0.enabled = GL_TRUE;
    self.effect.colorMaterialEnabled = GL_TRUE;
 
    glEnable(GL_DEPTH_TEST);
}

- (void)update
{
    float aspect = fabs(self.view.bounds.size.width / self.view.bounds.size.height);
    GLKMatrix4 projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(65.0f), aspect, 0.1f, 100.0f);
    self.effect.transform.projectionMatrix = projectionMatrix;
    
    GLKMatrix4 modelviewMatrix = GLKMatrix4MakeTranslation(0.0f, 0.0f, -3.0f);
    modelviewMatrix = GLKMatrix4Rotate(modelviewMatrix, _rotation, 0.0f, 1.0f, 0.0f);
    self.effect.transform.modelviewMatrix = modelviewMatrix;
    
    _rotation += self.timeSinceLastUpdate * 1.0f;
}

-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect{
    glClearColor(0xeb/255.f, 0xf5/255.f, 0xff/255.f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    [self.effect prepareToDraw];
    glDrawArrays(GL_TRIANGLES, 0, sphereLightNumVerts);
}

- (void)dealloc
{
    [EAGLContext setCurrentContext:((GLKView *)self.view).context];
    if (_vertexID != 0){
        glDeleteBuffers (1,&_vertexID);
        _vertexID = 0;
    }
    if (_normalID != 0){
        glDeleteBuffers (1,&_normalID);
        _normalID = 0;
    }
    if (_textureID) {
        glDeleteTextures(1, &_textureID);
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
