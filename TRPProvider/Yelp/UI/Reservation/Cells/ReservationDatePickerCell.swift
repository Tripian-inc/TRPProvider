//
//  ReservationDatePicker.swift
//  TRPProvider
//
//  Created by Evren Yaşar on 7.07.2020.
//  Copyright © 2020 Tripian Inc. All rights reserved.
//

import UIKit
class ReservationDatePickerCell: ReservationBaseCell {

    private lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        if let timeZone = TimeZone(identifier: "UTC") {
            picker.timeZone = timeZone
        }
        picker.datePickerMode = UIDatePicker.Mode.date
        picker.backgroundColor = UIColor.white
        picker.addTarget(self, action: #selector(datePickerValeuChanged(sender:)), for: UIControl.Event.valueChanged)
        return picker
    }()

    /*private lazy var timePicker: TRPTimePickerView = {
        let picker = TRPTimePickerView()
        picker.timePickerDelegate = self
        picker.dataSource = picker
        picker.delegate = picker
        picker.setTimeFieldType(with: .start)
        return picker
    }() */

    private var dateToolBar: UIToolbar = {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.sizeToFit()
        return toolBar
    }()

    public var inputText: UITextField = {
        let input = UITextField()
        input.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        input.textColor = UIColor.black //UIColor(red: 73.0/255.0, green: 73.0/255.0, blue: 73.0/255.0, alpha: 1.0);
        input.text = ""
        return input
    }()
    
    
    override func setupCustom(stack: UIStackView) {
        stack.addArrangedSubview(inputText)
        inputText.inputView = datePicker
        inputText.widthAnchor.constraint(equalToConstant: 200).isActive = true
    }
    
    @objc fileprivate func datePickerValeuChanged(sender: UIDatePicker) {
        
    }
}


