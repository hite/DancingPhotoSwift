//
//  DPWelcomeViewController.swift
//  DancingPhotoSwift
//
//  Created by liang on 2018/7/24.
//  Copyright © 2018 liang. All rights reserved.
//

import UIKit
import SnapKit

class DPWelcomeViewController: DPLayoutPageController {
    
    var _tip: UILabel? = nil
    override func viewDidLoad(){
        super.viewDidLoad();
        
        let desc = UITextView()
        desc.font = .systemFont(ofSize: 14, weight: .bold)
        desc.text = """
        本 demo 意在展示多种不同的布局方式的性能差异\n
        1. frame 直接布局
        2. 使用 VFL 语句布局
        3. 使用 layoutAnchor 布局
        4. 使用 masonry 布局\n
        点击下面的按钮，获取图片资源，然后左右滑动
        """
        
        self.view.addSubview(desc)
        
        desc.snp.makeConstraints { (make) in
            make.top.equalTo(100);
            make.height.equalTo(200)
            make.left.equalTo(20)
            make.right.equalTo(-20)
        };
        
        let load = UIButton()
        load.setTitle("预先加载图片资源", for: .normal)
        load.setTitleColor(.darkGray, for: .normal)
        load.addTarget(self, action: #selector(preload(_:)), for: .touchUpInside)
        load.layer.cornerRadius = 1.5
        load.layer.borderWidth = ONE_PIXEL;
        load.sizeToFit()
        
        self.view.addSubview(load)
        load.snp.makeConstraints { (make) in
            make.top.equalTo(desc.snp_bottomMargin).offset(60);
            make.centerX.equalTo(self.view.snp_centerXWithinMargins)
        }
        // 提示
        let l = UILabel()
        l.text = "未加载"
        l.textColor = UIColor.lightGray
        l.sizeToFit()
        
        _tip = l;
        self.view.addSubview(l)
        
        l.snp.makeConstraints { (make) in
            make.top.equalTo(load.snp_bottomMargin).offset(20)
            make.centerX.equalTo(self.view.snp_centerXWithinMargins)
        }
    }
    
    @objc func preload(_ sender: UIButton) -> Void {
        NSLog("iam here")
        _tip?.text = "开始加载~"
        _tip?.sizeToFit();

        _ = DPWelcomeViewController.matrix;
        _tip?.text = "加载完毕"
    }
}
