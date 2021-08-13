//
//  TabBarViewController.swift
//  On the Map
//
//  Created by Carmine Totera on 2021/8/11.
//  Copyright © 2021 Carmine Totera. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    var mapViewController:StudentLocationMapViewController? = nil
    var tableViewController:StudentLocationTableViewController? = nil
    
    override func viewDidLoad() {
        mapViewController = (viewControllers![0] as! UINavigationController).topViewController as? StudentLocationMapViewController
        tableViewController = (viewControllers![1] as! UINavigationController).topViewController as? StudentLocationTableViewController
    }
    
    // MARK: Actions
    
    @IBAction func refresh(_ sender: Any) {
        if (selectedIndex == 0) {
            mapViewController?.loadMapView()
        } else {
            tableViewController?.loadTableView()
        }
    }
    
    @IBAction func addLocation(_ sender: Any) {
        UdacityClient.sharedInstance.addLocation(self)
    }
    
    @IBAction func logout(_ sender: Any) {
        print("logout")
        
        DispatchQueue.main.async {
            self.startIndicatorAnimation()
        }
        
        UdacityClient.sharedInstance.logout(completion: {
            
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: {
                    self.stopIndicatorAnimation()

                })
            }
            
            
        }, failure: {
            DispatchQueue.main.async {
                self.stopIndicatorAnimation()
                UdacityClient.sharedInstance.displayAlert(self, title: ErrorMessage.UnableToLogout, message: ErrorMessage.CheckNetworkOrContactKuei)

            }
        })
    }
    
    func startIndicatorAnimation() {
        if (selectedIndex == 0) {
            self.mapViewController?.activityIndicator.startAnimating()
        } else {
            self.tableViewController?.activityIndicator.startAnimating()
        }
    }
    
    func stopIndicatorAnimation() {
        if (selectedIndex == 0) {
            self.mapViewController?.activityIndicator.stopAnimating()
        } else {
            self.tableViewController?.activityIndicator.stopAnimating()
        }
    }
}
