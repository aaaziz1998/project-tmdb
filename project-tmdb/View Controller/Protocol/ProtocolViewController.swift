//
//  ViewModelController.swift
//  project-tmdb
//
//  Created by Achmad Abdul Aziz on 03/06/20.
//  Copyright © 2020 Achmad Abdul Aziz. All rights reserved.
//

import Foundation

protocol ProtocolViewController {
    func success(message: String, response: APIResponseIndicator?)
    func failed(message: String, response: APIResponseIndicator?)
}

