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

#import "SKSecurity.h"

@implementation SKSecurity

#pragma mark - Public Instance Method
+ (instancetype) shared {

    static SKSecurity * shared = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        shared = [SKSecurity new];
    });
    
    return shared;
}

#pragma mark - Private Instance Method
- (nonnull const char *) copyPointer: (const size_t) length
                                    : (nonnull const NSString *) target {
    
    char * pointee = (char *) malloc(length);
    
    // write zeroes to a byte string
    bzero(pointee, length);
    
    // Converts the string to a given encoding and stores it in a buffer.
    [target getCString: pointee maxLength: length encoding: NSUTF8StringEncoding];
    
    return pointee;
}

- (nullable NSData *) getDataByStatus: (CCCryptorStatus) status
                                     : (nonnull void *) dataWithBytes
                                     : (size_t) length {
    
    switch (status) {
        case kCCSuccess:
            NSLog(@"[SKSecurity] Operation completed normally");
            return [NSData dataWithBytes: dataWithBytes length: length];

        case kCCParamError:
            NSLog(@"[SKSecurity] Illegal parameter value");
            return NULL;
        
        case kCCBufferTooSmall:
            NSLog(@"[SKSecurity] Insufficent Buffer Provided for Specified Operation");
            return NULL;
        
        case kCCMemoryFailure:
            NSLog(@"[SKSecurity] Memory allocation failure");
            return NULL;
        
        case kCCDecodeError:
            NSLog(@"[SKSecurity] Input Size was not Aligned Properly");
            return NULL;
        
        case kCCUnimplemented:
            NSLog(@"[SKSecurity] Function not Implemented for the Current Algorithm");
            return NULL;
            
        case kCCInvalidKey:
            NSLog(@"[SKSecurity] Key is not valid");
            return NULL;
            
        default:
            NSLog(@"[SKSecurity] Unknown CCCryptorStatus Error");
            return NULL;
    }
}

- (NSData *) crypt: (const NSString *) key
                  : (const SKSecurityAESType) keySize
                  : (const NSString *) iv
                  : (const NSData *) data
                  : (const CCOperation) operation {
    
    @synchronized (self) {
        
        // Creating an cryption key buffer
        const size_t keyLength = keySize;
        const char * keyPointee = [self copyPointer: keyLength
                                                   : key];
            
        // Creating an initialization vector buffer
        const size_t ivLength = kCCBlockSizeAES128;
        const char * ivPointee = [self copyPointer: ivLength
                                                  : iv];
        
        const size_t blockLength = data.length + kCCBlockSizeAES128;
        void * block = (void *) malloc(blockLength);
        
        // Performing Encryption or Decryption Operation
        size_t bytesCrypted = 0;
        const CCCryptorStatus status = CCCrypt(operation, kCCAlgorithmAES128, kCCOptionPKCS7Padding,
                                               keyPointee, keySize,
                                               ivPointee,
                                               data.bytes, data.length,
                                               block, blockLength,
                                               &bytesCrypted);
        
        return [self getDataByStatus: status
                                    : block
                                    : bytesCrypted];
    }
}

#pragma mark - Public Instance Method
- (NSData *) encrypt: (const NSString *) key
                    : (const SKSecurityAESType) keyType
                    : (const NSString *) iv
                    : (NSData *) data {
    
    NSLog(@"[SKSecurity] Performing Encryption Operation");
    
    return [self crypt: key
                      : keyType
                      : iv
                      : data
                      : ::Encrypt];
}

- (NSData *) decrypt: (const NSString *) key
                    : (const SKSecurityAESType) keyType
                    : (const NSString *) iv
                    : (NSData *) data {
    
    NSLog(@"[SKSecurity] Performing Decryption Operation");
   
    return [self crypt: key
                      : keyType
                      : iv
                      : data
                      : ::Decrypt];
}

- (NSString *) createInitializationVector {
    
    const NSArray * components = [NSUUID.UUID.UUIDString componentsSeparatedByString: @"-"];
    
    NSMutableString * stringValue = [[NSMutableString alloc] init];
    
    for (NSString * element in components) {
        [stringValue appendString: element];
    }
    
    NSMutableString * result = [[NSMutableString alloc] init];
    for (int index = 0; index < 16; index++) {
        NSUInteger characterAtIndex = arc4random() % stringValue.length;
        const unichar character = [stringValue characterAtIndex: characterAtIndex];
        [result appendFormat: @"%C", character];
    }
    
    // The IV (Initialization Vector) must have a length of 16 bytes
    return result;
}

@end
