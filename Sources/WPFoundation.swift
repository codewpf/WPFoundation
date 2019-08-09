//
//  WPFoundation.swift
//  Pods
//
//  Created by alex on 2017/7/8.
//
//  old version 0.3.5
//  new version 0.4.0

import Foundation
import UIKit
import CommonCrypto


/// 自定义输出
public func WPFLog<T>(_ message: T, fileName: String = #file, methodName: String =  #function, lineNumber: Int = #line)
{
    #if DEBUG
        let str : String = (fileName as NSString).pathComponents.last!.replacingOccurrences(of: "swift", with: "");
        print("\(Date()) \(str)\(methodName) [\(lineNumber) line] ---------->\n\(message)")
    #endif
}

//MARK: -
public extension NSObject {
    
    class func swapMethod(originSel: Selector, swapSel: Selector) {
        if let originMet: Method = class_getInstanceMethod(self, originSel),
            let swapMet: Method = class_getInstanceMethod(self, swapSel) {
            let added = class_addMethod(self, originSel, method_getImplementation(swapMet), method_getTypeEncoding(swapMet))
            if added == true {
                class_replaceMethod(self, swapSel, method_getImplementation(originMet), method_getTypeEncoding(originMet))
            } else {
                method_exchangeImplementations(originMet, swapMet)
            }
        }
    }
    
    func getMethodList() -> [String] {
        var count: UInt32 = 0
        guard let methodList = class_copyMethodList(type(of: self), &count) else {
            return []
        }
        var mutabList: [String] = []
        for i in 0 ..< count {
            let method = methodList[Int(i)]
            mutabList.append(NSStringFromSelector(method_getName(method)))
            
        }
        return mutabList
    }
    
    func getPropertyList() -> [String] {
        var count: UInt32 = 0
        guard let propertyList = class_copyPropertyList(type(of: self), &count) else {
            return []
        }
        var mutabList: [String] = []
        for i in 0 ..< count {
            if let nstr = NSString.init(utf8String: property_getName(propertyList[Int(i)])) {
                mutabList.append("\(nstr)")
            }
        }
        return mutabList
    }

}

//MARK: - 
public extension Array where Element: Equatable {
    mutating func remove(object: Element) {
        if let index = firstIndex(of: object) {
            remove(at: index)
        }
    }
}

//MARK: -
public extension String {
    
    /// 字符串长度
    var length: Int {
        return self.count
    }
    
    var md5: String {
        guard let data = self.data(using: .utf8) else {
            return self
        }
        var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        #if swift(>=5.0)
        _ = data.withUnsafeBytes { (bytes: UnsafeRawBufferPointer) in
            return CC_MD5(bytes.baseAddress, CC_LONG(data.count), &digest)
        }
        #else
        _ = data.withUnsafeBytes { bytes in
            return CC_MD5(bytes, CC_LONG(data.count), &digest)
        }
        #endif
        
        return digest.reduce(into: "") { $0 += String(format: "%02x", $1) }
    }
    
    /// 截取字符串 from
    /// - Parameter from: 开始位置
    func substring(from: UInt) -> String {
        guard self.length > Int(from) else {
            return ""
        }
        let idxStart = self.index(self.startIndex, offsetBy: Int(from))
        return String(self[idxStart...])
    }
    /// 截取字符串 to
    /// - Parameter to: 结束为止
    func substring(to: UInt) -> String {
        guard self.length >= Int(to) else {
            return self
        }
        let offsetBy: Int = Int(to) - self.length
        let idxEnd = self.index(self.endIndex, offsetBy: offsetBy)
        return String(self[self.startIndex ..< idxEnd ])
    }
    /// 截取字符串 Range
    /// - Parameter range: 截取的区间
    func substring(range: NSRange) -> String {
        
        if let r = Range.init(range) {
            let start = self.index(self.startIndex, offsetBy: r.lowerBound)
            let end = self.index(self.startIndex, offsetBy: r.upperBound)
            return String(self[start..<end])
        }
        return self
    }
    
    /// 替换字符串
    mutating func replace(range: NSRange, place: String = "****") {
        
        if let r = Range.init(range) {
            let start = self.index(self.startIndex, offsetBy: r.lowerBound)
            let end = self.index(self.startIndex, offsetBy: r.upperBound)
            let range = start..<end
            
            self.replaceSubrange(range, with: place)
        }
    }
    
    
    func contains(_ str: String) -> Bool {
        let nstr: NSString = NSString(string: self)
        return nstr.contains(str)
    }
    
    
}


//MARK: -
public extension UIColor {
    
    /// 16进制
    /// - Parameter sHex: string hex code (eg. "00EEEE")
    convenience init(sHex: String) {
        var str: String = sHex.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines).uppercased()
        
        if str.hasPrefix("#") {
            let sIndex = str.index(str.startIndex, offsetBy: 1)
            str = String(str[sIndex..<str.endIndex])
        }
        
        var r:CUnsignedInt = 255
        var g:CUnsignedInt = 255
        var b:CUnsignedInt = 255
        var a:CUnsignedInt = 255
        
        if str.length == 6 || str.length == 8 {
            
            let strRed = str.substring(range: NSMakeRange(0, 2))
            let strGreen = str.substring(range: NSMakeRange(2, 2))
            let strBlue = str.substring(range: NSMakeRange(4, 2))
            
            Scanner(string: strRed).scanHexInt32(&r)
            Scanner(string: strGreen).scanHexInt32(&g)
            Scanner(string: strBlue).scanHexInt32(&b)
            
            if str.length > 6 {
                let strAlpha = str.substring(range: NSMakeRange(6, 2))
                Scanner(string: strAlpha).scanHexInt32(&a)
            }
        }
        
        self.init(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: CGFloat(a)/255.0)
    }
    
    /// Init color with hex code
    /// - Parameter iHex: int hex code (eg. 0x33ff99)
    convenience init(iHex: Int64) {
        guard iHex <= 0xffffff,
            iHex >= 0x000000 else {
                self.init(red: 1, green: 1, blue: 1, alpha: 1)
                return
        }
        
        let fRed: CGFloat = CGFloat((iHex & 0xff0000) >> 16)
        let fGreen: CGFloat = CGFloat((iHex & 0xff00) >> 8)
        let fBlue: CGFloat = CGFloat(iHex & 0xff)
        
        self.init(red: fRed/255, green: fGreen/255, blue: fBlue/255, alpha: 1.0)
    }
    
    
    /// Init color with RGBA 0~255
    ///
    /// - Parameters:
    ///   - r: red 0~255
    ///   - g: green 0~255
    ///   - b: blue 0~255
    ///   - a: alpha 0~100
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: a/100)
    }
    
    /// Init color with RGB 0~255
    ///
    /// - Parameters:
    ///   - r: red 0~255
    ///   - g: green 0~255
    ///   - b: blue 0~255
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(r: r, g: g, b: b, a: 100)
    }
    
}

