/*
 * Copyright (c) 2023 Universal-SystemKit. All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Define Enum
typedef NS_ENUM(size_t, SKSecurityAESType) {
    
    /// AES-128의 경우 128 Bit의 대칭키를 쓰는 암호화 알고리즘
    AES128 = kCCKeySizeAES128,
    
    /// AES-192의 경우 192 Bit의 대칭키를 쓰는 암호화 알고리즘
    AES192 = kCCKeySizeAES192,
    
    /// AES-256의 경우 256 Bit의 대칭키를 쓰는 암호화 알고리
    AES256 = kCCKeySizeAES256
};

typedef NS_ENUM(NSInteger, SKSecurityCryptType) {
  
    /// 암호화 (Encryption)
    Encrypt = 0,
    
    /// 복호화
    Decrypt = 1
};

@interface SKSecurity : NSObject

#pragma mark - Define Properties
+ (instancetype) shared;

#pragma mark - Define Instance Method
- (nonnull NSData *) encrypt: (nonnull NSString *) key
                            : (const SKSecurityAESType) keyType
                            : (nonnull NSString *) iv
                            : (nonnull NSData *) data;

- (nonnull NSData *) decrypt: (nonnull NSString *) key
                            : (const SKSecurityAESType) keyType
                            : (nonnull NSString *) iv
                            : (nonnull NSData *) data;

- (nonnull NSString *) createInitializationVector;

@end

NS_ASSUME_NONNULL_END
