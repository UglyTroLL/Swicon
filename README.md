# Swicon
Use 1600+ icons from FontAwesome and Google Material Icons in your iOS project in an easy and space-efficient way!

## Installation

### CocoaPods

To integrate FontAwesome into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!

pod 'Swicon', '~> 0.81'
```

Then, run the following command:

```bash
$ pod install
```

### Manually

Copy all Swift files and ttf files into your project

## Usage

+ Initialize Swicon before you use it:

  - (Recommend)In your AppDelegate, add line
  ```swift
  import Swicon
  .............
  Swicon.instance.loadAllAsync()
  ```
  OR
  - Before you use the icon, initialize it in sync way:
  ```swift
  import Swicon
  .............
  Swicon.instance.loadAllSync()
  //Now you can start using it
  Swicon.instance.getUIImage(......)
  ```
  YOU ONLY NEED TO DO THE INITIALIZATION ONCE AFTER YOUR APP STARTS
  
+ Get iconic string or generate an image from the icon:

  ```swift
  //Get NSAttributedString, the "gm-games" is the name of Google Material Design's "games" icon
  let iconicString = Swicon.instance.getNSMutableAttributedString("gm-games", fontSize: 10)
  //Set it to label, to button, or whatever place you like
  label.attributedText = iconicString
  
  //Get UIImage, "fa-heart" is the "Heart" icon from FontAwesome
  let iconicImage = Swicon.instance.getUIImage("fa-heart", iconSize: 100, iconColour: UIColor.blueColor(), imageSize:   CGSizeMake(200, 200))
  //Set it to UIImageView
  imgView.image = iconicImage
  ```

## Icon Name Mapping

The built-in icons are from 
+ [Google Material Design Icons](https://www.google.com/design/icons/)
  - All the Google Material Icons are prefixed with "**gm-**" following with the real icon names from the above link. For example, ["gm-account_balance_wallet"](https://www.google.com/design/icons/#ic_account_balance_wallet) is the name for "account_balance_wallet" icon.
+ [FontAwesome](http://fortawesome.github.io/Font-Awesome/icons/)
  - All the FontAwesome Icons are prefixed with "**fa-**" following with the icon name of FontAwesome. For example, ["fa-dashcube"](http://fortawesome.github.io/Font-Awesome/icon/dashcube/) is the name for "dashcube" icon of FontAwesome.

And just give Swicon the icon name you want to render and Swicon will handle everything else for you.

## Add Your Own Icon Fonts
Let's say you have your own icon font(which can reduce the app size compare to including the resource images for different sizes) you want to be displayed in your iOS project, you only need to:
```swift
//BEFORE you call Swicon init

//The font name prefix you want to use. For example, if you set it to "custom" and Swicon see an icon name start with "custom-", then it will know it's a custom font.
let customFontPrefix = "custom"

//Copy the ttf font file into your project and give Swicon the font file name (WITHOUT the ".ttf" extension)
let fontFileName = "custom_font" //Then Swicon will try to load the font from "custom_font.ttf" file

//The Font File Name, the fontName of your font. (The font name after you install the ttf into your system)
let fontName = "Custom"

//The icon name/value mapping dict ([FONT_NAME: FONT_UNICODE_VALUE])
let iconNameValueMappingDict = ["custom-1":"\u{f000}",...]

//Add custom font to Swicon
Swicon.instance.addCustomFont(prefix: customFontPrefix, fontFileName: fontFileName, fontName: fontName, fontIconMap: iconNameValueMappingDict)

//Then init Swicon
Swicon.instance.loadAllAsync() //Or Sync, depends on your needs
```

##Examples and Screenshots
TBA

## Requirements
iOS 8 or later.

## License
- FontAwesome.ttf file licensed under [SIL OFL 1.1](http://scripts.sil.org/OFL)
- GoogleMaterialDesignIcons font file licensed under [CC-BY](https://creativecommons.org/licenses/by/4.0/)
- Swicon licensed under BSD
