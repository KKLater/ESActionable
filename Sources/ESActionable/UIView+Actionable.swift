//
//  UIView+Actionable.swift
//  ESActionable
//
//  Created by 罗树新 on 2020/12/29.
//

import UIKit

// MARK:  Public
public extension UIView {

    @discardableResult
    func tap<T: UIView>(taps: Int = 1, fingers: Int = 1, action: @escaping (T) -> ()) -> UITapGestureRecognizer {
        let action = CustomParametizedAction(parameter: (self as! T), action: action)
        return add(gesture: .tap(taps: taps, fingers: fingers), action: action) as! UITapGestureRecognizer
    }

    @discardableResult
    func tap(taps: Int = 1, fingers: Int = 1, action: @escaping () -> ()) -> UITapGestureRecognizer {
        let action = VoidAction(action)
        return add(gesture: .tap(taps: taps, fingers: fingers), action: action) as! UITapGestureRecognizer
    }

    @discardableResult
    func swipe<T: UIView>(direction: UISwipeGestureRecognizer.Direction?,  fingers: Int = 1, action: @escaping (T) -> ()) -> UISwipeGestureRecognizer {
        let action = CustomParametizedAction(parameter: (self as! T), action: action)
        return add(gesture: .swipe(direction: direction, fingers: fingers), action: action) as! UISwipeGestureRecognizer
    }
    
    @discardableResult
    func swipe(direction: UISwipeGestureRecognizer.Direction?, fingers: Int = 1, action: @escaping () -> ()) -> UISwipeGestureRecognizer {
        let action = VoidAction(action)
        return add(gesture: .swipe(direction: direction, fingers: fingers), action: action) as! UISwipeGestureRecognizer
    }
    
    @discardableResult
    func pan<T: UIView>(minimumNumberOfTouches: Int = 1, maximumNumberOfTouches: Int?, action: @escaping (T) -> ()) -> UIPanGestureRecognizer {
        let action = CustomParametizedAction(parameter: (self as! T), action: action)
        return add(gesture: .pan(minimumNumberOfTouches: minimumNumberOfTouches, maximumNumberOfTouches: maximumNumberOfTouches), action: action) as! UIPanGestureRecognizer
    }
  
    @discardableResult
    func pan(minimumNumberOfTouches: Int, maximumNumberOfTouches: Int?, action: @escaping () -> ()) -> UIPanGestureRecognizer {
        let action = VoidAction(action)
        return add(gesture: .pan(minimumNumberOfTouches: minimumNumberOfTouches, maximumNumberOfTouches: maximumNumberOfTouches), action: action) as! UIPanGestureRecognizer
    }

    @available(iOS 3.2, *)
    @discardableResult
    func pinch<T: UIView>(scale: CGFloat, action: @escaping (T) -> ()) -> UIPinchGestureRecognizer {
        let action = CustomParametizedAction(parameter: (self as! T), action: action)
        return add(gesture: .pinch(scale: scale), action: action) as! UIPinchGestureRecognizer
    }
    
    @available(iOS 3.2, *)
    @discardableResult
    func pinch(scale: CGFloat, action: @escaping () -> ()) -> UIPinchGestureRecognizer {
        let action = VoidAction(action)
        return add(gesture: .pinch(scale: scale), action: action) as! UIPinchGestureRecognizer
    }
    
    @available(iOS 3.2, *)
    @discardableResult
    func rotation<T: UIView>(rotation: CGFloat, action: @escaping (T) -> ()) -> UIRotationGestureRecognizer {
        let action = CustomParametizedAction(parameter: (self as! T), action: action)
        return add(gesture: .rotation(rotation: rotation), action: action) as! UIRotationGestureRecognizer
    }
    
    @available(iOS 3.2, *)
    @discardableResult
    func rotation(rotation: CGFloat, action: @escaping () -> ()) -> UIRotationGestureRecognizer {
        let action = VoidAction(action)
        return add(gesture: .rotation(rotation: rotation), action: action) as! UIRotationGestureRecognizer
    }
    
    @available(iOS 3.2, *)
    @discardableResult
    func longPress<T: UIView>(numberOfTapsRequired: Int = 0, numberOfTouchesRequired: Int = 1, minimumPressDuration: TimeInterval = 0.5, allowableMovement: CGFloat = 10, action: @escaping (T) -> ()) -> UILongPressGestureRecognizer {
        let action = CustomParametizedAction(parameter: (self as! T), action: action)
        return add(gesture: .longPress(numberOfTapsRequired: numberOfTapsRequired, numberOfTouchesRequired: numberOfTouchesRequired, minimumPressDuration: minimumPressDuration, allowableMovement: allowableMovement), action: action) as! UILongPressGestureRecognizer
    }
    
