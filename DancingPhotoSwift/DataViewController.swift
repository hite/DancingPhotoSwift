//
//  DataViewController.swift
//  DancingPhotoSwift
//
//  Created by liang on 2018/7/20.
//  Copyright © 2018 liang. All rights reserved.
//

import UIKit
import SnapKit;

class DataViewController: UIViewController {

    @IBOutlet weak var dataLabel: UILabel!
    var dataObject: String = ""

    lazy var box = UIImageView();

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view .addSubview(box);
        box.image = UIImage(named: "img-source");
        box.contentMode = .scaleAspectFit
        box.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view);
        }
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.dataLabel!.text = dataObject
    }


}

