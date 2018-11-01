//
//  CFSecureTool.h
//  secTest
//
//  Created by 谭建中 on 16/10/2018.
//  Copyright © 2018 谭建中. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+Json.h"

NS_ASSUME_NONNULL_BEGIN

@interface CFSecureTool : NSObject


/**
 输入原始内容，输出加密的内容
 @param originText 原内容
 @param pwd 密码
 @param salt 盐
 @return 密文
 */
+ (NSString *)CryText:(NSString *)originText pwd:(NSString *)pwd salt:(NSString *)salt;

/**
 解密
 @param secText 密文
 @param pwd 密码
 @param salt 盐
 @return 原始文
 */
+ (NSString *)deCryText:(NSString *)secText pwd:(NSString *)pwd salt:(NSString *)salt;
@end

NS_ASSUME_NONNULL_END
