//
//  Students.swift
//  On the Map
//
//  Created by Carmine Totera on 2021/8/11.
//  Copyright © 2021 Carmine Totera. All rights reserved.
//

import Foundation

struct Students {
    static var shared = Students()
    var students = [StudentInformation]()
}
