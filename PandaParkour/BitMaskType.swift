//
//  BitMaskType.swift
//  PandaParkour
//
//  Created by TongNa on 16/9/13.
//  Copyright © 2016年 TongNa. All rights reserved.
//

import Foundation

class BitMaskType {
    class var panda:UInt32 {
        return 1<<0
    }
    class var platform:UInt32 {
        return 1<<1//二进制，表示1向左位移1
    }
    class var apple:UInt32 {
        return 1<<2
    }
    class var scene:UInt32{
        return 1<<3
    }
}
