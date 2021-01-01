//
//  UIControl+Actionable.swift
//  ESActionable
//
//  Created by 罗树新 on 2020/12/29.
//

import UIKit


// MARK: Public

public extension UIControl {
    func add<T: UIControl>(event: UIControl.Event, action: @escaping (T, UIEvent?) -> ()) -> Actionable {
        let actionObj = EventAction(event: event, action: action)
        add(event: event, action: actionObj)
        return actionObj
    }
    
    func add<T: UIControl>(event: UIControl.Event, action: @escaping (T) -> ()) -> Actionable {
        let actionObj = ControlParametizedAction(event: event, action: action)
        add(event: event, action: actionObj)
        return actionObj
    }
    
    func add(event: UIControl.Event, action: @escaping () -> ()) -> Actionable {
        let actionObj = ControlVoidActionable(event: event, action: action)
        add(event: event, action: actionObj)
        return actionObj
    }
    
    func add<T: UIControl>(events: [UIControl.Event], action: @escaping (T, UIEvent?) -> ()) -> [Actionable] {
        return events.map { add(event: $0, action: action)}
    }
    
    func add<T: UIControl>(events: [UIControl.Event], action: @escaping (T) -> ()) -> [Actionable] {
        return events.map { add(event: $0, action: action) }
    }
    
    func add(events: [UIControl.Event], action: @escaping () -> ()) -> [Actionable] {
        return events.map { add(event: $0, action: action) }
    }

    func add(event: UIControl.Event, action: Actionable) {
        retain(action)
        addTarget(action, action: action.selector, for: event)
    }
        
    func remove(_ action: Actionable? = nil, for events: UIControl.Event) {
        if let action = action {
            removeTarget(action, action: action.selector, for: events)
            release(action)
        } else {
            for (_, value) in actions {
                guard let action = value as? ControlActionable, (action.controlEvent.rawValue & events.rawValue != 0) else {
                    continue
                }
                remove(action, for: events)
            }
        }
    }

}

public class UIControlTarget: NSObject {
    
    fileprivate weak var control: UIControl?
    
    init(control: UIControl) {
        self.control = control
    }

    public func add(event: UIControl.Event, action: Actionable) {
        retain(action)
        control?.addTarget(action, action: action.selector, for: event)
    }
        
    public func remove(_ action: Actionable? = nil, for events: UIControl.Event) {
        if let action = action {
            control?.removeTarget(action, action: action.selector, for: events)
            release(action)
            if actions.count == 0 {
                control?.targets.removeAll { $0 == self }
            }
        } else {
            for (_, value) in actions {
                guard let action = value as? ControlActionable, (action.controlEvent.rawValue & events.rawValue != 0) else {
                    continue
                }
                remove(action, for: events)
            }
        }
    }
    
    public func remove(for events: UIControl.Event? = nil) {
        if let control = control {
            for target in control.targets {
                /// 遍历所有 targets
                if target == self {
                    /// 找到当前target
                    
                    /// 如果有 event 限制
                    if let events = events {
                        
                        
                        for (_, value) in actions {
                            /// 遍历所有 events
                            guard let action = value as? ControlActionable, (action.controlEvent.rawValue & events.rawValue != 0) else {
                                continue
                            }
                            
                            /// events 一致
                            remove(action, for: events)
                        }
                    } else {
                        for (_, value) in actions {
                            /// events 一致
                            guard let action = value as? ControlActionable else { continue }
                            release(action)
                        }
                        if actions.count == 0 {
                            control.targets.removeAll { $0 == self }
                        }
                    }
                }
            }
        }
    }
}

public extension UIControlTarget {
    @discardableResult
    func touchDown<T: UIControl>(action: @escaping (T, UIControl.Event) -> ()) -> UIControlTarget {
        let actionObj = ControlEventActionable(controlEvent: .touchDown, action: action)
        add(event: .touchDown, action: actionObj)
        return self
    }
    
    @discardableResult
    func touchDown(action: @escaping () -> ()) -> UIControlTarget {
        let actionObj = ControlVoidActionable(event: .touchDown, action: action)
        add(event: .touchDown, action: actionObj)
        return self
    }
    
