//
//  KwiksHelpers.swift
//  KwiksSystemsAlerts
//
//  Created by Charlie Arcodia on 3/27/23.
//

import Foundation

struct GlobalsKit {
    
    static let shared = GlobalsKit()

    let supportEmail = "charlie@kwiks.com"
    let productPageURL = "https://www.google.com"
    let podBundleID = "org.cocoapods.KwiksSystemsAlerts"
    
}

//service handler
struct ServiceKit {
    
    static let shared = ServiceKit()
    
    let handleServiceSatisified = "handleServiceSatisified",
        handleServiceUnsatisified = "handleServiceUnsatisified",
        networkMonitor = "NetworkMonitor"

}

//bundled fonts
struct FontKit {
    
    static let shared = FontKit()
    
    let segoeRegular = "SegoeUI",
        segoeRegularItalic = "SegoeUI-Italic",
        segoeBold = "SegoeUI-Bold",
        segoeBoldItalic = "SegoeUI-BoldItalic"
    
}

//imagekit for icon reference
struct ImageKit {
    
    static let shared = ImageKit()
    
    let button_gradient_green = "button_gradient"
    let auth_error_icon = "auth_error_icon"
    let kwiks_logo_green = "kwiks_logo_green"
    let kwiks_logo_grey = "kwiks_logo_grey"
    let no_service_icon = "no_service_icon"
    let octagon_red_light_icon = "octagon_red_light_icon"
    let oops_icon = "oops_icon"
    let phone_with_check = "phone_with_check"
    let phone_with_green_check = "phone_with_green_check"
    let phone_with_x_icon = "phone_with_x_icon"
    let suspended_icon = "suspended_icon"
    
}

extension UIDevice {
    static func vibrateLight() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
    static func vibrateMedium() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
    static func vibrateHeavy() {
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
    }
}


//color extension
extension UIColor {
    convenience init(hex: Int, alpha: CGFloat = 1.0) {
        let red = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((hex & 0xFF00) >> 8) / 255.0
        let blue = CGFloat((hex & 0xFF)) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
}

//colorkit for color reference
struct ColorKit {
    static let shared = ColorKit()
    
    let kwiksGreen = UIColor(hex: 0x9AE769)
    let kwiksSmokeColor = UIColor(hex: 0x212121)
}

//OPENS URLS AS STRINGS
extension UIView {
    
    func openUrl(passedUrlString : String) {
        guard let developerWebsiteUrl = URL(string: passedUrlString) else { return }
        
        if UIApplication.shared.canOpenURL(developerWebsiteUrl) {
            return UIApplication.shared.open(developerWebsiteUrl, options: [:],     completionHandler: nil)
        }
    }
}

class RandomClass: Any { }
extension UIImage {
    convenience init?(fromPodAssetName name: String) {
        let bundle = Bundle(for: KwiksSystemAlerts.self)
        self.init(named: name, in: bundle, compatibleWith: nil)
    }
}

private final class BundleToken {}
func registerFont(with fontName: String) {
    guard let url = Bundle(identifier: GlobalsKit().podBundleID)!
          .url(forResource: fontName, withExtension: nil),
          CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil) else {
        return
    }
}
