//
//  GameManager.swift
//  Snake
//
//  Created by Furkan Celik on 21.01.2019.
//  Copyright © 2019 Furkan Celik. All rights reserved.
//

import SpriteKit


class GameManager {
    
    var scene: GameScene!
    var nextTime: Double?
    var timeExtension: Double = 0.2
    var playerDirection: Int = 1
    var currentScore: Int = 0
    var portalTimer: Timer = Timer()
    var portalGenerationTimer: Timer = Timer()
    
    private var secondsForPortal = 5
    
    init(scene: GameScene) {
        self.scene = scene
    }
    
    func InitGame() {
        scene.playerPositions.append((10, 10))
        scene.playerPositions.append((10, 11))
        scene.playerPositions.append((10, 12))
        RenderChange()
        GenerateNewScore()
        GenerateNewPortal()
    }
    
    func RenderChange() {
        for (node, x, y) in scene.gameArray {
            if scene.Contains(a: scene.playerPositions, v: (x, y)) {
                node.fillColor = SKColor.cyan
            } else {
                node.fillColor = SKColor.clear
                
                if scene.scorePos != nil {
                    if Int((scene.scorePos?.x)!) == y && Int((scene.scorePos?.y)!) == x {
                        node.fillColor = SKColor.red
                    }
                }
                if scene.portalPos.0 != nil {
                    if( (Int((scene.portalPos.0?.x)!)) == y && Int((scene.portalPos.0?.y)!) == x ||
                        (Int((scene.portalPos.1?.x)!)) == y && Int((scene.portalPos.1?.y)!) == x) {
                        node.fillColor = SKColor.green
                    }
                }
                for enemy in scene.enemySnakes {
                    if scene.Contains(a: enemy.snakePositions, v: (x, y)) {
                        node.fillColor = SKColor.magenta
                    }
                }
            }
        }
    }
    
