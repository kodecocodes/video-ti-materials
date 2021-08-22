/// Copyright (c) 2020 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit
import MessageUI
import StoreKit

class AboutViewController: UITableViewController, MFMailComposeViewControllerDelegate {
	@IBOutlet private weak var lblVersion:UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
		// Set text
		if let info = Bundle.main.infoDictionary, let ver = info["CFBundleShortVersionString"] as? String, let bld = info["CFBundleVersion"] as? String {
			self.lblVersion.text = "Version: \(ver) (\(bld))"
		}
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
	// MARK:- Actions
	@IBAction func feedback() {
		// Send e-mail
		let mailComposerVC = MFMailComposeViewController()
		mailComposerVC.mailComposeDelegate = self
		mailComposerVC.setToRecipients(["someone@somewhere.com"])
		mailComposerVC.setSubject("Feedback...")
		mailComposerVC.setMessageBody("This is my feedback:", isHTML: false)
		if MFMailComposeViewController.canSendMail() {
			self.present(mailComposerVC, animated: true, completion: nil)
		} else {
			let alert = UIAlertController(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", preferredStyle: UIAlertController.Style.alert)
			alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
			present(alert, animated: true, completion: nil)
		}
	}
	
	@IBAction func rate() {
		SKStoreReviewController.requestReview()
	}
	
  @IBAction func visitOurSite() {
    if let url = URL(string:"http://raywenderlich.com") {
      UIApplication.shared.open(url)
    }
  }
  
  @IBAction func followOnTwitter() {
    
    if let url = URL(string:"https://twitter.com/rwenderlich") {
      UIApplication.shared.open(url)
    }
  }
  
	// MARK:- MFMailComposeViewControllerDelegate Method
	func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
		controller.dismiss(animated: true, completion: nil)
	}
}
