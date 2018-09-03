//
//  dispatchTest.swift
//  DancingPhotoSwift
//
//  Created by liang on 2018/8/16.
//  Copyright © 2018 liang. All rights reserved.
//

import Foundation
// 讲指针的文章，https://www.jianshu.com/p/8217bf3444a8
class DispatchIOTest: NSObject {
    static func readFile() {
        let bundlePath = Bundle.main.bundlePath
        let filePath: NSString = "\(bundlePath)/wheretogo.md" as NSString
        let fileDescriptor = open(filePath.utf8String!, (O_RDWR | O_CREAT | O_APPEND), (S_IRWXU | S_IRWXG))

        let queue = DispatchQueue(label: "me.hite.test.swiftTest")
        let cleanupHandler:(Int32) -> Void = { errorNumber in
            
        }
        
        let io = DispatchIO(type:.stream, fileDescriptor: fileDescriptor, queue: queue, cleanupHandler: cleanupHandler)
        io.setLimit(highWater: 1024)
        
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let toFile = "\(documentsPath)/to.md" as NSString;
        print(toFile)
        let toFileDescriptor = open(toFile.utf8String!, (O_RDWR | O_CREAT | O_APPEND), (S_IRWXU | S_IRWXG))
        
        let writeIO = DispatchIO(type:.stream, fileDescriptor: toFileDescriptor, queue: queue, cleanupHandler: cleanupHandler)
        var offset = 0;
        writeIO.setLimit(highWater: 1024)
        io.read(offset: 0, length: Int.max, queue: queue) { (doneReading, data, error) in
            if error > 0 {
                print("读取错误，错误码 \(error)")
                return
            }
            
            if data != nil {
                print("写到 to.last")
                writeIO.write(offset: off_t(offset), data: data!, queue: queue, ioHandler: { (succ, data, error) in
                    if error > 0 {
                        print("写文件错误，错误码 \(error)")
                    } else {
                        print("Write done")
                    }
                })
                offset = offset + (data?.count)!;
            }
            if (doneReading) {
                io.close()
            }
        }
    }
    
}

class DispatchSourceTest: NSObject {
    var filePath: String
    var counter = 0
    let queue = DispatchQueue.global()
    
    override init() {
        filePath = "\(NSTemporaryDirectory())"
        super.init()
        startObserve {
            print("File was changed")
        }
    }
    
    func startObserve(closure: @escaping () -> Void) {
        let fileURL = URL(fileURLWithPath: filePath)
        let monitoredDirectoryFileDescriptor = open(fileURL.path, O_EVTONLY)
        
        let source = DispatchSource.makeFileSystemObjectSource(
            fileDescriptor: monitoredDirectoryFileDescriptor,
            eventMask: .write, queue: queue)
        source.setEventHandler(handler: closure)
        source.setCancelHandler {
            close(monitoredDirectoryFileDescriptor)
        }
        source.resume()
        
        print("Observe start")
    }
    
    func changeFile() {
        DispatchSourceTest.createFile(name: "DispatchSourceTest.md", filePath: NSTemporaryDirectory())
        counter += 1
        let text = "\(counter)"
        try! text.write(toFile: "\(filePath)/DispatchSourceTest.md", atomically: true, encoding: String.Encoding.utf8)
        print("file writed.")
    }
    
    static func createFile(name: String, filePath: String){
        let manager = FileManager.default
        let fileBaseUrl = URL(fileURLWithPath: filePath)
        let file = fileBaseUrl.appendingPathComponent(name)
        print("文件: \(file)")
        
        // 写入 "hello world"
        let exist = manager.fileExists(atPath: file.path)
        if !exist {
            let data = Data(base64Encoded:"aGVsbG8gd29ybGQ=" ,options:.ignoreUnknownCharacters)
            let createSuccess = manager.createFile(atPath: file.path,contents:data,attributes:nil)
            print("文件创建结果: \(createSuccess)")
        }
    }
}

class AsyncAfter {
    /// 延迟执行闭包
    static func dispatch_later(_ time: TimeInterval, block: @escaping () -> ()){
        let t = DispatchTime.now() + time
        DispatchQueue.main.asyncAfter(deadline: t, execute: block)
    }
    
    typealias ExchangableTask = (_ newDelayTime: TimeInterval?, _ anotherTask:@escaping (()->())
    ) -> Void
    
    /// 延迟执行一个任务，并支持在实际执行前替换为新的任务，并设定新的延迟时间。
    ///
    /// - Parameters:
    ///   - time: 延迟时间
    ///   - yourTask: 要执行的任务
    /// - Returns: 可替换原任务的闭包
    static func delay(_ time: TimeInterval, yourTask: @escaping () ->()) ->ExchangableTask{
        var exchangingTask: (() -> ())?
        var newDelayTime:TimeInterval?
        
        let finalClosure = { ()-> Void in
            if exchangingTask == nil{
                DispatchQueue.main.async(execute: yourTask)
            } else {
                if newDelayTime == nil {
                    DispatchQueue.main.async {
                        print("任务已更新，现在是:\(Date())")
                        exchangingTask!()
                    }
                }
            }
            
        }
        
        dispatch_later(time){
            finalClosure()
        }
        
        let exchangableTask: ExchangableTask = { delayTime, anotherTask in
            exchangingTask = anotherTask
            newDelayTime = delayTime
            
            if delayTime != nil {
                self.dispatch_later(delayTime!, block: {
                    anotherTask()
                    print("任务已更改，现在是\(Date())")
                })
            }
        }
        
        return exchangableTask
    }
}