    func Update(time: Double) {
        if nextTime == nil {
            nextTime = time + timeExtension
        } else {
            if time >= nextTime! {
                nextTime = time + timeExtension
                UpdatePlayerPosition()
                for enemy in scene.enemySnakes {
                    enemy.Move()
                }
                CheckForScore()
                CheckForPortal()
                CheckForEnemy()
                CheckForDeath()
                FinishAnimation()
                
                if !portalTimer.isValid && secondsForPortal != 0 {
                    portalTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: (#selector(UpdateTimer)), userInfo: nil, repeats: false)
                }
            }
        }
    }
    
    private func UpdatePlayerPosition() {
        var xChange = -1
        var yChange = 0
        switch playerDirection {
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
        
        if scene.playerPositions.count > 0 {
            var start = scene.playerPositions.count - 1
            while start > 0 {
                scene.playerPositions[start] = scene.playerPositions[start - 1]
                start -= 1
            }
            scene.playerPositions[0] = (scene.playerPositions[0].0 + yChange, scene.playerPositions[0].1 + xChange)
            
            if scene.playerPositions.count > 1 {
                let x = scene.playerPositions[0].1
                let y = scene.playerPositions[0].0
                
                if y > 39 {
                    scene.playerPositions[0].0 = 0
                }else if y < 0 {
                    scene.playerPositions[0].0 = 40
                }else if x > 19 {
                    scene.playerPositions[0].1 = 0
                }else if x < 0 {
                    scene.playerPositions[0].1 = 20
                }
            }
            RenderChange()
        }
    }
    
    func swipe(ID: Int) {
        if (!(ID == 2 && playerDirection == 4) && !(ID == 4 && playerDirection == 2) &&
            !(ID == 1 && playerDirection == 3) && !(ID == 3 && playerDirection == 1)) {
            if playerDirection != 0 {
                playerDirection = ID
            }
        }
    }
    
    @objc func UpdateTimer() {
        secondsForPortal -= 1
        if secondsForPortal == 0 {
            portalTimer.invalidate()
        }
    }
    
    @objc func UpdateGenTimer() {
        GenerateNewPortal()
    }
    
    private func GenerateNewScore() {
        var randomX = CGFloat(arc4random_uniform(19))
        var randomY = CGFloat(arc4random_uniform(39))
        while scene.Contains(a: scene.playerPositions, v: (Int(randomX), Int(randomY))) {
            randomX = CGFloat(arc4random_uniform(19))
            randomY = CGFloat(arc4random_uniform(39))
        }
        scene.scorePos = CGPoint(x: randomX, y: randomY)
    }
    
    private func GenerateNewPortal() {
        if !portalGenerationTimer.isValid {
            portalGenerationTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: (#selector(UpdateGenTimer)), userInfo: nil, repeats: false)
            var possiblity = CGFloat(arc4random_uniform(100))
            if possiblity > 75 {
                if secondsForPortal == 0 {
                    let randomX1 = CGFloat(arc4random_uniform(19)), randomX2 = CGFloat(arc4random_uniform(19))
                    let randomY1 = CGFloat(arc4random_uniform(39)), randomY2 = CGFloat(arc4random_uniform(39))
                    scene.portalPos = (CGPoint(x: randomX1, y: randomY1), CGPoint(x: randomX2, y: randomY2))
                    secondsForPortal = 5
                    print("Portal created")
                }
            }else {
                possiblity = CGFloat(arc4random_uniform(100))
            }
            if secondsForPortal == 0 {
                scene.portalPos = (nil, nil)
            }
        }
    }
    
    private func CheckForScore() {
        if scene.scorePos != nil {
            let x = scene.playerPositions[0].0
            let y = scene.playerPositions[0].1
            if Int((scene.scorePos?.x)!) == y && Int((scene.scorePos?.y)!) == x {
                currentScore += 1
                scene.currentScore.text = "Score: \(currentScore)"
                GenerateNewScore()
                scene.playerPositions.append(scene.playerPositions.last!)
                scene.playerPositions.append(scene.playerPositions.last!)
                scene.playerPositions.append(scene.playerPositions.last!)
            } else {
                for enemy in scene.enemySnakes {
                    if Int(scene.scorePos!.x) == enemy.snakePositions[0].1 && Int(scene.scorePos!.y) == enemy.snakePositions[0].0 {
                        GenerateNewScore()
                        enemy.snakePositions.append(enemy.snakePositions.last!)
                    }
                }
            }
        }
    }
    
    private func CheckForPortal() {
        if scene.portalPos.0 != nil && scene.playerPositions.count != 0 {
            for i in 0...scene.playerPositions.count-1 {
                let playerCg = CGPoint(x: scene.playerPositions[i].1, y: scene.playerPositions[i].0)
                if  playerCg == scene.portalPos.0 {
                    scene.playerPositions[i] = (Int(scene.portalPos.1!.y), Int(scene.portalPos.1!.x))
                } else if playerCg == scene.portalPos.1 {
                    scene.playerPositions[i] = (Int(scene.portalPos.0!.y), Int(scene.portalPos.0!.x))
                }
            }
            for enemy in scene.enemySnakes {
                for i in 0...enemy.snakePositions.count-1 {
                    let enemyCG = CGPoint(x: enemy.snakePositions[i].1, y: enemy.snakePositions[i].0)
                    if enemyCG == scene.portalPos.0 {
                        enemy.snakePositions[i] = (Int(scene.portalPos.1!.y), Int(scene.portalPos.1!.x))
                    }else if enemyCG == scene.portalPos.1 {
                        enemy.snakePositions[i] = (Int(scene.portalPos.0!.y), Int(scene.portalPos.0!.x))
                    }
                }
            }
            if secondsForPortal == 0 {
                scene.portalPos = (nil, nil)
            }
        } else if secondsForPortal == 0 && scene.portalPos.0 != nil {
            scene.portalPos = (nil, nil)
        } else {
            GenerateNewPortal()
        }
    }
    
    private func CheckForEnemy() {
        if scene.enemySnakes.count > 0 && scene.playerPositions.count > 0 {
            for enemy in scene.enemySnakes {
                var arrayOfPositions = enemy.snakePositions
                for i in 0...arrayOfPositions.count - 1 {
                    if enemy.snakePositions[i] == scene.playerPositions[0] {
                        if i >= 5 {
                            let newEnemy = EnemySnake(scene: scene)
                            for j in (i...arrayOfPositions.count - 1).reversed() {
                                newEnemy.snakePositions.insert(enemy.snakePositions[j], at: 0)
                                arrayOfPositions.remove(at: j)
                            }
                            scene.enemySnakes.append(newEnemy)
                        } else {
                            scene.enemySnakes = scene.enemySnakes.filter() { $0.snakePositions[0] != enemy.snakePositions[0] }
                        }
                    }
                }
                enemy.snakePositions = arrayOfPositions
                if enemy.snakePositions.count <= 3 {
                    scene.enemySnakes = scene.enemySnakes.filter() { $0.snakePositions[0] != enemy.snakePositions[0] }
                }
            }
        }
    }
    
    private func FrontRow() -> (Int, Int){
        if scene.playerPositions.count > 0 {
            var arrayOfPositions = scene.playerPositions
            let headOfSnake = arrayOfPositions[0]
            switch playerDirection {
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
    
    private func CheckForDeath() {
        if scene.playerPositions.count > 0 {
            var arrayOfPositions = scene.playerPositions
            let headOfSnake = arrayOfPositions[0]
            arrayOfPositions.remove(at: 0)
            if scene.Contains(a: arrayOfPositions, v: headOfSnake) {
                if scene.playerPositions.count < 12 {
                    playerDirection = 0
                }else {
                    for i in 1...scene.playerPositions.count-1 {
                        if headOfSnake == scene.playerPositions[i] {
                            if i < arrayOfPositions.count-3 {
                                let newEnemy = EnemySnake(scene: scene)
                                for j in (i + 1...arrayOfPositions.count-1).reversed() {
                                    newEnemy.snakePositions.append(arrayOfPositions[j])
                                    arrayOfPositions.remove(at: j)
                                }
                                arrayOfPositions.remove(at: i)
                                scene.enemySnakes.append(newEnemy)
                            }
                        }
                    }
                    scene.playerPositions = arrayOfPositions
                    scene.playerPositions.insert(headOfSnake, at: 0)
                }
            }
        }
    }
    
    private func FinishAnimation() {
        if playerDirection == 0 && scene.playerPositions.count > 0 {
            var hasFinished = true
            let headOfSnake = scene.playerPositions[0]
            for position in scene.playerPositions {
                if headOfSnake != position {
                    hasFinished = false
                }
            }
            
            if hasFinished {
                print("End game")
                UpdateScore()
                playerDirection = 4
                scene.scorePos = nil
                scene.playerPositions.removeAll()
                RenderChange()
                
                scene.currentScore.run(SKAction.scale(to: 0, duration: 0.4)){
                    self.scene.currentScore.isHidden = true
                }
                scene.gameBG.run(SKAction.scale(to: 0, duration: 0.4)) {
                    self.scene.gameBG.isHidden = true
                    self.scene.gameLogo.isHidden = false
                    self.scene.gameLogo.run(SKAction.move(to: CGPoint(x: 0, y: (self.scene.frame.size.height / 2) - 200), duration: 0.5)) {
                        self.scene.playButton.isHidden = false
                        self.scene.playButton.run(SKAction.scale(to: 1, duration: 0.3))
                        
                        self.scene.bestScore.run(SKAction.move(to: CGPoint(x: 0, y: self.scene.gameLogo.position.y - 50), duration: 0.3))
                    }
                }
            }
        }
    }
    
    private func UpdateScore() {
        if currentScore > UserDefaults.standard.integer(forKey: "bestScore") {
            UserDefaults.standard.set(currentScore, forKey: "bestScore")
        }
        currentScore = 0
        scene.currentScore.text = "Score: 0"
        scene.bestScore.text = "Best Score: \(UserDefaults.standard.integer(forKey: "bestScore"))"
    }
    
    private func CreateEnemy(_scene: GameScene) -> EnemySnake {
        let percentage = Int.random(in: 0...99)
        if percentage < 65 {
            return EnemySnake(scene: _scene)
        }else if percentage < 80 {
            return CrossMoveSnake(scene: _scene)
        }else {
            return PredatorSnake(scene: _scene)
        }
    }
}
