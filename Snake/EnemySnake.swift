//
//  EnemySnake.swift
//  Snake
//
//  Created by Furkan Celik on 24.01.2019.
//  Copyright © 2019 Furkan Celik. All rights reserved.
//

import SpriteKit

class EnemySnake {
    var snakePositions: [(Int, Int)] = []
    var snakeDirection: Int = 1
    var scene: GameScene!
    
    init(scene: GameScene) {
        self.scene = scene
    }
    
    func Move(directionChange: Bool = true, cornerAdjust: Bool = true) {
        if directionChange {
            SetDirection()
        }
        var xChange = -1
        var yChange = 0
        switch snakeDirection {
        case 0: //Dead
            xChange = 0
            yChange = 0
            break
        case 1: //left
            xChange = -1
            yChange = 0
            break
        case 2: //up
            xChange = 0
            yChange = -1
            break
        case 3: //right
            xChange = 1
            yChange = 0
            break
        case 4: //down
            xChange = 0
            yChange = 1
            break
        default:
            break
        }
        
        if snakePositions.count > 0 {
            var start = snakePositions.count - 1
            while start > 0 {
                snakePositions[start] = snakePositions[start - 1]
                start -= 1
            }
            snakePositions[0] = (snakePositions[0].0 + yChange, snakePositions[0].1 + xChange)
        }
        
        if cornerAdjust {
            CornerAdjust()
        }
    }
    
    internal func CornerAdjust() {
        if snakePositions.count > 0 {
            if snakePositions.count > 1 {
                let x = snakePositions[0].1
                let y = snakePositions[0].0
                
                if y > 39 {
                    snakePositions[0].0 = 0
                }else if y < 0 {
                    snakePositions[0].0 = 39
                }else if x > 19 {
                    snakePositions[0].1 = 0
                }else if x < 0 {
                    snakePositions[0].1 = 19
                }
            }
        }
    }
    
    func SetDirection() {
        if scene.scorePos != nil && scene.scorePos!.x == CGFloat(snakePositions[0].1) && snakeDirection != 0 {
            if scene.scorePos!.y > CGFloat(snakePositions[0].0) {
                snakeDirection = 4
            }else {
                snakeDirection = 2
            }
        }else if scene.scorePos != nil && scene.scorePos!.y == CGFloat(snakePositions[0].0) {
            if scene.scorePos!.x == CGFloat(snakePositions[0].1) {
                snakeDirection = 1
            }else {
                snakeDirection = 3
            }
        }
        DetectCollusion(tryLimit: 5)
    }
    
    internal func DetectCollusion(tryLimit: Int) {
        if scene.Contains(a: scene.playerPositions, v: FrontRow()) && tryLimit > 0 {
            snakeDirection = (snakeDirection + 1)
            if snakeDirection > 4 {
                snakeDirection += 1
            }
            DetectCollusion(tryLimit: tryLimit - 1)
        } else if tryLimit == 0 {
            snakeDirection = 0
        }
    }
    
    internal func FrontRow() -> (Int, Int){
        if snakePositions.count > 0 {
            var arrayOfPositions = snakePositions
            let headOfSnake = arrayOfPositions[0]
            switch snakeDirection {
            case 1: //left
                return (headOfSnake.0, headOfSnake.1 - 1)
            case 2: //up
                return (headOfSnake.0 - 1, headOfSnake.1)
            case 3: //right
                return (headOfSnake.0, headOfSnake.1 + 1)
            case 4: //down
                return (headOfSnake.0 + 1, headOfSnake.1)
            default:
                break
            }
        }
        return (0, 0)
    }
    
    static func !=(left: EnemySnake, right: EnemySnake) -> Bool {
        return left.snakePositions[0] != left.snakePositions[0]
    }
}
