//
//  NSString+MTSS3DES.m
//  WXGZ_SDK
//
//  Created by 谭建中 on 14/3/2019.
//  Copyright © 2019 ijiami. All rights reserved.
//

#import "NSString+MTSS3DES.h"
#import "MTSSLog.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCrypto.h>

@implementation NSString (MTSS3DES)
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
        //加密结果base64编码
        result = [resultData base64EncodedStringWithOptions:0];
    }
    return result;
}


//3DES解密
+ (NSString *)decrypt3DES:(NSString *)base64text key:(NSString *)key
{
    //先base64解码
    NSData *unBase64Data = [[NSData alloc] initWithBase64EncodedString:base64text options:0];

    //解密3DES
    NSData *unencData = [self decryptUse3DES:unBase64Data keyString:key];
    
    NSString *result = @"";
    if (unencData)
    {
        //加密结果base64解码
        result =[[NSString alloc] initWithData:unencData encoding:NSUTF8StringEncoding];
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
//3DES解密
+ (NSData *)decryptUse3DES:(NSData*)EncryptData keyString:(NSString*)keyString
{
    const void * vplainText;
    size_t plainTextBufferSize;
    
    //解密
    plainTextBufferSize= [EncryptData length];
    vplainText = [EncryptData bytes];
    
    CCCryptorStatus ccStatus;
    uint8_t * bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    // uint8_t ivkCCBlockSize3DES;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES)
    &~(kCCBlockSize3DES- 1);
    
    bufferPtr = malloc(bufferPtrSize* sizeof(uint8_t));
    memset((void*)bufferPtr,0x0, bufferPtrSize);
    
    NSString * key = keyString;
    NSString * initVec = nil;
    
    const void * vkey= (const void *)[key UTF8String];
    const void * vinitVec= (const void *)[initVec UTF8String];
    
    uint8_t iv[kCCBlockSize3DES];
    memset((void*) iv,0x0, (size_t)sizeof(iv));
    
    ccStatus = CCCrypt(kCCDecrypt,
                       kCCAlgorithm3DES,
                       kCCOptionECBMode | kCCOptionPKCS7Padding,
                       vkey,//"123456789012345678901234", //key
                       kCCKeySize3DES,
                       vinitVec,//"init Vec", //iv,
                       vplainText,//plainText,
                       plainTextBufferSize,
                       (void*)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    
    if (ccStatus == kCCSuccess) NSLog(@"SUCCESS");
    if (ccStatus== kCCParamError) return nil;
    else if (ccStatus == kCCBufferTooSmall) return nil;
    else if (ccStatus == kCCMemoryFailure) return nil;
    else if (ccStatus == kCCAlignmentError) return nil;
    else if (ccStatus == kCCDecodeError) return nil;
    else if (ccStatus == kCCUnimplemented) return nil;
    
    NSString * result = [[NSString alloc] initWithData:[NSData
                                                 dataWithBytes:(const void *)bufferPtr
                                                 length:(NSUInteger)movedBytes]
                                       encoding:NSUTF8StringEncoding];
    
    NSData *data = [[NSData alloc] initWithBase64EncodedString:result options:NSDataBase64DecodingIgnoreUnknownCharacters];
    
    
    return data;
}


@end
