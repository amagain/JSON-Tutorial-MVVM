//
//  MovieViewModel.swift
//  JSONTutorial
//
//  Created by Kapil Amagain on 5/11/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit

struct MovieViewModel {

    let title: String
    let imageURL: String
    let releaseDate: String
    let purchasePrice: String
    let summary: String
    
    init(model: Movie) {
        self.title = model.title.uppercased()
        self.imageURL = model.imageURL
        self.releaseDate = "Release Date: \(model.releaseDate)"
        if let doublePurchasePRice = Double(model.purchasePrice.amount) {
            self.purchasePrice = String(format: "%.02f %@", doublePurchasePRice, model.purchasePrice.currency)
        } else {
            self.purchasePrice = "Not Available for Purchase"
        }
        self.summary = model.summary == "" ? "No Data Provided" : model.summary
    }
}
