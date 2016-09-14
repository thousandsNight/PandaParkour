//
//  Platform.swift
//  PandaParkour
//
//  Created by TongNa on 16/9/13.
//  Copyright © 2016年 TongNa. All rights reserved.
//

import Foundation
import SpriteKit

class PlatForm: SKNode {
    
    var width:CGFloat = 0.0
    var height:CGFloat = 0.0
    var isDown = false
    var isShock = false
    //创建平台
    func onCreate(arrSprite:[SKSpriteNode]) {
        for platform in arrSprite {
            platform.position.x = self.width
            self.addChild(platform)
            self.width += platform.size.width
        }
        //短到只有3小块的平台会下落
        if arrSprite.count <= 3 {
            isDown = true
        }else
        {
            //随机振动
            let random = arc4random() % 10
            if random > 6 {
                isShock = true
            }
            
        }
        
        self.height = 10
        
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.width, height: self.height), center: CGPoint(x: self.width / 2, y: 0))
        self.physicsBody?.categoryBitMask = BitMaskType.platform
        self.physicsBody?.isDynamic = false
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.restitution = 0
        self.zPosition = 20
    }
    
}
