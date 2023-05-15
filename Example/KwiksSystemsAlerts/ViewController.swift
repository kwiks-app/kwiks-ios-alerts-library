//
//  ViewController.swift
//  KwiksSystemsAlerts
//
//  Created by 26388491 on 03/27/2023.
//  Copyright (c) 2023 26388491. All rights reserved.
//

import UIKit
import KwiksSystemsAlerts

class ViewController: UIViewController {
    
    var alert = KwiksSystemAlerts()

    lazy var testButton : UIButton = {
        
        let cbf = UIButton(type: .system)
        cbf.translatesAutoresizingMaskIntoConstraints = false
        cbf.setTitle("ALERT POPUP", for: UIControl.State.normal)
        cbf.titleLabel?.adjustsFontSizeToFitWidth = true
        cbf.titleLabel?.numberOfLines = 1
        cbf.titleLabel?.adjustsFontForContentSizeCategory = true
        cbf.titleLabel?.textColor = UIColor .black
        cbf.backgroundColor = .clear
        cbf.tintColor = UIColor .black
        cbf.backgroundColor = .orange
        cbf.addTarget(self, action: #selector(self.runPopup), for: .touchUpInside)
        
        return cbf
        
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .black
        self.view.addSubview(self.testButton)
        
        self.testButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.testButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        self.testButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.testButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    @objc func runPopup() {
        
        self.alert = KwiksSystemAlerts(presentingViewController: self, popupType: .noInternetConnection)
        self.alert.engagePopup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

