# simple_keyboard_layout_guide

## What is this

This pod provides a `KeyboardLayoutGuide` which behaves like `bottomLayoutGuide`.
When the keyboard is fully invisible, `KeyboardLayoutGuide.topAnchor == bottomLayoutGuide.topAnchor`
Otherwise, `KeyboardLayoutGuide.toAnchor` tracks the top edge of the keyboard.

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation

```ruby
pod 'simple_keyboard_layout_guide', :git => 'https://github.com/louischan-oursky/simple_keyboard_layout_guide.git', :commit => '<commit-hash>'
```

## License

simple_keyboard_layout_guide is available under the MIT license. See the LICENSE file for more info.
