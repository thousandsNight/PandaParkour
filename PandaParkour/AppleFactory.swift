//
//  AppleFactory.swift
//  PandaParkour
//
//  Created by TongNa on 16/9/13.
//  Copyright © 2016年 TongNa. All rights reserved.
//

import Foundation
import SpriteKit

class AppleFactory:SKNode{
    let appleTexture = SKTexture(imageNamed: "apple")
    var sceneWidth:CGFloat = 0.0
    var arrApple = [SKSpriteNode]()
    var timer = Timer()
    var theY:CGFloat = 0.0
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("NSCoder not supported")
    }
    func onInit(width:CGFloat, y:CGFloat) {
        
        self.sceneWidth = width
        self.theY = y
        timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(AppleFactory.createApple), userInfo: nil, repeats: true)
    }
    func createApple(){
        let random = arc4random() % 10
        if random > 8 {
            let apple = SKSpriteNode(texture: appleTexture)
            apple.physicsBody = SKPhysicsBody(rectangleOf: apple.size)
            apple.physicsBody!.restitution = 0
            apple.physicsBody!.categoryBitMask = BitMaskType.apple
            apple.physicsBody!.isDynamic = false
            apple.anchorPoint = CGPoint(x: 0, y: 0)
            apple.zPosition = 40
            apple.position  = CGPoint(x: sceneWidth+apple.frame.width ,y: theY + 100)
            arrApple.append(apple)
            self.addChild(apple)
        }
        
    }
    func move(speed:CGFloat){
        for apple in arrApple {
            apple.position.x -= speed
        }
        if arrApple.count > 0 && arrApple[0].position.x < -20{
            
            arrApple[0].removeFromParent()
            arrApple.remove(at: 0)
            
        }
        
    }
    func reSet(){
        self.removeAllChildren()
        arrApple.removeAll(keepingCapacity: false)
    }
}
