//
//  ESActionable.swift
//  ESActionable
//
//  Created by 罗树新 on 2020/12/28.
//

import Foundation

// MARK: Protocol

/// Protocol for action
public protocol Actionable {
    
    /// The `key` used to manage actions through `retain` or `release` method
    /// - Note：The suggestion is `ProcessInfo.processInfo.globallyUniqueString`
    var key: String { get }
    
    /// Method of executing `action` operation
    var selector: Selector { get }
}

/// Protocol for storing actions
public protocol ActionStoreable {
    
    /// Actions stored in `key`-`action` mode
    /// `key` is the key of the object following the `Actionable` protocol, and `action` is the method executed in the `selector` of the object following the `Aactionable` protocol
    var actions: [String: Actionable]! { get }
}

// MARK: class
/// An action class that follows the `Actionable` protocol and has no callback parameters,
public class VoidAction: Actionable {
    
    /// The `key` used to manage actions through `retain` or `release` method
    /// - Note：The default value is `ProcessInfo.processInfo.globallyUniqueString`
    public var key: String = ProcessInfo.processInfo.globallyUniqueString
    
    /// This `selector` is used to perform the action
    public var selector: Selector = #selector(perform)
    
    /// This `action` will be executed when the `selector` method of `Actionable` protocol is called
    var action: () -> ()
    
    /// Creat an `VoidAction` with an action
    /// - Parameter action: This `action` will be executed when the `selector` method of `Actionable` protocol is called
    /// - Returns: An `Actionable` `Voidaction` object to be stored
    init(_ action: @escaping () -> ()) {
        self.action = action
    }
    
    /// Execute action
    @objc func perform() {
        action()
    }
}

/// An action class that follows the `Actionable` protocol and has a undefined callback parameters,
public class ParametizedAction<T: Any>: Actionable {
    
    /// The `key` used to manage actions through `retain` or `release` method
    /// - Note：The default value is `ProcessInfo.processInfo.globallyUniqueString`
    public var key: String = ProcessInfo.processInfo.globallyUniqueString
    
    /// This `selector` is used to perform the action
    public var selector: Selector = #selector(perform)
    
    /// This `action` will be executed when the `selector` method of `Actionable` protocol is called
    var action: (T) -> ()
    
    /// Creat an `VoidAction` with an action
    /// - Parameter action: This `action` will be executed when the `selector` method of `Actionable` protocol is called
    /// - Returns: An `Actionable` `Voidaction` object to be stored
    init(_ action: @escaping (T) -> ()) {
        self.action = action
    }
    
    /// Execute action
    @objc func perform(parameters: Any) {
        action(parameters as! T)
    }
}

// MARK: extension
private var actionsKey: UInt8 = 0

/// The extension of `NSObject` class following `ActionStoreable` protocol
extension NSObject: ActionStoreable {
    
    /// Stored actions
    /// This is a dictionary with the `key` of the object that follows the actionable protocol as key and the object as value
    public var actions: [String: Actionable]! {
        get {
            var actions = objc_getAssociatedObject(self, &actionsKey) as? [String: Actionable]
            
            if actions == nil {
                actions = [String: Actionable]()
                self.actions = actions
            }
            
            return actions
        }
        
        set {
            objc_setAssociatedObject(self, &actionsKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    /// Store an object that follows the `Actionable` protocol
    /// - Parameters:
    ///   - action: An object that follows the `Actionable` protocol. In order to execute the action callback, its `selector` method will be executed at the appropriate time.
    public func retain(_ action: Actionable) {
        self.actions[action.key] = action
    }
    
    /// Release a stored `Actionable` object for cancel an action callback
    /// - Parameter action: An object that follows the `Actionable` protocol.
    public func release(_ action: Actionable) {
        self.actions[action.key] = nil
    }
}
