
//
//  KwiksSystemsAlerts.swift
//  KwiksSystemsAlerts
//
//  Created by Charlie Arcodia on 3/26/23.
//

import Foundation
import UIKit

public class KwiksSystemAlerts : NSObject {
    
    public enum PopupType{
        case noInternetConnection
        case somethingWentWrong
        case suspended
        case tempLocked
        case kwiksUnavailable
        case waitingResponse
        case loginApproved
        case timeOut
        case networkConnectionTimeout
        case sessionExpired
        case accessDenied
        case serverError
        case authenticationError
        case authenticationDenied
        case updateKwiks
    }
    
    public var rootController: UIViewController?
    public var popupType: PopupType?
    public var popupFinalHeight = 0.0
    public var hasService : Bool = true
    
    var screenHeight : CGFloat = 0.0,
        screenWidth : CGFloat = 0.0
    
    let headerIcon : UIImageView = {
        
        let dcl = UIImageView()
        dcl.translatesAutoresizingMaskIntoConstraints = false
        dcl.backgroundColor = .clear
        dcl.contentMode = .scaleAspectFit
        dcl.isUserInteractionEnabled = false
        dcl.clipsToBounds = true
        
        return dcl
    }()
    
    var headerLabel : UILabel = {
        
        let hfl = UILabel()
        hfl.translatesAutoresizingMaskIntoConstraints = false
        hfl.backgroundColor = .clear
        hfl.textColor = UIColor .black
        hfl.textAlignment = .center
        hfl.adjustsFontSizeToFitWidth = true
        
        return hfl
    }()
    
    var subHeaderLabel : UILabel = {
        
        let hfl = UILabel()
        hfl.translatesAutoresizingMaskIntoConstraints = false
        hfl.backgroundColor = .clear
        hfl.textColor = UIColor .black
        hfl.textAlignment = .center
        hfl.numberOfLines = -1
        
        return hfl
    }()
    
    lazy var confirmationButton : UIButton = {
        
        let cbf = UIButton(type: .custom)
        cbf.translatesAutoresizingMaskIntoConstraints = false
        cbf.titleLabel?.adjustsFontSizeToFitWidth = true
        cbf.titleLabel?.numberOfLines = 1
        cbf.titleLabel?.adjustsFontForContentSizeCategory = true
        cbf.backgroundColor = ColorKit().kwiksGreen
        cbf.layer.cornerRadius = 9
        cbf.alpha = 0.0
        cbf.isEnabled = true
        cbf.isUserInteractionEnabled = true
        cbf.layer.zPosition = 100
        cbf.tintColor = UIColor .white
        let image = UIImage(named: ImageKit().button_gradient_green)?.withRenderingMode(.alwaysOriginal)
        cbf.setBackgroundImage(image, for: .normal)
        cbf.titleLabel?.font = UIFont.init(name: FontKit().segoeBold, size: 30)

        return cbf
        
    }()
    
    public var dynamicPopUpContainer : UIButton = {
        let dpp = UIButton(type: .system)
        dpp.translatesAutoresizingMaskIntoConstraints = true
        dpp.backgroundColor = UIColor .white
        dpp.isUserInteractionEnabled = true
        dpp.layer.cornerRadius = 25
        dpp.layer.masksToBounds = true
        return dpp
    }()
    
    var activityIndicator : UIActivityIndicatorView = {
        
        let ai = UIActivityIndicatorView(style: .medium)
        ai.translatesAutoresizingMaskIntoConstraints = false
        ai.color = UIColor .black
        ai.hidesWhenStopped = true
       return ai
    }()
  
    struct ButtonWidth {
        var small : CGFloat = 182.0
        var large : CGFloat = 250.0
    }
    
    var buttonWidthLayoutConstraint : NSLayoutConstraint?
    
