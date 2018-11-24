//
//  __objc_mediator.mm
//  Mediator
//
//  Created by Archer on 2018/11/21.
//

#import "__objc_msgSend.h"
#import "__objc_mediator.h"

// 这里为简单起见，用assert处理了所有错误
id __objc_performSelector(NSString *selName, NSString *clsName, NSString *moduleName, NSDictionary<NSString *, id>  *params) {
    // 参数检查
    NSCParameterAssert(selName);
    NSCParameterAssert(clsName);
    
    // 获取类名
    NSString *fullClassName = clsName;
    if (moduleName) { fullClassName = [NSString stringWithFormat: @"%@.%@", moduleName, clsName]; }
    // 获取类对象
    Class cls = NSClassFromString(fullClassName);
    // 获取选择子
    SEL sel = NSSelectorFromString(selName);
    
    NSCAssert(cls, @"Class not found.");
    NSCAssert(sel, @"SEL not found.");
    
    // 获取目标对象
    id target = [[cls alloc] init];
    
    NSCAssert([target respondsToSelector:sel], @"Target can not responds to input selector.");
    
    return __objc_msgSend(target, sel, params);
}
