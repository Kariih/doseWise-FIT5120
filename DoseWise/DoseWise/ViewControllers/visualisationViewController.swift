import Foundation
import UIKit
import WebKit

import SafariServices

class visualisationViewController: UIViewController, SFSafariViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    //this is the more button which going to rediect the view to built-in Safari, and then redirect to visualisation website.
    @IBAction func moreBtn(_ sender: Any) {
        let visitSafari = SFSafariViewController(url: URL(string: "http://13.211.168.172/")!)
        present(visitSafari, animated: true, completion: nil)
        visitSafari.delegate = self
    }
}

