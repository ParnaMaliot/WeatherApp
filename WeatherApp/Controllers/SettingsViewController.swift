
import UIKit
import Kingfisher

class SettingsViewController: UIViewController {
    
    var city: City?
    
    @IBOutlet weak var holderView: UIView!
    @IBOutlet weak var imageViewTwo: UIImageView!
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //
        //
        imageViewTwo.kf.setImage(with: URL(string: "https://wow.zamimg.com/images/hearthstone/cards/enus/animated/EX1_323h_premium.gif"))
        
        imageView.kf.setImage(with: URL(string: "https://wow.zamimg.com/images/hearthstone/backs/animated/Card_Back_Default.gif"))
        imageViewTwo.isHidden = true


    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now()+5) { 
            let transitionOptions: UIView.AnimationOptions = [.transitionFlipFromRight, .showHideTransitionViews]
            
    //
            UIView.transition(with: self.holderView, duration: 1.0, options: transitionOptions, animations: {
                  self.imageView.isHidden = true
              })
    //
            UIView.transition(with: self.holderView, duration: 1.0, options: transitionOptions, animations: {
                  self.imageViewTwo.isHidden = false
              }) 
        }

    }

    @IBAction func onclick(_ sender: Any) {
        
    }
}
