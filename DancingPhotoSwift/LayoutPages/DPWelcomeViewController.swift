//
//  DPWelcomeViewController.swift
//  DancingPhotoSwift
//
//  Created by liang on 2018/7/24.
//  Copyright © 2018 liang. All rights reserved.
//

import UIKit
import SnapKit

enum DispatchTaskType: String {
    case serial
    case cocurrent
    case main
    case global
}

struct Fuzzy: Equatable {
    var value: Double
    
    init(_ value: Double) {
        precondition(value >= 0.0 && value <= 1.0)
        self.value = value
    }
}

extension Fuzzy: ExpressibleByBooleanLiteral {
    init(booleanLiteral value: Bool) {
        self.init(value ? 1.0 : 0.0)
    }
}

class DPWelcomeViewController: DPLayoutPageController {
    //https://melerpaine.com/2018/04/08/iOS%20Swift%20GCD%20开发教程/
    // 定义队列
    let serialQueue = DispatchQueue(label: "com.sinkingsoul.DispatchQueueTest.serialQueue")
    let concurrentQueue = DispatchQueue(
        label: "com.sinkingsoul.DispatchQueueTest.concurrentQueue",
        attributes: .concurrent)
    let mainQueue = DispatchQueue.main
    let globalQueue = DispatchQueue.global()
    
    // 定义队列 key
    let serialQueueKey = DispatchSpecificKey<String>()
    let concurrentQueueKey = DispatchSpecificKey<String>()
    let mainQueueKey = DispatchSpecificKey<String>()
    let globalQueueKey = DispatchSpecificKey<String>()
    
    // 初始化队列 key
   override init(pageType: DPPageType) {
        serialQueue.setSpecific(key: serialQueueKey, value: DispatchTaskType.serial.rawValue)
        concurrentQueue.setSpecific(key: concurrentQueueKey, value: DispatchTaskType.cocurrent.rawValue)
        mainQueue.setSpecific(key: mainQueueKey, value: DispatchTaskType.main.rawValue)
        globalQueue.setSpecific(key: globalQueueKey, value: DispatchTaskType.global.rawValue)
        
        super.init(pageType:pageType)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        
        demo()
    }
    
    
    /// 迭代任务
    func concurrentPerformTask() {
        printCurrentThread(with: "start test")
        
        // 判断是否可以被另外一个整数
        func isDividedExactlyBy(_ divisor: Int, with number: Int) -> Bool {
            return number % divisor == 0
        }
        
        let array = Array(1...100)
        var result = [Int]()
        
        globalQueue.async {
            //通过concurrentPerform，循环变量数组
            print("concurrentPerform task start--->")
            DispatchQueue.concurrentPerform(iterations: 100, execute: { (index) in
                if isDividedExactlyBy(13, with: array[index]) {
                    self.printCurrentThread(with: "find a match: \(array[index])")
                    self.mainQueue.async {
                        result.append(array[index])
                    }
                }
            })
            
            print("--->concurrentPerform task over")
            //执行完毕，主线程更新结果。
            DispatchQueue.main.sync {
                print("back to main thread")
                print("result: find \(result.count) number - \(result)")
            }
        }
         printCurrentThread(with: "end test")
    }
    
