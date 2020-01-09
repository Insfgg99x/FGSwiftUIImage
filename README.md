# FGSwiftUIImage
-----------------------

## Introducation

FGSwiftUIImage is a SwiftUI web-image

```swift
var body: some View {
    FGSwiftUIImage("http://ww1.sinaimg.cn/large/0065oQSqly1ft3fna1ef9j30s210skgd.jpg")
}
```

placeholdered

```swift
var body: some View {
    FGSwiftUIImage("http://ww1.sinaimg.cn/large/0065oQSqly1ft3fna1ef9j30s210skgd.jpg")
        .placeholder {
        Text("This is a placeholder.")
    }
}
```

## Required

- macOS 10.15 +
- iOS 13.0 +
- tvOS 13.0 +
- watchOS 6.0 +

## Usage

- pod

```
pod repo update
pod 'FGSwiftUIImage'
```

- swift pm

Xcode -> File -> Swift Packages -> Add Package Dependency, and type in:
```
https://github.com/Insfgg99x/FGSwiftUIImage.git
```
