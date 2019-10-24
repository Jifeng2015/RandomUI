//
//  CommonData.swift
//  BeeColony
//
//  Created by TralyFang on 2019/3/8.
//  Copyright © 2019 TralyFang. All rights reserved.
//

import UIKit

// MARK: - UI
let kScreenHeight                   = UIScreen.main.bounds.size.height
let kScreenWidth                    = UIScreen.main.bounds.size.width
let kScreenScale                    = UIScreen.main.scale
let kStatusBarHeight                = UIApplication.shared.statusBarFrame.size.height
//private let kNavigationBarHeight: CGFloat   = 44 // 跟HXPhotoDefine.h -> kNavigationBarHeight 有冲突了
let kLineHeight: CGFloat            = 1.0/kScreenScale //0.5
let kNavAndStatusBarHeight          = kStatusBarHeight + 44
let kTabBarHeight                   = 49 + kFuncSafeAreaBottomHeight()
let kSafeAreaBottomHeight: CGFloat  = kFuncSafeAreaBottomHeight()
let kSafeAreaTopHeight: CGFloat     = kFuncSafeAreaTopHeight()

// 是否是iPhone X
private func kFuncIsIphoneX() -> Bool {
    var isX = (CGSize(width: 375.0, height: 812.0).equalTo(UIScreen.main.bounds.size) || CGSize(width: 812.0, height: 375.0).equalTo(UIScreen.main.bounds.size))
    if #available(iOS 11.0, *) {
        if (UIApplication.shared.delegate?.window??.safeAreaInsets.bottom ?? 0.0) > 0.0 {
            isX = true
        }
    }
    return isX
}
// 安全区域距离底部的高度
private func kFuncSafeAreaBottomHeight() -> CGFloat {
    if #available(iOS 11.0, *) {
        return UIApplication.shared.delegate?.window??.safeAreaInsets.bottom ?? 0.0
    }
    return kFuncIsIphoneX() ? 34 : 0
}
// 安全区域距离顶部的高度
private func kFuncSafeAreaTopHeight() -> CGFloat {
    if #available(iOS 11.0, *) {
        return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0.0
    }
    return kFuncIsIphoneX() ? 44 : 0
}


typealias OperationBlock        = ((Bool)->())
typealias ButtonClickBlock      = ((NSInteger)->())




public let FMScale = UIScreen.main.bounds.width / 1080.0

/// 像素转换为点,PX1080转换函数
///
/// - Parameter px: px大小
/// - Returns: 按PX1080转换后的大小
public func FMPx(_ px: CGFloat) -> CGFloat {
    return (px) * FMScale
}

public extension UIFont{
    
    public enum fontStyle {
        case regular
        case medium
        case bold
        case boldDIN
        case thin
        case akBlack
        case akBold
        case wechatLight
        
    }
    
    class func fmStyle(_ style: UIFont.fontStyle, px: CGFloat) -> UIFont {
        switch style {
        case .regular:
            return UIFont.init(name: "PingFangSC-Regular", size: FMPx(px)) ?? UIFont.systemFont(ofSize: FMPx(px))
        case .medium:
            return UIFont(name: "PingFangSC-Medium", size: FMPx(px)) ?? UIFont.boldSystemFont(ofSize: FMPx(px))
        case .bold:
            return UIFont(name: "PingFangSC-Semibold", size: FMPx(px)) ?? UIFont.boldSystemFont(ofSize: FMPx(px))
        case .boldDIN:
            return UIFont(name: "DINAlternate-Bold", size: FMPx(px)) ?? UIFont.boldSystemFont(ofSize: FMPx(px))
        case .thin:
            return UIFont(name: "PingFangSC-Thin", size: FMPx(px)) ?? UIFont.systemFont(ofSize: FMPx(px))
        //// 以下是自定义字体，需要下载的
        case .akBlack:
            return UIFont(name: "Akrobat-Black", size: FMPx(px)) ?? UIFont.boldSystemFont(ofSize: FMPx(px))
        case .akBold:
            return UIFont(name: "Akrobat-Bold", size: FMPx(px)) ?? UIFont.boldSystemFont(ofSize: FMPx(px))
        case .wechatLight:
            return UIFont(name: "WeChat-Sans-Std-Light", size: FMPx(px)) ?? UIFont.boldSystemFont(ofSize: FMPx(px))
        }
        /* 苹果自带的字体
         (lldb) po UIFont.fontNames(forFamilyName: "PingFang SC")
         ▿ 6 elements
         - 0 : "PingFangSC-Medium"
         - 1 : "PingFangSC-Semibold"
         - 2 : "PingFangSC-Light"
         - 3 : "PingFangSC-Ultralight"
         - 4 : "PingFangSC-Regular"
         - 5 : "PingFangSC-Thin"
         */
    }
}