    public init(presentingViewController: UIViewController? = nil, popupType : PopupType? = nil) {
        super.init()
        
        if presentingViewController != nil && popupType != nil {
            self.rootController = presentingViewController
            self.popupType = popupType
            
            self.loadFonts { complete in
                self.copyDecision(popupType: popupType!)
                
                //start monitoring the network
                NetworkMonitor.shared.startMonitoring()
                NotificationCenter.default.addObserver(self, selector: #selector(self.handleServiceSatisified), name: NSNotification.Name(ServiceKit().handleServiceSatisified), object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(self.handleServiceUnsatisified), name: NSNotification.Name(ServiceKit().handleServiceUnsatisified), object: nil)
            }
        }
    }
    
    @objc func handleServiceUnsatisified() {
        self.hasService = false
        
        ///call the no service popup
        if self.rootController != nil {
            if self.hasService == false {
                self.popupType = .noInternetConnection
                self.copyDecision(popupType: popupType!)
                self.engagePopup()
            }
        }
    }
    
    @objc func handleServiceSatisified() {
        self.hasService = true
    }
    
    public func copyDecision(popupType : PopupType) {
        
        switch popupType {
            
        case .noInternetConnection:
            self.headerIcon.image = UIImage.init(fromPodAssetName: ImageKit().no_service_icon)
            self.headerLabel.text = "No Internet connection"
            self.subHeaderLabel.text = "Connect to the internet and try again."
            self.confirmationButton.setTitle("Retry", for: .normal)
            self.buttonWidthLayoutConstraint?.constant = ButtonWidth().small
            
        case .somethingWentWrong:
            self.headerIcon.image = UIImage.init(fromPodAssetName: ImageKit().oops_icon)
            self.headerLabel.text = "Something went wrong."
            self.subHeaderLabel.text = "Please try again later or contact support for assistance"
            self.confirmationButton.setTitle("Retry", for: .normal)
            self.buttonWidthLayoutConstraint?.constant = ButtonWidth().small
            
        case .suspended:
            self.headerIcon.image = UIImage.init(fromPodAssetName: ImageKit().suspended_icon)
            self.headerLabel.text = "SUSPENDED!"
            self.subHeaderLabel.text = "Your account is permanently suspended due to multiple violations of our Community Guidelines"
            self.confirmationButton.setTitle("Contact Support", for: .normal)
            self.buttonWidthLayoutConstraint?.constant = ButtonWidth().large
            
        case .tempLocked:
            self.headerIcon.image = UIImage.init(fromPodAssetName: ImageKit().suspended_icon)
            self.headerLabel.text = "Temporarily Locked"
            self.subHeaderLabel.text = "Your account is temporarily suspended due to multiple violations of our Community Guidelines"
            self.confirmationButton.setTitle("Contact Support", for: .normal)
            self.buttonWidthLayoutConstraint?.constant = ButtonWidth().large
            
        case .kwiksUnavailable:
            self.headerIcon.image = UIImage.init(fromPodAssetName: ImageKit().kwiks_logo_grey)
            self.headerLabel.text = "Kwiks is currently unavailable"
            self.subHeaderLabel.text = "Kwiks is under maintenance. Please try again later"
            self.confirmationButton.setTitle("Try Again ", for: .normal)
            self.buttonWidthLayoutConstraint?.constant = ButtonWidth().small
            
        case .waitingResponse: //TODO: fixme
            self.headerIcon.image = UIImage.init(fromPodAssetName: ImageKit().phone_with_check)
            self.headerLabel.text = "We’re waiting for your response"
            self.subHeaderLabel.text = "Approve this login by open the Kwiks App and tapping “Yes, It’s me”"
            self.confirmationButton.setTitle("FIX ME", for: .normal)
            self.buttonWidthLayoutConstraint?.constant = ButtonWidth().small
            
        case .loginApproved: //TODO: fixme
            self.headerIcon.image = UIImage.init(fromPodAssetName: ImageKit().phone_with_green_check)
            self.headerLabel.text = "Login Approved"
            self.subHeaderLabel.text = "Your login has been approved."
            self.confirmationButton.setTitle("Continue", for: .normal)
            self.buttonWidthLayoutConstraint?.constant = ButtonWidth().large
            
        case .timeOut: //TODO: fixme
            self.headerIcon.image = UIImage.init(fromPodAssetName: ImageKit().phone_with_x_icon)
            self.headerLabel.text = "Time Out!"
            self.subHeaderLabel.text = "Authentication Timeout. Please try again"
            self.confirmationButton.setTitle("Retry", for: .normal)
            self.buttonWidthLayoutConstraint?.constant = ButtonWidth().small
            
        case .networkConnectionTimeout: //TODO: fixme
            self.headerIcon.image = UIImage.init(fromPodAssetName: ImageKit().no_service_icon)
            self.headerLabel.text = "Network connection Timeout."
            self.subHeaderLabel.text = "Connect to the internet and try again."
            self.confirmationButton.setTitle("Retry", for: .normal)
            self.buttonWidthLayoutConstraint?.constant = ButtonWidth().small
            
        case .sessionExpired: //TODO: fixme
            self.headerIcon.image = UIImage.init(fromPodAssetName: ImageKit().kwiks_logo_grey)
            self.headerLabel.text = "Session Expired!"
            self.subHeaderLabel.text = "Please login again to continue using Kwiks."
            self.confirmationButton.setTitle("Login", for: .normal)
            self.buttonWidthLayoutConstraint?.constant = ButtonWidth().small
            
        case .accessDenied: //TODO: fixme
            self.headerIcon.image = UIImage.init(fromPodAssetName: ImageKit().octagon_red_light_icon)
            self.headerLabel.text = "Access Denied"
            self.subHeaderLabel.text = "Your IP has been blocked or you do not have permission to access this."
            self.confirmationButton.setTitle("Login", for: .normal)
            self.buttonWidthLayoutConstraint?.constant = ButtonWidth().small
            
        case .serverError: //TODO: fixme
            self.headerIcon.image = UIImage.init(fromPodAssetName: ImageKit().octagon_red_light_icon)
            self.headerLabel.text = "Server Error!"
            self.subHeaderLabel.text = "The System is busy. Please try again later."
            self.confirmationButton.setTitle("Login", for: .normal)
            self.buttonWidthLayoutConstraint?.constant = ButtonWidth().small
            
        case .authenticationError: //TODO: fixme
            self.headerIcon.image = UIImage.init(fromPodAssetName: ImageKit().auth_error_icon)
            self.headerLabel.text = "Authentication Error!"
            self.subHeaderLabel.text = "Authentication time out. Please try again."
            self.confirmationButton.setTitle("Login", for: .normal)
            self.buttonWidthLayoutConstraint?.constant = ButtonWidth().small
            
        case .updateKwiks: //TODO: fixme
            self.headerIcon.image = UIImage.init(fromPodAssetName: ImageKit().kwiks_logo_green)
            self.headerLabel.text = "Update Kwiks"
            self.subHeaderLabel.text = "Kwiks app version is too low. To continue, update to the latest version of the app."
            self.confirmationButton.setTitle("Update Now", for: .normal)
            self.buttonWidthLayoutConstraint?.constant = ButtonWidth().large
            
        case .authenticationDenied: //TODO: fixme
            self.headerIcon.image = UIImage.init(fromPodAssetName: ImageKit().octagon_red_light_icon)
            self.headerLabel.text = "Authentication Denied"
            self.subHeaderLabel.text = "You do not have permission to access this."
            self.confirmationButton.setTitle("Contact Support", for: .normal)
            self.buttonWidthLayoutConstraint?.constant = ButtonWidth().large
        }
    }
    
    public func engagePopup() {
        
        self.headerLabel.font = UIFont(name: FontKit().segoeBold, size: 20)
        self.subHeaderLabel.font = UIFont(name: FontKit().segoeRegular, size: 16)
        self.confirmationButton.titleLabel?.font = UIFont(name: FontKit().segoeBold, size: 18)
        
        let height = self.rootController?.view.frame.height,
            width = self.rootController?.view.frame.width
        
        //nil check prior
        if height != nil && width != nil {
            self.screenWidth = width!
            self.screenHeight = height!
            self.presentPopup()
            
        } else {
            print("🔴 COCOAPOD ERROR: NIL - LET KWIKS DEV LIBRARY MAGICIAN KNOW - SERIAL (64575)")
        }
    }
    
    public func presentPopup() {
        
        //always suceeds
        if let root = self.rootController {
            
            //no children, nils the selector
            root.view.addSubview(self.dynamicPopUpContainer)
            dynamicPopUpContainer.addSubview(self.headerIcon)
            dynamicPopUpContainer.addSubview(self.headerLabel)
            dynamicPopUpContainer.addSubview(self.subHeaderLabel)
            root.view.addSubview(self.activityIndicator)
            root.view.addSubview(self.confirmationButton)
            
            self.subHeaderLabel.centerYAnchor.constraint(equalTo: self.dynamicPopUpContainer.centerYAnchor, constant: -20).isActive = true
            self.subHeaderLabel.leftAnchor.constraint(equalTo: self.dynamicPopUpContainer.leftAnchor, constant: 50).isActive = true
            self.subHeaderLabel.rightAnchor.constraint(equalTo: self.dynamicPopUpContainer.rightAnchor, constant: -50).isActive = true
            self.subHeaderLabel.sizeToFit()
            
            self.headerLabel.bottomAnchor.constraint(equalTo: self.subHeaderLabel.topAnchor, constant: -16).isActive = true
            self.headerLabel.leftAnchor.constraint(equalTo: self.dynamicPopUpContainer.leftAnchor, constant: 24).isActive = true
            self.headerLabel.rightAnchor.constraint(equalTo: self.dynamicPopUpContainer.rightAnchor, constant: -24).isActive = true
            self.headerLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
            
            self.headerIcon.bottomAnchor.constraint(equalTo: self.headerLabel.topAnchor, constant: -18).isActive = true
            self.headerIcon.centerXAnchor.constraint(equalTo: self.dynamicPopUpContainer.centerXAnchor, constant: 0).isActive = true
            self.headerIcon.heightAnchor.constraint(equalToConstant: 90).isActive = true
            self.headerIcon.widthAnchor.constraint(equalToConstant: 90).isActive = true
            
            self.confirmationButton.topAnchor.constraint(equalTo: self.subHeaderLabel.bottomAnchor, constant: 59).isActive = true
            self.confirmationButton.centerXAnchor.constraint(equalTo: self.dynamicPopUpContainer.centerXAnchor).isActive = true
            self.buttonWidthLayoutConstraint = self.confirmationButton.widthAnchor.constraint(equalToConstant: 185)
            self.buttonWidthLayoutConstraint?.isActive = true
            self.confirmationButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
            self.confirmationButton.layer.cornerRadius = 25
            
            self.activityIndicator.centerXAnchor.constraint(equalTo: self.confirmationButton.centerXAnchor).isActive = true
            self.activityIndicator.centerYAnchor.constraint(equalTo: self.confirmationButton.centerYAnchor).isActive = true
            
            self.runLogic(root: root)
        }
    }
    
    public func runLogic(root : UIViewController) {
        
        let baselineHeight = 325.0
        
        let textToSize = self.subHeaderLabel.text ?? "",
            size = CGSize(width: self.screenWidth - 80.0 - 48, height: 2000),
            options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        let estimatedFrame = NSString(string: textToSize).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font : UIFont(name: FontKit().segoeRegular, size: 16)!], context: nil)
        let estimatedHeight = estimatedFrame.height
        
