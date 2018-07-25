//
//  DPLayoutKitViewController.swift
//  DancingPhotoSwift
//
//  Created by liang on 2018/7/25.
//  Copyright © 2018 liang. All rights reserved.
//

import UIKit
import LayoutKit

class DPLayoutKitViewController: DPLayoutPageController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let colorMatrix = DPLayoutPageController.matrix;
        
        // 布局参数
        // 将这些颜色画到界面
        // 颜色的矩阵不会大于整个 view 的尺寸，因为采样的时候已经保证了这一点
        // 前提：间距 为 1 像素，元素尺寸需要计算
        let oneUnit = ONE_PIXEL;
        let yLen = colorMatrix.count
        let yGap = oneUnit
        let yStep = (SCREEN_HEIGHT - yGap * CGFloat(yLen + 1)) / CGFloat(yLen);
        let yStartOffset: CGFloat = 1
        
        let xStartOffset: CGFloat = 1
        let xGap = oneUnit
        NSLog("开始作画:")
        let startTime  = NSDate().timeIntervalSince1970;
        //
        var ySubLayouts: [StackLayout] = [StackLayout]()

        for (_, xColors) in colorMatrix.enumerated() {
            // 计算横行步进。因为采样的长度是不足于屏幕的尺寸的
            let xLen = xColors.count
            let xStep = (SCREEN_WIDTH - xGap * CGFloat(xLen + 1)) / CGFloat(xLen)

            var subLayouts: [SizeLayout] = [SizeLayout]()
            for (_, color) in xColors.enumerated() {
                let dotLayout = SizeLayout<UIView>(width: xStep, height: yStep, config:{(dot) in
                    dot.backgroundColor = color
                })
                subLayouts.append(dotLayout)
            }
            let xStack = StackLayout(
                axis: .horizontal,spacing: xGap, sublayouts: subLayouts
            )
            
            ySubLayouts.append(xStack)
        }
        let yStack = StackLayout(
            axis: .vertical, spacing: yGap, sublayouts: ySubLayouts
        )
        
        let insets = UIEdgeInsets(top: yStartOffset, left: xStartOffset, bottom: 0, right: 0)
        let matrix = InsetLayout(insets: insets, sublayout: yStack)
        matrix.arrangement().makeViews(in: self.view)
        
        NSLog("画图结束，耗时：%f", NSDate().timeIntervalSince1970 - startTime);
    }

}
