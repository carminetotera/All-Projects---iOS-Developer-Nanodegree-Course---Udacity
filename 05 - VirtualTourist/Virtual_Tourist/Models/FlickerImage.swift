//
//  FlickerImage.swift
//  Virtual_Tourist
//
//  Created by Carmine Totera on 13/08/21.
//

 // MARK: Properties

struct FlickerImage {
    
    // MARK: Properties
    
    let id:String
    let secret:String
    let server:String
    let farm:Int

    // MARK: Initializers
    
    // construct a FlickerImage from a dictionary
    init(dictionary: [String:AnyObject]) {
        id = dictionary["id"] as! String
        secret = dictionary["secret"] as! String
        server = dictionary["server"] as! String
        farm = dictionary["farm"] as! Int
    }
    
    func photoImageURL() -> String {
        return "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret)_q.jpg"
    }
    
    static func fetchFlickerImages(_ results: [[String:AnyObject]]) -> [FlickerImage] {
        
        var images = [FlickerImage]()
        
        // iterate through array of dictionaries, each FlickerImage is a dictionary
        for result in results {
            images.append(FlickerImage(dictionary: result))
        }
        
        return images
    }
}
