//
//  __objc_msgSend.mm
//  Mediator
//
//  Created by Archer on 2018/11/22.
//

#import "__objc_msgSend.h"

// see RxCocoa -> _RxObjCRuntime.m for more information

typedef struct supported_type {
    const char *encoding;
} supported_type_t;

static supported_type_t supported_types[] = {
    { .encoding = @encode(void)},
    { .encoding = @encode(id)},
    { .encoding = @encode(Class)},
    { .encoding = @encode(void (^)(void))},
    { .encoding = @encode(char)},
    { .encoding = @encode(short)},
    { .encoding = @encode(int)},
    { .encoding = @encode(long)},
    { .encoding = @encode(long long)},
    { .encoding = @encode(unsigned char)},
    { .encoding = @encode(unsigned short)},
    { .encoding = @encode(unsigned int)},
    { .encoding = @encode(unsigned long)},
    { .encoding = @encode(unsigned long long)},
    { .encoding = @encode(float)},
    { .encoding = @encode(double)},
    { .encoding = @encode(BOOL)},
    { .encoding = @encode(const char*)},
};

static BOOL __objc_methodReturnTypeIsSupported(const char *type) {
    if (type == nil) {
        return NO;
    }
    
    for (int i = 0; i < sizeof(supported_types) / sizeof(supported_type_t); ++i) {
        if (supported_types[i].encoding[0] != type[0]) {
            continue;
        }
        if (strcmp(supported_types[i].encoding, type) == 0) {
            return YES;
        }
    }
    
    return NO;
}

static id _Nullable __objc_getReturnValue(NSInvocation *inv, NSMethodSignature *sig) {
    
    NSUInteger length = [sig methodReturnLength];
    if (length == 0) return nil;
    
    char *type = (char *)[sig methodReturnType];
    while (*type == 'r' || // const
           *type == 'n' || // in
           *type == 'N' || // inout
           *type == 'o' || // out
           *type == 'O' || // bycopy
           *type == 'R' || // byref
           *type == 'V') { // oneway
        type++; // cutoff useless prefix
    }
    
#define RETURN_VALUE(_type_) \
    else if (strcmp(type, @encode(_type_)) == 0) {\
        _type_ value = 0; \
        [inv getReturnValue:&value]; \
        return @(value); \
    }
    
    if (strcmp(type, @encode(id)) == 0 ||
        strcmp(type, @encode(Class)) == 0 ||
        strcmp(type, @encode(void (^)(void))) == 0) {
        __unsafe_unretained id value = nil;
        [inv getReturnValue:&value];
        return value;
    }
    RETURN_VALUE(char)
    RETURN_VALUE(short)
    RETURN_VALUE(int)
    RETURN_VALUE(long)
    RETURN_VALUE(long long)
    RETURN_VALUE(unsigned char)
    RETURN_VALUE(unsigned short)
    RETURN_VALUE(unsigned int)
    RETURN_VALUE(unsigned long)
    RETURN_VALUE(unsigned long long)
    RETURN_VALUE(float)
    RETURN_VALUE(double)
    RETURN_VALUE(BOOL)
    RETURN_VALUE(const char *)
    else {
        NSUInteger size = 0;
        NSGetSizeAndAlignment(type, &size, NULL);
        NSCParameterAssert(size > 0);
        uint8_t data[size];
        [inv getReturnValue:&data];
        return [NSValue valueWithBytes:&data objCType:type];
    }
#undef RETURN_VALUE
}

id __objc_msgSend(id target, SEL selector, NSDictionary<NSString *, id> * arguments) {
    // 校验
    NSMethodSignature *signature = [target methodSignatureForSelector:selector];
    
    NSCAssert(signature, @"Method signature does not exists.");
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    NSCAssert(invocation, @"Invocation does not exists.");
    
    NSCAssert(__objc_methodReturnTypeIsSupported(signature.methodReturnType), @"Method return type is unsupported");
    
    // 符合预期
    invocation.target = target;
    invocation.selector = selector;
    if (arguments) { [invocation setArgument:&arguments atIndex:2]; /** skip self & _cmd */ }
    
    [invocation invoke];
    
    return __objc_getReturnValue(invocation, signature);
}


