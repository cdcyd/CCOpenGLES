//
//  QuadrilateralGLSLViewController.m
//  CCOpenGLES
//
//  Created by wsk on 16/10/9.
//  Copyright © 2016年 cyd. All rights reserved.
//

#import "QuadrilateralGLSLViewController.h"
#import "ShaderManager.h"

@interface QuadrilateralGLSLViewController ()
@property(nonatomic, assign)GLuint program;
@end

@implementation QuadrilateralGLSLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupGL];
}

-(void)setupGL{
    GLKView *view = (GLKView *)self.view;
    view.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    [EAGLContext setCurrentContext:view.context];
    
    // 着色器
    [ShaderManager loadShader:@"HelloShader" progam:&_program];
    glBindAttribLocation(_program, GLKVertexAttribPosition, "position");
    
    [ShaderManager linkProgram:_program];
    
    // 顶点数据，关于点的位置属性
    GLfloat vertices[] = {
        -0.5f, 0.5f, 0.0f,    
         0.5f, 0.5f, 0.0f,    
        -0.5f,-0.5f, 0.0f,    
        -0.5f,-0.5f, 0.0f,    
         0.5f,-0.5f, 0.0f,    
         0.5f, 0.5f, 0.0f,    
    };
    
    // 把顶点数组复制到缓冲中提供给OpenGL使用
    GLuint VBO;
    glGenBuffers(1, &VBO);
    glBindBuffer(GL_ARRAY_BUFFER, VBO);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
    
    // 链接顶点属性
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 3 * sizeof(GLfloat), (GLvoid*)0);
    glEnableVertexAttribArray(0);	// 开启顶点属性
    glBindBuffer(GL_ARRAY_BUFFER, 0);
}

-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glClearColor(0xeb/255.f, 0xf5/255.f, 0xff/255.f, 1.0f);	
    glClear(GL_COLOR_BUFFER_BIT);		
    
    glUseProgram(_program);
    glDrawArrays(GL_TRIANGLES, 0, 6);
}

-(void)dealloc{
    if (_program != 0) {
        glDeleteProgram(_program);
        _program = 0;
    }
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
