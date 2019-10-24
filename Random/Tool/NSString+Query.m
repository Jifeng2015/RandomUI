//
//  NSString+Query.m
//  Random
//
//  Created by FangZhongli on 2019/9/20.
//  Copyright © 2019 Lingju. All rights reserved.
//

#import "NSString+Query.h"
#include <CommonCrypto/CommonCrypto.h>


@implementation NSString (Query)
- (NSString *)md5 {
    
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(data.bytes, (CC_LONG)data.length, result);
    
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
    
}
@end
