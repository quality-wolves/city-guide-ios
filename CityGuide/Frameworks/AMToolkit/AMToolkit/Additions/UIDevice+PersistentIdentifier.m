//
//  UIDevice+PersistentIdentifier.m
//
//  Created by Anton Kaizer on 12.08.13.
//

#import "UIDevice+PersistentIdentifier.h"
#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import <CommonCrypto/CommonDigest.h>
#import <objc/runtime.h>

static char kDeviceIdKey;

@implementation UIDevice (PersistentIdentifier)

- (NSString *) stringFromMD5: (NSString *) val{
    
    if(val == nil || [val length] == 0)
        return nil;
    
    const char *value = [val UTF8String];
    
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, (CC_LONG)strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    
    return outputString;
}

- (NSString *) macaddress {
    
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        free(buf);
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                           *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    
    return outstring;
}

- (NSString *) generateIdentifier {
	if ([[UIDevice currentDevice].systemVersion integerValue] >= 7) {
		return [ [[UIDevice currentDevice] identifierForVendor] UUIDString];
	}
    NSString *macaddress = [self macaddress];
    NSString *uniqueIdentifier = [self stringFromMD5: macaddress];
    
    return uniqueIdentifier;
}

- (void) writeDeviceID:(NSString *) deviceId {
	if (deviceId == nil)
		return;
	NSString *ident = [[[NSBundle mainBundle] objectForInfoDictionaryKey:(__bridge id)kCFBundleIdentifierKey] stringByAppendingString:@".DeviceId"];
	
	NSMutableDictionary *genericPasswordQuery = [NSMutableDictionary dictionary];
	
	[genericPasswordQuery setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
	[genericPasswordQuery setObject:ident forKey:(__bridge id)kSecAttrService];
	[genericPasswordQuery setObject:ident forKey:(__bridge id)kSecAttrAccount];
	
	[genericPasswordQuery setObject:(__bridge id)kSecAttrAccessibleAlwaysThisDeviceOnly forKey:(__bridge id)kSecAttrAccessible];
	[genericPasswordQuery setObject:[deviceId dataUsingEncoding:NSUTF8StringEncoding] forKey:(__bridge id)kSecValueData];
	
	NSDictionary *tempQuery = [NSDictionary dictionaryWithDictionary:genericPasswordQuery];
	OSStatus st = SecItemAdd((__bridge CFDictionaryRef)tempQuery, NULL);
	if (st != noErr)
	{
		NSLog(@"error during saving persistent identifier");
	}
}

- (NSString *) readDeviceId {
	NSString *ident = [[[NSBundle mainBundle] objectForInfoDictionaryKey:(__bridge id)kCFBundleIdentifierKey] stringByAppendingString:@".DeviceId"];
	
	NSMutableDictionary *genericPasswordQuery = [[NSMutableDictionary alloc] init];
	
	[genericPasswordQuery setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
	[genericPasswordQuery setObject:ident forKey:(__bridge id)kSecAttrService];
	[genericPasswordQuery setObject:ident forKey:(__bridge id)kSecAttrAccount];
	
	[genericPasswordQuery setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
	[genericPasswordQuery setObject:(__bridge id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
	
	NSDictionary *tempQuery = [NSDictionary dictionaryWithDictionary:genericPasswordQuery];
	
	CFDataRef pwdData = NULL;
	if (SecItemCopyMatching((__bridge CFDictionaryRef)tempQuery, (CFTypeRef *)&pwdData) == noErr)
	{
        NSData *result = (__bridge_transfer NSData *)pwdData;
        NSString *password = [[NSString alloc] initWithBytes:[result bytes] length:[result length]
													encoding:NSUTF8StringEncoding];
		return password;
	}
	return nil;
}

- (NSString *) persistentIdentifier {
	NSString *deviceId = objc_getAssociatedObject(self, &kDeviceIdKey);
	if (deviceId == nil) {
		deviceId = [self readDeviceId];
		objc_setAssociatedObject(self, &kDeviceIdKey, deviceId, OBJC_ASSOCIATION_RETAIN);
	}
	if (deviceId == nil) {
		deviceId = [self generateIdentifier];
		[self writeDeviceID:deviceId];
		objc_setAssociatedObject(self, &kDeviceIdKey, deviceId, OBJC_ASSOCIATION_RETAIN);
	}
	return deviceId;
}

@end