    @discardableResult
    func touchDownRepeat<T: UIControl>(action: @escaping (T, UIControl.Event) -> ()) -> UIControlTarget {
        let actionObj = ControlEventActionable(controlEvent: .touchDownRepeat, action: action)
        add(event: .touchDownRepeat, action: actionObj)
        return self
    }
    
    @discardableResult
    func touchDownRepeat(action: @escaping () -> ()) -> UIControlTarget {
        let actionObj = ControlVoidActionable(event: .touchDownRepeat, action: action)
        add(event: .touchDownRepeat, action: actionObj)
        return self
    }
    
    @discardableResult
    func touchDragInside<T: UIControl>(action: @escaping (T, UIControl.Event) -> ()) -> UIControlTarget {
        let actionObj = ControlEventActionable(controlEvent: .touchDragInside, action: action)
        add(event: .touchDragInside, action: actionObj)
        return self
    }
    
    @discardableResult
    func touchDragInside(action: @escaping () -> ()) -> UIControlTarget {
        let actionObj = ControlVoidActionable(event: .touchDragInside, action: action)
        add(event: .touchDragInside, action: actionObj)
        return self
    }
    
    @discardableResult
    func touchDragOutside<T: UIControl>(action: @escaping (T, UIControl.Event) -> ()) -> UIControlTarget {
        let actionObj = ControlEventActionable(controlEvent: .touchDragOutside, action: action)
        add(event: .touchDragOutside, action: actionObj)
        return self
    }
    
    @discardableResult
    func touchDragOutside(action: @escaping () -> ()) -> UIControlTarget {
        let actionObj = ControlVoidActionable(event: .touchDragOutside, action: action)
        add(event: .touchDragOutside, action: actionObj)
        return self
    }
    
    @discardableResult
    func touchDragEnter<T: UIControl>(action: @escaping (T, UIControl.Event) -> ()) -> UIControlTarget {
        let actionObj = ControlEventActionable(controlEvent: .touchDragEnter, action: action)
        add(event: .touchDragEnter, action: actionObj)
        return self
    }
    
    @discardableResult
    func touchDragEnter(action: @escaping () -> ()) -> UIControlTarget {
        let actionObj = ControlVoidActionable(event: .touchDragEnter, action: action)
        add(event: .touchDragEnter, action: actionObj)
        return self
    }
    
    @discardableResult
    func touchDragExit<T: UIControl>(action: @escaping (T, UIControl.Event) -> ()) -> UIControlTarget {
        let actionObj = ControlEventActionable(controlEvent: .touchDragExit, action: action)
        add(event: .touchDragExit, action: actionObj)
        return self
    }
    
    @discardableResult
    func touchDragExit(action: @escaping () -> ()) -> UIControlTarget {
        let actionObj = ControlVoidActionable(event: .touchDragExit, action: action)
        add(event: .touchDragExit, action: actionObj)
        return self
    }
    
    @discardableResult
    func touchUpInside<T: UIControl>(action: @escaping (T, UIControl.Event) -> ()) -> UIControlTarget {
        let actionObj = ControlEventActionable(controlEvent: .touchUpInside, action: action)
        add(event: .touchUpInside, action: actionObj)
        return self
    }
    
    @discardableResult
    func touchUpInside(action: @escaping () -> ()) -> UIControlTarget {
        let actionObj = ControlVoidActionable(event: .touchUpInside, action: action)
        add(event: .touchUpInside, action: actionObj)
        return self
    }
    
    @discardableResult
    func touchUpOutside<T: UIControl>(action: @escaping (T, UIControl.Event) -> ()) -> UIControlTarget {
        let actionObj = ControlEventActionable(controlEvent: .touchUpOutside, action: action)
        add(event: .touchUpOutside, action: actionObj)
        return self
    }
    
    @discardableResult
    func touchUpOutside(action: @escaping () -> ()) -> UIControlTarget {
        let actionObj = ControlVoidActionable(event: .touchUpOutside, action: action)
        add(event: .touchUpOutside, action: actionObj)
        return self
    }
    
