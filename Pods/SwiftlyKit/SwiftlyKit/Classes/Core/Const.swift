//
//  Const.swift
//  SWKit
//
//  Created by jewelz on 2017/10/26.
//

import UIKit

public let ScreenRect = UIScreen.main.bounds
public let ScreenW = ScreenRect.size.width
public let ScreenH = ScreenRect.size.height
public let NavBarHeight: CGFloat = ScreenH == 812.0 ? 88 : 64
public let TabBarHeight: CGFloat = 49
public let SafeAreaBottomMargin: CGFloat = ScreenH == 812.0 ? 34 : 0
public let SafeAreaTopMargin: CGFloat = ScreenH == 812.0 ? 44 : 0
public let ScreenScale = ScreenW / 375

public let SEPARATOR_HEIGHT: CGFloat = 1 / UIScreen.main.scale