        self.popupFinalHeight = baselineHeight + estimatedHeight
        
        self.dynamicPopUpContainer.frame = CGRect(x: 0, y: self.screenHeight, width: self.screenWidth, height: self.screenHeight)
        self.dynamicPopUpContainer.center.x = root.view.center.x
        
        UIView.animate(withDuration: 0.45, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0.75, options: .curveEaseInOut) {
            self.dynamicPopUpContainer.frame = CGRect(x: 0, y: 0, width: self.screenWidth, height: self.screenHeight)
            self.dynamicPopUpContainer.center.x = root.view.center.x
        } completion: { complete in
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn) {
                self.confirmationButton.alpha = 1.0
            } completion: { complete in
                self.confirmationButton.addTarget(self, action: #selector(self.handleAction(sender:)), for: .touchUpInside)
            }
        }
    }
    
    @objc public func handleAction(sender:UIButton) {
        
        UIDevice.vibrateLight()
        
        switch popupType {
            
        case .noInternetConnection://check for service here
            if self.hasService == true {
                self.dismiss()
            } else {
                
                self.confirmationButton.alpha = 0.0
                self.activityIndicator.startAnimating()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                    
                    self.activityIndicator.stopAnimating()
                    
                    if self.hasService == false {
                        self.confirmationButton.setTitle("Try again", for: .normal)
                        self.confirmationButton.alpha = 1.0
                    } else {
                        self.dismiss()
                    }
                }
            }
        case .somethingWentWrong://product page
            self.dismiss()
            
        case .suspended://product page
            if self.confirmationButton.titleLabel?.text == "Error" {
                self.dismiss()
            } else {
                self.contactSupportEmail()
            }
            
        case .tempLocked://product page
            if self.confirmationButton.titleLabel?.text == "Error" {
                self.dismiss()
            } else {
                self.contactSupportEmail()
            }
        case .kwiksUnavailable://product page
            self.dismiss()
            
        case .waitingResponse://NEED A UI CHANGE HERE WITH PREP
            self.dismiss()
            
        case .loginApproved:
            self.dismiss()
            
        case .timeOut://product page
            self.dismiss()
            
        case .networkConnectionTimeout://product page
            self.dismiss()
            
        case .sessionExpired://product page
            self.dismiss()
            
        case .accessDenied://product page
            self.dismiss()
            
        case .serverError://product page
            self.dismiss()
            
        case .authenticationError://product page
            self.dismiss()
            
        case .updateKwiks://product page
            self.dynamicPopUpContainer.openUrl(passedUrlString: GlobalsKit().productPageURL)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.dismiss()
            }
            
        case .authenticationDenied://product page
            if self.confirmationButton.titleLabel?.text == "Error" {
                self.dismiss()
            } else {
                self.contactSupportEmail()
            }
        default: debugPrint("not possible")
        }
    }
    
    @objc public func dismiss() {
        
        if let root = self.rootController {
            
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut) {
                self.confirmationButton.alpha = 0.0
                self.dynamicPopUpContainer.frame = CGRect(x: 0, y: self.screenHeight, width: self.screenWidth, height: self.screenHeight)
                self.dynamicPopUpContainer.center.x = root.view.center.x
            }
        }
    }
    
    public func loadFonts(completion : @escaping(_ complete : Bool) -> () ) {
        if let _ = UIFont(name: FontKit().segoeRegular, size: 16) {
            completion(true)
        } else {
            registerFont(with: "SegoeBoldItalic.ttf")
            registerFont(with: "SegoeBold.ttf")
            registerFont(with: "SegoeItalic.ttf")
            registerFont(with: "SegoeRegular.ttf")
            completion(true)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

import MessageUI

extension KwiksSystemAlerts : MFMailComposeViewControllerDelegate {
    
    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
   @objc public func contactSupportEmail() {
        
        if MFMailComposeViewController.canSendMail() {
            
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setSubject("Support - Kwiks Customer Service")
            mail.setMessageBody("<p> To: Team Kwiks,</p>", isHTML: true)
            mail.setToRecipients([GlobalsKit().supportEmail])
            
            if self.rootController != nil {
                self.rootController!.present(mail, animated: true, completion: nil)
            }
            
        } else {
            self.confirmationButton.setTitle("Error", for: .normal)
        }
    }
}
