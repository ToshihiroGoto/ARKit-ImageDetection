//
//  ViewController.swift
//  ImageDetection
//
//  Created by Toshihiro Goto on 2018/01/25.
//  Copyright © 2018年 Toshihiro Goto. All rights reserved.
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
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // デバッグ用に特徴点を表示
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // 水平と垂直で平面を認識
        configuration.planeDetection = [.vertical, .horizontal]

        // 画像認識の参照用画像をアセットから取得
        configuration.detectionImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil)
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/

    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
    }
    
    // アンカーが更新された時
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        
        DispatchQueue.main.async {

            // アンカーが画像認識用か調べる
            if let imageAnchor = anchor as? ARImageAnchor {
                
                //　ジオメトリが設定されていなければ、ジオメトリを設定
                if(node.geometry == nil){
                    let plane = SCNPlane()
                    
                    //　アンカーの大きさをジオメトリに反映させる
                    plane.width = imageAnchor.referenceImage.physicalSize.width
                    plane.height = imageAnchor.referenceImage.physicalSize.height
                    
                    plane.firstMaterial?.diffuse.contents = UIImage(named:"book2.jpg")
                    
                    node.geometry = plane
                }
                
                //　位置の変更
                node.simdTransform = imageAnchor.transform
                
                let angle = node.eulerAngles
                node.eulerAngles = SCNVector3(angle.x - (Float.pi * 0.5), angle.y, angle.z)
                
            }
            
        }
        
    }
    
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
