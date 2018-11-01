# EncryptDecodeTool
密码+pbkdf2_hmac 盐 用户ID ,AES,base64


1. 先将密码使用pbkdf2_hmac算法, 哈希算法为 SHA256, 盐为用户id， 次数为1000000 得到十六进制的字符串,截取前32位 为 key 
2. 使用步骤1 得到的密钥，用AES 加密算法, CBC 模式, PCKS5PADDING 填充模式, iv 取 秘钥 的前16位 加密要传送的json数据 
3. 将加密的得到的bytes进行base64编码得到加密后文本




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
