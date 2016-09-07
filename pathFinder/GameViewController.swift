//
//  GameViewController.swift
//  pathFinder
//
//  Created by Allan Wallace on 31/07/2016.
//  Copyright (c) 2016 Allan Wallace. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit
import SpriteKit
import GameKit
import AVFoundation

struct bodyNames {
    static let Person = 0x1 << 1
    static let Coin = 0x1 << 2
}



class GameViewController: UIViewController, SCNSceneRendererDelegate, SCNPhysicsContactDelegate /*GKGameCenterControllerDelegate*/{
    
    let scene = SCNScene()
    let cameraNode = SCNNode()
    var person = SCNNode()
    let firstBox = SCNNode()
    var goingLeft = Bool()
    var tempBox = SCNNode()
    var prevBoxNumber = Int()
    var boxNumber = Int()
    var firstOne = Bool()
    var score = Int()
    var highscore = Int()
    var speed = Float()
    var counter = Int()
    var coinSound = AVAudioPlayer()
    var dead = Bool()
    var scoreLabel = UILabel()
    var highscoreLabel = UILabel()
    var livesLbl = UILabel()
    var gameOverLabel = UILabel()
    var HSTable = UILabel()
    var lives = 3
    var gameButton = UIButton()
    var newGameButton = UIButton()
    var bgColor = UIColor.white
    var personColor = UIColor()
    //var boxColor = UIColor()
    var red = CGFloat()
    var green = CGFloat()
    var blue = CGFloat()
    var boxMaterial = SCNMaterial()
    var gameOver = Bool()
    var highScore2 = Int()
    var highScore3 = Int()
    var highScore4 = Int()
    var highScore5 = Int()
    var highScoresTable = UILabel()
    
    
    
    
    
    override func viewDidLoad() {
        self.createNewScene()
        
        //authenticatePlayer()
        let path = Bundle.main.path(forResource: "coin", ofType: "wav")
        let soundUrl = URL(fileURLWithPath: path!)
        
        do {
            try coinSound = AVAudioPlayer(contentsOf: soundUrl)
            coinSound.prepareToPlay()
            
            
            
        } catch let err as NSError {
            print(err.debugDescription)
        }
        
        scene.physicsWorld.contactDelegate = self
        
        scoreLabel = UILabel(frame: CGRect(origin: CGPoint(x: self.view.frame.width / 2, y: self.view.frame.height / 2 + self.view.frame.height / 2.5), size: CGSize(width: self.view.frame.width, height: 100)))
        
        scoreLabel.center = CGPoint(x: self.view.frame.width / 2, y: self.view.frame.height / 2 - self.view.frame.height / 2.5)
        scoreLabel.textAlignment = .center
        scoreLabel.text = "Score : \(score)"
        scoreLabel.textColor = UIColor.darkGray
        self.view.addSubview(scoreLabel)
        
        livesLbl = UILabel(frame: CGRect(origin: CGPoint(x: self.view.frame.width / 2, y: self.view.frame.height / 2 + self.view.frame.height / 2.7), size: CGSize(width: self.view.frame.width, height: 100)))
        
        livesLbl.center = CGPoint(x: self.view.frame.width / 2, y: self.view.frame.height / 2 - self.view.frame.height / 2.7)
        livesLbl.textAlignment = .center
        livesLbl.text = "Lives : \(lives)"
        livesLbl.textColor = UIColor.darkGray
        self.view.addSubview(livesLbl
        )
        
        
        highscoreLabel = UILabel(frame: CGRect(origin: CGPoint(x: self.view.frame.width / 2, y: self.view.frame.height / 2 + self.view.frame.height / 2.5), size: CGSize(width: self.view.frame.width, height: 100)))
        
        highscoreLabel.center = CGPoint(x: self.view.frame.width / 2, y: self.view.frame.height / 2 + self.view.frame.height / 2.5)
        highscoreLabel.textAlignment = .center
        highscoreLabel.text = "Highscore : \(highscore)"
        highscoreLabel.textColor = UIColor.darkGray
        self.view.addSubview(highscoreLabel)
        
        
        gameOverLabel = UILabel(frame: CGRect(origin: CGPoint(x: self.view.frame.width / 2, y: (self.view.frame.height / 2) - 200), size: CGSize(width: self.view.frame.width, height: 100)))
        
        gameOverLabel.center = CGPoint(x: self.view.frame.width / 2, y: self.view.frame.height / 2)
        gameOverLabel.textAlignment = .center
        gameOverLabel.text = "GAME OVER"
        gameOverLabel.textColor = UIColor.blue
        gameOverLabel.font = UIFont.boldSystemFont(ofSize: 25)
        self.view.addSubview(gameOverLabel)
        gameOverLabel.isHidden = true
        
        
        highScoresTable = UILabel(frame: CGRect(origin: CGPoint(x: self.view.frame.width / 2, y: self.view.frame.height / 2), size: CGSize(width: self.view.frame.width, height: 200)))
        
        highScoresTable.center = CGPoint(x: self.view.frame.width / 2, y: self.view.frame.height / 2 + 200)
        highScoresTable.textAlignment = .center
        highScoresTable.text = "Highscore :\(highscore)"
        highScoresTable.textColor = UIColor.blue
        highScoresTable.font = UIFont.boldSystemFont(ofSize: 25)
        self.view.addSubview(highScoresTable)
        highScoresTable.isHidden = true

        
        
        
//        gameButton = UIButton(type: UIButtonType.Custom)
//        gameButton.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
//        gameButton.center = CGPoint(x: self.view.frame.width - 40, y: 60)
//        gameButton.setImage(UIImage(named: "gamecenter"), forState: UIControlState())
       /* gameButton.addTarget(self, action: #selector(GameViewController.showLeaderboard), forControlEvents: UIControlEvents.TouchUpInside)
         self.view.addSubview(gameButton)*/
        
    }
    
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        
        let nodeA = contact.nodeA
        let nodeB = contact.nodeB
        if nodeA.physicsBody?.categoryBitMask == bodyNames.Coin && nodeB.physicsBody?.categoryBitMask == bodyNames.Person{
            nodeA.removeFromParentNode()
            addScore()
            if coinSound.isPlaying == true{
                                coinSound.stop()
                                coinSound.play()
                           } else {
                                coinSound.play()
                
                            }

        }
            
            
            
