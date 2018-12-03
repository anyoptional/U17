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
        dispatchedTasks.append(task)
    }
    
    /// Removes all commited tasks, note task may execute already.
    public func removeAllTasks() {
        dispatchedTasks.removeAll(keepingCapacity: true)
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
            while !self.dispatchedTasks.isEmpty {
                let task = self.dispatchedTasks.remove(at: 0)
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
