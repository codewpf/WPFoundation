//
//  WPFoundation.swift
//  Pods
//
//  Created by alex on 2017/7/8.
//

import Foundation
import UIKit
import CommonCrypto
import CryptoKit


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
    mutating func removed(object: Element) {
        if let index = firstIndex(of: object) {
            remove(at: index)
        }
    }
    
    func remove(object: Element) -> [Element] {
        var result = self
        result.removed(object: object)
        return result
    }
    
}

public extension Array where Element: Hashable {
    func removDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()

        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }

    mutating func removedDuplicates() {
        self = self.removDuplicates()
    }
}


public extension Array where Element: Hashable {
    var unique:[Element] {
        var uniq = Set<Element>()
        uniq.reserveCapacity(self.count)
        return self.filter {
            return uniq.insert($0).inserted
        }
    }
}


@available(iOS 13.0, *)
extension Digest {
    var bytes: [UInt8] { Array(makeIterator()) }
    var data: Data { Data(bytes) }
    
    var hexStr: String {
        bytes.map { String(format: "%02X", $0) }.joined()
    }
}


//MARK: -
public extension String {
    
    /// 字符串长度
    var length: Int {
        return self.count
    }
    
    @available(iOS 13.0, *)
    var sha256: String {
        get {
            guard let data = self.data(using: .utf8) else { return  self}
            let digest = SHA256.hash(data: data)
            return digest.hexStr.uppercased()
        }
    }
    
    var md5: String {
        if #available(iOS 13.0, *) {
            guard let data = self.data(using: .utf8) else {
                return self
            }
            let digest = Insecure.MD5.hash(data: data)
            
            return digest.map {
                String(format: "%02hhx", $0)
            }.joined().uppercased()
        } else {
            guard let data = self.data(using: .utf8) else { return self }
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
            
            return digest.reduce(into: "") { $0 += String(format: "%02x", $1) }.uppercased()
        }
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
    func replace(range: NSRange, place: String = "****") -> String {
        var result = self
        
        if let r = Range.init(range) {
            let start = self.index(self.startIndex, offsetBy: r.lowerBound)
            let end = self.index(self.startIndex, offsetBy: r.upperBound)
            let range = start..<end
            
            result.replaceSubrange(range, with: place)
        }
        return result
    }
    
    
    func contains(_ str: String) -> Bool {
        let nstr: NSString = NSString(string: self)
        return nstr.contains(str)
    }
    
    func height(with size: CGSize, font: UIFont) -> CGFloat {
        let nss = NSString(string: self)
        let options: NSStringDrawingOptions = [.usesLineFragmentOrigin,.usesFontLeading]
        return CGFloat(ceilf( Float(nss.boundingRect(with: size, options: options, attributes: [.font: font], context: nil).size.height) ))
    }
    
    func size(with size: CGSize, font: UIFont) -> CGSize {
        let nss = NSString(string: self)
        let options: NSStringDrawingOptions = [.usesLineFragmentOrigin,.usesFontLeading]
        let size = nss.boundingRect(with: size, options: options, attributes: [.font: font], context: nil).size
        let height = CGFloat(ceilf( Float(size.height) ))
        let width = CGFloat(ceilf( Float(size.width) ))
        
        return CGSize(width: width, height: height)
    }
    
    func matches(for regex:String) -> [String] {
        do {
            let regex: NSRegularExpression = try NSRegularExpression(pattern: regex, options: [])
            let matches = regex.matches(in: self, options: [], range: NSMakeRange(0, self.count))
            
            var data:[String] = Array()
            for item in matches {
                let string = (self as NSString).substring(with: item.range)
                data.append(string)
            }
            
            return data
        }
        catch {
            return []
        }
    }
    
    func compareVersion(with other: String) -> Int {
        guard self != other else {
            return 0
        }
        
        var result: Int = 0
        
        
        var str = self
        var another = other
        
        let sp1 = str.split(separator: ".").count
        let sp2 = another.split(separator: ".").count
        if sp1 != sp2 {
            let count = Int(fabs(Double(sp1 - sp2)))
            if sp1 > sp2 {
                for _ in 0 ..< count {
                    another += ".0"
                }
            } else {
                for _ in 0 ..< count {
                    str += ".0"
                }
            }
        }
        
        
        let selfArray = str.split(separator: ".").map{Int64($0) ?? 0}
        let otherArray = another.split(separator: ".").map{Int64($0) ?? 0}
        
        for i in 0 ..< selfArray.count {
            
            let currentSelf = selfArray[i]
            let currentOther = otherArray[i]
            
            if currentSelf > currentOther {
                result = 1
                break
            } else if currentSelf < currentOther {
                result = -1
                break
            } else {
                continue
            }
        }
        
        
        return result
    }
    
}


