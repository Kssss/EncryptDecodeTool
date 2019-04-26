//
//  NSString+MTSS3DES.h
//  WXGZ_SDK
//
//  Created by 谭建中 on 14/3/2019.
//  Copyright © 2019 ijiami. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (MTSS3DES)
//先base64编码---->3DES加密---->再base64编码
+ (NSString *)encrypt3DES:(NSString *)plainText key:(NSString *)key;
//先base64解码--->3DES解密------->base64解码
+ (NSString *)decrypt3DES:(NSString *)base64text key:(NSString *)key;
@end

NS_ASSUME_NONNULL_END
