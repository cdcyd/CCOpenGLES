//
//  LightViewController.m
//  CCOpenGLES
//
//  Created by wsk on 16/10/8.
//  Copyright © 2016年 cyd. All rights reserved.
//

#import "LightViewController.h"
#import "sphere.h"

@interface LightViewController ()
{
    GLuint _vertexID;
    GLuint _normalID;
}
@property(nonatomic, strong)GLKBaseEffect *effect;

@end

@implementation LightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupGL];
}

-(void)setupGL{
    GLKView *view = (GLKView *)self.view;
    view.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    [EAGLContext setCurrentContext:view.context];
    
    // case 4：多光源
    self.effect = [[GLKBaseEffect alloc] init];
    // 材质镜面光
    self.effect.material.specularColor = GLKVector4Make(0.8f, 0.8f, 0.8f, 0.0f);
    self.effect.material.shininess = 32;
    // 第一个光源
    self.effect.light0.enabled = GL_TRUE;
    self.effect.light0.ambientColor = GLKVector4Make(0.0f, 1.0f, 0.0f, 1.0f);
    self.effect.light0.diffuseColor = GLKVector4Make(1.0f, 0.0f, 0.0f, 1.0f);
    self.effect.light0.specularColor = GLKVector4Make(0.0f, 0.0f, 1.0f, 0.0f);
    // 第二个光源
    self.effect.light1.enabled = GL_TRUE;
    self.effect.light1.position = GLKVector4Make(1.0f, 0.0f, 1.0f, 0.0f);
    self.effect.light1.ambientColor = GLKVector4Make(0.0f, 0.0f, 0.0f, 1.0f);
    self.effect.light1.diffuseColor = GLKVector4Make(0.0f, 1.0f, 1.0f, 1.0f);
    self.effect.light1.specularColor = GLKVector4Make(1.0f, 0.0f, 0.0f, 0.0f);
    
    glEnable(GL_DEPTH_TEST);
}

-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect{
    glClearColor(0xeb/255.f, 0xf5/255.f, 0xff/255.f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    for (int i = 0 ; i < 3; i ++) {
        [self.effect prepareToDraw];
        
        float aspect = fabs(self.view.bounds.size.width / self.view.bounds.size.height);
        GLKMatrix4 projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(65.0f), aspect, 0.1f, 100.0f);
        self.effect.transform.projectionMatrix = projectionMatrix;
        self.effect.transform.modelviewMatrix = GLKMatrix4MakeTranslation(0.0f, 3*i-2, -(i+8));
        
        glGenBuffers(1, &_vertexID);
        glBindBuffer(GL_ARRAY_BUFFER, _vertexID);
        glBufferData(GL_ARRAY_BUFFER, sizeof(sphereVerts), sphereVerts, GL_STATIC_DRAW);
        
        glGenBuffers(1, &_normalID);
        glBindBuffer(GL_ARRAY_BUFFER, _normalID);
        glBufferData(GL_ARRAY_BUFFER, sizeof(sphereNormals), sphereNormals, GL_STATIC_DRAW);
        
        glEnableVertexAttribArray(GLKVertexAttribPosition);
        glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 3*sizeof(GLfloat), 0);
        
        glEnableVertexAttribArray(GLKVertexAttribNormal);
        glVertexAttribPointer(GLKVertexAttribNormal, 3, GL_FLOAT, GL_FALSE, 3*sizeof(GLfloat), 0);
        
        glDrawArrays(GL_TRIANGLES, 0, sphereNumVerts);
        
        glDeleteBuffers(1, &_vertexID);
        _vertexID = 0;
        glDeleteBuffers(1,&_normalID);
        _normalID = 0;
    }
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
