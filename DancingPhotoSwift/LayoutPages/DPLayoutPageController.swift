//
//  DPLayoutPageController.swift
//  DancingPhotoSwift
//
//  Created by liang on 2018/7/24.
//  Copyright © 2018 liang. All rights reserved.
//

import Foundation
import UIKit

let xStepPixel: Int8 = 3
let yStepPixel: Int8 = 3

class DPLayoutPageController: UIViewController, DPLayoutPageProtocol {
    var pageName: String = "demo"
    var pageType: DPPageType = DPPageType.welcome;
    func onMusicPowerChange(of average: Float, of peak: Float) {
        NSLog("Do nothing = %f", average)
    }
    
    init(pageType: DPPageType) {
        super.init(nibName: nil, bundle: nil)
        self.pageType = pageType;
        self.pageName = pageType.simpleDescription()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.pageName.count > 0 {
            let t = UILabel()
            t.text = self.pageName;
            self.view.addSubview(t)
            t.backgroundColor = .white;
            t.sizeToFit()
            
            t.snp.makeConstraints { (make) in
                make.top.equalTo(self.view.snp_topMargin).offset(20)
                make.centerX.equalTo(self.view.snp_centerXWithinMargins)
            }
        }
        
        NSLog("View name = %@", self.pageName);
    }
    
    var dots = [UIView]();
    
    static var matrix: [[UIColor]] = {
        let c = DPLayoutPageController.colorMatric()
        return c;
    }();
    
    static func colorMatric() -> [[UIColor]]{
        NSLog("imhe")
        let tron = UIImage(named: "img-source")
        NSLog("开始处理了，有点慢先等等，图片尺寸是%@", NSCoder.string(for: (tron?.size)!))
        let startTime = NSDate().timeIntervalSince1970;
        let imgView = UIImageView(image: tron);
        
        imgView.contentMode = .scaleAspectFit;
        let ws:[CGFloat] = [SCREEN_WIDTH, (tron?.size.width)!];
        let width = ws.min();
        let hs:[CGFloat] = [SCREEN_HEIGHT, (tron?.size.height)!]
        let height = hs.min()
        
        imgView.frame = CGRect(x: 0, y: 0, width: width!, height: height!)
        
        // 两层循环，先 x 轴，再 y 轴
        var xyColors: [[UIColor]] = Array();
        let maxH: Int = Int(imgView.bounds.size.height)
        for j in stride(from: 0, to: maxH, by: Int(yStepPixel)) {
            
            var xColors:[UIColor] = Array();
            //
            let maxW: Int = Int(imgView.bounds.size.width)
            
            for i in stride(from: 0, to: maxW, by: Int(xStepPixel)) {
                let point = CGPoint(x: i, y: j);
                let color: UIColor = imgView.colorOfPoint(point: point)
                xColors.append(color)
                
            }
            
            xyColors.append(xColors)
        }

        NSLog("处理结束，耗时：%f", NSDate().timeIntervalSince1970 - startTime);
        return xyColors;
    }
}

// https://github.com/sungeunDev/Sungeun_iOS/blob/eb6bb5e348f9beb5a7184585451e56e7809a7a7a/Study/Test/CollectionViewReordering/CollectionViewReordering/Extension.swift
private extension CALayer {
    func color(point: CGPoint) -> UIColor {
        var pixel: [CUnsignedChar] = [0, 0, 0, 0]
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmap = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: &pixel, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: bitmap.rawValue)
        
        context?.translateBy(x: -point.x, y: -point.y)
        render(in: context!)
        
        let red: CGFloat = CGFloat(pixel[0])/255.0
        let green: CGFloat = CGFloat(pixel[1])/255.0
        let blue: CGFloat = CGFloat(pixel[2])/255.0
        let alpha: CGFloat = CGFloat(pixel[3])/255.0
        
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}
