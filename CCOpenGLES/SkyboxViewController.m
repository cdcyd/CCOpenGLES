//
//  SkyboxViewController.m
//  CCOpenGLES
//
//  Created by wsk on 2016/10/18.
//  Copyright © 2016年 cyd. All rights reserved.
//

#import "SkyboxViewController.h"

@interface SkyboxViewController ()

@property(nonatomic, strong)GLKSkyboxEffect *skyboxEffect;

@property (assign, nonatomic, readwrite) GLKVector3 eyePosition;
@property (assign, nonatomic) GLKVector3 lookAtPosition;
@property (assign, nonatomic) GLKVector3 upVector;
@property (assign, nonatomic) float angle;

@end

@implementation SkyboxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupGL];
}

-(void)setupGL{
    GLKView *view = (GLKView *)self.view;
    view.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    [EAGLContext setCurrentContext:view.context];
    
    self.eyePosition = GLKVector3Make(0.0, 3.0, 3.0);
    self.lookAtPosition = GLKVector3Make(0.0, 0.0, 0.0);
    self.upVector = GLKVector3Make(0.0, 1.0, 0.0);
    
    NSArray *textureFiles = @[[[NSBundle mainBundle] pathForResource:@"blood_lf.tga" ofType:nil],
                              [[NSBundle mainBundle] pathForResource:@"blood_rt.tga" ofType:nil],
                              [[NSBundle mainBundle] pathForResource:@"blood_up.tga" ofType:nil],
                              [[NSBundle mainBundle] pathForResource:@"blood_dn.tga" ofType:nil],
                              [[NSBundle mainBundle] pathForResource:@"blood_ft.tga" ofType:nil],
                              [[NSBundle mainBundle] pathForResource:@"blood_bk.tga" ofType:nil]];
    GLKTextureInfo *skyTexture = [GLKTextureLoader cubeMapWithContentsOfFiles:textureFiles options:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], GLKTextureLoaderGenerateMipmaps, 
                                     [NSNumber numberWithBool:NO], GLKTextureLoaderOriginBottomLeft, 
                                     [NSNumber numberWithBool:NO], GLKTextureLoaderApplyPremultiplication, 
                                     nil] error:nil];
    self.skyboxEffect = [[GLKSkyboxEffect alloc]init];
    self.skyboxEffect.textureCubeMap.name = skyTexture.name;
    self.skyboxEffect.textureCubeMap.target = skyTexture.target;
    self.skyboxEffect.xSize = 6.0f;
    self.skyboxEffect.ySize = 6.0f;
    self.skyboxEffect.zSize = 6.0f;
    
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST_MIPMAP_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
    
    glEnable(GL_CULL_FACE);
}

-(void)update{
    const GLfloat aspectRatio = self.view.bounds.size.width/self.view.bounds.size.height;
    self.eyePosition = GLKVector3Make(3.0f*sinf(self.angle), 3.0f, 3.0f*cosf(self.angle));    
    self.lookAtPosition = GLKVector3Make(0.0, 1.5+3.0f*sinf(0.3*self.angle), 0.0);
    self.skyboxEffect.center = self.eyePosition;
    self.skyboxEffect.transform.projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(85.0f), aspectRatio, 0.1f, 20.0f); 
    self.skyboxEffect.transform.modelviewMatrix = GLKMatrix4MakeLookAt(self.eyePosition.x,      
                                                                       self.eyePosition.y,
                                                                       self.eyePosition.z,
                                                                       self.lookAtPosition.x,   
                                                                       self.lookAtPosition.y,
                                                                       self.lookAtPosition.z,
                                                                       self.upVector.x,        
                                                                       self.upVector.y,
                                                                       self.upVector.z);
    self.angle += 0.01;
}

-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect{
    glClearColor(0xeb/255.f, 0xf5/255.f, 0xff/255.f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    [self.skyboxEffect prepareToDraw];
    [self.skyboxEffect draw];
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
