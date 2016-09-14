//
//  GameScene.swift
//  PandaParkour
//
//  Created by TongNa on 16/9/13.
//  Copyright © 2016年 TongNa. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    override func didMove(to view: SKView) {
        
        //创建背景
        let background = SKSpriteNode(color: UIColor(red: 113 / 255.0, green: 197 / 255.0, blue: 207 / 255.0, alpha: 1), size: self.size)
        background.anchorPoint = CGPoint(x: 0, y: 0)
        //创建熊猫跑动
        let panda = Panda(size: CGSize(width: 100, height: 100))
        panda.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 70)
        //创建开始游戏按钮
        let label = SKLabelNode(fontNamed: "Chalkduster")
        label.name = "button"
        label.text = "开始游戏"
        label.fontSize = 50
        label.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 100)
        label.run(SKAction.repeatForever(SKAction.sequence([
            SKAction.scale(to: 1.1, duration: 1),
            SKAction.scale(to: 1, duration: 1)
            ])))
    
        addChild(background)
        addChild(panda)
        addChild(label)
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let button = childNode(withName: "button")
        button?.run(SKAction.fadeOut(withDuration: 0.5), completion: { 
            let scene = MainScene(size: self.size)
            self.view?.presentScene(scene, transition: SKTransition.doorsOpenVertical(withDuration: 0.5))
        })
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
