//
//  NSData+HexStr.h
//  secTest
//
//  Created by 谭建中 on 16/10/2018.
//  Copyright © 2018 谭建中. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData (HexStr)
- (NSData *)convertHexStrToData:(NSString *)str;
@end

NS_ASSUME_NONNULL_END
