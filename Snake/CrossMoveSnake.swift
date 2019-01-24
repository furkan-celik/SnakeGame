//
//  CrossMoveSnake.swift
//  Snake
//
//  Created by Furkan Celik on 24.01.2019.
//  Copyright © 2019 Furkan Celik. All rights reserved.
//

import Foundation

class CrossMoveSnake: EnemySnake {
    var nextSnakeDirection: Int = 1
    var crossMove: Int = 1
    
    override func Move(directionChange: Bool = false, cornerAdjust: Bool = false) {
        if nextSnakeDirection != snakeDirection && snakeDirection != 0 {
            snakeDirection = nextSnakeDirection
            super.Move(directionChange: false)
            return
        }
        SetDirection()
        switch crossMove {
        case 0: //Dead
            snakeDirection = 0
            super.Move(directionChange: false, cornerAdjust: false)
            break
        case 1: //left up
            snakeDirection = 1 //left
            super.Move(directionChange: false, cornerAdjust: false)
            nextSnakeDirection = 2 //up
            break
        case 2: //left down
            snakeDirection = 1 //left
            super.Move(directionChange: false, cornerAdjust: false)
            nextSnakeDirection = 4 //down
            break
        case 3: //right down
            snakeDirection = 3 //right
            super.Move(directionChange: false, cornerAdjust: false)
            nextSnakeDirection = 4 //down
            break
        case 4: //right up
            snakeDirection = 3 //right
            super.Move(directionChange: false, cornerAdjust: false)
            nextSnakeDirection = 2 //up
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
            
            if snakePositions.count > 1 {
                let x = snakePositions[0].1
                let y = snakePositions[0].0
                
                if y > 39 {
                    crossMove = 0
                }else if y < 0 {
                    crossMove = 0
                }else if x > 19 {
                    crossMove = 0
                }else if x < 0 {
                    crossMove = 0
                }
            }
        }
    }
    
    override func DetectCollusion(tryLimit: Int) {
        if scene.Contains(a: scene.playerPositions, v: FrontRow()) && tryLimit > 0 {
            crossMove += 1
            if crossMove > 4 {
                crossMove += 1
            }
            DetectCollusion(tryLimit: tryLimit - 1)
        }else if tryLimit == 0 {
            crossMove = 0
        }
    }
}
