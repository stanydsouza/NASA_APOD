//
//  Extensions.swift
//  NASA_APOD
//
//  Created by Stany Dsouza on 23/09/22.
//

import Foundation
import UIKit.UIImageView

extension Date {
    
    func toString(format: String) -> String{
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = format
        let str = formatter.string(from: self)
        return str
    }
    
}

extension UIImageView {
    
    func setImage(urlString: String, name: String, onComplete: (() -> Void)? = nil) {
        
        let fileManager = FileManager.default
        let documentURL = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let directory = documentURL.appending("/Images/")
        
        if !fileManager.fileExists(atPath: directory){
             try! fileManager.createDirectory(atPath: directory, withIntermediateDirectories: false, attributes: nil)
        }
        
        let imagePath = directory.appending("\(name).jpg")
        
        if fileManager.fileExists(atPath: imagePath){
            self.image = UIImage(contentsOfFile: imagePath)
            onComplete?()
        }
        else{
            guard let url = URL(string: urlString) else { return }
            APIService.shared.getRequest(url) { result in
                
                DispatchQueue.main.async {
                    switch result {
                        
                    case .success(let data):
                        
                        self.image = .init(data: data)
                        onComplete?()
                        let imageData = self.image!.jpegData(compressionQuality: 1)!
                        do {
                            try imageData.write(to: URL(fileURLWithPath: imagePath), options: .atomic)
                        }
                        catch{}
                        break
                    case .failure(_):
                        self.image = nil
                        onComplete?()
                        break
                    }
                }
                
            }
            
            
        }
    
    }
    
}
