//
//  PredatorSnake.swift
//  Snake
//
//  Created by Furkan Celik on 25.01.2019.
//  Copyright © 2019 Furkan Celik. All rights reserved.
//

import Foundation

class PredatorSnake: EnemySnake {
    
    override func Move(directionChange: Bool = false, cornerAdjust: Bool = true) {
        SetDirection()
        super.Move(directionChange: false, cornerAdjust: true)
    }
    
    override func SetDirection() {
        let playerHead = scene.playerPositions[0]
        let myHead = snakePositions[0]
        
        if playerHead.0 > myHead.0 {
            snakeDirection = 2
        }else if playerHead.0 < myHead.0 {
            snakeDirection = 4
        } else if playerHead.1 > myHead.1 {
            snakeDirection = 3
        }else {
            snakeDirection = 1
        }
    }
}
