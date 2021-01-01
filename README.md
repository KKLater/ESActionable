# ESActionable

Esactionable provides action encapsulation for `UIControl`, `UITapgestureRecognizer`, `UIBarButtonItem` and `NSNotification`.

## Requirements

* iOS 9.0+
* Swift 5.0+

## Installation

### Swift Package Manager

Swift Package Manager is a tool for managing the distribution of Swift code. It’s integrated with the Swift build system to automate the process of downloading, compiling, and linking dependencies.

> Xcode 11+ is required to build ESActionable using Swift Package Manager.

To integrate ESActionable into your Xcode project using Swift Package Manager, add it to the dependencies value of your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/KKLater/ESActionable.git", .upToNextMajor(from: "0.0.1"))
]
```

## Usage

### About UIControl 

eg. UIButton

```Swift
/// for add target action
let target1 = testButton.touchUpInside {
    print("touchUpInside1")
}

/// for add more target action
let target1 = testButton.touchUpInside {
    print("touchUpInside1")
}.touchDown {
    print("touchDown1")
}

let target12 = testButton.touchUpInside {
    print("touchUpInsid2")
}.touchDown {
    print("touchDown2")
}


/// for remove one target action
target1?.remove(for: .touchUpInside)

/// for remove more target actions
target2?.remove()
```

### About UITapGestureRecognizer

```swift
/// for default
view.tap { (view) in
    print("view tap")
}

/// for more touchs
view.tap(taps: 2) { (view) in
    print("view tap 2")
}
```
More other usages in demo.

### About UIBarButtonItem

```swift
navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit) { (item) in
    print("edit")
}
```

### About Notification

```Swift
/// for add notification observer object
object.observe(.notification1) { [unowned self] (notification) in
    print("name: \(Notification.Name.notification1.rawValue), notification: \(notification)")
}

/// for remove notification observer object
object.unobserve(.notification1)
```

#### Also about KeyboardNotification

```Swift
/// keyboard will show notification
keyboardWillShow { [unowned self] (info) in
    let text = "keyboardWillShow:\n\n    animationCure: \(String(describing: info.animationCure)),\n    animationDuration: \(info.animationDuration),\n    beginFrame: \(String(describing: info.beginFrame)), \n    endFrame: \(String(describing: info.endFrame)), \n    isLocal: \(info.isLocal)"
    print(text)
}

/// keyboard did show notification
keyboardDidShow {[unowned self] (info) in
    let text = "keyboardDidShow:\n\n    animationCure: \(String(describing: info.animationCure)),\n    animationDuration: \(info.animationDuration),\n    beginFrame: \(String(describing: info.beginFrame)), \n    endFrame: \(String(describing: info.endFrame)), \n    isLocal: \(info.isLocal)"
    print(text)
}

/// keyboard will hide notification
keyboardWillHide { [unowned self] (info) in
    let text = "keyboardWillHide:\n\n    animationCure: \(String(describing: info.animationCure)),\n    animationDuration: \(info.animationDuration),\n    beginFrame: \(String(describing: info.beginFrame)), \n    endFrame: \(String(describing: info.endFrame)), \n    isLocal: \(info.isLocal)"
    print(text)
}

/// keyboard did hide notification
keyboardDidHide { [unowned self] (info) in
    let text = "keyboardDidHide:\n\n    animationCure: \(String(describing: info.animationCure)),\n    animationDuration: \(info.animationDuration),\n    beginFrame: \(String(describing: info.beginFrame)), \n    endFrame: \(String(describing: info.endFrame)), \n    isLocal: \(info.isLocal)"
    print(text)
}
```

## License

`ESActionable` is released under the MIT license. See LICENSE for details.