        else if nodeA.physicsBody?.categoryBitMask == bodyNames.Person && nodeB.physicsBody?.categoryBitMask == bodyNames.Coin{
            nodeB.removeFromParentNode()
            addScore()
            if coinSound.isPlaying == true{
                coinSound.stop()
                coinSound.play()
            } else {
                coinSound.play()
                
            }

            
        }
        
        
        
        
    }

    
    
    func updateLabel(){
         if gameOver == true{
            scoreLabel.isHidden = true
            highscoreLabel.isHidden = true
            livesLbl.isHidden = true
            gameOverLabel.isHidden = false
            highScoresTable.isHidden = false
        } else {
            gameOverLabel.isHidden = true
            scoreLabel.text = "Score : \(score)"
            highscoreLabel.text = "Highscore : \(highscore)"
            livesLbl.text = "Lives : \(lives)"

        }
        
        
        
        
    }
    
    
    func addScore(){
        score += 1
        
        self.performSelector(onMainThread: #selector(GameViewController.updateLabel), with: nil, waitUntilDone: false)

        
        
        if score > highscore{
            
            highscore = score
            
            let scoreDefault = UserDefaults.standard
            scoreDefault.set(highscore, forKey: "highscore")
            print(highscore)
            
        }
        
    }
    
    
    
    
    
    func fadeIn(_ node : SCNNode){
        
        node.opacity = 0
        node.runAction(SCNAction.fadeIn(duration: 0.5))
        
    }
    func createCoin(_ box : SCNNode){
        scene.physicsWorld.gravity = SCNVector3Make(0, 0, 0)
        let spin = SCNAction.rotate(by: CGFloat(M_PI * 2), around: SCNVector3Make(0, 0.5 , 0) , duration: 0.75)
        let randomNumber = arc4random() % 7
        if randomNumber == 3{
            let coinScene = SCNScene(named: "Coin.dae")
            let coin = coinScene?.rootNode.childNode(withName: "Coin", recursively: true)
            coin?.position = SCNVector3Make(box.position.x, box.position.y + 1, box.position.z)
            coin?.scale = SCNVector3Make(0.2, 0.2, 0.2)
            
            
            coin?.physicsBody = SCNPhysicsBody(type: SCNPhysicsBodyType.dynamic, shape: SCNPhysicsShape(node: coin!, options: nil))
            coin?.physicsBody?.categoryBitMask = bodyNames.Coin
            coin?.physicsBody?.contactTestBitMask = bodyNames.Person
            coin?.physicsBody?.collisionBitMask = bodyNames.Person
            coin?.physicsBody?.isAffectedByGravity = false
            
            
            scene.rootNode.addChildNode(coin!)
            coin?.runAction(SCNAction.repeatForever(spin))
        
            fadeIn(coin!)
        }
        
    }
    
    func fadeOutx(_ node : SCNNode){
        
        
        let move = SCNAction.move(to: SCNVector3Make(node.position.x + 5, node.position.y, node.position.z), duration: 0.5)
        node.runAction(move)
        node.runAction(SCNAction.fadeOut(duration: 0.5))
        
        
        
    }
    
    
    func fadeOutz(_ node : SCNNode){
        
        
        let move = SCNAction.move(to: SCNVector3Make(node.position.x, node.position.y, node.position.z + 5), duration: 0.5)
        node.runAction(move)
        node.runAction(SCNAction.fadeOut(duration: 0.5))
    }
    
    
    
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        if dead == false{
            let deleteBox = self.scene.rootNode.childNode(withName: "\(prevBoxNumber)", recursively: true)
            
            let currentBox = self.scene.rootNode.childNode(withName: "\(prevBoxNumber + 1)", recursively: true)
            
            if (deleteBox?.position.x)! > person.position.x + 1 {
                prevBoxNumber += 1
                fadeOutx(deleteBox!)
                createBox()
                
            } else if (deleteBox?.position.z)! > person.position.z + 1{
                prevBoxNumber += 1
                fadeOutz(deleteBox!)
                createBox()
                
            }
            
            if person.position.x > currentBox!.position.x - 0.6 && person.position.x < currentBox!.position.x + 0.6 || person.position.z > currentBox!.position.z - 0.6 && person.position.z < currentBox!.position.z + 0.6 {
                
                
                
            }
            else{
                
                die()
                dead = true
            }
            
        }
        
    }
    
    func die(){
        person.runAction(SCNAction.move(to: SCNVector3Make(person.position.x, person.position.y - 10, person.position.z), duration: 1.0))
        
        let wait = SCNAction.wait(duration: 0.75)
        loseLife()
        
        
       if lives != 0{
        
        let sequence = SCNAction.sequence([wait, SCNAction.run({
            node in
            
            self.scene.rootNode.enumerateChildNodes({
                node, stop in
                
                node.removeFromParentNode()
                
            })
            
        }), SCNAction.run({
            node in
            
            self.createScene()
            
            
        })])
        
        
    
    
        person.runAction(sequence)
       }  else {
        gameOver = true
        gameOverFunc()
        
        
        }
    }
    
    func loseLife(){
        lives -= 1
        self.performSelector(onMainThread: #selector(GameViewController.updateLabel), with: nil, waitUntilDone: false)
        

        
    }
    
    func gameOverFunc(){
        
        let savedHighScore2 = UserDefaults.standard
        let savedHighScore3 = UserDefaults.standard
        let savedHighScore4 = UserDefaults.standard
        let savedHighScore5 = UserDefaults.standard
        
        if savedHighScore2.integer(forKey: "savedHighScore2") != 0{
            
            highScore2 = savedHighScore2.integer(forKey: "savedHighScore2")
        } else {
            highScore2 = 0
        }
        
        if savedHighScore3.integer(forKey: "savedHighScore3") != 0{
            
            highScore3 = savedHighScore3.integer(forKey: "savedHighScore3")
        } else {
            highScore3 = 0
        }

        
        if savedHighScore4.integer(forKey: "savedHighScore4") != 0{
            
            highScore4 = savedHighScore4.integer(forKey: "savedHighScore4")
        } else {
            highScore4 = 0
        }

        
        if savedHighScore5.integer(forKey: "savedHighScore5") != 0{
            
            highScore5 = savedHighScore5.integer(forKey: "savedHighScore5")
        } else {
            highScore5 = 0
        }

        if score > highScore2 {
            highScore5 = highScore4
            highScore4 = highScore3
            highScore3 = highScore2
            highScore2 = score
            
        }
        
        if score > highScore3 {
            highScore5 = highScore4
            highScore4 = highScore3
            highScore3 = score
            
        }
        
        if score > highScore4 {
            highScore5 = highScore4
            highScore4 = score
            
        }
        
        if score > highScore5 {
            highScore5 = score
            
        }
        
        let wait = SCNAction.wait(duration: 0.75)
        let sequence = SCNAction.sequence([wait, SCNAction.run({
            node in
            
            self.scene.rootNode.enumerateChildNodes({
                node, stop in
                
                node.removeFromParentNode()
                
            })
            
            
            
        }), SCNAction.run({
            node in
            
            //self.createNewScene()
            self.person.isHidden = true
            self.lives = 3
            self.score = 0
            self.performSelector(onMainThread: #selector(GameViewController.updateLabel), with: nil, waitUntilDone: false)
            self.displayScores()
            
        })])
        
        
        
        
        person.runAction(sequence)
    }
    
    
    
    func displayScores(){
    
     
        
    }
    
    
    
    func createBox(){
        tempBox = SCNNode(geometry: firstBox.geometry)
        let prevBox = scene.rootNode.childNode(withName: "\(boxNumber)", recursively: true)
        boxNumber += 1
        tempBox.name = "\(boxNumber)"
        counter += 1
        if counter == 10 {
            speed -= 1
            addScore()
            counter = 0
        }
        
        let randomNumber = arc4random() % 2
        
        switch randomNumber{
            
        case 0:
            tempBox.position = SCNVector3Make((prevBox?.position.x)! - firstBox.scale.x, (prevBox?.position.y)!, (prevBox?.position.z)!)
            if firstOne == true{
                firstOne = false
                goingLeft = false
            }
            break
        case 1:
            tempBox.position = SCNVector3Make((prevBox?.position.x)!, (prevBox?.position.y)!, (prevBox?.position.z)! - firstBox.scale.z)
            if firstOne == true{
                firstOne = false
                goingLeft = true
            }
            break
        default:
            
            break
        }
        self.scene.rootNode.addChildNode(tempBox)
        createCoin(tempBox)
        fadeIn(tempBox)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if dead == false{
            self.performSelector(onMainThread: #selector(GameViewController.updateLabel), with: nil, waitUntilDone: false)
            if goingLeft == false{
                person.removeAllActions()
                person.runAction(SCNAction.repeatForever(SCNAction.move(by: SCNVector3Make(speed, 0, 0), duration: 20)))
                goingLeft = true
                
            }
            else {
                person.removeAllActions()
                person.runAction(SCNAction.repeatForever(SCNAction.move(by: SCNVector3Make(0, 0, speed), duration: 20)))
                goingLeft = false
            }
        }
    }
    
    
    
    func newBox(){
        red = CGFloat((arc4random()%10)+2)/12
        green = CGFloat((arc4random()%10)+2)/12
        blue = CGFloat((arc4random()%10)+2)/12
        boxMaterial.diffuse.contents = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
       
    }
    
    func createNewScene(){
        newBox()
        updateLabel()
        let scoreDefault = UserDefaults.standard
        if scoreDefault.integer(forKey: "highscore") != 0{
            
            highscore = scoreDefault.integer(forKey: "highscore")
        }
        else{
            
            highscore = 0
        }
        gameOver = false
        lives = 3
        boxNumber = 0
        score = 0
        prevBoxNumber = 0
        firstOne = true
        dead = false
        speed = -50
        counter = 0

        self.view.backgroundColor = bgColor
        let sceneView = self.view as! SCNView
        sceneView.delegate = self
        sceneView.scene = scene
        
        setup()
    }
    
    
    
    func createScene(){
        newBox()
        updateLabel()
        boxNumber = 0
        prevBoxNumber = 0         
        firstOne = true
        dead = false
        speed += 5
        counter = 0
        
        self.view.backgroundColor = bgColor
        let sceneView = self.view as! SCNView
        sceneView.delegate = self
        sceneView.scene = scene
        setup()
    }
    
    
    
    func setup(){
        
        //Create Person
        
        personColor = UIColor.red
        let personGeo = SCNSphere(radius: 0.2)
        person = SCNNode(geometry: personGeo)
        let personMat = SCNMaterial()
        personMat.diffuse.contents = personColor
        personGeo.materials = [personMat]
        person.position = SCNVector3Make(0, 1.05, 0)
        
        person.physicsBody = SCNPhysicsBody(type: SCNPhysicsBodyType.static, shape:SCNPhysicsShape(node: person, options: nil))
        person.physicsBody?.categoryBitMask = bodyNames.Person
        person.physicsBody?.collisionBitMask = bodyNames.Coin
        person.physicsBody?.contactTestBitMask = bodyNames.Coin
        person.physicsBody?.isAffectedByGravity = false
        
        scene.rootNode.addChildNode(person)
        
        //Create Camera
        
        cameraNode.camera = SCNCamera()
        cameraNode.camera?.usesOrthographicProjection = true
        cameraNode.camera?.orthographicScale = 3
        cameraNode.position = SCNVector3Make(20, 20, 20)
        cameraNode.eulerAngles = SCNVector3Make(-45, 45, 0)
        let constraint = SCNLookAtConstraint(target: person)
        constraint.isGimbalLockEnabled = true
        self.cameraNode.constraints = [constraint]
        scene.rootNode.addChildNode(cameraNode)
        person.addChildNode(cameraNode)
        
        
        //Create Box
        newBox()
        let firstBoxGeo = SCNBox(width: 1, height: 1.5, length: 1, chamferRadius: 0.1)
        firstBox.geometry = firstBoxGeo
        firstBoxGeo.materials = [boxMaterial]
        firstBox.position = SCNVector3Make(0, 0, 0)
        scene.rootNode.addChildNode(firstBox)
        firstBox.name = "\(boxNumber)"
        firstBox.opacity = 1
        for _ in 0...6{
            createBox()
        }
        
        
        //Create Light
        
        let light = SCNNode()
        light.light = SCNLight()
        light.light?.type = SCNLight.LightType.directional
        light.eulerAngles = SCNVector3Make(-45, 45, 0)
        scene.rootNode.addChildNode(light)
        
        let light2 = SCNNode()
        light2.light = SCNLight()
        light2.light?.type = SCNLight.LightType.directional
        light2.eulerAngles = SCNVector3Make(45, -46, 0)
        scene.rootNode.addChildNode(light2)
        
    }
    
    
    /*func authenticatePlayer(){
     
     let localPlayer = GKLocalPlayer()
     
     localPlayer.authenticateHandler = {
     (viewController, error) in
     
     if viewController != nil {
     
     self.presentViewController(viewController!, animated: true, completion: nil)
     }
     
     else{
     print("logged in")
     }
     
     
     }
     
     
     }
     
     func saveHighscore(score : Int){
     
     if GKLocalPlayer.localPlayer().authenticated {
     
     let scoreReporter = GKScore(leaderboardIdentifier: "zag.001")
     
     scoreReporter.value = Int64(score)
     
     
     let scoreArray : [GKScore] = [scoreReporter]
     
     GKScore.reportScores(scoreArray, withCompletionHandler: nil)
     print("HI")
     
     }
     
     }
     
     func showLeaderboard(){
     saveHighscore(highscore)
     
     let gc = GKGameCenterViewController()
     
     gc.gameCenterDelegate = self
     
     self.presentViewController(gc, animated: true, completion: nil)
     
     
     }
     
     func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController) {
     gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
     }
     
     
     
     */
    
    
    
}
