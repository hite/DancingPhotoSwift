//
//  DPLayoutPageProtocol.swift
//  DancingPhotoSwift
//
//  Created by liang on 2018/7/23.
//  Copyright © 2018 liang. All rights reserved.
//

import UIKit

enum DPPageType {
    case welcome
    case frame
    case VFL
    case anchor
    case snapkit
    case layoutkit
    func simpleDescription() -> String {
        switch self {
        case .welcome:
            return "welcome"
        case .frame:
            return "frame"
        case .anchor:
            return "anchor"
        case .VFL:
            return "VFL"
        case .snapkit:
            return "snapkit"
        case .layoutkit:
            return "layoutkit"
        }
    }
}

protocol DPLayoutPageProtocol {
    var pageType: DPPageType { get }
    var pageName: String { get }
    func onMusicPowerChange(of average: Float, of peak: Float) -> Void
}


//MARK:
//获取设备的物理高度
public let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
//获取设备的物理宽度
public let SCREEN_WIDTH = UIScreen.main.bounds.size.width

public let ONE_PIXEL = (1 / UIScreen.main.scale)
