//
//  MainScene.swift
//  PandaParkour
//
//  Created by TongNa on 16/9/13.
//  Copyright © 2016年 TongNa. All rights reserved.
//

import Foundation
import SpriteKit

class MainScene: SKScene, SKPhysicsContactDelegate, ProtocolMainscreen{
    
    lazy var panda = Panda(size: CGSize(width: 50, height: 50))
    lazy var platformFactory = PlatformFactory()
    lazy var sound = SoundManager()
    lazy var bg = Background()
    lazy var appleFactory = AppleFactory()
    let scoreLab = SKLabelNode(fontNamed:"Chalkduster")
    let appLab = SKLabelNode(fontNamed:"Chalkduster")
    let myLabel = SKLabelNode(fontNamed:"Chalkduster")
    var appleNum = 0
    
    var moveSpeed :CGFloat = 5.0
    var maxSpeed :CGFloat = 15.0
    var distance:CGFloat = 0.0
    var lastDis:CGFloat = 0.0
    var theY:CGFloat = 0.0
    var isLose = false
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("NSCoder not supported")
    }
    override init(size: CGSize) {
        super.init(size: size)
        
        backgroundColor = SKColor(red: 113 / 255.0, green: 197 / 255.0, blue: 207 / 255.0, alpha: 1)
        scoreLab.horizontalAlignmentMode = .left
        scoreLab.position = CGPoint(x: 20, y: self.frame.size.height - 40)
        scoreLab.text = "run: 0 km"
        self.addChild(scoreLab)
        
        appLab.horizontalAlignmentMode = .left
        appLab.position = CGPoint(x: self.frame.width - 240, y: self.frame.size.height - 40)
        appLab.text = "eat: \(appleNum) apple"
        self.addChild(appLab)
        
        myLabel.text = "";
        myLabel.fontSize = 65;
        myLabel.zPosition = 100
        myLabel.position = CGPoint(x:self.frame.midX, y:self.frame.midY);
        self.addChild(myLabel)
        //配置物理系统
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -5)
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsBody?.categoryBitMask = BitMaskType.scene
        self.physicsBody?.isDynamic = false
        //创建熊猫和平台
        panda.position = CGPoint(x: 200, y: 400)
        panda.openPhysics()
        addChild(panda)
        addChild(platformFactory)
        platformFactory.screenWidth = self.frame.width
        platformFactory.delegate = self
        platformFactory.createPlatform(midNum: 3, x: 0, y: 200)
        
        addChild(bg)
        
        addChild(sound)
        sound.playBackgroundMusic()
        
        appleFactory.onInit(width: self.frame.width, y: theY)
        addChild(appleFactory)
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        //熊猫和苹果碰撞
        if (contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask) == (BitMaskType.apple | BitMaskType.panda){
            sound.playEat()
            self.appleNum += 1
            if contact.bodyA.categoryBitMask == BitMaskType.apple {
                contact.bodyA.node!.isHidden = true
            }else{
                contact.bodyB.node!.isHidden = true
            }
        }
        
        //熊猫和台子碰撞
        if (contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask) == (BitMaskType.platform | BitMaskType.panda){
            var isDown = false
            var canRun = false
            if contact.bodyA.categoryBitMask == BitMaskType.platform {
                if (contact.bodyA.node as! PlatForm).isDown {
                    isDown = true
                    contact.bodyA.node!.physicsBody!.isDynamic = true
                    contact.bodyA.node!.physicsBody!.collisionBitMask = 0
                }else if (contact.bodyA.node as! PlatForm).isShock {
                    (contact.bodyA.node as! PlatForm).isShock = false
                    downAndUp(node: contact.bodyA.node!, down: -50, downTime: 0.2, up: 100, upTime: 1, isRepeat: true)
                }
                if contact.bodyB.node!.position.y > contact.bodyA.node!.position.y {
                    canRun=true
                }
                
            }else if contact.bodyB.categoryBitMask == BitMaskType.platform  {
                if (contact.bodyB.node as! PlatForm).isDown {
                    contact.bodyB.node!.physicsBody!.isDynamic = true
                    contact.bodyB.node!.physicsBody!.collisionBitMask = 0
                    isDown = true
                }else if (contact.bodyB.node as! PlatForm).isShock {
                    (contact.bodyB.node as! PlatForm).isShock = false
                    downAndUp(node: contact.bodyB.node!, down: -50, downTime: 0.2, up: 100, upTime: 1, isRepeat: true)
                }
                if contact.bodyA.node!.position.y > contact.bodyB.node!.position.y {
                    canRun=true
                }
                
            }
            
            panda.jumpEnd = panda.position.y
            if panda.jumpEnd-panda.jumpStart <= -70 {
                panda.roll()
                sound.playRoll()
                
                if !isDown {
                    downAndUp(node: contact.bodyA.node!)
                    downAndUp(node: contact.bodyB.node!)
                }
                
            }else{
                if canRun {
                    panda.run()
                }
                
            }
        }
        
        if (contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask) == (BitMaskType.scene | BitMaskType.panda) {
            //只有碰触下边界以及左边界才导致游戏结束（理论上超出上边界不算结束，是跳出去的）
            if contact.contactPoint.y <= 25 || contact.contactPoint.x <= 25{
                print("game over")
                myLabel.text = "game over"
                sound.playDead()
                isLose = true
                sound.stopBackgroundMusic()
            }
        }
        
        //落地后jumpstart数据要设为当前位置，防止自由落地计算出错
        panda.jumpStart = panda.position.y
    }
    func didEndContact(contact: SKPhysicsContact){
        panda.jumpStart = panda.position.y
        
    }
    func downAndUp(node :SKNode,down:CGFloat = -50,downTime:CGFloat=0.05,up:CGFloat=50,upTime:CGFloat=0.1,isRepeat:Bool=false){
        let downAct = SKAction.moveBy(x: 0, y: down, duration: Double(downTime))
        //moveByX(CGFloat(0), y: down, duration: downTime)
        let upAct = SKAction.moveBy(x: 0, y: up, duration: Double(upTime))
        let downUpAct = SKAction.sequence([downAct,upAct])
        if isRepeat {
            node.run(SKAction.repeatForever(downUpAct))
        }else {
            node.run(downUpAct)
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isLose {
            reSet()
        }else{
            if panda.status != Status.jump2 {
                sound.playJump()
            }
            panda.jump()
        }
    }
    
    //重新开始游戏
    func reSet(){
        isLose = false
        panda.position = CGPoint(x: 200, y: 400)
        myLabel.text = ""
        moveSpeed  = 5.0
        distance = 0.0
        lastDis = 0.0
        self.appleNum = 0
        platformFactory.reset()
        appleFactory.reSet()
        platformFactory.createPlatform(midNum: 3, x: 0, y: 200)
        sound.playBackgroundMusic()
    }
    
    override func update(_ currentTime: TimeInterval) {
        if isLose {
            
        }else{
            if panda.position.x < 200 {
                let x = panda.position.x + 1
                panda.position = CGPoint(x: x, y: panda.position.y)
            }
            distance += moveSpeed
            lastDis -= moveSpeed
            var tempSpeed = CGFloat(5 + Int(distance/2000))
            if tempSpeed > maxSpeed {
                tempSpeed = maxSpeed
            }
            if moveSpeed < tempSpeed {
                moveSpeed = tempSpeed
            }
            
            if lastDis < 0 {
                platformFactory.createPlatformRandom()
            }
            distance += moveSpeed
            scoreLab.text = "run: \(Int(distance/1000*10)/10) km"
            appLab.text = "eat: \(appleNum) apple"
            platformFactory.move(speed: moveSpeed)
            bg.move(speed: moveSpeed / 5)
            appleFactory.move(speed: moveSpeed)
        }
    }
    
    func onGetData(dist: CGFloat, theY: CGFloat) {
        self.lastDis = dist
        self.theY = theY
        appleFactory.theY = theY
    }
    
}

protocol ProtocolMainscreen {
    func onGetData(dist:CGFloat, theY:CGFloat)
}
