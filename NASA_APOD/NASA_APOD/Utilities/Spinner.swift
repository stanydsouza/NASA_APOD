//
//  Spinner.swift
//  NASA_APOD
//
//  Created by Stany Dsouza on 23/09/22.
//

import Foundation
import UIKit

class Spinner {
    static var spinnerView: UIActivityIndicatorView?
    
    public static func spin(touchHandler: (() -> Void)? = nil) {
        if spinnerView == nil,
            let window = UIApplication.shared.keyWindow {
            let frame = UIScreen.main.bounds
            spinnerView = UIActivityIndicatorView(frame: frame)
            spinnerView!.backgroundColor = UIColor(white: 0, alpha: 0.6)
            spinnerView!.style = .large
            window.addSubview(spinnerView!)
            spinnerView!.startAnimating()
        }
    }
    
    public static func stop() {
        if let _ = spinnerView {
            spinnerView!.stopAnimating()
            spinnerView!.removeFromSuperview()
            spinnerView = nil
        }
    }
}
