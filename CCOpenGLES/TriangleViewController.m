//
//  TriangleViewController.m
//  CCOpenGLES
//
//  Created by wsk on 16/10/8.
//  Copyright © 2016年 cyd. All rights reserved.
//

#import "TriangleViewController.h"

@interface TriangleViewController ()
{
    GLuint vertexBufferID;
}

@property(nonatomic, strong)GLKBaseEffect *effect;

@end

@implementation TriangleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupGL];
}

-(void)setupGL{
    GLKView *view = (GLKView *)self.view;
    view.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    [EAGLContext setCurrentContext:view.context];
    
    self.effect = [[GLKBaseEffect alloc]init];
    self.effect.useConstantColor = GL_TRUE;
    self.effect.constantColor = GLKVector4Make(1.0f, 0.5f, 0.2f, 1.0);
    
    GLfloat vertices[] = {
        -0.5f, -0.5f, 0.0f,
         0.5f, -0.5f, 0.0f,
        -0.5f,  0.5f, 0.0f
    };
    
    glGenBuffers(1, &vertexBufferID);
    glBindBuffer(GL_ARRAY_BUFFER, vertexBufferID);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 3*sizeof(GLfloat), NULL);
}

-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glClearColor(0xeb/255.f, 0xf5/255.f, 0xff/255.f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    
    [self.effect prepareToDraw];
    glDrawArrays(GL_TRIANGLES, 0, 3);
}

-(void)dealloc
{
    [EAGLContext setCurrentContext:((GLKView *)self.view).context];
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
