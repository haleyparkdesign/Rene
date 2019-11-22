import UIKit
import SceneKit
import ARKit

private let planeWidth: CGFloat = 0.28
private let planeHeight: CGFloat = 0.28
private let nodeYPosition: Float = 0.03 // 0 == bottom

class FourthViewController: UIViewController, ARSCNViewDelegate {
    var window: UIWindow?
    var contentNode: SCNNode?
    
    private let birdPlane = SCNPlane(width: planeWidth, height: planeHeight)
    private let birdNode = SCNNode()
    private var scale: CGFloat = 1
    
    @IBOutlet weak var unsupportedLabel: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func takePhoto(_ sender: Any) {
        let screenshot = sceneView.snapshot()
        UIImageWriteToSavedPhotosAlbum(screenshot, self, #selector(savedImage), nil)
        
        // vibration feedback
        AudioServicesPlaySystemSound(1519)
        
        // display picture taken
        imageView.image = screenshot
    }
    
    @objc func savedImage(_ im:UIImage, error:Error?, context:UnsafeMutableRawPointer?) {
        if let err = error {
            print(err)
            return
        }
        print("successfully saved image")
    }
    
    
    @IBOutlet var sceneView: ARSCNView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set page title
        self.title = "Man in a Bowler Hat"
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = false
        sceneView.delegate = self
        unsupportedLabel.isHidden = true
         
        guard ARFaceTrackingConfiguration.isSupported else {
            // show unsupported device message
            unsupportedLabel.isHidden = false
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
    
    private func updateBird(with index: Int) {
        let imageName = "bird"
        birdPlane.firstMaterial?.diffuse.contents = UIImage(named: imageName)
        
    }

    private func updateSize() {
        birdPlane.width = scale * planeWidth
        birdPlane.height = scale * planeHeight
    }
}

extension FourthViewController {
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        guard let device = sceneView.device else {
            return nil
        }
        
        let faceGeometry = ARSCNFaceGeometry(device: device)
        let faceNode = SCNNode(geometry: faceGeometry)
        faceNode.geometry?.firstMaterial?.transparency = 0
        
        birdPlane.firstMaterial?.isDoubleSided = true
        updateBird(with: 0)
        
        birdNode.position.z = faceNode.boundingBox.max.z * 3 / 4
        birdNode.position.y = nodeYPosition
        birdNode.geometry = birdPlane

        faceNode.addChildNode(birdNode)
        
        return faceNode
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let faceAnchor = anchor as? ARFaceAnchor, let faceGeometry = node.geometry as? ARSCNFaceGeometry else {
            return
        }
        
        faceGeometry.update(from: faceAnchor.geometry)
    }
}
