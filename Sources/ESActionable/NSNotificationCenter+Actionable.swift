//
//  NSNotificationCenter+Actionable.swift
//  ESActionable
//
//  Created by 罗树新 on 2020/12/29.
//

import Foundation

/// Class for storing notification observer
/// Observer is stored as dictionary. The notification name is key, and the instance object that follows the `NotificationCenterAction` protocol is value
/// Object observe or post notifications with the notificationCenter. Its default value is `NotificationCenter.default`
/// The observers storted will be released when the store perform `deinit` method.
public class ObserverStore: NSObject {
    fileprivate var observerActions: [NSNotification.Name: NotificationCenterAction] = [NSNotification.Name: NotificationCenterAction]()
    
    public var notifivationCenter: NotificationCenter { .default }
    
    deinit {
        clear()
    }
}

/// The `extension` of the `NSObject` provides the `observe` or `post` notification method
public extension NSObject {
    
    /// Observe a notification and execute the action when the notification is received
    /// - Parameters:
    ///   - name: The `name` of the notification
    ///   - object: The object posting the named notfication
    ///   - action: The action will be executed when received the notification. Its callback notification arguments
    func observe(_ name: NSNotification.Name, object: AnyObject? = nil, action: @escaping (NSNotification) -> ()) {
        let action = NotificationCenterParametizedAction(name: name, observer: self, object: object, action: action)
        observerStore.notifivationCenter.addObserver(action, selector: action.selector, name: name, object: object)
        observerStore.retainObserve(action, self)
    }
    
    /// Observe a notification and execute the action when the notification is received
    /// - Parameters:
    ///   - name: The `name` of the notification
    ///   - object: The object posting the named notfication
    ///   - action: The action will be executed when received the notification. Its callback `nil`
    func observe(_ name: NSNotification.Name, object: AnyObject? = nil, action: @escaping () -> ()) {
        let action = NotificationCenterVoidAction(name: name, observer: self, object: object, action: action)
        observerStore.notifivationCenter.addObserver(action, selector: action.selector, name: name, object: object)
        observerStore.retainObserve(action, self)
    }
    
    /// Unobserve a notification and release the observe action for this notification
    /// - Parameter name: Name of the notification
    func unobserve(_ name: NSNotification.Name) {
        for (key, value) in observerStore.observerActions {
            if key == name {
                observerStore.notifivationCenter.removeObserver(value)
                observerStore.releaseObserve(value, self)
            }
        }
    }
    
    /// Post a notification
    /// - Parameter name: Name of the notification
    func post(_ name: NSNotification.Name?) {
        if let name = name {
            observerStore.notifivationCenter.post(Notification(name: name))
        }
    }
    
//    func addRunloopObserver() {
//        let flags: CFRunLoopActivity = [.beforeWaiting, .exit]
//        let observer = CFRunLoopObserverCreateWithHandler(kCFAllocatorDefault, flags.rawValue, true, 0) { [weak self] (observer, activity) in
//            self?.clean()
//        }
//        CFRunLoopAddObserver(CFRunLoopGetCurrent(), observer, .commonModes)
//    }
}

// MARK: Private
fileprivate protocol NotificationCenterAction: Actionable {
    var notificationName: NSNotification.Name { get }
    var notificationObject: AnyObject? { get }
    var observer: NSObject? { get set }
}

fileprivate class NotificationCenterVoidAction: VoidAction, NotificationCenterAction {
    let notificationName: NSNotification.Name
    let notificationObject: AnyObject?
    weak var observer: NSObject?

    init(name: NSNotification.Name, observer: NSObject? = nil, object: AnyObject?, action: @escaping () -> Void) {
        self.notificationName = name
        self.notificationObject = object
        self.observer = observer
        super.init(action)
    }
    
    override func perform() {
        if observer != nil {
            super.perform()
        }
    }
}

fileprivate class NotificationCenterParametizedAction: ParametizedAction<NSNotification>, NotificationCenterAction {
    let notificationName: NSNotification.Name
    let notificationObject: AnyObject?
    weak var observer: NSObject?

    init(name: NSNotification.Name, observer: NSObject? = nil, object: AnyObject?, action: @escaping (NSNotification) -> Void) {
        self.notificationName = name
        self.notificationObject = object;
        self.observer = observer
        super.init(action)
    }
    
    override func perform(parameters: Any) {
        if observer != nil {
            super.perform(parameters: parameters)
        }
    }
}

fileprivate extension ObserverStore {

    func retainObserve(_ action: NotificationCenterAction, _ object: NSObject) {
        observerActions[action.notificationName] = action
    }

    func releaseObserve(_ action: NotificationCenterAction, _ object: NSObject) {
        observerActions[action.notificationName] = nil
    }
        
    func clear() {
        for (key, value) in observerActions {
            notifivationCenter.removeObserver(value)
            observerActions[key] = nil
        }
    }
}

private var observerStoreKey: UInt8 = 0
fileprivate extension NSObject {
    var observerStore: ObserverStore! {
        get {
            var observerStore = objc_getAssociatedObject(self, &observerStoreKey) as? ObserverStore
            if observerStore == nil {
                observerStore = ObserverStore()
                self.observerStore = observerStore
            }
            return observerStore
        }
        set {
            objc_setAssociatedObject(self, &observerStoreKey, newValue, .OBJC_ASSOCIATION_RETAIN)

        }
    }
}
