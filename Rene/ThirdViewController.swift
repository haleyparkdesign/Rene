import UIKit
import SceneKit
import ARKit

private let planeWidth: CGFloat = 0.28
private let planeHeight: CGFloat = 0.28
private let nodeYPosition: Float = 0.038 // 0 == bottom

class ThirdViewController: UIViewController, ARSCNViewDelegate {
    var window: UIWindow?
    var contentNode: SCNNode?
    
    private let applePlane = SCNPlane(width: planeWidth, height: planeHeight)
    private let appleNode = SCNNode()
    private var scale: CGFloat = 1
    
    
    @IBOutlet var sceneView: ARSCNView!
    
    @IBOutlet weak var unsupportedMsg: UIView!
    
    
    @IBOutlet weak var imageView: UIButton!
    
    @IBAction func openGallery(_ sender: Any) {
         UIApplication.shared.open(URL(string:"photos-redirect://")!)
    }
    
    @IBOutlet weak var takePhotoBtn: UIButton!
    
    @IBAction func takePhoto(_ sender: Any) {
        let screenshot = sceneView.snapshot()
        UIImageWriteToSavedPhotosAlbum(screenshot, self, #selector(savedImage), nil)
        
        // vibration feedback
        AudioServicesPlaySystemSound(1519)
        
        // display picture taken
        imageView.setImage(screenshot, for: UIControl.State.normal)
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
        
        // Set page title
        self.title = "The Son of Man"
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = false
        sceneView.delegate = self
        
        unsupportedMsg.isHidden = true
        
        // set background image fill mode
        imageView.imageView?.contentMode = .scaleAspectFill
         
        guard ARFaceTrackingConfiguration.isSupported else {
            // show unsupported device message
            unsupportedMsg.isHidden = false
            takePhotoBtn.isHidden = true
            return
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Show the Navigation Bar
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        
        // Create a session configuration
        let configuration = ARFaceTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    private func updateApple(with index: Int) {
        let imageName = "apple"
        applePlane.firstMaterial?.diffuse.contents = UIImage(named: imageName)
        
    }

    private func updateSize() {
        applePlane.width = scale * planeWidth
        applePlane.height = scale * planeHeight
    }
}

extension ThirdViewController {
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        guard let device = sceneView.device else {
            return nil
        }
        
        let faceGeometry = ARSCNFaceGeometry(device: device)
        let faceNode = SCNNode(geometry: faceGeometry)
        faceNode.geometry?.firstMaterial?.transparency = 0
        
        applePlane.firstMaterial?.isDoubleSided = true
        updateApple(with: 0)
        
        appleNode.position.z = faceNode.boundingBox.max.z * 3 / 4
        appleNode.position.y = nodeYPosition
        appleNode.geometry = applePlane

        faceNode.addChildNode(appleNode)
        
        return faceNode
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let faceAnchor = anchor as? ARFaceAnchor, let faceGeometry = node.geometry as? ARSCNFaceGeometry else {
            return
        }
        
        faceGeometry.update(from: faceAnchor.geometry)
    }
}
