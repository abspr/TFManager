# TFManager

Let's say you have multiple `UITextField`s to get data from users. You need to handle each field keyboard's return key and add an accessory view to the keyboard for navigating through fields. TFManager will do this for you in just one line of code!
And if you want more you can add validation rules to the text fields and check if they're valid or not.

## Navigate

- [Installation](#installation)
    - [Swift Package Manager](#swift-package-manager)
    - [CocoaPods](#cocoapods)
    - [Manually](#manually)
- [Basic Usage](#Basic Usage)

## Installation

Ready for use on iOS and iPadOS 11+.

### Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the `swift` compiler. It’s integrated with the Swift build system to automate the process of downloading, compiling, and linking dependencies.

Once you have your Swift package set up, adding as a dependency is as easy as adding it to the `dependencies` value of your `Package.swift`.

```swift
dependencies: [
    .package(url: "https://github.com/abspr/TFManager", .upToNextMajor(from: "1.0.0"))
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
var form = TFManager()
```
2. Add your `textFields` to it:
```swift
form.add([nameField, mailField, ageField])
```
3. There is no more steps 😯

## Validate From

## Validation Rules
