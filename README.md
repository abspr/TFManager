<p float="center">
  <img src="https://github.com/abspr/TFManager/blob/main/ScreenShots/demo.gif" width="300" />
</p>

# TFManager

Let's say you have multiple `UITextField`s to get data from users. You need to handle each field keyboard's return key and add an accessory view to the keyboard for navigating through fields. TFManager will do this for you in just one line of code!
And if you want more you can add validation rules to the text fields and check if they're valid or not.

[![iOS](https://img.shields.io/badge/iOS-11.0-blue.svg)](https://developer.apple.com/iOS)
[![SPM](https://img.shields.io/badge/SPM-compatible-red?style=flat-square)](https://developer.apple.com/documentation/swift_packages/package/)
[![MIT](https://img.shields.io/badge/licenses-MIT-red.svg)](https://opensource.org/licenses/MIT)  

## Navigate

- [Installation](#installation)
    - [Swift Package Manager](#swift-package-manager)
    - [CocoaPods](#cocoapods)
    - [Manually](#manually)
- [Basic Usage](#basic-usage)
- [Validate All Fields](#validate-all-fields)
- [Rules](#rules)
- [Contact](#contact)
- [License](#license)

## Installation

Ready for use on iOS and iPadOS 11+.

### Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the `swift` compiler. It’s integrated with the Swift build system to automate the process of downloading, compiling, and linking dependencies.

Once you have your Swift package set up, adding as a dependency is as easy as adding it to the `dependencies` value of your `Package.swift`.

```swift
dependencies: [
    .package(url: "https://github.com/abspr/TFManager", .upToNextMajor(from: "1.1.0"))
]
```

### CocoaPods:

[CocoaPods](https://cocoapods.org) is a dependency manager. For usage and installation instructions, visit their website. To integrate using CocoaPods, specify it in your `Podfile`:

```ruby
pod 'TFManager'
```

### Manually

If you prefer not to use any of dependency managers, you can integrate manually. Put `Sources/TFManager` folder in your Xcode project. Make sure to enable `Copy items if needed` and `Create groups`.

## Basic Usage

1. Create an instance of TFManager in your `viewController`
```swift
var fieldsManager = TFManager()
```
2. Add your `textFields` to it:
```swift
fieldsManager.add([nameField, mailField, ageField])
```
3. There is no more steps 😯

## Validate All Fields
You can add rules to your `UITextField`s and ask `TFManager` to apply validation to all of child fields:

1. Change your textField class to `ValidatableField`.
<img src="https://github.com/abspr/TFManager/blob/main/ScreenShots/screenShot1.png" />

2. Then you can call `validate()` method on your `TFManager` instance.
```swift
let result = fieldsManager.validate()
result.forEach { (invalidField, validationResult) in
    invalidField.textColor = .systemRed
    print(validationResult.message)
}
```

💡 You can set `TFManager`'s delegate and use its methods to get notified which textField is become active or its text is changing:
```swift
fieldsManager.delegate = self

extension ViewController: TFManagerDelegate {
    func textDidChange(_ textField: UITextField, validationResult: ValidationResult?) {
        guard let validationResult = validationResult else { return }
        textField.textColor = validationResult.isValid ? .label : .systemRed
    }
}
```

💡 You also can subclass `ValidatableField` and customize your textField. 
Override `didFailValidation(_:)` and `didPass()` methods to handle valid/invalid states (eg: show/hide the error label)

## Rules
`TFManager` comes with set of rules (`TextRulesSet`) and you can add them to any `ValidatableField`:
```swift
ageField.rulesRepo.add(TextRulesSet.numbersOnly())
ageField.rulesRepo.add(TextRulesSet.minLenght(1))
ageField.rulesRepo.add(TextRulesSet.maxLenght(2))
```

💡 You can have your own rules too. Just create a `struct` and implement `TextRule`:

```swift
struct YourRule: TextRule {
    var message: String

    func validate(_ text: String) -> Bool {
        // code
    }
}
```

## Contact
email : [hosein@me.com](mailto:hosein@me.com)

## License
TFManager is available under the MIT license. See the [LICENSE](LICENSE) file for more info.
