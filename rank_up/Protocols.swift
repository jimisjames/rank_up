//
//  File.swift
//  rank_up
//
//  Created by Jim Lambert on 11/16/18.
//  Copyright © 2018 Jim Lambert. All rights reserved.
//

import UIKit

protocol FormDelegate: class {
    func saveButtonPressed(_ newItemName: String, _ indexPath: IndexPath?)
}
