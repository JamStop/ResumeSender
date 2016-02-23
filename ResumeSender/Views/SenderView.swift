//
//  SenderView.swift
//  ResumeSender
//
//  Created by Jimmy Yue on 2/23/16.
//  Copyright © 2016 Jimmy Yue. All rights reserved.
//

import UIKit

class SenderView: UIView {
    
    var view: UIView!

    // MARK: - Outlets
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    // MARK: - Properties
    var keyboardHeight: CGFloat!
    var keyboardIsVisible = false
    
    // MARK: - View Ownership
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        xibSetup()
    }
    
    
    func xibSetup() {
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        addSubview(view)
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "SenderView", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        return view
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        xibSetup()
    }
    
    
    // MARK: - Keyboard Notification Center
    func keyboardSetup() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if !keyboardIsVisible {
            if let userInfo = notification.userInfo {
                if let keyboardSize =  (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
                    keyboardHeight = keyboardSize.height * 0.85
                    self.animateTextField(true)
                    self.keyboardIsVisible = true
                }
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            if let keyboardSize =  (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
                keyboardHeight = keyboardSize.height * 0.85
                self.animateTextField(false)
                self.keyboardIsVisible = false
            }
        }
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - Animations + Transitions
    func showSendButton() {
        sendButton.hidden = false
        UIView.animateWithDuration(0.25, animations: {
            self.sendButton.alpha = 1
        })
    }
    
    func hideSendButton() {
        UIView.animateWithDuration(0.25, animations: {
            self.sendButton.alpha = 0
            }, completion: { Void in
                self.sendButton.hidden = true
        })
    }
    
    func animateTextField(up: Bool) {
        let movement = (up ? -keyboardHeight : keyboardHeight)
        UIView.animateWithDuration(0.3, animations: {
            self.view.frame = CGRectOffset(self.view.frame, 0, movement/2)
        })
    }

}