    @discardableResult
    func touchCancel<T: UIControl>(action: @escaping (T, UIControl.Event) -> ()) -> UIControlTarget {
        let actionObj = ControlEventActionable(controlEvent: .touchCancel, action: action)
        add(event: .touchCancel, action: actionObj)
        return self
    }
    
    @discardableResult
    func touchCancel(action: @escaping () -> ()) -> UIControlTarget {
        let actionObj = ControlVoidActionable(event: .touchCancel, action: action)
        add(event: .touchCancel, action: actionObj)
        return self
    }
    
    @discardableResult
    func valueChanged<T: UIControl>(action: @escaping (T, UIControl.Event) -> ()) -> UIControlTarget {
        let actionObj = ControlEventActionable(controlEvent: .valueChanged, action: action)
        add(event: .valueChanged, action: actionObj)
        return self
    }
    
    @discardableResult
    func valueChanged(action: @escaping () -> ()) -> UIControlTarget {
        let actionObj = ControlVoidActionable(event: .valueChanged, action: action)
        add(event: .valueChanged, action: actionObj)
        return self
    }
    
    @available(iOS 9.0, *)
    @discardableResult
    func primaryActionTriggered<T: UIControl>(action: @escaping (T, UIControl.Event) -> ()) -> UIControlTarget {
        let actionObj = ControlEventActionable(controlEvent: .primaryActionTriggered, action: action)
        add(event: .primaryActionTriggered, action: actionObj)
        return self
    }
    
    @available(iOS 9.0, *)
    @discardableResult
    func primaryActionTriggered(action: @escaping () -> ()) -> UIControlTarget {
        let actionObj = ControlVoidActionable(event: .primaryActionTriggered, action: action)
        add(event: .primaryActionTriggered, action: actionObj)
        return self
    }
    
    @available(iOS 14.0, *)
    @discardableResult
    func menuActionTriggered<T: UIControl>(action: @escaping (T, UIControl.Event) -> ()) -> UIControlTarget {
        let actionObj = ControlEventActionable(controlEvent: .menuActionTriggered, action: action)
        add(event: .menuActionTriggered, action: actionObj)
        return self
    }
    
    @available(iOS 14.0, *)
    @discardableResult
    func menuActionTriggered(action: @escaping () -> ()) -> UIControlTarget {
        let actionObj = ControlVoidActionable(event: .menuActionTriggered, action: action)
        add(event: .menuActionTriggered, action: actionObj)
        return self
    }
    
    @discardableResult
    func editingDidBegin<T: UIControl>(action: @escaping (T, UIControl.Event) -> ()) -> UIControlTarget {
        let actionObj = ControlEventActionable(controlEvent: .editingDidBegin, action: action)
        add(event: .editingDidBegin, action: actionObj)
        return self
    }
    
    @discardableResult
    func editingDidBegin(action: @escaping () -> ()) -> UIControlTarget {
        let actionObj = ControlVoidActionable(event: .editingDidBegin, action: action)
        add(event: .editingDidBegin, action: actionObj)
        return self
    }
    
    @discardableResult
    func editingChanged<T: UIControl>(action: @escaping (T, UIControl.Event) -> ()) -> UIControlTarget {
        let actionObj = ControlEventActionable(controlEvent: .editingChanged, action: action)
        add(event: .editingChanged, action: actionObj)
        return self
    }
    
    @discardableResult
    func editingChanged(action: @escaping () -> ()) -> UIControlTarget {
        let actionObj = ControlVoidActionable(event: .editingChanged, action: action)
        add(event: .editingChanged, action: actionObj)
        return self
    }
    
    @discardableResult
    func editingDidEnd<T: UIControl>(action: @escaping (T, UIControl.Event) -> ()) -> UIControlTarget {
        let actionObj = ControlEventActionable(controlEvent: .editingDidEnd, action: action)
        add(event: .editingDidEnd, action: actionObj)
        return self
    }
    
    @discardableResult
    func editingDidEnd(action: @escaping () -> ()) -> UIControlTarget {
        let actionObj = ControlVoidActionable(event: .editingDidEnd, action: action)
        add(event: .editingDidEnd, action: actionObj)
        return self
    }
    
