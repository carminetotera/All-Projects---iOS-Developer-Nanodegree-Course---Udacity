//
//  AlbumViewController.swift
//  Virtual_Tourist
//
//  Created by Carmine Totera on 13/08/21.
//

import UIKit
import MapKit

class AlbumViewController: UIViewController {
    
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var bottomButton: UIButton!
    
    var loadPage = 1
    var selectedPin: Pin!
    var photos: [Photo] = []
    var selectedPhotoIndexPathToDelete: IndexPath? = nil {
        didSet {
            if selectedPhotoIndexPathToDelete != nil {
                bottomButton.setTitle("Delete", for: .normal)
            } else {
                bottomButton.setTitle("New Collection", for: .normal)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenWidth = UIScreen.main.bounds.width
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: screenWidth/3, height: screenWidth/3)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionView.collectionViewLayout = layout

        map.addAnnotationMap(coordinate: CLLocationCoordinate2D(latitude: selectedPin.lat, longitude: selectedPin.lon))
        
        refreshloadPhotos()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    

    
    func getPhotosFlicker() {
        let coord = CLLocationCoordinate2D(latitude: selectedPin.lat, longitude: selectedPin.lon)
        FlickerClient().getPhotos(coord: coord, page: loadPage) { (images, pages, error) in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            self.loadPage = self.getRandom(totalPages: pages!)
            CoreDataController.shared.addPhotos(images: images!, pin: self.selectedPin) { photos in
                self.photos = photos
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    func getRandom(totalPages: Int) -> Int {
        return Int.random(in: 1...totalPages)
    }
    
    func refreshloadPhotos() {
        photos = CoreDataController.shared.loadPhotos(pin: selectedPin)
        if photos.count == 0 {
            getPhotosFlicker()
        } else {
            collectionView.reloadData()
        }
    }
    
    @IBAction func bottomButtonAction(_ sender: Any) {
        if selectedPhotoIndexPathToDelete != nil {
           CoreDataController.shared.deletePhoto(photo: photos[selectedPhotoIndexPathToDelete!.row]) {
                self.selectedPhotoIndexPathToDelete = nil
                self.refreshloadPhotos()
            }
        } else {
            CoreDataController.shared.deletePhotos(pin: selectedPin) {
                self.photos.removeAll()
                self.collectionView.reloadData()
                self.getPhotosFlicker()
            }
        }
    }
}

