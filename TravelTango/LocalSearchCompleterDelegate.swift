//
//  LocalSearchCompleterDelegate.swift
//  TravelTango
//
//  Created by Damsara Samarakoon on 2025-04-14.
//
import Foundation
import MapKit

class LocalSearchCompleterDelegate: NSObject, MKLocalSearchCompleterDelegate {
    var didUpdateResults: (([MKLocalSearchCompletion]) -> Void)?
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        didUpdateResults?(completer.results)
    }
}

