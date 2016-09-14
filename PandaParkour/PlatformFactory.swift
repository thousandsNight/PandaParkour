//
//  PlatformFactory.swift
//  PandaParkour
//
//  Created by TongNa on 16/9/13.
//  Copyright © 2016年 TongNa. All rights reserved.
//

import Foundation
import SpriteKit

class PlatformFactory: SKNode {
    
    //平台是由3部分组成
    let textureLeft = SKTexture(imageNamed: "platform_l")
    let textureMid = SKTexture(imageNamed: "platform_m")
    let textureRight = SKTexture(imageNamed: "platform_r")
    
    var platforms = [PlatForm]()
    var screenWidth:CGFloat = 0.0
    var delegate: ProtocolMainscreen?
    
    func createPlatformRandom() {
        let midNum = arc4random()%4 + 1
        let gap:CGFloat = CGFloat(arc4random()%8 + 1)
        let x = self.screenWidth + CGFloat(midNum*50) + gap + 100
        let y = CGFloat(arc4random()%200 + 50)
        
        createPlatform(midNum: midNum, x: x, y: y)
    }
    
    func createPlatform(midNum:UInt32,x:CGFloat,y:CGFloat) {
        let platform = PlatForm()
        let platform_left = SKSpriteNode(texture: textureLeft)
        platform_left.anchorPoint = CGPoint(x: 0, y: 0.9)
        
        let platform_right = SKSpriteNode(texture: textureRight)
        platform_right.anchorPoint = CGPoint(x: 0, y: 0.9)
        
        var arrPlatform = [SKSpriteNode]()
        
        arrPlatform.append(platform_left)
        platform.position = CGPoint(x: x, y: y)
        
        for _ in 1...midNum {
            let paltform_mid = SKSpriteNode(texture: textureMid)
            paltform_mid.anchorPoint = CGPoint(x: 0, y: 0.9)
            arrPlatform.append(paltform_mid)
        }
        
        arrPlatform.append(platform_right)
        platform.onCreate(arrSprite: arrPlatform)
        platform.name = "palform"
        self.addChild(platform)
        
        platforms.append(platform)
        self.delegate?.onGetData(dist: platform.width + x - screenWidth, theY: y)
    }
    //平台从右向左移动，并且完全超出屏幕外的平台将被移除
    func move(speed:CGFloat) {
        for p in platforms {
            let position = p.position
            p.position = CGPoint(x: position.x - speed, y: position.y)
        }
        if platforms[0].position.x < -platforms[0].width {
            platforms[0].removeFromParent()
            platforms.remove(at: 0)
        }
    }
    //清除所有node
    func reset() {
        self.removeAllChildren()
        platforms.removeAll(keepingCapacity: false)
    }
}
