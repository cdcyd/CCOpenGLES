//
//  QuadrilateralViewController.m
//  OpenGLGraphics
//
//  Created by wsk on 16/8/4.
//  Copyright © 2016年 cyd. All rights reserved.
//

#import "QuadrilateralViewController.h"
#import <GLKit/GLKit.h>

GLfloat vertices[] = {
     0.5f,  0.5f, 0.0f, // 右上角
     0.5f, -0.5f, 0.0f, // 右下角
    -0.5f, -0.5f, 0.0f, // 左下角
    -0.5f,  0.5f, 0.0f  // 左上角
};

GLuint indices[] = { 
    0, 1, 3,
    1, 2, 3
};

@interface QuadrilateralViewController ()<GLKViewDelegate>
{
    GLuint vertexBufferID;
    GLuint quadrxBufferID;
}
@property(nonatomic, strong)GLKView *glView;
@property(nonatomic, strong)GLKBaseEffect *baseEffect;
@end

@implementation QuadrilateralViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    EAGLContext *context = [[EAGLContext alloc]initWithAPI:kEAGLRenderingAPIOpenGLES2];
    self.glView = [[GLKView alloc]initWithFrame:self.view.bounds context:context];
    self.glView.delegate = self;
    [self.view addSubview:self.glView];
    [EAGLContext setCurrentContext:self.glView.context];
    
    self.baseEffect = [[GLKBaseEffect alloc]init];
    self.baseEffect.useConstantColor = GL_TRUE;
    self.baseEffect.constantColor = GLKVector4Make(1.0f, 0.5f, 0.2f, 1.0);
    
    glGenBuffers(1, &vertexBufferID);
    glGenBuffers(1, &quadrxBufferID);
    
    glBindBuffer(GL_ARRAY_BUFFER, vertexBufferID);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
    
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, quadrxBufferID);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(indices), indices, GL_STATIC_DRAW);
}

//绘图函数
-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    [self.baseEffect prepareToDraw];
    
    glClearColor(0xeb/255.f, 0xf5/255.f, 0xff/255.f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    
    glEnableVertexAttribArray(0);
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 3*sizeof(GLfloat), NULL);
    glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_INT, 0);
}

//删除顶点缓存和上下文
-(void)dealloc
{
    [EAGLContext setCurrentContext:self.glView.context];
    if (vertexBufferID != 0){
        glDeleteBuffers (1,&vertexBufferID);
        vertexBufferID = 0;
    }
    if (quadrxBufferID != 0) {
        glDeleteBuffers(1, &quadrxBufferID);
        quadrxBufferID = 0;
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
