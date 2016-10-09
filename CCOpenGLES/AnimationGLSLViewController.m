//
//  AnimationGLSLViewController.m
//  CCOpenGLES
//
//  Created by wsk on 16/10/9.
//  Copyright © 2016年 cyd. All rights reserved.
//

#import "AnimationGLSLViewController.h"
#import "ShaderManager.h"

typedef struct {
    GLKVector3 positionCoords;
}SeceneVertex;

static SeceneVertex vertices[3] = {
    {{-0.5f, -0.5f, 0.0f}},
    {{ 0.5f, -0.5f, 0.0f}},
    {{-0.5f,  0.5f, 0.0f}}
};

static GLKVector3 movementVectors[3] = {
    {-0.02f,  -0.010f, 0.0f},
    { 0.01f,  -0.005f, 0.0f},
    {-0.01f,   0.010f, 0.0f},
};

@interface AnimationGLSLViewController ()
{
    GLuint VBO;
}
@property(nonatomic, assign)GLuint program;
@end

@implementation AnimationGLSLViewController

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
   
    glGenBuffers(1, &VBO);
    glBindBuffer(GL_ARRAY_BUFFER, VBO);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(SeceneVertex), NULL);
    
    // 链接顶点属性
    glVertexAttribPointer (0, 3, GL_FLOAT, GL_FALSE, 3 * sizeof(GLfloat), (GLvoid*)0);
    glEnableVertexAttribArray (0);	// 开启顶点属性
    glBindBuffer(GL_ARRAY_BUFFER, 0);
}

-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glClearColor(0xeb/255.f, 0xf5/255.f, 0xff/255.f, 1.0f);	
    glClear (GL_COLOR_BUFFER_BIT);		
    
    glUseProgram (_program);
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
    
    glBindBuffer(GL_ARRAY_BUFFER, VBO);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
}

-(void)dealloc
{
    [EAGLContext setCurrentContext:((GLKView *)self.view).context];
    if (VBO != 0){
        glDeleteBuffers(1,&VBO);
        VBO = 0;
    }
    
    if (_program != 0) {
        glDeleteProgram(_program);
        _program = 0;
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
