//
//  UdacityConvenience.swift
//  On the Map
//
//  Created by Carmine Totera on 2021/8/11.
//  Copyright © 2021 Carmine Totera. All rights reserved.
//

import UIKit

// MARK: - UdacityClient (Convenient Resource Methods)

extension UdacityClient {
    
    func displayAlert(_ controller: UIViewController, title: String, message: String) {
        let uiAlertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default) { action in
            uiAlertController.dismiss(animated: true, completion: nil)
        }
        uiAlertController.addAction(dismissAction)
        controller.present(uiAlertController, animated: true, completion: nil)
    }
    
    func displayAlertForOverwrite(_ controller: UIViewController, title: String, message: String) {
        let uiAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let overwriteAction = UIAlertAction(title: "Overwrite", style: UIAlertActionStyle.default) {
            action in self.presentAddLocation(controller)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default) {
            action in uiAlertController.dismiss(animated: true, completion: nil)
        }
        
        uiAlertController.addAction(overwriteAction)
        uiAlertController.addAction(cancelAction)
        
        controller.present(uiAlertController, animated: true, completion: nil)
    }
    
    func checkURL(_ url: String) -> Bool {
        if let url = URL(string: url) {
            return UIApplication.shared.canOpenURL(url)
        }
        return false
    }
    
    func presentAddLocation(_ controller: UIViewController) {
        controller.performSegue(withIdentifier: "AddLocationSegue", sender: controller)
    }
    
    func addLocation(_ controller: UIViewController) {
        if UdacityClient.sharedInstance.showOverwrite {
            UdacityClient.sharedInstance.displayAlertForOverwrite(controller, title: "", message: ErrorMessage.OverwriteMessage)
        } else {
            UdacityClient.sharedInstance.presentAddLocation(controller)
        }
    }
}

struct ErrorMessage {
    static let EmptyEmailOrPassword = "Empty Email or Password."
    static let InvalidEmailOrPassword = "Invalid Email or Password."
    static let NoNetwork = "The Internet connection appears to be offine."
    static let InvalidLinkTitle = "Invalid Link"
    static let InvalidLink = "Include HTTP(S)://"
    static let OverwriteMessage = "You Have Already Posted a Student Location. Would You Like to Overwrite Your Location?"
    static let LocationNotFound = "Location Not Found"
    static let EnterLocation = "Must Enter a Location."
    static let EnterWebsite = "Must Enter a Website."
    static let InvalidGeocode = "Could Not Geocode the String"
    static let UpdateLocationError = "Failed to Update Location."
    static let UnableToLogout = "Unable to Logout"
    static let CheckNetworkOrContactKuei = "Please Check your network connection or contact Kuei"
}