    @discardableResult
    func editingDidEndOnExit<T: UIControl>(action: @escaping (T, UIControl.Event) -> ()) -> UIControlTarget {
        let actionObj = ControlEventActionable(controlEvent: .editingDidEndOnExit, action: action)
        add(event: .editingDidEndOnExit, action: actionObj)
        return self
    }

    @discardableResult
    func editingDidEndOnExit(action: @escaping () -> ()) -> UIControlTarget {
        let actionObj = ControlVoidActionable(event: .editingDidEndOnExit, action: action)
        add(event: .editingDidEndOnExit, action: actionObj)
        return self
    }
    
    @discardableResult
    func allTouchEvents<T: UIControl>(action: @escaping (T, UIControl.Event) -> ()) -> UIControlTarget {
        let actionObj = ControlEventActionable(controlEvent: .allTouchEvents, action: action)
        add(event: .allTouchEvents, action: actionObj)
        return self
    }
    
    @discardableResult
    func allTouchEvents(action: @escaping () -> ()) -> UIControlTarget {
        let actionObj = ControlVoidActionable(event: .allTouchEvents, action: action)
        add(event: .allTouchEvents, action: actionObj)
        return self
    }
    
    @discardableResult
    func allEditingEvents<T: UIControl>(action: @escaping (T, UIControl.Event) -> ()) -> UIControlTarget {
        let actionObj = ControlEventActionable(controlEvent: .allEditingEvents, action: action)
        add(event: .allEditingEvents, action: actionObj)
        return self
    }
    
    @discardableResult
    func allEditingEvents(action: @escaping () -> ()) -> UIControlTarget {
        let actionObj = ControlVoidActionable(event: .allEditingEvents, action: action)
        add(event: .allEditingEvents, action: actionObj)
        return self
    }
    
    @discardableResult
    func applicationReserved<T: UIControl>(action: @escaping (T, UIControl.Event) -> ()) -> UIControlTarget {
        let actionObj = ControlEventActionable(controlEvent: .applicationReserved, action: action)
        add(event: .applicationReserved, action: actionObj)
        return self
    }
    
    @discardableResult
    func applicationReserved(action: @escaping () -> ()) -> UIControlTarget {
        let actionObj = ControlVoidActionable(event: .applicationReserved, action: action)
        add(event: .applicationReserved, action: actionObj)
        return self
    }
    
    @discardableResult
    func systemReserved<T: UIControl>(action: @escaping (T, UIControl.Event) -> ()) -> UIControlTarget {
        let actionObj = ControlEventActionable(controlEvent: .systemReserved, action: action)
        add(event: .systemReserved, action: actionObj)
        return self
    }

    @discardableResult
    func systemReserved(action: @escaping () -> ()) -> UIControlTarget {
        let actionObj = ControlVoidActionable(event: .systemReserved, action: action)
        add(event: .systemReserved, action: actionObj)
        return self
    }

    @discardableResult
    func allEvents<T: UIControl>(action: @escaping (T, UIControl.Event) -> ()) -> UIControlTarget {
        let actionObj = ControlEventActionable(controlEvent: .allEvents, action: action)
        add(event: .allEvents, action: actionObj)
        return self
    }
    
    @discardableResult
    func allEvents(action: @escaping () -> ()) -> UIControlTarget {
        let actionObj = ControlVoidActionable(event: .allEvents, action: action)
        add(event: .allEvents, action: actionObj)
        return self
    }
}

