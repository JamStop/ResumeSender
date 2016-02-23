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
    
    // MARK: - Properties
    var keyboardHeight: CGFloat!
    var keyboardIsVisible = false

    // MARK: - Outlets
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
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
    
    func animateShow(keyboardSize: CGRect) {
        keyboardHeight = keyboardSize.height * 0.85
        animateTextField(true)
        keyboardIsVisible = true
    }
    
    func animateHide(keyboardSize: CGRect) {
        keyboardHeight = keyboardSize.height * 0.85
        animateTextField(false)
        keyboardIsVisible = false
    }
    
    private func animateTextField(up: Bool) {
        let movement = (up ? -keyboardHeight : keyboardHeight)
        UIView.animateWithDuration(0.3, animations: {
            self.view.frame = CGRectOffset(self.view.frame, 0, movement/2)
        })
    }

}
