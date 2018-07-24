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
    
    class func colorMatric() -> [NSArray]{
        NSLog("imhe")
        return [];
    }
}
