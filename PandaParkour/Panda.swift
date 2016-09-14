//
//  Panda.swift
//  PandaParkour
//
//  Created by TongNa on 16/9/13.
//  Copyright © 2016年 TongNa. All rights reserved.
//

import Foundation
import SpriteKit

enum Status: Int {
    case run = 1, jump, jump2, roll
}

class Panda: SKSpriteNode {
    //定义跑、跳、滚动等动作动画
    let runAtlas = SKTextureAtlas(named: "run.atlas")
    var runFrames = [SKTexture]()
    let jumpAtlas = SKTextureAtlas(named: "jump.atlas")
    var jumpFrames = [SKTexture]()
    let rollAtlas = SKTextureAtlas(named: "roll.atlas")
    var rollFrames = [SKTexture]()
    //增加跳起的逼真动画效果
    let jumpEffectAtlas = SKTextureAtlas(named: "jump_effect.atlas")
    var jumpEffectFrames = [SKTexture]()
    var jumpEffect = SKSpriteNode()
    
    var status = Status.run
    var jumpStart:CGFloat = 0.0
    var jumpEnd:CGFloat = 0.0
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("NSCoder not supported")
    }
    init(size:CGSize) {
        let texture = runAtlas.textureNamed("panda_run_01")
        super.init(texture: texture, color: .white, size: size)
        //跑
        for v in runAtlas.textureNames {
            let runTexture = runAtlas.textureNamed(v)
            runFrames.append(runTexture)
        }
        //跳
        for v in jumpAtlas.textureNames {
            let runTexture = jumpAtlas.textureNamed(v)
            jumpFrames.append(runTexture)
        }
        //滚
        for v in rollAtlas.textureNames {
            let runTexture = rollAtlas.textureNamed(v)
            rollFrames.append(runTexture)
        }
        //跳的时候的点缀效果
        for v in jumpEffectAtlas.textureNames {
            let runTexture = jumpEffectAtlas.textureNamed(v)
            jumpEffectFrames.append(runTexture)
        }
        jumpEffect = SKSpriteNode(texture: jumpEffectFrames[0])
        jumpEffect.position = CGPoint(x: -50, y: -10)
        jumpEffect.isHidden = true
        addChild(jumpEffect)
        
        run()
    }
    //开启物理系统
    func openPhysics() -> Void {
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.restitution = 0.1//反弹力
        self.physicsBody?.categoryBitMask = BitMaskType.panda
        self.physicsBody?.contactTestBitMask = BitMaskType.platform | BitMaskType.apple | BitMaskType.scene
        self.physicsBody?.collisionBitMask = BitMaskType.platform
        self.zPosition = 20
    }
    
    func run() {
        //清除所有动作
        self.removeAllActions()
        self.status = .run
        //重复跑动动作
        self.run(SKAction.repeatForever(SKAction.animate(with: runFrames, timePerFrame: 0.05)))
    }
    func jump() {
        self.removeAllActions()
        if status != .jump2 {
            self.run(SKAction.animate(with: jumpFrames, timePerFrame: 0.05), withKey: "jump")
            //间接影响熊猫跳起的高度
            self.physicsBody?.velocity = CGVector(dx: 0, dy: 400)
            if status == .jump {
                self.run(SKAction.animate(with: rollFrames, timePerFrame: 0.05))
                status = .jump2
                self.jumpStart = self.position.y
            }else
            {
                showJumpEffect()
                status = .jump
            }
        }
    }
    func roll() {
        self.removeAllActions()
        self.status = .roll
        self.run(SKAction.animate(with: rollFrames, timePerFrame: 0.05)) { 
            self.run()
        }
    }
    func showJumpEffect() {
        jumpEffect.isHidden = false
        jumpEffect.run(SKAction.sequence([
            SKAction.animate(with: jumpEffectFrames, timePerFrame: 0.05),
            SKAction.run({ 
                self.jumpEffect.isHidden = true
            })
            ]))
        
    }
    
}
