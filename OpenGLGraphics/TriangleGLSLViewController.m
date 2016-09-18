//
//  TriangleGLSLViewController.m
//  OpenGLGraphics
//
//  Created by wsk on 16/8/5.
//  Copyright © 2016年 cyd. All rights reserved.
//

#import "TriangleGLSLViewController.h"
#import <GLKit/GLKit.h>

@interface TriangleGLSLViewController ()<GLKViewDelegate>
@property(nonatomic, strong)EAGLContext *context;
@property(nonatomic, assign)GLuint vertexShader;
@property(nonatomic, assign)GLuint fragmentShader;
@property(nonatomic, assign)GLuint shaderPropram;
@end

@implementation TriangleGLSLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    _context = [[EAGLContext alloc]initWithAPI:kEAGLRenderingAPIOpenGLES2];
    GLKView *glview = [[GLKView alloc]initWithFrame:self.view.bounds context:_context];
    glview.delegate = self;
    [self.view addSubview:glview];
    [EAGLContext setCurrentContext:_context];
    
    // 创建顶点着色器
    _vertexShader = [self compileShader:@"Shader" withType:GL_VERTEX_SHADER];
    // 创建片段着色器
    _fragmentShader = [self compileShader:@"Shader" withType:GL_FRAGMENT_SHADER];
    // 链接两个着色器
    _shaderPropram = glCreateProgram();
    glAttachShader(_shaderPropram, _vertexShader);
    glAttachShader(_shaderPropram, _fragmentShader);
    glLinkProgram(_shaderPropram);
    
    // 检测是否链接成功
    GLint succ;
    glGetProgramiv(_shaderPropram, GL_LINK_STATUS, &succ);
    if (!succ) {
        GLchar messages[256];
        glGetProgramInfoLog(_shaderPropram, sizeof(messages), 0, &messages[0]);
        NSString *messageString = [NSString stringWithUTF8String:messages];
        NSLog(@"链接着色器失败:%@", messageString);
    }
    
    // 删除着色器
    glDeleteShader(_vertexShader);
    glDeleteShader(_fragmentShader);
   
    // 顶点数据，关于点的位置属性
    GLfloat vertices[] = {
        0.0f, 0.5f, 0.0f,
        -0.5f, -0.5f, 0.0f,
        0.5f, -0.5f, 0.0f
    };
    
    // 把顶点数组复制到缓冲中提供给OpenGL使用
    GLuint VBO;
    glGenBuffers(1, &VBO);
    glBindBuffer(GL_ARRAY_BUFFER, VBO);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
    
    // 链接顶点属性
    glVertexAttribPointer (0, 3, GL_FLOAT, GL_FALSE, 3 * sizeof (GLfloat), (GLvoid*) 0);
    glEnableVertexAttribArray (0);	// 开启顶点属性
    glBindBuffer(GL_ARRAY_BUFFER, 0);
}

-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glClearColor(0xeb/255.f, 0xf5/255.f, 0xff/255.f, 1.0f);	
    glClear (GL_COLOR_BUFFER_BIT);		
    
    glUseProgram (_shaderPropram);
    glDrawArrays (GL_TRIANGLES, 0, 3);
}

- (GLuint)compileShader:(NSString*)shaderName withType:(GLenum)shaderType {
    NSString *type;
    if (shaderType == GL_FRAGMENT_SHADER) {
        type = @"fglsl";
    }
    else{
        type = @"vglsl";
    }
    NSError* error = nil;    
    NSString* shaderPath = [[NSBundle mainBundle] pathForResource:shaderName ofType:type];
    NSString* shaderString = [NSString stringWithContentsOfFile:shaderPath encoding:NSUTF8StringEncoding error:&error];
    if (!shaderString) {
        NSLog(@"读取着色器失败:%@",error.localizedDescription);
    }
    
    const char* shaderStringUTF8 = [shaderString UTF8String];
    int shaderStringLength = (int)[shaderString length];
    
    GLuint shaderHandle = glCreateShader(shaderType);
    glShaderSource(shaderHandle, 1, &shaderStringUTF8, &shaderStringLength);
    glCompileShader(shaderHandle);
    
    // 检测是否编译成功
    GLint compileSuccess;
    glGetShaderiv(shaderHandle, GL_COMPILE_STATUS, &compileSuccess);
    if (compileSuccess == GL_FALSE) {
        GLchar messages[256];
        glGetShaderInfoLog(shaderHandle, sizeof(messages), 0, &messages[0]);
        NSString *messageString = [NSString stringWithUTF8String:messages];
        NSLog(@"编译着色器失败:%@", messageString);
    }
    return shaderHandle;
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
