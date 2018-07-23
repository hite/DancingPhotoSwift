//
//  DPLayoutPageProtocol.swift
//  DancingPhotoSwift
//
//  Created by liang on 2018/7/23.
//  Copyright © 2018 liang. All rights reserved.
//

import UIKit

enum DPPageType {
    case frame
    case VFL
    case anchor
    case snapkit
    case layoutkit
}

protocol DPLayoutPageProtocol {
    var pageName: String { get }
    func onMusicPowerChange(of average: CGFloat, of peak: CGFloat) -> Void
}
