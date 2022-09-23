//
//  DatePickerViewController.swift
//  NASA_APOD
//
//  Created by Stany Dsouza on 23/09/22.
//

import UIKit

final class DatePickerViewController: UIViewController {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var selectedDate: Date!
    var onDateSelected: ((Date)->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.clear.withAlphaComponent(0.5)
    
        datePicker.maximumDate = Date()
        datePicker.date = selectedDate
        
    }
    
    @IBAction func setBtnAction(_ sender: Any) {
        dismiss(animated: false){
            self.onDateSelected?(self.datePicker.date)
        }
    }
    
    
    @IBAction func cancelBtnAction(_ sender: Any) {
        dismiss(animated: false)
    }
    
    
}