private var actionsKey: UInt8 = 0
public extension UIControl {
    fileprivate var targets: [UIControlTarget]! {
        get {
            var targets = objc_getAssociatedObject(self, &actionsKey) as? [UIControlTarget]
            if targets == nil {
                targets = [UIControlTarget]()
                self.targets = targets
            }
            return targets
        }
        set {
            objc_setAssociatedObject(self, &actionsKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    @discardableResult
    func touchDown<T: UIControl>(action: @escaping (T, UIControl.Event) -> ()) -> UIControlTarget {
        let target = UIControlTarget(control: self)
        let actionObj = ControlEventActionable(controlEvent: .touchDown, action: action)
        target.add(event: .touchDown, action: actionObj)
        targets.append(target)
        return target
    }
    
    @discardableResult
    func touchDown(action: @escaping () -> ()) -> UIControlTarget {
        let target = UIControlTarget(control: self)
        let actionObj = ControlVoidActionable(event: .touchDown, action: action)
        target.add(event: .touchDown, action: actionObj)
        targets.append(target)
        return target
    }
    
    @discardableResult
    func touchDownRepeat<T: UIControl>(action: @escaping (T, UIControl.Event) -> ()) -> UIControlTarget {
        let target = UIControlTarget(control: self)
        let actionObj = ControlEventActionable(controlEvent: .touchDownRepeat, action: action)
        target.add(event: .touchDownRepeat, action: actionObj)
        targets.append(target)
        return target
    }
    
    @discardableResult
    func touchDownRepeat(action: @escaping () -> ()) -> UIControlTarget {
        let target = UIControlTarget(control: self)
        let actionObj = ControlVoidActionable(event: .touchDownRepeat, action: action)
        target.add(event: .touchDownRepeat, action: actionObj)
        targets.append(target)
        return target
    }
    
    @discardableResult
    func touchDragInside<T: UIControl>(action: @escaping (T, UIControl.Event) -> ()) -> UIControlTarget {
        let target = UIControlTarget(control: self)
        let actionObj = ControlEventActionable(controlEvent: .touchDragInside, action: action)
        target.add(event: .touchDragInside, action: actionObj)
        targets.append(target)
        return target
    }
    
    @discardableResult
    func touchDragInside(action: @escaping () -> ()) -> UIControlTarget {
        let actionObj = ControlVoidActionable(event: .touchDragInside, action: action)
        let target = UIControlTarget(control: self)
        target.add(event: .touchDragInside, action: actionObj)
        targets.append(target)
        return target
    }
    
    @discardableResult
    func touchDragOutside<T: UIControl>(action: @escaping (T, UIControl.Event) -> ()) -> UIControlTarget {
        let actionObj = ControlEventActionable(controlEvent: .touchDragOutside, action: action)
        let target = UIControlTarget(control: self)
        target.add(event: .touchDragOutside, action: actionObj)
        targets.append(target)
        return target
    }
    
    @discardableResult
    func touchDragOutside(action: @escaping () -> ()) -> UIControlTarget {
        let actionObj = ControlVoidActionable(event: .touchDragOutside, action: action)
        let target = UIControlTarget(control: self)
        target.add(event: .touchDragOutside, action: actionObj)
        targets.append(target)
        return target
    }
    
    @discardableResult
    func touchDragEnter<T: UIControl>(action: @escaping (T, UIControl.Event) -> ()) -> UIControlTarget {
        let actionObj = ControlEventActionable(controlEvent: .touchDragEnter, action: action)
        let target = UIControlTarget(control: self)
        target.add(event: .touchDragEnter, action: actionObj)
        targets.append(target)
        return target
    }
    
    @discardableResult
    func touchDragEnter(action: @escaping () -> ()) -> UIControlTarget {
        let actionObj = ControlVoidActionable(event: .touchDragEnter, action: action)
        let target = UIControlTarget(control: self)
        target.add(event: .touchDragEnter, action: actionObj)
        targets.append(target)
        return target
    }
    
    @discardableResult
    func touchDragExit<T: UIControl>(action: @escaping (T, UIControl.Event) -> ()) -> UIControlTarget {
        let actionObj = ControlEventActionable(controlEvent: .touchDragExit, action: action)
        let target = UIControlTarget(control: self)
        target.add(event: .touchDragExit, action: actionObj)
        targets.append(target)
        return target
    }
    
    @discardableResult
    func touchDragExit(action: @escaping () -> ()) -> UIControlTarget {
        let actionObj = ControlVoidActionable(event: .touchDragExit, action: action)
        let target = UIControlTarget(control: self)
        target.add(event: .touchDragExit, action: actionObj)
        targets.append(target)
        return target
    }
    
    @discardableResult
    func touchUpInside<T: UIControl>(action: @escaping (T, UIControl.Event) -> ()) -> UIControlTarget {
        let actionObj = ControlEventActionable(controlEvent: .touchUpInside, action: action)
        let target = UIControlTarget(control: self)
        target.add(event: .touchUpInside, action: actionObj)
        targets.append(target)
        return target
    }
    
    @discardableResult
    func touchUpInside(action: @escaping () -> ()) -> UIControlTarget {
        let actionObj = ControlVoidActionable(event: .touchUpInside, action: action)
        let target = UIControlTarget(control: self)
        target.add(event: .touchUpInside, action: actionObj)
        targets.append(target)
        return target
    }
    
    @discardableResult
    func touchUpOutside<T: UIControl>(action: @escaping (T, UIControl.Event) -> ()) -> UIControlTarget {
        let actionObj = ControlEventActionable(controlEvent: .touchUpOutside, action: action)
        let target = UIControlTarget(control: self)
        target.add(event: .touchUpOutside, action: actionObj)
        targets.append(target)
        return target
    }
    
    @discardableResult
    func touchUpOutside(action: @escaping () -> ()) -> UIControlTarget {
        let actionObj = ControlVoidActionable(event: .touchUpOutside, action: action)
        let target = UIControlTarget(control: self)
        target.add(event: .touchUpOutside, action: actionObj)
        targets.append(target)
        return target
    }
    
    @discardableResult
    func touchCancel<T: UIControl>(action: @escaping (T, UIControl.Event) -> ()) -> UIControlTarget {
        let actionObj = ControlEventActionable(controlEvent: .touchCancel, action: action)
        let target = UIControlTarget(control: self)
        target.add(event: .touchCancel, action: actionObj)
        targets.append(target)
        return target
    }
    
    @discardableResult
    func touchCancel(action: @escaping () -> ()) -> UIControlTarget {
        let actionObj = ControlVoidActionable(event: .touchCancel, action: action)
        let target = UIControlTarget(control: self)
        target.add(event: .touchCancel, action: actionObj)
        targets.append(target)
        return target
    }
    
    @discardableResult
    func valueChanged<T: UIControl>(action: @escaping (T, UIControl.Event) -> ()) -> UIControlTarget {
        let actionObj = ControlEventActionable(controlEvent: .valueChanged, action: action)
        let target = UIControlTarget(control: self)
        target.add(event: .valueChanged, action: actionObj)
        targets.append(target)
        return target
    }
    
    @discardableResult
    func valueChanged(action: @escaping () -> ()) -> UIControlTarget {
        let actionObj = ControlVoidActionable(event: .valueChanged, action: action)
        let target = UIControlTarget(control: self)
        target.add(event: .valueChanged, action: actionObj)
        targets.append(target)
        return target
    }
    
    @available(iOS 9.0, *)
    @discardableResult
    func primaryActionTriggered<T: UIControl>(action: @escaping (T, UIControl.Event) -> ()) -> UIControlTarget {
        let actionObj = ControlEventActionable(controlEvent: .primaryActionTriggered, action: action)
        let target = UIControlTarget(control: self)
        target.add(event: .primaryActionTriggered, action: actionObj)
        targets.append(target)
        return target
    }
    
    @available(iOS 9.0, *)
    @discardableResult
    func primaryActionTriggered(action: @escaping () -> ()) -> UIControlTarget {
        let actionObj = ControlVoidActionable(event: .primaryActionTriggered, action: action)
        let target = UIControlTarget(control: self)
        target.add(event: .primaryActionTriggered, action: actionObj)
        targets.append(target)
        return target
    }
    
    @available(iOS 14.0, *)
    @discardableResult
    func menuActionTriggered<T: UIControl>(action: @escaping (T, UIControl.Event) -> ()) -> UIControlTarget {
        let actionObj = ControlEventActionable(controlEvent: .menuActionTriggered, action: action)
        let target = UIControlTarget(control: self)
        target.add(event: .menuActionTriggered, action: actionObj)
        targets.append(target)
        return target
    }
    
    @available(iOS 14.0, *)
    @discardableResult
    func menuActionTriggered(action: @escaping () -> ()) -> UIControlTarget {
        let actionObj = ControlVoidActionable(event: .menuActionTriggered, action: action)
        let target = UIControlTarget(control: self)
        target.add(event: .menuActionTriggered, action: actionObj)
        targets.append(target)
        return target
    }
    
    @discardableResult
    func editingDidBegin<T: UIControl>(action: @escaping (T, UIControl.Event) -> ()) -> UIControlTarget {
        let actionObj = ControlEventActionable(controlEvent: .editingDidBegin, action: action)
        let target = UIControlTarget(control: self)
        target.add(event: .editingDidBegin, action: actionObj)
        targets.append(target)
        return target
    }
    
    @discardableResult
    func editingDidBegin(action: @escaping () -> ()) -> UIControlTarget {
        let actionObj = ControlVoidActionable(event: .editingDidBegin, action: action)
        let target = UIControlTarget(control: self)
        target.add(event: .editingDidBegin, action: actionObj)
        targets.append(target)
        return target
    }
    
    @discardableResult
    func editingChanged<T: UIControl>(action: @escaping (T, UIControl.Event) -> ()) -> UIControlTarget {
        let actionObj = ControlEventActionable(controlEvent: .editingChanged, action: action)
        let target = UIControlTarget(control: self)
        target.add(event: .editingChanged, action: actionObj)
        targets.append(target)
        return target
    }
    
    @discardableResult
    func editingChanged(action: @escaping () -> ()) -> UIControlTarget {
        let actionObj = ControlVoidActionable(event: .editingChanged, action: action)
        let target = UIControlTarget(control: self)
        target.add(event: .editingChanged, action: actionObj)
        targets.append(target)
        return target
    }
    
    @discardableResult
    func editingDidEnd<T: UIControl>(action: @escaping (T, UIControl.Event) -> ()) -> UIControlTarget {
        let actionObj = ControlEventActionable(controlEvent: .editingDidEnd, action: action)
        let target = UIControlTarget(control: self)
        target.add(event: .editingDidEnd, action: actionObj)
        targets.append(target)
        return target
    }
    
    @discardableResult
    func editingDidEnd(action: @escaping () -> ()) -> UIControlTarget {
        let actionObj = ControlVoidActionable(event: .editingDidEnd, action: action)
        let target = UIControlTarget(control: self)
        target.add(event: .editingDidEnd, action: actionObj)
        targets.append(target)
        return target
    }
    
    @discardableResult
    func editingDidEndOnExit<T: UIControl>(action: @escaping (T, UIControl.Event) -> ()) -> UIControlTarget {
        let actionObj = ControlEventActionable(controlEvent: .editingDidEndOnExit, action: action)
        let target = UIControlTarget(control: self)
        target.add(event: .editingDidEndOnExit, action: actionObj)
        targets.append(target)
        return target
    }

    @discardableResult
    func editingDidEndOnExit(action: @escaping () -> ()) -> UIControlTarget {
        let actionObj = ControlVoidActionable(event: .editingDidEndOnExit, action: action)
        let target = UIControlTarget(control: self)
        target.add(event: .editingDidEndOnExit, action: actionObj)
        targets.append(target)
        return target
    }
    
    @discardableResult
    func allTouchEvents<T: UIControl>(action: @escaping (T, UIControl.Event) -> ()) -> UIControlTarget {
        let actionObj = ControlEventActionable(controlEvent: .allTouchEvents, action: action)
        let target = UIControlTarget(control: self)
        target.add(event: .allTouchEvents, action: actionObj)
        targets.append(target)
        return target
    }
    
    @discardableResult
    func allTouchEvents(action: @escaping () -> ()) -> UIControlTarget {
        let actionObj = ControlVoidActionable(event: .allTouchEvents, action: action)
        let target = UIControlTarget(control: self)
        target.add(event: .allTouchEvents, action: actionObj)
        targets.append(target)
        return target
    }
    
    @discardableResult
    func allEditingEvents<T: UIControl>(action: @escaping (T, UIControl.Event) -> ()) -> UIControlTarget {
        let actionObj = ControlEventActionable(controlEvent: .allEditingEvents, action: action)
        let target = UIControlTarget(control: self)
        target.add(event: .allEditingEvents, action: actionObj)
        targets.append(target)
        return target
    }
    
    @discardableResult
    func allEditingEvents(action: @escaping () -> ()) -> UIControlTarget {
        let actionObj = ControlVoidActionable(event: .allEditingEvents, action: action)
        let target = UIControlTarget(control: self)
        target.add(event: .allEditingEvents, action: actionObj)
        targets.append(target)
        return target
    }
    
    @discardableResult
    func applicationReserved<T: UIControl>(action: @escaping (T, UIControl.Event) -> ()) -> UIControlTarget {
        let actionObj = ControlEventActionable(controlEvent: .applicationReserved, action: action)
        let target = UIControlTarget(control: self)
        target.add(event: .applicationReserved, action: actionObj)
        targets.append(target)
        return target
    }
    
    @discardableResult
    func applicationReserved(action: @escaping () -> ()) -> UIControlTarget {
        let actionObj = ControlVoidActionable(event: .applicationReserved, action: action)
        let target = UIControlTarget(control: self)
        target.add(event: .applicationReserved, action: actionObj)
        targets.append(target)
        return target
    }
    
    @discardableResult
    func systemReserved<T: UIControl>(action: @escaping (T, UIControl.Event) -> ()) -> UIControlTarget {
        let actionObj = ControlEventActionable(controlEvent: .systemReserved, action: action)
        let target = UIControlTarget(control: self)
        target.add(event: .systemReserved, action: actionObj)
        targets.append(target)
        return target
    }

    @discardableResult
    func systemReserved(action: @escaping () -> ()) -> UIControlTarget {
        let actionObj = ControlVoidActionable(event: .systemReserved, action: action)
        let target = UIControlTarget(control: self)
        target.add(event: .systemReserved, action: actionObj)
        targets.append(target)
        return target
    }

    @discardableResult
    func allEvents<T: UIControl>(action: @escaping (T, UIControl.Event) -> ()) -> UIControlTarget {
        let actionObj = ControlEventActionable(controlEvent: .allEvents, action: action)
        let target = UIControlTarget(control: self)
        target.add(event: .allEvents, action: actionObj)
        targets.append(target)
        return target
    }
    
    @discardableResult
    func allEvents(action: @escaping () -> ()) -> UIControlTarget {
        let actionObj = ControlVoidActionable(event: .allEvents, action: action)
        let target = UIControlTarget(control: self)
        target.add(event: .allEvents, action: actionObj)
        targets.append(target)
        return target
    }
}


// MARK: Private

fileprivate protocol ControlActionable: Actionable {
    var controlEvent: UIControl.Event { get }
}

fileprivate class ControlVoidActionable: VoidAction, ControlActionable {
    public var controlEvent: UIControl.Event
    init(event: UIControl.Event, action:@escaping () -> ()) {
        self.controlEvent = event
        super.init(action)
    }
}

fileprivate class ControlParametizedAction<T: UIControl>: ParametizedAction<T>, ControlActionable {
    public var controlEvent: UIControl.Event
    init(event: UIControl.Event, action: @escaping (T) -> ()) {
        controlEvent = event
        super.init(action)
    }
}

fileprivate class EventAction<T: UIControl>: ControlActionable {
    public var controlEvent: UIControl.Event
    
    public var key: String = ProcessInfo.processInfo.globallyUniqueString
    
    public var selector: Selector = #selector(perform)
    
    var action: (T, UIEvent?) -> Void

    @objc func perform(parameters: Any, event: UIEvent?) {
        action(parameters as! T, event)
    }
    
    init(event: UIControl.Event, action: @escaping (T, UIEvent?) -> ()) {
        self.action = action
        self.controlEvent = event
    }
}

fileprivate class ControlEventActionable<T: UIControl>: ControlActionable {
    public var controlEvent: UIControl.Event
    public var key: String = ProcessInfo.processInfo.globallyUniqueString
    public var selector: Selector = #selector(perform)
    var action: (T, UIControl.Event) -> Void

    init(controlEvent: UIControl.Event, action:@escaping (T, UIControl.Event) -> ()) {
        self.controlEvent = controlEvent
        self.action = action
    }
    
    @objc func perform(parameters: Any, controlEvent: UIControl.Event) {
        action(parameters as! T, controlEvent)
    }
}
