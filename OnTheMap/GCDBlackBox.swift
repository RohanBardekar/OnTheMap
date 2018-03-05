//
//  GCDBlackBox.swift
//  OnTheMap
//
//  Created by Rohan Bardekar on 16/08/17.
//  Copyright © 2017 Onbinge. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
    
    DispatchQueue.main.async {
        
        updates()
    }
}