//MARK: -
public extension UIColor {
    
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
public extension UIImage {
    
    static var appIcon: UIImage? {
        get {
            guard let iconsDictionary = Bundle.main.infoDictionary?["CFBundleIcons"] as? Dictionary<String, Any>,
                  let primaryIconsDictionary = iconsDictionary["CFBundlePrimaryIcon"] as? Dictionary<String, Any>,
                  let iconFiles = primaryIconsDictionary["CFBundleIconFiles"] as? [Any],
                  // First will be smallest for the device class, last will be the largest for device class
                  let lastIcon = iconFiles.last as? String,
                  let icon = UIImage(named: lastIcon) else {
                return nil
            }
            return icon
        }
    }
    
    
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
extension UIImage {
    func imageByRemoveWhiteBg() -> UIImage? {
        let colorMasking: [CGFloat] = [222, 255, 222, 255, 222, 255]
        return self.transparentColor(colorMasking: colorMasking)
    }
    
    func imageByRemoveBlackBg() -> UIImage? {
        let colorMasking: [CGFloat] = [0, 32, 0, 32, 0, 32]
        return self.transparentColor(colorMasking: colorMasking)
    }
    
    func transparentColor(colorMasking: [CGFloat]) -> UIImage? {
        if let rawImageRef = self.cgImage {
            UIGraphicsBeginImageContext(self.size)
            if let maskedImageRef = rawImageRef.copy(maskingColorComponents: colorMasking) {
                let context: CGContext = UIGraphicsGetCurrentContext()!
                context.translateBy(x: 0.0, y: self.size.height)
                context.scaleBy(x: 1.0, y: -1.0)
                let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
                context.draw(maskedImageRef, in: rect)
                let result = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                return result
            }
        }
        return nil
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
        
        let sOrientation = "Portrait"
        //        var sOrientation = ""
        //        switch UIApplication.shared.statusBarOrientation {
        //        case .landscapeLeft, .landscapeRight :
        //            sOrientation = "Landscape"
        //        case .portrait, .portraitUpsideDown :
        //            sOrientation = "Portrait"
        //        default:
        //            sOrientation = ""
        //        }
        
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

public extension UIView {
    
    /// Part corner
    ///
    /// - Parameters:
    ///   - corners: directions, multiple
    ///   - radii: corners radius
    /// - Examples:
    ///   let cornerss: UIRectCorner = [.bottomLeft,.bottomRight]
    ///   self.addPartCorners(byRoundingCorners: cornerss, radii: 10.0)
    func addPartCorners(byRoundingCorners corners: UIRectCorner, radii: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radii, height: radii))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
    }
    
    
    /// - Parameters:
    ///   - radius: corner radius
    ///   - size: image size
    func imageWithCorners(_ radius: CGFloat, size: CGSize) -> UIImage? {
        let rect = CGRect(origin: CGPoint.zero, size: size)
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()
        let path = UIBezierPath.init(roundedRect: rect, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: radius, height: radius))
        context?.addPath(path.cgPath)
        context?.clip()
        self.draw(rect)
        context?.drawPath(using: .fillStroke)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    func removeAllSubviews() {
        for sub in self.subviews {
            sub.removeFromSuperview()
        }
    }
    
    
    func dropShadow(color: UIColor = .gray, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 5, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
}

public extension CALayer {
    func applySketchShadow(
        color: CGColor,
        alpha: Float,
        x: CGFloat,
        y: CGFloat,
        blur: CGFloat,
        spread: CGFloat)
    {
        shadowColor = color
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2.0
        if spread == 0 {
            shadowPath = nil
        } else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
}

//MARK: -

protocol WPFLayoutable {}
extension WPFLayoutable {
    var bottomInset: CGFloat {
        get {
            let name = UIDevice.current.modelName
            if name.contains("iPhone X") || name.contains("Simulator") { return 34
            } else { return 0 }
        }
    }
    
