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
                make.top.equalTo(self.view.snp_topMargin).offset(30)
                make.centerX.equalTo(self.view.snp_centerXWithinMargins)
            }
        }
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
    
//    NSLog(@"开始处理了，有点慢先等等，图片尺寸是%@", NSStringFromCGSize(tron.size));
//    long long startTime = [[NSDate date] timeIntervalSince1970];
//
//    UIImageView *imgView = [[UIImageView alloc] initWithImage:tron];
//    imgView.contentMode = UIViewContentModeScaleAspectFit;
//    imgView.frame = CGRectMake(0, 0, MIN(SCREEN_WIDTH, tron.size.width), MIN(tron.size.height, SCREEN_HEIGHT));
//
//    // 两层循环，先 x 轴，再 y 轴
//    for (NSInteger j = 0; j < CGRectGetHeight(imgView.bounds); j += yStepPixel) {
//    NSMutableArray *xColors = [NSMutableArray arrayWithCapacity:100];
//    for (NSInteger i = 0; i < CGRectGetWidth(imgView.bounds); i += xStepPixel) {
//    CGPoint point = CGPointMake(i, j);
//    [xColors addObject:[imgView colorOfPoint:point]];
//    }
//    [matrix addObject:xColors];
//    }
//
//    NSLog(@"处理结束，耗时：%f", [[NSDate date] timeIntervalSince1970] - startTime);
//    });
//
//    return matrix;
}
