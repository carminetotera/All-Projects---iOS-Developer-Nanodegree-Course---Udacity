//
//  LocationMapViewExtensions.swift
//  Virtual_Tourist
//
//  Created by Carmine Totera on 13/08/21.
//

import Foundation
import UIKit
import MapKit
import CoreData

extension LocationsMapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let coordinate = view.annotation?.coordinate
        for pin in pins {
            if pin.lat == coordinate?.latitude && pin.lon == coordinate?.longitude {
                let controller = self.storyboard?.instantiateViewController(withIdentifier: "AlbumViewController") as! AlbumViewController
                controller.selectedPin = pin
                navigationController?.pushViewController(controller, animated: true)
                break
            }
        }
        mapView.deselectAnnotation(view.annotation, animated: false)
    }
}

extension AlbumViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as! PhotoCollectionViewCell
        cell.setupPhoto(photos[indexPath.row])
        cell.contentView.alpha = indexPath == selectedPhotoIndexPathToDelete ? 0.5 : 1
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if selectedPhotoIndexPathToDelete == indexPath {
            selectedPhotoIndexPathToDelete = nil
        } else {
            selectedPhotoIndexPathToDelete = indexPath
        }
        collectionView.reloadData()
    }

}

extension FlickerClient {
    
    // MARK: Constants
    struct Constants {
        
        // MARK: API Key insert
        static let ApiKey = "API_KEY_FLICKER"
                        
        // MARK: URLs
        static let ApiScheme = "https"
        static let ApiHost = "www.flickr.com"
        static let ApiPath = "/services/rest"
    }
    
    // MARK: Parameter Keys
    struct ParameterKeys {
        static let ApiKey = "api_key"
        static let Format = "format"
        static let NoJsonCallback = "nojsoncallback"
        static let Method = "method"
        static let Latitude = "lat"
        static let Longitude = "lon"
    }
    
    // MARK: Parameter Values
    struct ParameterValues {
        static let SearchMethod = "flickr.photos.search"
        static let Json = "json"
        static let JsonCallbackValue = 1
    }
}

extension FlickerClient {
    
    func getPhotos(coord: CLLocationCoordinate2D, page: Int, completionHandlerForPhotos: @escaping (_ result: [FlickerImage]?, _ pages: Int?, _ error: NSError?) -> Void) {
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let parameters = [FlickerClient.ParameterKeys.Method : FlickerClient.ParameterValues.SearchMethod,
                          FlickerClient.ParameterKeys.Latitude: String(coord.latitude),
                          FlickerClient.ParameterKeys.Longitude: String(coord.longitude)]
        
        /* 2. Make the request */
        let _ = taskForGETMethod(parameters: parameters as [String:AnyObject]) { (results, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandlerForPhotos(nil, nil, error)
            } else {
                if let photosResults = results?["photos"] as? [String:AnyObject], let pages = photosResults["pages"] as? Int, let imageResults = photosResults["photo"] as? [[String:AnyObject]] {
                    let photos = FlickerImage.fetchFlickerImages(imageResults)
                    completionHandlerForPhotos(photos, pages, nil)
                } else {
                    completionHandlerForPhotos(nil, nil, NSError(domain: "getPhotos parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getPhotos"]))
                }
            }
        }
    }
    
    func getPhotoImageData(photo: Photo, completionHandlerForPhotoImageData: @escaping (_ result: Data?, _ error: NSError?) -> Void) {
        if let photoImageUrl = photo.imageUrl {
            let _ = taskForGETImage(photoImageUrl) { (data, error) in
                
                /* Send the desired value(s) to completion handler */
                if let error = error {
                    completionHandlerForPhotoImageData(nil, error)
                } else {
                    completionHandlerForPhotoImageData(data, nil)
                }
            }
        }
    }
}

extension CoreDataController {
    
    func loadPins() -> [Pin] {
        var pins: [Pin] = []
        let fetchRequest: NSFetchRequest<Pin> = Pin.fetchRequest()
        if let result = try? viewContext.fetch(fetchRequest) {
            pins = result
        }
        return pins
    }
    
    func addPin(coordinate: CLLocationCoordinate2D, completionHandler: (Pin) -> Void) {
        let pin = Pin(context: viewContext)
        pin.lat = coordinate.latitude
        pin.lon = coordinate.longitude
        if saveContext() {
            completionHandler(pin)
        }
    }
    
    func loadPhotos(pin: Pin) -> [Photo] {
        var photos: [Photo] = []
        let fetchRequest: NSFetchRequest<Photo> = Photo.fetchRequest()
        let predicate = NSPredicate(format: "pin = %@", pin)
        fetchRequest.predicate = predicate
        if let result = try? viewContext.fetch(fetchRequest) {
            photos = result
        }
        return photos
    }
    
    func fetchPhotoBy(id: String) -> Photo? {
        let fetchRequest: NSFetchRequest<Photo> = Photo.fetchRequest()
        let predicate = NSPredicate(format: "id = %@", id)
        fetchRequest.predicate = predicate
        if let result = try? viewContext.fetch(fetchRequest), result.count > 0 {
            return result[0]
        } else {
            return nil
        }
    }
    
    func addPhoto(id:String, imageURL: String, imageData: Data?, pin: Pin, completionHandler: (Photo) -> Void) {
        if let photo = fetchPhotoBy(id: id) {
            completionHandler(photo)
            return
        }
        let photo = Photo(context: viewContext)
        photo.id = id
        photo.imageUrl = imageURL
        photo.imageData = imageData
        photo.pin = pin
        if saveContext() {
            completionHandler(photo)
        }
    }
    
    func addPhotos(images: [FlickerImage], pin: Pin, completionHandler: ([Photo]) -> Void) {
        var photos: [Photo] = []
        for image in images {
            let photo = Photo(context: viewContext)
            photo.id = image.id
            photo.imageUrl = image.photoImageURL()
            photo.imageData = nil
            photo.pin = pin
            photos.append(photo)
        }
        if saveContext() {
            completionHandler(photos)
        }
    }
    
    func deletePhoto(photo: Photo, completionHandler: () -> Void) {
        viewContext.delete(photo)
        if saveContext() {
            completionHandler()
        }
    }
    
    func deletePhotos(pin: Pin, completionHandler: (() -> Void)? = nil) {
        let photos  = loadPhotos(pin: pin)
        for photo in photos {
            viewContext.delete(photo)
        }
        if saveContext() {
            completionHandler?()
        }
    }
    
    func saveImageDataToPhoto(photo: Photo, imageData: Data, completionHandler: () -> Void) {
        photo.imageData = imageData
        if saveContext() {
            completionHandler()
        }
    }
    
}

extension MKMapView {
    
    func addAnnotationMap(coordinate: CLLocationCoordinate2D) {
        let pinAnnotation: MKPointAnnotation = MKPointAnnotation()
        pinAnnotation.coordinate = coordinate
        addAnnotation(pinAnnotation)
    }
}
