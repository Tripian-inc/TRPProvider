//
//  TRPBaseUIViewController.swift
//  TRPProvider
//
//  Created by Evren Yaşar on 23.01.2022.
//  Copyright © 2022 Tripian Inc. All rights reserved.
//

import Foundation
import UIKit
import TRPUIKit
//TODO: - TASIMA
//import TRPDataLayer
public class TRPBaseUIViewController: UIViewController {
    
    public enum CloseButtonPosition {
        case left, right
    }
    
    //MARK: UI
    public var loader: TRPLoaderView?
    
    public var applyButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Apply", for: .normal)
        btn.backgroundColor = TRPColor.pink
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(applyButtonPressed), for: UIControl.Event.touchUpInside)
        btn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        btn.layer.cornerRadius = 6
        return btn
    }()
    
  
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setupViews()
        hideKeyboardWhenTappedAround()
    }
    
    public func setupViews() {
        loader = TRPLoaderView(superView: view)
    }
    
    @objc func applyButtonPressed() {}
    
    @objc func closeButtonPressed() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }
    
    func showWarningIfOffline() -> Bool {
        /*if ReachabilityUseCases.shared.isOnline == false {
            let alert = UIAlertController(title: "Ups", message: "This feature needs internet connection", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
            return true
        }*/
        return false
    }
    
}

//MARK: - Custom UI
extension TRPBaseUIViewController {
    
    public func addApplyButton() {
        view.addSubview(applyButton)
        applyButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        applyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        if #available(iOS 11.0, *) {
            applyButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
        }else {
            applyButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16).isActive = true
        }
    }
    
    public func addCloseButton(position: CloseButtonPosition) {
        guard let image = TRPImageController().getImage(inFramework: "btn_back_default", inApp: TRPAppearanceSettings.Common.closeButtonImage) else {
            print("[Error] Close Button image can not found")
            return
        }
        
        let navButton = UIBarButtonItem(image: image.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(closeButtonPressed))
       
        
        switch position {
        case .left:
            navigationItem.leftBarButtonItem = navButton
        case .right:
            navigationItem.rightBarButtonItem = navButton
        }
    }
    
    public func addBackButton(position: CloseButtonPosition) {
        guard let image = TRPImageController().getImage(inFramework: "btn_back_default", inApp: TRPAppearanceSettings.Common.closeButtonImage) else {
            print("[Error] Close Button image can not found")
            return
        }
        
        let navButton = UIBarButtonItem(image: image.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(backButtonPressed))
       
        
        switch position {
        case .left:
            navigationItem.leftBarButtonItem = navButton
        case .right:
            navigationItem.rightBarButtonItem = navButton
        }
    }
    
    public func addNavigationBarCustomView(view: UIView) {
        let barButtonItem = UIBarButtonItem(customView: view)
        self.navigationItem.rightBarButtonItem = barButtonItem
    }
    
}

extension TRPBaseUIViewController: ViewModelDelegate {
    
    @objc public func viewModel(error: Error) {
        EvrAlertView.showAlert(contentText: error.localizedDescription, type: .error, parentViewController: self)
    }
    
    @objc public func viewModel(showPreloader: Bool) {
        if showPreloader {
            loader?.show()
        }else {
            loader?.remove()
        }
    }
    
    public func viewModel(showMessage: String, type: EvrAlertLevel) {
        EvrAlertView.showAlert(contentText: showMessage, type: type)
    }
    
    @objc public func viewModel(dataLoaded: Bool) {}
    
}

extension TRPBaseUIViewController {
    
    @objc func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}
