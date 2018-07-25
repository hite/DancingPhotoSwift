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
        
        NSLog("开始作画:")
        let startTime  = NSDate().timeIntervalSince1970;
        
        let poster = SizeLayout<UIImageView>(width: 50, height: 50, config: { imageView in
            imageView.image = UIImage(named: "img-source")
        })
        
        let label = LabelLayout(text: "Hello World!", alignment: .center)

        let stack = StackLayout(
            axis: .vertical, sublayouts: [label, poster]
        )
        
        let insets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 8)
        let matrix = InsetLayout(insets: insets, sublayout: stack);
        
        matrix.arrangement().makeViews(in: self.view)
//        for (yIdx, xColors) in colorMatrix.enumerated() {
//            // 计算横行步进。因为采样的长度是不足于屏幕的尺寸的
//            let xLen = xColors.count
//            let xGap = oneUnit
//            let xStep = (SCREEN_WIDTH - xGap * CGFloat(xLen + 1) ) / CGFloat(xLen)
//            let xStartOffset: CGFloat = 1
//
//            for (i, color) in xColors.enumerated() {
//                let dot = UIView()
//
//                dot.backgroundColor = color
//
//                self.dots.append(dot)
//                self.view.addSubview(dot)
//                // layoutkit
//                dot.frame = CGRect(x: xStartOffset + (xGap + xStep) * CGFloat(i), y: yStartOffset + CGFloat(yIdx) * (yStep + yGap), width: xStep, height: yStep)
//
//            }
//        }
        
        NSLog("画图结束，耗时：%f", NSDate().timeIntervalSince1970 - startTime);
    }

}
