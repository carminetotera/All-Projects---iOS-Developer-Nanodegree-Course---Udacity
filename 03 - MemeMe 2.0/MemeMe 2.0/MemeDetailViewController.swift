//
//  MemeDetailViewController.swift
//  MemeMe 2.0
//
//  Created by Carmine Totera on 26/06/2021.
//  Copyright © 2021 Carmine Totera. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    
    // MARK: Properties
    
    var detailMeme: Meme!

    @IBOutlet weak var memeDetialImageView: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
        self.memeDetialImageView.image = detailMeme.memedImage
        self.memeDetialImageView.contentMode = .scaleAspectFit
    }

}
