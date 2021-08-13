//
//  UDACITYClient.swift
//  On the Map
//
//  Created by Carmine Totera on 2021/8/11.
//  Copyright © 2021 Carmine Totera. All rights reserved.
//

// MARK: - UdacityClient (Constants)

extension UdacityClient {
    
    // MARK: Constants
    struct Constants {
        
        // MARK: URLs
        static let ApiScheme = "https"
        static let ParseApiHost = "onthemap-api.udacity.com"
        static let ParseApiPath = "/v1"
        static let UdacityApiHost = "onthemap-api.udacity.com"
        static let UdacityApiPath = "/v1"
        static let SignUpURL = "https://auth.udacity.com/sign-up?next=https://classroom.udacity.com"
    }
    
    // MARK: Methods
    struct ParseMethods {
        
        // MARK: Student Locations
        static let StundetLocation = "/StudentLocation"
    }
    
    struct UdacityMethods {
        
        // MARK: Session
        static let Session = "/session"
        static let User = "/users/{id}"
    }
    
    // MARK: URL Keys
    struct URLKeys {
        static let UserID = "id"
    }
    
    // MARK: Parameter Keys
    struct ParameterKeys {
        
        // MARK: StudentLocation
        static let Limit = "limit"
        static let Order = "order"
        static let Where = "where"
        static let UniqueKey = "key"
    }
    
    // MARK: Parameter Values
    struct ParameterValues {
        static let MaxNumber = "100"
        static let SortedOrder = "updatedAt"
        static let UniqueKey = ""
    }
    
    // MARK: JSON Body Keys
    struct JSONBodyKeys {
        static let Username = "username"
        static let Password = "password"
    }
    
    // MARK: JSON Response Keys
    struct JSONResponseKeys {
        
        // MARK: Authentication
        static let Account = "account"
        static let UserId = "key"
        
        // MARK: Students
        static let StudentCreatedTime = "createdAt"
        static let StudentFirstName = "firstName"
        static let StudentLastName = "lastName"
        static let StudentLatitude = "latitude"
        static let StudentLongitude = "longitude"
        static let StudentMapString = "mapString"
        static let StudentMediaURL = "mediaURL"
        static let StudentObjectId = "objectId"
        static let StudentUniqueKey = "uniqueKey"
        static let StudentUpdatedTime = "updatedAt"
        static let StudentResults = "results"
    }
}
