//
//  Swicon.swift
//  Swicon
//
//  Created by Zhibo Wei on 7/5/15.
//  Copyright (c) 2015 Zhibo Wei. All rights reserved.
//

import Foundation
import UIKit
import CoreText
import Dispatch

open class Swicon {
    
    open static let instance = Swicon()
    
    fileprivate let load_queue = DispatchQueue(label: "com.swicon.font.load.queue", attributes: [])
    
    fileprivate var fontsMap :[String: IconFont] = [
        "fa": FontAwesomeIconFont(),
        "gm": GoogleMaterialIconFont()
    ]
    
    fileprivate init() {
    }
    
    open func addCustomFont(_ prefix: String, fontFileName: String, fontName: String, fontIconMap: [String: String]) {
        fontsMap[prefix] = CustomIconFont(fontFileName: fontFileName, fontName: fontName, fontMap: fontIconMap)
    }
    
    open func loadAllAsync() {
        self.load_queue.async(execute: {
            self.loadAllSync([String](self.fontsMap.keys))
        })
    }
    
    open func loadAllAsync(_ fontNames:[String]) {
        self.load_queue.async(execute: {
            self.loadAllSync(fontNames)
        })
    }
    
    open func loadAllSync() {
        self.loadAllSync([String](fontsMap.keys))
        //NSLog("debug : font names : \(UIFont.familyNames())")
    }
    
    open func loadAllSync(_ fontNames:[String]) {
        for fontName in fontNames {
            if let font = fontsMap[fontName] {
                font.loadFontIfNecessary()
            }
        }
    }
    
    open func getNSMutableAttributedString(_ iconName: String, fontSize: CGFloat) -> NSMutableAttributedString? {
        for fontPrefix in fontsMap.keys {
            if iconName.hasPrefix(fontPrefix) {
                let iconFont = fontsMap[fontPrefix]!
                if let iconValue = iconFont.getIconValue(iconName) {
                    let iconUnicodeValue = iconValue.substring(to: iconValue.characters.index(iconValue.startIndex, offsetBy: 1))
                    if let uiFont = iconFont.getUIFont(fontSize) {
                        let attrs = [NSFontAttributeName : uiFont]
                        return NSMutableAttributedString(string:iconUnicodeValue, attributes:attrs)
                    }
                }
            }
        }
        return nil
    }
    
    open func getUIImage(_ iconName: String, iconSize: CGFloat, iconColour: UIColor = UIColor.black, imageSize: CGSize) -> UIImage {
        let style = NSMutableParagraphStyle()
        style.alignment = NSTextAlignment.left
        style.baseWritingDirection = NSWritingDirection.leftToRight
        
        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0.0);
        let attString = getNSMutableAttributedString(iconName, fontSize: iconSize)
        if attString != nil {
            attString?.addAttributes([NSForegroundColorAttributeName: iconColour, NSParagraphStyleAttributeName: style], range: NSMakeRange(0, attString!.length))
            // get the target bounding rect in order to center the icon within the UIImage:
            let ctx = NSStringDrawingContext()
            let boundingRect = attString!.boundingRect(with: CGSize(width: iconSize, height: iconSize), options: NSStringDrawingOptions.usesDeviceMetrics, context: ctx)
            
            attString!.draw(in: CGRect(x: (imageSize.width/2.0) - boundingRect.size.width/2.0, y: (imageSize.height/2.0) - boundingRect.size.height/2.0, width: imageSize.width, height: imageSize.height))
            
            var iconImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            if(iconImage?.responds(to: #selector(UIImage.withRenderingMode(_:))))!{
                iconImage = iconImage?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
            }
            
            return iconImage!
        } else {
            return UIImage()
        }
    }
    
}

private class FontAwesomeIconFont: IconFont {
    
    fileprivate let fontMap = FONT_AWESOME_ICON_MAPS
    fileprivate let fontFileName = "fontawesome"
    fileprivate let fontName = "FontAwesome"
    fileprivate var fontLoadedAttempted = false
    fileprivate var fontLoadedSucceed = false
    