    var statusBarHeight: CGFloat {
        get {
            guard let window = UIApplication.shared.delegate?.window else { return 20.0 }
            if #available(iOS 13.0, *) {
                return window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0
            } else {
                return 20.0
            }
        }
    }
}

extension WPFLayoutable where Self: UIViewController {
    var navigationBarHeight: CGFloat {
        get {
            guard let bar = self.navigationController?.navigationBar else {
                return 0
            }
            return bar.frame.height
        }
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
        
        func mapToDevice(identifier: String) -> String { // swiftlint:disable:this cyclomatic_complexity
            #if os(iOS)
            switch identifier {
            case "iPod5,1":                                 return "iPod touch (5th generation)"
            case "iPod7,1":                                 return "iPod touch (6th generation)"
            case "iPod9,1":                                 return "iPod touch (7th generation)"
            case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
            case "iPhone4,1":                               return "iPhone 4s"
            case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
            case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
            case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
            case "iPhone7,2":                               return "iPhone 6"
            case "iPhone7,1":                               return "iPhone 6 Plus"
            case "iPhone8,1":                               return "iPhone 6s"
            case "iPhone8,2":                               return "iPhone 6s Plus"
            case "iPhone8,4":                               return "iPhone SE"
            case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
            case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
            case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
            case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
            case "iPhone10,3", "iPhone10,6":                return "iPhone X"
            case "iPhone11,2":                              return "iPhone XS"
            case "iPhone11,4", "iPhone11,6":                return "iPhone XS Max"
            case "iPhone11,8":                              return "iPhone XR"
            case "iPhone12,1":                              return "iPhone 11"
            case "iPhone12,3":                              return "iPhone 11 Pro"
            case "iPhone12,5":                              return "iPhone 11 Pro Max"
            case "iPhone12,8":                              return "iPhone SE (2nd generation)"
            case "iPhone13,1":                              return "iPhone 12 mini"
            case "iPhone13,2":                              return "iPhone 12"
            case "iPhone13,3":                              return "iPhone 12 Pro"
            case "iPhone13,4":                              return "iPhone 12 Pro Max"
            case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
            case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad (3rd generation)"
            case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad (4th generation)"
            case "iPad6,11", "iPad6,12":                    return "iPad (5th generation)"
            case "iPad7,5", "iPad7,6":                      return "iPad (6th generation)"
            case "iPad7,11", "iPad7,12":                    return "iPad (7th generation)"
            case "iPad11,6", "iPad11,7":                    return "iPad (8th generation)"
            case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
            case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
            case "iPad11,3", "iPad11,4":                    return "iPad Air (3rd generation)"
            case "iPad13,1", "iPad13,2":                    return "iPad Air (4th generation)"
            case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad mini"
            case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad mini 2"
            case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad mini 3"
            case "iPad5,1", "iPad5,2":                      return "iPad mini 4"
            case "iPad11,1", "iPad11,2":                    return "iPad mini (5th generation)"
            case "iPad6,3", "iPad6,4":                      return "iPad Pro (9.7-inch)"
            case "iPad7,3", "iPad7,4":                      return "iPad Pro (10.5-inch)"
            case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":return "iPad Pro (11-inch) (1st generation)"
            case "iPad8,9", "iPad8,10":                     return "iPad Pro (11-inch) (2nd generation)"
            case "iPad6,7", "iPad6,8":                      return "iPad Pro (12.9-inch) (1st generation)"
            case "iPad7,1", "iPad7,2":                      return "iPad Pro (12.9-inch) (2nd generation)"
            case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":return "iPad Pro (12.9-inch) (3rd generation)"
            case "iPad8,11", "iPad8,12":                    return "iPad Pro (12.9-inch) (4th generation)"
            case "AppleTV5,3":                              return "Apple TV"
            case "AppleTV6,2":                              return "Apple TV 4K"
            case "AudioAccessory1,1":                       return "HomePod"
            case "AudioAccessory5,1":                       return "HomePod mini"
            case "i386", "x86_64":                          return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "iOS"))"
            default:                                        return identifier
            }
            #elseif os(tvOS)
            switch identifier {
            case "AppleTV5,3": return "Apple TV 4"
            case "AppleTV6,2": return "Apple TV 4K"
            case "i386", "x86_64": return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "tvOS"))"
            default: return identifier
            }
            #endif
        }
        
        return mapToDevice(identifier: identifier)
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
