//
//  FDTransaction.swift
//  Fate
//
//  Created by Archer on 2018/12/3.
//

import Foundation

/// 在当前runloop空闲时执行一些操作
public class FDTransaction: NSObject {
    
    public typealias Task = @convention(block) () -> ()
    
    public static let `default` = FDTransaction()
    
    private lazy var dispatchedTasks = [Task]()
    
    private override init() {
        super.init()
        commonInit()
    }
}

extension FDTransaction {
    /// Executes task when main runloop is before waiting.
    public func commit(task: @escaping Task) {
        objc_sync_enter(self)
        dispatchedTasks.append(task)
        objc_sync_exit(self)
    }
    
    /// Removes all commited tasks, note that task may execute already.
    public func removeAllTasks() {
        objc_sync_enter(self)
        dispatchedTasks.removeAll(keepingCapacity: true)
        objc_sync_exit(self)
    }
}

extension FDTransaction {
    private func commonInit() {
        let runloop = CFRunLoopGetMain()
        let activity = CFRunLoopActivity.beforeWaiting.rawValue
        let observer = CFRunLoopObserverCreateWithHandler(kCFAllocatorDefault,
                                                          activity,
                                                          true, 0xFFFFFF) // after CATransaction
        { (observer, activity) in
            objc_sync_enter(self)
            var tasks = self.dispatchedTasks
            self.removeAllTasks()
            objc_sync_exit(self)
            while !tasks.isEmpty {
                let task = tasks.remove(at: 0)
                // 以source0分解到runloop
                self.perform(#selector(self.invokeTask),
                             on: Thread.main,
                             with: task,
                             waitUntilDone: false,
                             modes: [RunLoop.Mode.default.rawValue])
            }
        }
        CFRunLoopAddObserver(runloop, observer, .defaultMode)
    }
    
    @objc private func invokeTask(_ task: Task) {
        task()
    }
}
