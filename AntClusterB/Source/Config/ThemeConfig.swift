//
//  ThemeConfig.swift
//  AntClusterB
//
//  Created by 小唐 on 2019/5/30.
//  Copyright © 2019 ChainOne. All rights reserved.
//
//  App主题配置
//  App的主题相关：背景、颜色、等
//  本App有多个主题，可切换
/**
 主题切换涉及到的部分：(待UI沟通与统计)
 
 经确认，通用页暂无主题切换功能，该页面保留，具体处可写死
 
 **/

import Foundation

/// App主题分类
enum AppThemeType {
    case `default`
    case light
    case dark
}

/// App主题配置
typealias AppThemeConfig = ThemeConfig
/// App主题配置
class ThemeConfig {

    static let `default`: ThemeConfig = ThemeConfig.init(type: .default)
    static let light: ThemeConfig = ThemeConfig.init(type: .light)
    static let dark: ThemeConfig = ThemeConfig.init(type: .dark)

    init(type: AppThemeType) {
        switch type {
        case .light:
            break
        case .dark:
            break
        case .default:
            break
        }
    }

    /// 主题色
    var themeColor: UIColor = UIColor.init(hex: 0xF5BE41)
    /// 辅助色/次要色
    var minorColor: UIColor = UIColor.init(hex: 0xFFFFFF)
    /// 分割线颜色
    var dividingColor: UIColor = UIColor.init(hex: 0xE2E2E2)
    /// 主题红色
    var themeRedColor: UIColor = UIColor.init(hex: 0xCE586E)
    /// 主题黄色
    var themeYellowColor: UIColor = UIColor.init(hex: 0xFF8068)

    /// 标题色(页面)
    var titleColor: UIColor = UIColor.init(hex: 0x29313D)
    /// 正文颜色
    var mainTextColor: UIColor = UIColor.init(hex: 0x29313D)
    var subMainTextColor: UIColor = UIColor.init(hex: 0x333333)
    /// 详情颜色
    var detailTextColor: UIColor = UIColor.init(hex: 0x666666)
    /// 详情颜色
    var minorTextColor: UIColor = UIColor.init(hex: 0x8C97AC)
    /// 灰色文字颜色
    var grayTextColor: UIColor = UIColor.init(hex: 0x999999)  // 0x999999, 0x8C97AC

    /// 页面背景色(占位色)
    var pageBgColor: UIColor = UIColor.init(hex: 0xF1F2F6)
    /// 图片背景色(占位色)
    var imgBgColor: UIColor = UIColor.init(hex: 0x000000).withAlphaComponent(0.3)

    /// 不可用颜色 CCCCCC
    var disableColor: UIColor = UIColor.init(hex: 0xCCCCCC) // 0xC7CED8 0xCCCCCC
    /// 文字不可用颜色
    var disableTitleColor: UIColor = UIColor.init(hex: 0x8C97AC)

    /// 输入框背景色
    var inputBgColor: UIColor = UIColor.init(hex: 0xFFFFFF)
    /// 输入框PlaceHolder文字颜色
    var inputPlaceColor: UIColor = UIColor.init(hex: 0xC5CED9)

    /// 导航栏背景色
    var navBarTintColor: UIColor = UIColor.init(hex: 0xFFFFFF)
    /// 导航栏主题色 - 左右按钮item颜色
    var navTintColor: UIColor = UIColor.init(hex: 0x333333)
    /// 导航栏标题色
    var navTitleColor: UIColor = UIColor.init(hex: 0x333333)
    /// 导航栏阴影颜色
    var navShadowColor: UIColor = UIColor.init(hex: 0xE2E2E2)   // 0xE2E2E2
    
    /// 标签栏背景色
    var tabBarTintColor: UIColor = UIColor.init(hex: 0xFFFFFF)
    /// 标签栏未选中色
    var tabItemUnSelectedColor: UIColor = UIColor.init(hex: 0xC7C6D1)
    /// 标签栏选中色
    var tabItemSelectedColor: UIColor = UIColor.init(hex: 0xF5BE41)

}
