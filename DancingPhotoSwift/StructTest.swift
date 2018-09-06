//
//  StructTest.swift
//  DancingPhotoSwift
//
//  Created by liang on 2018/9/4.
//  Copyright © 2018 liang. All rights reserved.
//

import Foundation

class SomeClass {
    var number: Int = 0
    
}

struct SomeStruct {
    var number: Int = 0
}

func demo() -> Void {
    print("王\u{0301}亮")
    
    let zalgo = "s̼̐͗͜o̠̦̤ͯͥ̒ͫ́ͅo̺̪͖̗̽ͩ̃͟ͅn̢͔͖͇͇͉̫̰ͪ͑"

    print(zalgo)
    print(zalgo.count)
    print(zalgo.utf16.count)
    
    // CR+LF is a single Character
    let crlf = "\r\n"
    print(crlf)
    print(crlf.count)
}

