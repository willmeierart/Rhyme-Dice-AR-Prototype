//
//  ViewController.swift
//  RhymeDice AR prototype
//
//  Created by Will Meier on 9/13/17.
//  Copyright © 2017 Will Meier. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    
    var diceArray:[SCNNode] = []

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        sceneView.autoenablesDefaultLighting = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if ARWorldTrackingConfiguration.isSupported{
            let configuration = ARWorldTrackingConfiguration()
            configuration.planeDetection = .horizontal
            sceneView.session.run(configuration)
        } else {
            let configuration = AROrientationTrackingConfiguration()
            sceneView.session.run(configuration)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let touchLocation = touch.location(in: sceneView)
            let results = sceneView.hitTest(touchLocation, types: .existingPlaneUsingExtent)
            
            if let hitResult = results.first {
                addDice(atLocation: hitResult)
            }
        }
    }
    
    func generateDice(atLocation: ARHitTestResult, diceScene: SCNScene, name:String){
        if let node = diceScene.rootNode.childNode(withName:name, recursively:true){
            if !diceArray.contains(node) {
                diceArray.append(node)
                
                let diceHeight = (0.000000002*node.boundingSphere.radius)
                
                node.position = SCNVector3(
                    x: atLocation.worldTransform.columns.3.x,
                    y: atLocation.worldTransform.columns.3.y + diceHeight,
                    z: atLocation.worldTransform.columns.3.z
                )
                sceneView.scene.rootNode.addChildNode(node)
                
                roll(dice:node)
            }
        }
    }
    
    func addDice(atLocation: ARHitTestResult){
        let diceCommonScene = SCNScene(named: "art.scnassets/common.scn")!
        let diceLongScene = SCNScene(named: "art.scnassets/long.scn")!
        let diceRContScene = SCNScene(named: "art.scnassets/Rcontrolled.scn")!
        let diceShortScene = SCNScene(named: "art.scnassets/short.scn")!
        
        if diceArray.count == 0 {
            generateDice(atLocation: atLocation, diceScene: diceCommonScene, name: "Common")
            return
        }
        if diceArray.count == 1 {
            generateDice(atLocation: atLocation, diceScene: diceLongScene, name: "Long")
            return
        }
        if diceArray.count == 2 {
            generateDice(atLocation: atLocation, diceScene: diceRContScene, name: "RCont")
            return
        }
        if diceArray.count == 3 {
            generateDice(atLocation: atLocation, diceScene: diceShortScene, name: "Short")
            return
        }
    }
    
    @IBAction func removeDice(_ sender: UIBarButtonItem) {
        if !diceArray.isEmpty {
            for dice in diceArray {
                dice.removeFromParentNode()
            }
            diceArray = []
        }
    }
    
    
    override func motionBegan(_ motion: UIEventSubtype, with event: UIEvent?) {
        rollAll()
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        rollAll()
    }
    
    func roll(dice:SCNNode){
        let randomMultiplier = Float(arc4random_uniform(4)+7)
        let randomFaceValue = CGFloat(Float(arc4random_uniform(4)+1) * (Float.pi/2))
        
        let diceHeight = (0.000000002*dice.boundingSphere.radius)
        dice.pivot = SCNMatrix4MakeTranslation(0, 1.2, 0)
        
        dice.runAction(
            SCNAction.rotateBy(
                x: randomFaceValue,
                y: 0,
                z: 0,
                duration: TimeInterval(randomMultiplier * 0.1)
            )
        )
    }
    
    func rollAll(){
        if !diceArray.isEmpty {
            for dice in diceArray {
                roll(dice:dice)
            }
        }
    }
    
    
    //MARK: - ARSCNViewDelegateMethods:
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor){
        guard let planeAnchor = anchor as? ARPlaneAnchor else{return}
        
        let planeNode = createPlane(withPlaneAnchor: planeAnchor)
        
        node.addChildNode(planeNode)
        
    }
    
    
    //MARK: - PlaneRenderingMethods:
    
    func createPlane(withPlaneAnchor planeAnchor: ARPlaneAnchor) -> SCNNode{
        let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
        let planeNode = SCNNode()
        
        planeNode.position = SCNVector3(x:planeAnchor.center.x, y:0, z: planeAnchor.center.z)
        planeNode.transform = SCNMatrix4MakeRotation(-Float.pi/2, 1, 0, 0)
        
        let gridMaterial = SCNMaterial()
        gridMaterial.diffuse.contents = UIImage(named: "art.scnassets/grid.png")
        plane.materials = [gridMaterial]
        
        planeNode.geometry = plane
        
        return planeNode
    }
}
