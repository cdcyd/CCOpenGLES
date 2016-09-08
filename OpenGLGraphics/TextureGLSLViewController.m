//
//  TextureGLSLViewController.m
//  OpenGLGraphics
//
//  Created by wsk on 16/9/8.
//  Copyright © 2016年 cyd. All rights reserved.
//

#import "TextureGLSLViewController.h"
#import <GLKit/GLKit.h>

#define BUFFER_OFFSET(i) ((char *)NULL + (i))

@interface TextureGLSLViewController ()<GLKViewDelegate>{
    GLuint _program;
    GLuint _VBO;
    GLuint _VAO;
    
    GLKMatrix4 _modelViewProjectionMatrix;
    GLKMatrix3 _normalMatrix;
}
// OpenGL ES
@property(nonatomic, strong)GLKView *pageView;
@property(nonatomic, strong)EAGLContext *context;

@end

@implementation TextureGLSLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupGL];
}

-(void)setupGL{
    self.context = [[EAGLContext alloc]initWithAPI:kEAGLRenderingAPIOpenGLES3];
    self.pageView = [[GLKView alloc]initWithFrame:self.view.bounds context:self.context];
    self.pageView.delegate = self;
    [self.view addSubview:self.pageView];
    
    [EAGLContext setCurrentContext:self.context];
    
    [self loadShaders];
    
    GLfloat vertexs[] = {
        -0.5f, 0.5f,     0.0f,1.0f,
         0.5f, 0.5f,     1.0f,1.0f,
        -0.5f,-0.5f,     0.0f,0.0f,
        -0.5f,-0.5f,     0.0f,0.0f,
         0.5f,-0.5f,     1.0f,0.0f,
         0.5f, 0.5f,     1.0f,1.0f
    };
    
    glGenBuffers(1, &_VBO);
    glBindBuffer(GL_ARRAY_BUFFER, _VBO);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertexs), vertexs, GL_STATIC_DRAW);
    
    [self loadTexture:&_VAO texture:[UIImage imageNamed:@"www"] texType:@"image"];
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, 4*sizeof(GLfloat), BUFFER_OFFSET(0));
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, 4*sizeof(GLfloat), BUFFER_OFFSET(2*sizeof(GLfloat)));
}

-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect{
    glClearColor(0.65f, 0.65f, 0.65f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    glUseProgram(_program);
    
    glDrawArrays(GL_TRIANGLES, 0, 6);
}

/// texType 1."image":UIImage 2."imageName":图片名 3."file":图片路径
- (void)loadTexture:(GLuint *)textureName texture:(id)texture texType:(NSString *)texType
{
    UIImage *image;
    if ([texType isEqualToString:@"image"]) {
        image = (UIImage *)texture;
    }
    else if ([texType isEqualToString:@"file"]){
        image = [UIImage imageWithContentsOfFile:texture];
    }
    else if ([texType isEqualToString:@"imageName"]){
        image = [UIImage imageNamed:texture];
    }
    
    if (image) {
        CGImageRef imageRef = [image CGImage];
        size_t imageWidth = CGImageGetWidth(imageRef);
        size_t imageHeight = CGImageGetHeight(imageRef);
        
        GLubyte *imageData = (GLubyte *)malloc(imageWidth*imageHeight*4);
        memset(imageData, 0, imageWidth*imageHeight*4);
        
        CGColorSpaceRef colorSpace = CGImageGetColorSpace(imageRef);
        CGContextRef imageContextRef = CGBitmapContextCreate(imageData, imageWidth, imageHeight, 8, imageWidth*4, colorSpace, kCGImageAlphaPremultipliedLast);
        CGContextTranslateCTM(imageContextRef, 0, imageHeight);
        CGContextScaleCTM(imageContextRef, 1.0, -1.0); 
        CGContextDrawImage(imageContextRef, CGRectMake(0.0, 0.0, (CGFloat)imageWidth, (CGFloat)imageHeight), imageRef);
        CGContextRelease(imageContextRef);
        
        glGenTextures(1, textureName);
        glBindTexture(GL_TEXTURE_2D, *textureName);
        glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, (int)imageWidth, (int)imageHeight, 0, GL_RGBA, GL_UNSIGNED_BYTE, imageData);
        free(imageData);
        
        // 纹理取样模式
        /*
         GL_TEXTURE_MIN_FILTER  出现多个纹素对应一个片元时，从相配的多个元素中取样颜色
         GL_TEXTURE_MAG_FILTER  出现纹素少于片元是的取样方式
         
         GL_LINEAR   线性内插法来混合颜色以得到一个新的片元颜色:在GL_TEXTURE_MIN_FILTER时，会将取多个纹素来混合得到片元颜色；在GL_TEXTURE_MAG_FILTER时，会取附近的纹素一起来混合的到片元颜色
         GL_NEAREST  取其中一个颜色：在GL_TEXTURE_MIN_FILTER时，会取多个纹素其中一个的颜色；在GL_TEXTURE_MAG_FILTER时，会取与片元U、V位置接近的纹素的颜色
         */
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
        
        // 纹理循环模式
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
        
        glEnable(GL_TEXTURE_2D);
    }
}

