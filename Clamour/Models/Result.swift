//
//  Result.swift
//  Clamour
//
//  Created by San Byn Nguyen on 23.04.2018.
//  Copyright © 2018 Udacity. All rights reserved.
//
import UIKit
import Foundation

class Result {
    var type: String = ""
    var suitableTypes: [String] = []
    var adjacentColors: [UIColor] = []
    var coplementaryColors: [UIColor] = []
    
    init(type: String, suitable: [String], adjColors: [UIColor], copColors: [UIColor]) {
        self.type = type
        self.suitableTypes = suitable
        self.adjacentColors = adjColors
        self.coplementaryColors = copColors
    }
}