    func loadFontIfNecessary() {
        if (!self.fontLoadedAttempted) {
            self.fontLoadedAttempted = true
            self.fontLoadedSucceed = loadFontFromFile(fontFileName, forClass: Swicon.self, isCustom: false)
        }
    }
    
    func getUIFont(_ fontSize: CGFloat) -> UIFont? {
        self.loadFontIfNecessary()
        if (self.fontLoadedSucceed) {
            return UIFont(name: self.fontName, size: fontSize)
        } else {
            return nil
        }
    }
    
    func getIconValue(_ iconName: String) -> String? {
        return self.fontMap[iconName]
    }
    
}

private class GoogleMaterialIconFont: IconFont {
    
    fileprivate let fontMap = GOOGLE_MARTERIAL_ICON_MAPS
    fileprivate let fontFileName = "gmdicons"
    fileprivate let fontName = "Material Icons"
    fileprivate var fontLoadedAttempted = false
    fileprivate var fontLoadedSucceed = false
    
    func loadFontIfNecessary() {
        if (!self.fontLoadedAttempted) {
            self.fontLoadedAttempted = true
            self.fontLoadedSucceed = loadFontFromFile(fontFileName, forClass: Swicon.self, isCustom: false)
        }
    }
    
    func getUIFont(_ fontSize: CGFloat) -> UIFont? {
        self.loadFontIfNecessary()
        if (self.fontLoadedSucceed) {
            return UIFont(name: self.fontName, size: fontSize)
        } else {
            return nil
        }
    }
    
    func getIconValue(_ iconName: String) -> String? {
        return self.fontMap[iconName]
    }
    
}

private class CustomIconFont: IconFont {
    
    fileprivate let fontFileName: String
    fileprivate let fontName: String
    fileprivate let fontMap: [String: String]
    fileprivate var fontLoadedAttempted = false
    fileprivate var fontLoadedSucceed = false
    
    init(fontFileName: String, fontName: String, fontMap: [String: String]) {
        self.fontFileName = fontFileName
        self.fontName = fontName
        self.fontMap = fontMap
    }
    
    func loadFontIfNecessary() {
        if (!self.fontLoadedAttempted) {
            self.fontLoadedAttempted = true
            self.fontLoadedSucceed = loadFontFromFile(self.fontFileName, forClass: Swicon.self, isCustom: true)
        }
    }
    
    func getUIFont(_ fontSize: CGFloat) -> UIFont? {
        self.loadFontIfNecessary()
        if (self.fontLoadedSucceed) {
            return UIFont(name: self.fontName, size: fontSize)
        } else {
            return nil
        }
    }
    
    func getIconValue(_ iconName: String) -> String? {
        return self.fontMap[iconName]
    }
    
}

private func loadFontFromFile(_ fontFileName: String, forClass: AnyClass, isCustom: Bool) -> Bool{
    let bundle = Bundle(for: forClass)
    var fontURL: URL?
    let identifier = bundle.bundleIdentifier
    
    if isCustom {
        fontURL = Bundle.main.url(forResource: fontFileName, withExtension: "ttf")
    } else if identifier?.hasPrefix("org.cocoapods") == true {
        // If this framework is added using CocoaPods and it's not a custom font, resources is placed under a subdirectory
        fontURL = bundle.url(forResource: fontFileName, withExtension: "ttf", subdirectory: "Swicon.bundle")
    } else {
        fontURL = bundle.url(forResource: fontFileName, withExtension: "ttf")
    }
    
    if fontURL != nil {
        let data = try! Data(contentsOf: fontURL!)
        let provider = CGDataProvider(data: data as CFData)
        let font = CGFont(provider!)
        
        if (!CTFontManagerRegisterGraphicsFont(font, nil)) {
            NSLog("Failed to load font \(fontFileName)");
            return false
        } else {
            return true
        }
    } else {
        NSLog("Failed to load font \(fontFileName) because the file \(fontFileName) is not available");
        return false
    }
}

private protocol IconFont {
    func loadFontIfNecessary()
    func getUIFont(_ fontSize: CGFloat) -> UIFont?
    func getIconValue(_ iconName: String) -> String?
}
