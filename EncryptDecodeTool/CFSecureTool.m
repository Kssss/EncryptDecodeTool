//
//  CFSecureTool.m
//  secTest
//
//  Created by 谭建中 on 16/10/2018.
//  Copyright © 2018 谭建中. All rights reserved.
//

#import "CFSecureTool.h"
#include <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonKeyDerivation.h>
#import "NSString+AES.h"


@implementation CFSecureTool
+ (NSString *)CryText:(NSString *)originText pwd:(NSString *)pwd salt:(NSString *)salt
{
    //1 生成密钥
    NSData * keyData = [self AESKeyForPassword:pwd withSalt:salt];
    NSString *key = [[self convertDataToHexStr:keyData] substringToIndex:32];
    NSString *iv = [key substringToIndex:16];

    //2 数据加密
    NSString *secText = [originText aci_encryptWithAESWithKey:key iv:iv];

    //3 返回
    return secText;
}
+ (NSString *)deCryText:(NSString *)secText pwd:(NSString *)pwd salt:(NSString *)salt
{
    //1 生成密钥
    NSData * keyData = [self AESKeyForPassword:pwd withSalt:salt];
    NSString *key = [[self convertDataToHexStr:keyData] substringToIndex:32];
    NSString *iv = [key substringToIndex:16];
    
    //2 数据加密
    NSString *originText = [secText aci_decryptWithAESWithKey:key iv:iv];
    
    //3 返回
    return originText;
}

+ (NSData *)AESKeyForPassword:(NSString *)password withSalt:(NSString *)saltStr
{
    //Derive a key from a text password/passphrase
    NSMutableData *derivedKey = [NSMutableData dataWithLength:kCCKeySizeAES256];
    
    //    NSData *salt = [NSData dataWithBytes:saltBuff length:kCCKeySizeAES128];
    NSData *salt = [saltStr dataUsingEncoding:NSUTF8StringEncoding];
    
    int result = CCKeyDerivationPBKDF(kCCPBKDF2,        // algorithm算法
                                      password.UTF8String,  // password密码
                                      password.length,      // passwordLength密码的长度
                                      salt.bytes,           // salt内容
                                      salt.length,          // saltLen长度
                                      kCCPRFHmacAlgSHA256,    // PRF
                                      1000000,         // rounds循环次数
                                      derivedKey.mutableBytes, // derivedKey
                                      derivedKey.length);   // derivedKeyLen derive:出自
    
    NSAssert(result == kCCSuccess,
             @"Unable to create AES key for spassword: %d", result);
    return derivedKey;
}

+ (NSString *)convertDataToHexStr:(NSData *)data
{
    if (!data || [data length] == 0) {
        return @"";
    }
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[data length]];
    
    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        unsigned char *dataBytes = (unsigned char*)bytes;
        for (NSInteger i = 0; i < byteRange.length; i++) {
            NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0xff];
            if ([hexStr length] == 2) {
                [string appendString:hexStr];
            } else {
                [string appendFormat:@"0%@", hexStr];
            }
        }
    }];
    return string;
}

@end
