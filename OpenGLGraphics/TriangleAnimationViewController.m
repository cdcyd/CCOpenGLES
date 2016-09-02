//
//  TriangleAnimationViewController.m
//  OpenGLGraphics
//
//  Created by wsk on 16/8/12.
//  Copyright © 2016年 cyd. All rights reserved.
//

#import "TriangleAnimationViewController.h"
#import <GLKit/GLKit.h>

// 1.定义一个包含一个顶点的结构体
typedef struct {
    GLKVector3 positionCoords;
}SeceneVertex;

// 2.定义一个三角形(一个三角形有3个定点)
static SeceneVertex vertices[3] = {
    {{-0.5f, -0.5f, 0.0f}},//外层{}是赋值给vertices[3]数组，里层{}是赋值个GLKVector3中v[3]数组
    {{ 0.5f, -0.5f, 0.0f}},
    {{-0.5f,  0.5f, 0.0f}}
};

static GLKVector3 movementVectors[3] = {
    {-0.02f,  -0.010f, 0.0f},
    { 0.01f,  -0.005f, 0.0f},
    {-0.01f,   0.010f, 0.0f},
};

@interface TriangleAnimationViewController ()<GLKViewDelegate>
{
    GLuint vertexBufferID;
}
@property(nonatomic, strong)GLKView *glView;
@property(nonatomic, strong)GLKBaseEffect *baseEffect;
@property(nonatomic, strong)CADisplayLink *playlink;

@end

@implementation TriangleAnimationViewController

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
    
    if (!self.playlink) {
        self.playlink = [CADisplayLink displayLinkWithTarget:self selector:@selector(update)];
        [self.playlink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (self.playlink) {
        [self.playlink removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
        [self.playlink invalidate];
        self.playlink = nil;
    }
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

- (void)updateAnimatedVertexPositions{
    for(int i = 0; i < 3; i++)
    {
        vertices[i].positionCoords.x += movementVectors[i].x;
        if(vertices[i].positionCoords.x >= 1.0f || vertices[i].positionCoords.x <= -1.0f)
        {
            movementVectors[i].x = -movementVectors[i].x;
        }
        
        vertices[i].positionCoords.y += movementVectors[i].y;
        if(vertices[i].positionCoords.y >= 1.0f || vertices[i].positionCoords.y <= -1.0f)
        {
            movementVectors[i].y = -movementVectors[i].y;
        }
        
        vertices[i].positionCoords.z += movementVectors[i].z;
        if(vertices[i].positionCoords.z >= 1.0f || vertices[i].positionCoords.z <= -1.0f)
        {
            movementVectors[i].z = -movementVectors[i].z;
        }
    }
}

-(void)update{
    [self updateAnimatedVertexPositions];
    
    glBindBuffer(GL_ARRAY_BUFFER, vertexBufferID);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
    
    [self.glView setNeedsDisplay];
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
