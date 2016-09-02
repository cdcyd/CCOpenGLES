//
//  TextureViewController.m
//  OpenGLGraphics
//
//  Created by wsk on 16/8/10.
//  Copyright © 2016年 cyd. All rights reserved.
//

#import "TextureViewController.h"
#import <GLKit/GLKit.h>

typedef struct {
    GLKVector3 positionCoords;
    GLKVector2 textureCoords;
}SceneVertex;

static SceneVertex vertexs[] = {
    {{-0.5f, -0.5f, 0.0f}, {0.0f, 1.0f}}, 
    {{ 0.5f, -0.5f, 0.0f}, {0.8f, 1.0f}}, 
    {{-0.5f,  0.5f, 0.0f}, {0.0f, 0.0f}}, 
};

@interface TextureViewController ()<GLKViewDelegate>
{
    GLuint VBO;
}
@property(nonatomic, strong)EAGLContext   *context;
@property(nonatomic, strong)GLKBaseEffect *baseEffect;
@property(nonatomic, strong)GLKView       *glView;

@end

@implementation TextureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.context = [[EAGLContext alloc]initWithAPI:kEAGLRenderingAPIOpenGLES2];
    self.glView = [[GLKView alloc]initWithFrame:self.view.bounds context:self.context];
    self.glView.delegate = self;
    [self.view addSubview:self.glView];
    [EAGLContext setCurrentContext:self.context];
    
    self.baseEffect = [[GLKBaseEffect alloc]init];
    self.baseEffect.useConstantColor = GL_TRUE;
    self.baseEffect.constantColor = GLKVector4Make(1.0f, 1.0f, 1.0f, 1.0f);

    glGenBuffers(1, &VBO);
    glBindBuffer(GL_ARRAY_BUFFER, VBO);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertexs), vertexs, GL_STATIC_DRAW);
    
    CGImageRef imageRef = [[UIImage imageNamed:@"www.png"] CGImage];
    GLKTextureInfo *textureInfo = [GLKTextureLoader 
                                   textureWithCGImage:imageRef 
                                   options:nil 
                                   error:NULL];
    self.baseEffect.texture2d0.name = textureInfo.name;
    self.baseEffect.texture2d0.target = textureInfo.target;
}

-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect{
    
    [self.baseEffect prepareToDraw];
    
    glClearColor(0xeb/255.f, 0xf5/255.f, 0xff/255.f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    
    glBindBuffer(GL_ARRAY_BUFFER, VBO);
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(SceneVertex), NULL + offsetof(SceneVertex, positionCoords));
    
    glBindBuffer(GL_ARRAY_BUFFER, VBO);
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, sizeof(SceneVertex), NULL + offsetof(SceneVertex, textureCoords));
    
    glDrawArrays(GL_TRIANGLES, 0, 3);
}

- (void)dealloc
{
    [EAGLContext setCurrentContext:self.glView.context];
    if (VBO != 0){
        glDeleteBuffers (1,&VBO);
        VBO = 0;
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
