//
//  ScrollViewKeyboardController.swift
//  TRPProvider
//
//  Created by Evren Yaşar on 30.01.2022.
//  Copyright © 2022 Tripian Inc. All rights reserved.
//

import UIKit

class ScrollViewKeyboardController {
    
    private let scrollView: UIScrollView
    
    init(scrollView: UIScrollView) {
        self.scrollView = scrollView
        addObservers()
    }
    
    deinit {
        removeObservers()
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height + 20, right: 0)
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
    }
}

extension ScrollViewKeyboardController: ObserverProtocol {
    
    func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func removeObservers() {
        NotificationCenter.default.removeObserver(self)
    }
}

