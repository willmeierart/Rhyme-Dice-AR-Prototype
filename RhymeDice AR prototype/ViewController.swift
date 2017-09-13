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

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
//        let scene =         SCNScene(named: "art.scnassets/ship.scn")!
        let diceCommonScene = SCNScene(named: "art.scnassets/common1.scn")!
        let diceLongScene = SCNScene(named: "art.scnassets/long1.scn")!
        let diceRContScene = SCNScene(named: "art.scnassets/Rcontrolled1.scn")!
        let diceShortScene = SCNScene(named: "art.scnassets/short1.scn")!
        
        if let diceCommonNode = diceCommonScene.rootNode.childNode(withName:"Common", recursively:true){
            diceCommonNode.position = SCNVector3(x: -03, y: 0, z: -0.1)
            sceneView.scene.rootNode.addChildNode(diceCommonNode)
        }
        if let diceLongNode = diceLongScene.rootNode.childNode(withName:"Long", recursively:true){
            diceLongNode.position = SCNVector3(x: -0.1, y: 0, z: -0.1)
            sceneView.scene.rootNode.addChildNode(diceLongNode)
        }
        if let diceRContNode = diceRContScene.rootNode.childNode(withName:"RCont", recursively:true){
            diceRContNode.position = SCNVector3(x: 0.1, y: 0, z: -0.1)
            sceneView.scene.rootNode.addChildNode(diceRContNode)
        }
        if let diceShortNode = diceShortScene.rootNode.childNode(withName:"Short", recursively:true){
            diceShortNode.position = SCNVector3(x: 0.3, y: 0, z: -0.1)
            sceneView.scene.rootNode.addChildNode(diceShortNode)
        }
        
        
       
        
        
        
        
        
        
        
        
        
        
        
//        let cube = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.01)
//
//        let material = SCNMaterial()
//        material.diffuse.contents = UIColor.red
//        cube.materials = [material]
//
//        let node = SCNNode()
//        node.position = SCNVector3(x:0,y:0.1,z:-0.5)
//        node.geometry = cube
//
//        sceneView.scene.rootNode.addChildNode(node)
//
//        // Create a new scene
//        let scene = SCNScene(named: "art.scnassets/ship.scn")!
//
//        // Set the scene to the view
//        sceneView.scene = scene
        
        sceneView.autoenablesDefaultLighting = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        if ARWorldTrackingConfiguration.isSupported{
            let configuration = ARWorldTrackingConfiguration()
            sceneView.session.run(configuration)
        } else {
            let configuration = AROrientationTrackingConfiguration()
            sceneView.session.run(configuration)
        }
        

        // Run the view's session
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
}
