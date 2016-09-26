//
//  TextureManager.m
//  OpenGLGraphics
//
//  Created by wsk on 16/9/26.
//  Copyright © 2016年 cyd. All rights reserved.
//

#import "TextureManager.h"

@implementation TextureManager

+ (void)loadTexture:(GLuint *)textureName texture:(UIImage *)texture texType:(NSString *)texType{
    UIImage *image = texture;
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
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_MIRRORED_REPEAT);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_MIRRORED_REPEAT);
        
        glEnable(GL_TEXTURE_2D);
    }
}

@end