//MARK: -
public extension Dictionary {
    func paraStr() -> String {
        var str = ""
        for (key, value) in self {
            str += "&\(key)=\(value)"
        }
        return str.substring(from: 1)
    }
}

//MARK: -
public extension UIImage {
    
    static func image(withColor color: UIColor, _ rect: CGRect = CGRect(x: 0, y: 0, width: 1, height: 1)) -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.screenS)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
        
    }
    
    func resetSize(withSeize size: CGSize = CGSize(width: 500, height: 500)) -> UIImage? {
        let sourceImage = self
        let imageSize = sourceImage.size
        let orginWidth = imageSize.width
        let orginHeight = imageSize.height
        let targetWidth = size.width
        let targetHeight = size.height
        var scaleFactor: CGFloat = 0.0
        var scaledWidth = targetWidth
        var scaledHeight = targetHeight
        var point = CGPoint.zero
        
        if __CGSizeEqualToSize(imageSize, size) == false {
            let widthFactor = targetWidth / orginWidth
            let heightFactor = targetHeight / orginHeight
            if widthFactor > heightFactor {
                scaleFactor = widthFactor
            } else {
                scaleFactor = heightFactor
            }
            
            scaledWidth = orginWidth * scaleFactor
            scaledHeight = orginHeight * scaleFactor
            
            if widthFactor > heightFactor {
                point.y = (targetHeight - scaledHeight) * 0.5
            } else {
                point.x = (targetWidth - scaledWidth) * 0.5
            }
        }
        
        UIGraphicsBeginImageContext(size)
        var rect = CGRect.zero
        rect.origin = point
        rect.size.width = scaledWidth
        rect.size.height = scaledHeight
        sourceImage.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}

//MARK: -
public extension Bundle {
    
    var bundleName: String {
        guard let name = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String else { return "not found" }
        return name
    }
    
    var bundleID: String {
        guard let bundleID = Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String else { return "none" }
        return bundleID
    }
    
    var bundleVersion: String {
        guard let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else { return "1.0" }
        return version
    }
    