// MARK: - 业务颜色
enum ColorManager {
    case text       // 文本黑色  1C1B22
    case textSub    // 副文本黑色 666666
    case textTip    // 副文本黑色 C3C1CE
    case line       // 线浅灰色  DAD9E6
    case background // 背景灰 F5F5F9
    case orange     // 主题橙色 FF5900
    case yellow     // 黄色 FFCB3D
    case red        // 红色 FC0840
    case green      // 绿色 00D29D
    case gold       // 金黄色 D25F00
    case wathetBlue       // 浅蓝色 4A90E2
    case text3      // 333333
    case text6      // 666666
    case text8      // 888888
    case text9      // 999999
    case ccc        // CCCCCC
    case `default`
}

extension UIColor {
    static func muColor(_ color: ColorManager) -> UIColor{
        switch color {
        case .text:
            return UIColor.hex(0x1C1B22)// 282631
        case .textSub:
            return UIColor.hex(0x666666)
        case .textTip:
            return UIColor.hex(0xC3C1CE)
        case .line:
            return UIColor.hex(0xDAD9E6)
        case .background:
            return UIColor.hex(0xF5F5F9)
        case .orange:
            return UIColor.hex(0xFF5900)
        case .yellow:
            return UIColor.hex(0xFFCB3D)
        case .red:
            return UIColor.hex(0xFC0840)
        case .green:
            return UIColor.hex(0x00D29D)
        case .gold:
            return UIColor.hex(0xD25F00)
        case .wathetBlue:
            return UIColor.hex(0x4A90E2)
        case .text3:
            return UIColor.hex(0x333333)
        case .text6:
            return UIColor.hex(0x666666)
        case .text8:
            return UIColor.hex(0x888888)
        case .text9:
            return UIColor.hex(0x999999)
        case .ccc:
            return UIColor.hex(0xCCCCCC)
        default:
            return UIColor.white
        }
    }
    public convenience init(redInt: Int, greenInt: Int, blueInt: Int) {
        self.init(red: CGFloat(redInt) / 255.0, green: CGFloat(greenInt) / 255.0, blue: CGFloat(blueInt) / 255.0, alpha: 1.0)
    }
    
    
}

extension UIColor {
    public static func hex(_ Hex: UInt32, alpha: CGFloat=1.0) -> UIColor {
        return UIColor.init(red: CGFloat((Hex & 0xFF0000) >> 16) / 255.0,
                            green: CGFloat((Hex & 0xFF00) >> 8) / 255.0,
                            blue: CGFloat((Hex & 0xFF)) / 255.0,
                            alpha: alpha)
    }
    
    public static func rgba(_ r:CGFloat, _ g: CGFloat, _ b: CGFloat, _ a: CGFloat=1) -> UIColor {
        return UIColor.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
    }
}


public extension Int {
    /// 闭区间
    public static func random(lower: Int = 0, _ upper: Int = Int.max) -> Int {
        return lower + Int(arc4random_uniform(UInt32(upper - lower + 1)))
    }
}


extension UIView {
    @discardableResult
    func addGradient(colors: [CGColor], bounds: CGRect, endPoint:CGPoint=CGPoint(x: 0, y: 1)) -> CAGradientLayer {
        let layer =  CAGradientLayer()
        layer.colors = colors
        layer.startPoint = CGPoint(x: 0, y: 0)
        layer.endPoint = endPoint
        layer.frame = bounds
        self.layer.insertSublayer(layer, at: 0)
        return layer
    }
    
    func addTapGesture(target: Any?, action: Selector?) -> () {
        // 添加手势识别
        self.isUserInteractionEnabled = true
        let tap0 = UITapGestureRecognizer(target: target, action: action)
        self.addGestureRecognizer(tap0)
    }
}

extension String {
    
    static func isEmpty(for text: String?) -> Bool {
        guard var text = text else {
            return true
        }
        text = text.trimmingCharacters(in: .whitespacesAndNewlines)
        return text.count == 0
    }
    
    //获取子字符串
    func substingInRange(_ r: Range<Int>) -> String? {
        if r.lowerBound < 0 || r.upperBound > self.count {
            return nil
        }
        let startIndex = self.index(self.startIndex, offsetBy:r.lowerBound)
        let endIndex   = self.index(self.startIndex, offsetBy:r.upperBound)
        return String(self[startIndex..<endIndex])
        
        /*
         let str = "Do any additional"
         let str4 = str.substingInRange(3..<6)
         print("string from 4 - 6 : \(str4)")
         //string from 4 - 6 : any
         */
    }
}


class Utility: NSObject {

// MARK: - 转字符串
class func anyToString(any:Any) -> String? {

    if ((any as? Int64) != nil) { // 整型
        return "\(any as! Int64)"
    }
    else if ((any as? Int) != nil) { // 整型
        return "\(any as! Int)"
    }
    else if (any as? Double) != nil{ // 浮点数
        return "\(any as! Double)"
    }
    else if (any as? String) != nil{ // 字符串
        return (any as! String)
    }
    else if (any as? Bool) != nil{ // Bool
        if let endValue = (any as? Bool){
            let endStr = (endValue == true) ? "1" : "0"
            return endStr
        }
    }
    return nil;
}
}
