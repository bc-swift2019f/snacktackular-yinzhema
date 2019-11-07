//
//  Double+roundTo.swift
//  Snacktacular
//
//  Created by Yinzhe Ma on 11/7/19.
//  Copyright © 2019 John Gallaugher. All rights reserved.
//

import Foundation

//rounds any double to "places" places, e.g. if value=3.123456, value.round(places:1) returns 3.1

extension Double{
    func  roundTo(places: Int)-> Double {
        let tenToPower=pow(10.0, Double((places>=0 ? places:0)))
        let roundedValue=(self*tenToPower).rounded()/tenToPower
        return roundedValue
    }
}