- (BOOL)loadShaders
{
    GLuint vertShader, fragShader;
    NSString *vertShaderPathname, *fragShaderPathname;
    
    _program = glCreateProgram();
    
    vertShaderPathname = [[NSBundle mainBundle] pathForResource:@"Shader" ofType:@"vsh"];
    if (![self compileShader:&vertShader type:GL_VERTEX_SHADER file:vertShaderPathname]) {
        return NO;
    }
    
    fragShaderPathname = [[NSBundle mainBundle] pathForResource:@"Shader" ofType:@"fsh"];
    if (![self compileShader:&fragShader type:GL_FRAGMENT_SHADER file:fragShaderPathname]) {
        return NO;
    }
    
    glAttachShader(_program, vertShader);
    glAttachShader(_program, fragShader);
    
    glBindAttribLocation(_program, GLKVertexAttribPosition, "position");
    glBindAttribLocation(_program, GLKVertexAttribTexCoord0, "texCoord0");
    
    if (![self linkProgram:_program]) {
        if (vertShader) {
            glDeleteShader(vertShader);
            vertShader = 0;
        }
        if (fragShader) {
            glDeleteShader(fragShader);
            fragShader = 0;
        }
        if (_program) {
            glDeleteProgram(_program);
            _program = 0;
        }
        return NO;
    }
    
    if (vertShader) {
        glDetachShader(_program, vertShader);
        glDeleteShader(vertShader);
    }
    if (fragShader) {
        glDetachShader(_program, fragShader);
        glDeleteShader(fragShader);
    }
    
    return YES;
}

- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file
{
    GLint status;
    const GLchar *source;
    
    source = (GLchar *)[[NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil] UTF8String];
    if (!source) {
        NSLog(@"Failed to load vertex shader");
        return NO;
    }
    
    *shader = glCreateShader(type);
    glShaderSource(*shader, 1, &source, NULL);
    glCompileShader(*shader);
    
#if defined(DEBUG)
    GLint logLength;
    glGetShaderiv(*shader, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetShaderInfoLog(*shader, logLength, &logLength, log);
        NSLog(@"Shader compile log:\n%s", log);
        free(log);
    }
#endif
    
    glGetShaderiv(*shader, GL_COMPILE_STATUS, &status);
    if (status == 0) {
        glDeleteShader(*shader);
        return NO;
    }
    
    return YES;
}

- (BOOL)linkProgram:(GLuint)prog
{
    GLint status;
    glLinkProgram(prog);
    
#if defined(DEBUG)
    GLint logLength;
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program link log:\n%s", log);
        free(log);
    }
#endif
    
    glGetProgramiv(prog, GL_LINK_STATUS, &status);
    if (status == 0) {
        return NO;
    }
    
    return YES;
}

- (BOOL)validateProgram:(GLuint)prog
{
    GLint logLength, status;
    
    glValidateProgram(prog);
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program validate log:\n%s", log);
        free(log);
    }
    
    glGetProgramiv(prog, GL_VALIDATE_STATUS, &status);
    if (status == 0) {
        return NO;
    }
    
    return YES;
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
