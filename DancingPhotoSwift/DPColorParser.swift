//
//  DPColorParser.swift
//  LayoutKit
//
//  Created by liang on 2018/7/23.
//

import UIKit

class DPColorParser: NSObject {

}

extension UIImage{
    func colorAtPixel(point: CGPoint) -> UIColor? {
        // Cancel if point is outside image coordinates
        let imageRect: CGRect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height);
        if !imageRect.contains(point) {
            return nil;
        }
        let pointX: CGFloat = trunc(point.x)
        let pointY: CGFloat = trunc(point.y)
        
        let cgImage = self.cgImage;
        let width = self.size.width;
        let height = self.size.height;
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let test = 55;
        let bytesPerPixel: NSInteger = 4;
        let bytesPerRow = bytesPerPixel * 1;
        let bitsperComponet = 8
        var pixelData = [CUnsignedInt](repeating: 0, count: 4)
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        
        let context: CGContext = CGContext(data: &pixelData, width: 1, height: 1, bitsPerComponent: bitsperComponet, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)!
        context.setBlendMode(.normal)
        context.translateBy(x: -pointX, y: pointY-height)
        context.draw(cgImage!, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        let red = CGFloat(pixelData[0] / 255);
        let green = CGFloat(pixelData[1] / 255);
        let blue = CGFloat(pixelData[2] / 255);
        let alpha = CGFloat(pixelData[3] / 255);
        
        return UIColor(red: red, green: green, blue: blue, alpha: alpha);
    }
}
