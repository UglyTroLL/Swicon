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

public class Swicon {
    
    public static let instance = Swicon()
    
    private var fontAwesoneLoaded = false, googleMaterialLoaded = false, customFontLoaded = false
    private let load_queue = dispatch_queue_create("com.swicon.font.load.queue", DISPATCH_QUEUE_SERIAL)
    
    private var fontsMap :[String: IconFont] = [
        "fa": FontAwesomeIconFont(),
        "gm": GoogleMaterialIconFont()
    ]
    
    private init() {
        
    }
    
    public func addCustomFont(prefix: String, fontFileName: String, fontName: String, fontIconMap: [String: String]) {
        fontsMap[prefix] = CustomIconFont(fontFileName: fontFileName, fontName: fontName, fontMap: fontIconMap)
    }
    
    public func loadAllAsync() {
        dispatch_async(self.load_queue, {
            self.loadAllSync()
        })
    }
    
    public func loadAllSync() {
        for font in fontsMap.values {
            font.loadFontIfNecessary()
        }
    }
    
    public func getNSMutableAttributedString(iconName: String, fontSize: CGFloat) -> NSMutableAttributedString? {
        for fontPrefix in fontsMap.keys {
            if iconName.hasPrefix(fontPrefix) {
                NSLog("\(iconName) has prefix \(fontPrefix)")
                let iconFont = fontsMap[fontPrefix]!
                if let iconValue = iconFont.getIconValue(iconName) {
                    let iconUnicodeValue = iconValue.substringToIndex(advance(iconValue.startIndex, 1))
                    if let uiFont = iconFont.getUIFont(fontSize) {
                        var attrs = [NSFontAttributeName : uiFont]
                        return NSMutableAttributedString(string:iconUnicodeValue, attributes:attrs)
                    } else {
                        NSLog("font \(fontPrefix) is null")
                    }
                } else {
                    NSLog("But we couldnt find icon values for \(iconName)")
                }
            }
        }
        return nil
    }
    
    public func getUIImage(iconName: String, iconSize: CGFloat, iconColour: UIColor = UIColor.blackColor(), imageSize: CGSize) -> UIImage {
        var style = NSMutableParagraphStyle()
        style.alignment = NSTextAlignment.Left
        style.baseWritingDirection = NSWritingDirection.LeftToRight
        
        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0.0);
        var attString = getNSMutableAttributedString(iconName, fontSize: iconSize)
        if attString != nil {
            attString?.addAttributes([NSForegroundColorAttributeName: iconColour, NSParagraphStyleAttributeName: style], range: NSMakeRange(0, attString!.length))
            // get the target bounding rect in order to center the icon within the UIImage:
            var ctx = NSStringDrawingContext()
            var boundingRect = attString!.boundingRectWithSize(CGSizeMake(iconSize, iconSize), options: NSStringDrawingOptions.UsesDeviceMetrics, context: ctx)
            
            attString!.drawInRect(CGRectMake((imageSize.width/2.0) - boundingRect.size.width/2.0, (imageSize.height/2.0) - boundingRect.size.height/2.0, imageSize.width, imageSize.height))
            
            var iconImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            if(iconImage.respondsToSelector(Selector("imageWithRenderingMode:"))){
                iconImage = iconImage.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
            }
            
            return iconImage
        } else {
            return UIImage()
        }
    }
    
}

private class FontAwesomeIconFont: IconFont {
    
    private let fontMap = FONT_AWESOME_ICON_MAPS
    private let fontFileName = "fontawesome"
    private let fontName = "FontAwesome"
    private var fontLoadedAttempted = false
    private var fontLoadedSucceed = false
    
    func loadFontIfNecessary() {
        if (!self.fontLoadedAttempted) {
            self.fontLoadedAttempted = true
            self.fontLoadedSucceed = loadFontFromFile(fontFileName, Swicon.self, false)
        }
    }
    
    func getUIFont(fontSize: CGFloat) -> UIFont? {
        self.loadFontIfNecessary()
        if (self.fontLoadedSucceed) {
            return UIFont(name: self.fontName, size: fontSize)
        } else {
            return nil
        }
    }
    
    func getIconValue(iconName: String) -> String? {
        return self.fontMap[iconName]
    }
    
}

private class GoogleMaterialIconFont: IconFont {
    
    private let fontMap = GOOGLE_MARTERIAL_ICON_MAPS
    private let fontFileName = "gmdicons"
    private let fontName = "Material Icons"
    private var fontLoadedAttempted = false
    private var fontLoadedSucceed = false
    
    func loadFontIfNecessary() {
        if (!self.fontLoadedAttempted) {
            self.fontLoadedAttempted = true
            self.fontLoadedSucceed = loadFontFromFile(fontFileName, Swicon.self, false)
        }
    }
    
    func getUIFont(fontSize: CGFloat) -> UIFont? {
        self.loadFontIfNecessary()
        if (self.fontLoadedSucceed) {
            return UIFont(name: self.fontName, size: fontSize)
        } else {
            return nil
        }
    }
    
    func getIconValue(iconName: String) -> String? {
        return self.fontMap[iconName]
    }
    
}

private class CustomIconFont: IconFont {
    
    private let fontFileName: String
    private let fontName: String
    private let fontMap: [String: String]
    private var fontLoadedAttempted = false
    private var fontLoadedSucceed = false
    
    init(fontFileName: String, fontName: String, fontMap: [String: String]) {
        self.fontFileName = fontFileName
        self.fontName = fontName
        self.fontMap = fontMap
    }
    
    func loadFontIfNecessary() {
        if (!self.fontLoadedAttempted) {
            self.fontLoadedAttempted = true
            self.fontLoadedSucceed = loadFontFromFile(self.fontFileName, Swicon.self, true)
        }
    }
    
    func getUIFont(fontSize: CGFloat) -> UIFont? {
        self.loadFontIfNecessary()
        if (self.fontLoadedSucceed) {
            return UIFont(name: self.fontName, size: fontSize)
        } else {
            return nil
        }
    }
    
    func getIconValue(iconName: String) -> String? {
        return self.fontMap[iconName]
    }
    
}

private func loadFontFromFile(fontFileName: String, forClass: AnyClass, isCustom: Bool) -> Bool{
    let bundle = NSBundle(forClass: forClass)
    var fontURL = NSURL()
    let identifier = bundle.bundleIdentifier
    
    if identifier?.hasPrefix("org.cocoapods") == true && !isCustom {
        // If this framework is added using CocoaPods and it's not a custom font, resources is placed under a subdirectory
        fontURL = bundle.URLForResource(fontFileName, withExtension: "ttf", subdirectory: "Swicon.bundle")!
    } else {
        fontURL = bundle.URLForResource(fontFileName, withExtension: "ttf")!
    }
    
    let data = NSData(contentsOfURL: fontURL)!
    let provider = CGDataProviderCreateWithCFData(data)
    let font = CGFontCreateWithDataProvider(provider)!
    
    if (!CTFontManagerRegisterGraphicsFont(font, nil)) {
        NSLog("Failed to load font \(fontFileName)");
        return false
    } else {
        NSLog("Registered font \(fontFileName)")
        return true
    }
}

private protocol IconFont {
    func loadFontIfNecessary()
    func getUIFont(fontSize: CGFloat) -> UIFont?
    func getIconValue(iconName: String) -> String?
}
