//
//  ViewController.swift
//  ResumeSender
//
//  Created by Jimmy Yue on 2/23/16.
//  Copyright © 2016 Jimmy Yue. All rights reserved.
//

import UIKit
import MessageUI
import RxSwift
import RxCocoa

class SenderViewController: UIViewController {
    
    // Mark: - Properties
    @IBOutlet weak var mainView: SenderView!
    let viewModel = SenderViewModel()
    
    let emailSendAlert = UIAlertController(title: "", message: "", preferredStyle: .Alert)
    let disposeBag = DisposeBag()

    // Mark: - Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        configureSearchBar()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewWillAppear(animated: Bool) {
        mainView.hideSendButton()
    }
    
    
    // Mark: - Helper Functions
    private func setup() {
        let dismiss: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard:")
        self.mainView.addGestureRecognizer(dismiss)
        
        mainView.sendButton.addTarget(self, action: "sendButtonPressed:", forControlEvents: .TouchUpInside)
        emailSendAlert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
        
        configureSearchBar()
        
        keyboardSetup()
    }
    
    private func configureSearchBar() {
        
        mainView.emailField.rx_text
            .asDriver()
            .throttle(0.3)
            .distinctUntilChanged()
            .driveNext { query in
                if self.isValidEmail(query) {
                    self.mainView.showSendButton()
                }
                else {
                    self.mainView.hideSendButton()
                }
            }
            .addDisposableTo(disposeBag)
        
        
    }
    
    private func isValidEmail(testStr: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(testStr)
    }
    
    private func presentEmailAlert(message: String) {
        emailSendAlert.title = message
        self.presentViewController(emailSendAlert, animated: true, completion: nil)
    }
    
    private func showEmail(recipient: String) {
        let emailTitle = "Regards from Jimmy Yue!"
        let messageBody = "What's up Squarespace, here's my resume!"
        let toRecipients = NSArray(object: recipient)
        
        let mc = MFMailComposeViewController()
        mc.mailComposeDelegate = self
        
        mc.setSubject(emailTitle)
        mc.setMessageBody(messageBody, isHTML: false)
        mc.setToRecipients(toRecipients as? [String])
        
        let resumeData = UIImagePNGRepresentation(UIImage(named: "Resume")!)
        
        mc.addAttachmentData(resumeData!, mimeType: "image/png", fileName: "JimmyYueResume.png")
        
        self.presentViewController(mc, animated: true, completion: {
            Void in
            self.mainView.emailField.text = ""
        })
        
    }
    
    // Mark: - Actions
    func sendButtonPressed(sender: UIButton) {
        self.dismissKeyboard()
        showEmail(mainView.emailField.text!)
    }
    
    // MARK: - Keyboard Notification Center
    func keyboardSetup() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if !mainView.keyboardIsVisible {
            if let userInfo = notification.userInfo {
                if let keyboardSize =  (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
                    mainView.animateShow(keyboardSize)
                }
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            if let keyboardSize =  (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
                mainView.animateHide(keyboardSize)
            }
        }
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func dismissKeyboard(sender: AnyObject) {
        view.endEditing(true)
    }


}

extension SenderViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        self.dismissViewControllerAnimated(true, completion: nil)
        switch(result) {
        case MFMailComposeResultCancelled:
            presentEmailAlert("Email Cancelled")
            break
        case MFMailComposeResultSaved:
            presentEmailAlert("Email Saved")
            break
        case MFMailComposeResultSent:
            presentEmailAlert("Email Sent")
            break
        case MFMailComposeResultFailed:
            presentEmailAlert("Email Failed")
            break
        default:
            break
            
        }
    }
}

