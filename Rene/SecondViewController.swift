//
//  SecondViewController.swift
//  Rene
//
//  Created by Haley Park on 11/7/19.
//  Copyright © 2019 Haley Park. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import AudioToolbox // for haptic feedback

class SecondViewController: UIViewController, ARSCNViewDelegate {
    @IBOutlet var sceneView: ARSCNView!
    
    @IBOutlet weak var imageView: UIButton!
    
    // redirects to photos app when tapped
    @IBAction func openGallery(_ sender: Any) {
        UIApplication.shared.open(URL(string:"photos-redirect://")!)
    }
    
    @IBAction func takePhoto(_ sender: Any) {
        let screenshot = sceneView.snapshot()
        
        // display picture taken
       imageView.setImage(screenshot, for: UIControl.State.normal)
        
        UIImageWriteToSavedPhotosAlbum(screenshot, self, #selector(savedImage), nil)
        
        // vibration feedback
        AudioServicesPlaySystemSound(1519)
    }
    
    @objc func savedImage(_ im:UIImage, error:Error?, context:UnsafeMutableRawPointer?) {
        if let err = error {
            print(err)
            return
        }
        print("successfully saved image")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Golconda"
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = false
    
        sceneView.autoenablesDefaultLighting = false
        sceneView.automaticallyUpdatesLighting = true
        
        // Create a new scene
        let scene = SCNScene(named: "Models.scnassets/men.scn")!
        
        // Set the scene to the view
        sceneView.scene = scene
        
        // set background image fill mode
        imageView.imageView?.contentMode = .scaleAspectFill
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Show the Navigation Bar
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
}
