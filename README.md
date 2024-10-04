# DGExpandableLabel
see more see less style button at the end of Text

## Screens
<div>
<img width="414" alt="스크린샷 2024-10-04 오후 3 17 20" src="https://github.com/user-attachments/assets/90ceb400-7378-43aa-9560-3cac3921b0c5">
<img width="415" alt="스크린샷 2024-10-04 오후 3 17 07" src="https://github.com/user-attachments/assets/6f120b44-7160-4ac7-913e-e9afc5e75f94">
</div>

## Installation

### Swift Package Manager

The [Swift Package Manager](https://www.swift.org/documentation/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the `swift` compiler.

Once you have your Swift package set up, adding `DGExpandableLabel` as a dependency is as easy as adding it to the dependencies value of your Package.swift or the Package list in Xcode.

```
dependencies: [
   .package(url: "https://github.com/donggyushin/DGExpandableLabel.git", .upToNextMajor(from: "1.0.0"))
]
```

Normally you'll want to depend on the DGLineHeight target:

```
.product(name: "DGExpandableLabel", package: "DGExpandableLabel")
```

## Usage
```swift
DGExpandableLabel(
    reply.content,
    lineLimit: 4,
    font: Font.custom(.Regular, size: 14),
    moreText: "더보기",
    lessText: nil        // optional
)
.foregroundStyle(Color(red: 0.78, green: 0.78, blue: 0.78))
.fontWithLineHeight(font: Font.custom(.Regular, size: 14), lineHeight: 20) // https://github.com/donggyushin/DGLineHeight
```