    var bundleLaunchImageName: String {
        guard let info = Bundle.main.infoDictionary,
            let assets: [[String:String]] = info["UILaunchImages"] as? [[String : String]] else {
                return ""
        }
        
        let sSize = UIScreen.main.bounds.size
        print(sSize)
        
        var sOrientation = ""
        switch UIApplication.shared.statusBarOrientation {
        case .landscapeLeft, .landscapeRight :
            sOrientation = "Landscape"
        case .portrait, .portraitUpsideDown :
            sOrientation = "Portrait"
        default:
            sOrientation = ""
        }
        
        for asset in assets {
            let size: CGSize = NSCoder.cgSize(for: asset["UILaunchImageSize"] ?? "{0, 0}")
            let orientation = asset["UILaunchImageOrientation"] ?? ""
            if size == sSize && orientation == sOrientation {
                return asset["UILaunchImageName"] ?? ""
            }
            
        }
        return ""
    }
}
//MARK: -
public extension UINavigationBar {
    class func initializeOneMethod() {
        DispatchQueue.once(token: "Update_UINavigationBar_Layout_Margin") {
            self.swapMethod(originSel: #selector(layoutSubviews), swapSel: #selector(wpfLayoutSubviews))
        }
    }
    
    @objc func wpfLayoutSubviews() {
        self.wpfLayoutSubviews()
        
        // Solve the problem that left margin is too wide
        if #available(iOS 11.0, *) {
            self.layoutMargins = UIEdgeInsets.zero
            let space: CGFloat = 8
            for subview in self.subviews {
                if NSStringFromClass(type(of: subview)).contains("ContentView") {
                    subview.layoutMargins = UIEdgeInsets(top: 0, left: space, bottom: 0, right: space)
                }
            }
        }
        
    }
}



//MARK: -
public extension UIView {
    var kWidth: CGFloat {
        get {
            return frame.size.width
        }
        set {
            frame.size.width = newValue
        }
    }
    
    var kHeight: CGFloat {
        get {
            return frame.size.height
        }
        set {
            frame.size.height = newValue
        }
    }
    
    var kLeft: CGFloat {
        get {
            return frame.origin.x
        }
        set {
            frame.origin.x = newValue
        }
    }
    
    var kRight: CGFloat {
        get {
            return frame.origin.x + frame.size.width
        }
        set {
            frame.origin.x = newValue - frame.size.width
        }
    }
    
    var kTop: CGFloat {
        get {
            return frame.origin.y
        }
        set {
            frame.origin.y = newValue
        }
    }
    
    var kBottom: CGFloat {
        get {
            return frame.origin.y + frame.size.height
        }
        set {
            frame.origin.y = newValue - frame.size.height
        }
    }
    
    var kSize: CGSize {
        return frame.size
    }
    
    var kOrigin: CGPoint {
        return frame.origin
    }
    
}

//MARK: -
public extension CGRect {
    var kLeft: CGFloat {
        get {
            return origin.x
        }
        set {
            self.origin.x = newValue
        }
    }
    
    var kRight: CGFloat {
        get {
            return origin.x + size.width
        }
        set {
            self.origin.x = newValue - size.width
        }
    }
    
    var kTop: CGFloat {
        get {
            return origin.y
        }
        set {
            self.origin.y = newValue
        }
    }
    
    var kBottom: CGFloat {
        get {
            return origin.y + size.height
        }
        set {
            self.origin.y = newValue - size.height
        }
    }
    
}

//MARK: -
public extension UIScreen {
    /// 屏幕计算尺寸
    static var screenS: CGFloat {
        get {
            return UIScreen.main.scale
        }
    }
    static var screenW: CGFloat {
        get {
            return UIScreen.main.bounds.width
        }
    }
    
    static var screenH: CGFloat {
        get {
            return UIScreen.main.bounds.height
        }
    }
    static var screenRW: CGFloat {
        get {
            return UIScreen.main.scale * UIScreen.main.bounds.width
        }
    }
    
    static var screenRH: CGFloat {
        get {
            return UIScreen.main.scale * UIScreen.main.bounds.height
        }
    }
    
    static var screenRS: CGFloat {
        get {
            return UIScreen.main.scale / 2
        }
    }
}


//MARK: -
public extension UIDevice {
    
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4S"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5C"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5S"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6S"
        case "iPhone8,2":                               return "iPhone 6S Plus"
        case "iPhone8,4":                               return "iPhone SE"
        case "iPhone9,1":                               return "iPhone 7"
        case "iPhone9,2":                               return "iPhone 7 Plus"
        case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
        case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
        case "iPhone10,3", "iPhone10,6":                return "iPhone X"
        case "iPhone11,2":                              return "iPhone XS"
        case "iPhone11,4", "iPhone11,6":                return "iPhone XS Max"
        case "iPhone11,8":                              return "iPhone XR"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,7", "iPad6,8":                      return "iPad Pro"
        case "AppleTV5,3":                              return "Apple TV"
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return identifier
        }
    }
    
}

//MARK: -
public extension Date {
    func userFormatter(_ format: String) -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}

//MARK: -
public extension DispatchQueue {
    private static var onceTracker = [String]()
    
    class func once(token: String, block:()->Void) {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }
        
        if onceTracker.contains(token) {
            return
        }
        
        onceTracker.append(token)
        block()
    }
}


