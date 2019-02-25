//
//  MTSSDES.h
//  WXGZ_SDK
//
//  Created by huang on 2018/8/3.
//  Copyright © 2018 ijiami. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTSSDES : NSObject


//3DES加密
+ (NSString *)encrypt3DES:(NSString *)plainText key:(NSString *)key;
@end
