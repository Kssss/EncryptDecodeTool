//
//  MTSSDES.m
//  WXGZ_SDK
//
//  Created by huang on 2018/8/3.
//  Copyright © 2018 ijiami. All rights reserved.
//

#import "MTSSDES.h"
#import "MTSSLog.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCrypto.h>
@implementation MTSSDES


//加密
+ (NSString *)encrypt3DES:(NSString *)plainText key:(NSString *)key
{
    //先base64编码
    NSData *plainData = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    NSData *baes64Data = [plainData base64EncodedDataWithOptions:0];


    //3des加密
    Byte *bKey = (Byte *)[[key dataUsingEncoding:NSUTF8StringEncoding] bytes];
    NSData *resultData =  [self encryptUse3DES:baes64Data key:bKey];

    NSString *result = @"";
    if (resultData)
    {
         //加密结果base64转字符串
        result = [resultData base64EncodedStringWithOptions:0];
    }
    return result;
}
//3DES 加密
+ (NSData *)encryptUse3DES:(NSData *)plainText key:(Byte *)key
{
    NSData *textData = plainText;
    NSUInteger dataLength = [textData length];
    
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    
    bufferPtrSize = (dataLength + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithm3DES,
                                          kCCOptionECBMode | kCCOptionPKCS7Padding,
                                          key, kCCKeySize3DES,
                                          nil,
                                          [textData bytes], dataLength,
                                          bufferPtr, bufferPtrSize,
                                          &numBytesEncrypted);
    
    if (cryptStatus == kCCSuccess) {
        NSData *data = [NSData dataWithBytes:bufferPtr length:(NSUInteger)numBytesEncrypted];
        free(bufferPtr);
        return data;
    }
    free(bufferPtr);
    return nil;
}

@end
