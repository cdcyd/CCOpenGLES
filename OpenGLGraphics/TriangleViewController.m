//
//  TriangleViewController.m
//  OpenGLGraphics
//
//  Created by wsk on 16/8/4.
//  Copyright © 2016年 cyd. All rights reserved.
//

#import "TriangleViewController.h"
#import <GLKit/GLKit.h>

// 1.定义一个包含一个顶点的结构体
typedef struct {
    GLKVector3 positionCoords;
}SeceneVertex;

// 2.定义一个三角形(一个三角形有3个定点)
static const SeceneVertex vertices[3] = {
    {{-0.5f, -0.5f, 0.0f}},//外层{}是赋值给vertices[3]数组，里层{}是赋值个GLKVector3中v[3]数组
    {{ 0.5f, -0.5f, 0.0f}},
    {{-0.5f,  0.5f, 0.0f}}
};

// 上面的1、2步可以写成这一个结构体
//static const GLfloat vertices[] = {
//    -0.5f, -0.5f, 0.0f,
//     0.5f, -0.5f, 0.0f,
//    -0.5f,  0.5f, 0.0f
//};

@interface TriangleViewController ()<GLKViewDelegate>
{
    GLuint vertexBufferID;
}
@property(nonatomic, strong)GLKView *glView;
@property(nonatomic, strong)GLKBaseEffect *baseEffect;
@end

@implementation TriangleViewController

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
    glBindBuffer(GL_ARRAY_BUFFER, vertexBufferID);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
}


//绘图函数
-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    [self.baseEffect prepareToDraw];
    
    glClearColor(0xeb/255.f, 0xf5/255.f, 0xff/255.f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(SeceneVertex), NULL);
    glDrawArrays(GL_TRIANGLES, 0, 3);
}

//删除顶点缓存和上下文
-(void)dealloc
{
    [EAGLContext setCurrentContext:self.glView.context];
    if (vertexBufferID != 0){
        glDeleteBuffers (1,&vertexBufferID);
        vertexBufferID = 0;
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
