//
//  Constant.swift
//  AntClusterB
//
//  Created by 小唐 on 2019/1/10.
//  Copyright © 2019 TangXiaoDe. All rights reserved.
//
//  常量

import Foundation
import UIKit

// MARK: - UserInterfacePrinciples

struct ScreenSize {
    static let width = UIScreen.main.bounds.size.width
    static let height = UIScreen.main.bounds.size.height
    static let maxlength = max(ScreenSize.width, ScreenSize.height)
}

public let kIsiPhoneXSeries: Bool = floor(UIScreen.main.bounds.size.height / UIScreen.main.bounds.size.width * 100) == 216
public let kScreenWidth: CGFloat = UIScreen.main.bounds.size.width
public let kScreenHeight: CGFloat = UIScreen.main.bounds.size.height
public let kStatusBarIsHidden: Bool = UIApplication.shared.isStatusBarHidden
public let kStatusBarHeight: CGFloat = !kStatusBarIsHidden ? UIApplication.shared.statusBarFrame.size.height : (kIsiPhoneXSeries ? 44.0: 20.0)
public let kNavigationBarHeight: CGFloat = 44
public let kNavigationStatusBarHeight: CGFloat = kStatusBarHeight + kNavigationBarHeight
/// 注：iPhoneX系列下tabbar的高度83实际上是计算了kBottomHeight，因此高度计算时需注意这个高度问题
public let kTabBarHeight: CGFloat = kIsiPhoneXSeries ? 83 : 49
public let kBottomHeight: CGFloat = kIsiPhoneXSeries ? 34 : 0
