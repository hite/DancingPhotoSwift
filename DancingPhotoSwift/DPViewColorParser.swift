//
//  DPViewColorParser.swift
//  DancingPhotoSwift
//
//  Created by liang on 2018/7/25.
//  Copyright © 2018 liang. All rights reserved.
//

import Foundation
import UIKit

extension UIView{
    
    func colorOfPoint(point: CGPoint) -> UIColor {
        var pixel = [CUnsignedChar](repeating: 0, count: 4)
        let colorSpace:CGColorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext.init(data: &pixel, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
        
        context?.translateBy(x: -point.x, y: -point.y)
        
        self.layer.render(in: context!);
        
        let color = UIColor(red: CGFloat(pixel[0]) / 255.0, green: CGFloat(pixel[1]) / 255.0, blue: CGFloat(pixel[2]) / 255.0, alpha: CGFloat(pixel[3]) / 255.0)
        
        return color
    }
}