    /// 栅栏任务
    func barrierTask() {
        let queue = concurrentQueue
        let barrierTask = DispatchWorkItem(flags: .barrier) {
            print("\nbarrierTask--->")
            self.printCurrentThread(with: "barrierTask")
            print("--->barrierTask\n")
        }
        
        printCurrentThread(with: "start test")
        
        queue.async {
            print("\nasync task1--->")
            self.printCurrentThread(with: "async task1")
            print("--->async task1\n")
        }
        queue.async {
            print("\nasync task2--->")
            self.printCurrentThread(with: "async task2")
            print("--->async task2\n")
        }
        queue.async {
            print("\nasync task3--->")
            self.printCurrentThread(with: "async task3")
            print("--f->async task3\n")
        }
        
        queue.async(execute: barrierTask) // 栅栏任务
        
        queue.async {
            print("\nasync task4--->")
            self.printCurrentThread(with: "async task4")
            print("--->async task4\n")
        }
        queue.async {
            print("\nasync task5--->")
            self.printCurrentThread(with: "async task5")
            print("--->async task5\n")
        }
        queue.async {
            print("\nasync task6--->")
            self.printCurrentThread(with: "async task6")
            print("--->async task6\n")
        }
        printCurrentThread(with: "end test")
    }
    /// 串行队列任务中嵌套本队列的异步任务
    func testAsyncTaskNestedInSameSerialQueue() {
        printCurrentThread(with: "start test")
        serialQueue.sync {
            print("\nserialQueue sync task--->")
            self.printCurrentThread(with: "serialQueue sync task")
            self.testIsTaskInQueue(.serial, key: self.serialQueueKey)
            
            self.serialQueue.async {
                print("\nserialQueue async task--->")
                self.printCurrentThread(with: "serialQueue async task")
                self.testIsTaskInQueue(.serial, key: self.serialQueueKey)
                print("--->serialQueue async task\n")
            }
            
            print("--->serialQueue sync task\n")
        }
        printCurrentThread(with: "end test")
    }
    /// 串行队列中新增异步任务
    func testAsyncTaskInSerialQueue() {
        printCurrentThread(with: "start test")
        serialQueue.async {
            print("\nserialQueue async task--->")
            self.printCurrentThread(with: "serialQueue async task")
            self.testIsTaskInQueue(.serial, key: self.serialQueueKey)
            print("--->serialQueue async task\n")
        }
        printCurrentThread(with: "end test")
    }
    /// 并行队列中新增异步任务
    func testAsyncTaskInConcurrentQueue() {
        printCurrentThread(with: "start test")
        concurrentQueue.async {
            print("\nconcurrentQueue async task--->")
            self.printCurrentThread(with: "concurrentQueue async task")
            self.testIsTaskInQueue(.cocurrent, key: self.concurrentQueueKey)
            print("--->concurrentQueue async task\n")
        }
        printCurrentThread(with: "end test")
    }
    /// 串行队列中嵌套其他队列的同步任务
    func testSyncTaskNestedInOtherSerialQueue() {
        // 创新另一个串行队列
        let serialQueue2 = DispatchQueue(
            label: "com.sinkingsoul.DispatchQueueTest.serialQueue2")
        let serialQueueKey2 = DispatchSpecificKey<String>()
        serialQueue2.setSpecific(key: serialQueueKey2, value: "serial2")
        
        self.printCurrentThread(with: "start test")
        serialQueue.sync {
            print("\nserialQueue sync task--->")
            self.printCurrentThread(with: "nserialQueue sync task")
            self.testIsTaskInQueue(.serial, key: self.serialQueueKey)
            
            serialQueue2.sync {
                print("\nserialQueue2 sync task--->")
                self.printCurrentThread(with: "serialQueue2 sync task")
                self.testIsTaskInQueue(.serial, key: self.serialQueueKey)
                
                let value = DispatchQueue.getSpecific(key: serialQueueKey2)
                let opnValue: String? = "serial2"
                print("Is task in serialQueue2: \(value == opnValue)")
                print("--->serialQueue2 sync task\n")
            }
            
            print("--->serialQueue sync task\n")
        }
    }
    /// 并行队列任务中嵌套本队列的同步任务
    func testSyncTaskNestedInSameConcurrentQueue() {
        printCurrentThread(with: "start test")
        concurrentQueue.async {
            print("\nconcurrentQueue async task--->")
            self.printCurrentThread(with: "concurrentQueue async task")
            self.testIsTaskInQueue(.cocurrent, key: self.concurrentQueueKey)
            
            self.concurrentQueue.sync {
                print("\nconcurrentQueue sync task--->")
                self.printCurrentThread(with: "concurrentQueue sync task")
                self.testIsTaskInQueue(.cocurrent, key: self.concurrentQueueKey)
                print("--->concurrentQueue sync task\n")
            }
            
            print("--->concurrentQueue async task\n")
        }
        printCurrentThread(with: "end test")
    }
    /// 串行队列任务中嵌套本队列的同步任务
    func testSyncTaskNestedInSameSerialQueue() {
        printCurrentThread(with: "start test")
        serialQueue.async {
            print("\nserialQueue async task--->")
            self.printCurrentThread(with: "serialQueue async task")
            self.testIsTaskInQueue(.serial, key: self.serialQueueKey)
            
            self.serialQueue.sync {
                print("\nserialQueue sync task--->")
                self.printCurrentThread(with: "serialQueue sync task")
                self.testIsTaskInQueue(.serial, key: self.serialQueueKey)
                print("--->serialQueue sync task\n")
            } // Thread 9: EXC_BREAKPOINT (code=1, subcode=0x101613ba4)
            
            print("--->serialQueue async task\n")
        }
        printCurrentThread(with: "end test")
    }
    /// 串行队列中新增同步任务
    func testSyncTaskInSerialQueue() {
        self.printCurrentThread(with: "start test")
        serialQueue.sync {
            print("\nserialQueue sync task--->")
            self.printCurrentThread(with: "serialQueue sync task")
            self.testIsTaskInQueue(.serial, key: serialQueueKey)
            print("--->serialQueue sync task\n")
        }
        self.printCurrentThread(with: "end test")
    }
    
    func printCurrentThread(with des: String, _ terminator: String = "") -> Void {
        print("\(des) at thread: \(Thread.current), this is \(Thread.isMainThread ? "" : "not ")main thread\(terminator)")
    }
    
    func testIsTaskInQueue(_ queueType: DispatchTaskType, key: DispatchSpecificKey<String>) -> Void {
        let value = DispatchQueue.getSpecific(key: key)
        let opnValue: String? = queueType.rawValue
        print("Is task in \(queueType.rawValue) queue: \(value == opnValue)")
    }
    
    @objc func preload(_ sender: UIButton) -> Void {
        NSLog("iam here")
        _tip?.text = "开始加载~"

        _ = DPWelcomeViewController.matrix;
        _tip?.text = "加载完毕"
    }
}