    @available(iOS 3.2, *)
    @discardableResult
    func longPress(numberOfTapsRequired: Int = 0, numberOfTouchesRequired: Int = 1, minimumPressDuration: TimeInterval = 0.5, allowableMovement: CGFloat = 10, action: @escaping () -> ()) -> UILongPressGestureRecognizer {
        let action = VoidAction(action)
        return add(gesture: .longPress(numberOfTapsRequired: numberOfTapsRequired, numberOfTouchesRequired: numberOfTouchesRequired, minimumPressDuration: minimumPressDuration, allowableMovement: allowableMovement), action: action) as! UILongPressGestureRecognizer
    }
    
    @discardableResult
    private func add(gesture: Gesture, action: Actionable) -> UIGestureRecognizer {
        retain(action)
        let gesture = gesture.recognizer(action: action)
        isUserInteractionEnabled = true
        addGestureRecognizer(gesture)
        return gesture
    }
}

// MARK:  fileprivate

fileprivate extension UIGestureRecognizer {
    convenience init<T: UIGestureRecognizer>(action: @escaping (T) -> ()) {
        let action = ParametizedAction(action)
        self.init(target: action, action: action.selector)
        retain(action)
    }
    
    convenience init(action: @escaping () -> ()) {
        let action = VoidAction(action)
        self.init(target: action, action: action.selector)
        retain(action)
    }
}

fileprivate class CustomParametizedAction<T: NSObject>: Actionable {
    let key: String = ProcessInfo.processInfo.globallyUniqueString
    let selector: Selector = #selector(perform)
    
    let action: (T) -> ()
    weak var parameter: T?
    
    init(parameter: T?, action: @escaping (T) -> ()) {
        self.action = action
        self.parameter = parameter
    }
    
    @objc func perform() {
        guard let parameter = parameter else { return }
        action(parameter)
    }
}

fileprivate enum Gesture {
    case tap(taps: Int, fingers: Int)
    case swipe(direction: UISwipeGestureRecognizer.Direction?, fingers: Int)
    case pan(minimumNumberOfTouches: Int, maximumNumberOfTouches: Int?)
    case pinch(scale: CGFloat)
    case rotation(rotation: CGFloat)
    case longPress(numberOfTapsRequired: Int, numberOfTouchesRequired: Int, minimumPressDuration: TimeInterval, allowableMovement: CGFloat)
    
    fileprivate func recognizer(action: Actionable) -> UIGestureRecognizer {
        switch self {
        case let .tap(taps, fingers):
            let recognizer = UITapGestureRecognizer(target: action, action: action.selector)
            recognizer.numberOfTapsRequired = taps
            recognizer.numberOfTouchesRequired = fingers
            return recognizer
        case let .swipe(direction, fingers):
            let recognizer = UISwipeGestureRecognizer(target: action, action: action.selector)
            if let direction = direction {
                recognizer.direction = direction
            }
            recognizer.numberOfTouchesRequired = fingers
            return recognizer
        case let .pan(min, max):
            let recognizer = UIPanGestureRecognizer(target: action, action: action.selector)
            recognizer.minimumNumberOfTouches = min
            if let maximumNumberOfTouches = max {
                recognizer.maximumNumberOfTouches = maximumNumberOfTouches
            }
            return recognizer
        case let .pinch(scale):
            let recognizer = UIPinchGestureRecognizer(target: action, action: action.selector)
            recognizer.scale =  scale
            return recognizer
        case let .rotation(rotation):
            let recognizer = UIRotationGestureRecognizer(target: action, action: action.selector)
            recognizer.rotation = rotation
            return recognizer
        case let .longPress(numberOfTapsRequired, numberOfTouchesRequired, minimumPressDuration, allowableMovement):
            let recognizer = UILongPressGestureRecognizer(target: action, action: action.selector)
            recognizer.numberOfTapsRequired = numberOfTapsRequired
            recognizer.numberOfTouchesRequired = numberOfTouchesRequired
            recognizer.minimumPressDuration = minimumPressDuration
            recognizer.allowableMovement = allowableMovement
            return recognizer
        }
    }
}
