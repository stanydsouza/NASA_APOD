//
//  ViewController.swift
//  NASA_APOD
//
//  Created by Stany Dsouza on 22/09/22.
//

import UIKit
import AVKit

final class PictureViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var txtDescription: UITextView!
    @IBOutlet weak var btnGoFavourites: UIButton!
    
    @IBOutlet weak var btnPlay: UIButton!
    
    var btnFavourite: UIBarButtonItem!
    
    var fromFavourite = false
    
    private let viewModel: PictureViewModel = .init(dataRepository: PictureDataRepository())
    private var selectedDate: Date = .init()
    
    var pictureData: APODModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initViews()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if fromFavourite {
            setData()
        }
        else{
            getDetails()
        }
    }
    
    private func initViews(){
        
        btnFavourite = UIBarButtonItem(image: UIImage(named: "star"), style: .plain, target: self, action: #selector(changeFavourite))
        btnFavourite.tintColor = UIColor.orange
        
        if fromFavourite {
            navigationItem.title = "APOD"
            btnGoFavourites.isHidden = true
        }
        else{
            navigationItem.title = " NASA APOD"
            
            let pickDate = UIBarButtonItem(title: "Change Date", style: .plain, target: self, action: #selector(selectDate))
            self.navigationItem.leftBarButtonItem  = pickDate
            
        }
        
    }
    
    @objc func selectDate(){
        
        let datePicker = storyboard?.instantiateViewController(withIdentifier: "DatePickerViewController") as! DatePickerViewController
        datePicker.selectedDate = selectedDate
        datePicker.onDateSelected = { [weak self] date in
            self?.selectedDate = date
            self?.getDetails()
        }
        datePicker.modalPresentationStyle = .overFullScreen
        present(datePicker, animated: true)
    }
    
    @objc func changeFavourite(){
        pictureData!.favourite = !(pictureData!.favourite)
        viewModel.updateFavourite(pictureData!)
        setbtnFavouriteDesign()
    }
    
    @IBAction func goToFavourites(_ sender: Any){
        let vc = storyboard?.instantiateViewController(withIdentifier: "FavouritesViewController") as! FavouritesViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func playVideo(_ sender: Any){
        guard let link = pictureData?.url else { return }
        guard let url = URL(string: link) else { return }
        let vc = WebViewController(url: url)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private  func setData(){
        navigationItem.rightBarButtonItem = btnFavourite
        lblDate.text = "Date: " + pictureData!.date!
        lblHeading.text = pictureData?.title
        txtDescription.text = pictureData?.explanation
        setbtnFavouriteDesign()
        let isVideo = pictureData?.media_type == "video"
        btnPlay.isHidden = !isVideo
        let imageUrl = isVideo ? pictureData?.thumbnail_url : pictureData?.url
        
        imageView.setImage(urlString: imageUrl!, name: "apod_\(pictureData!.date!)"){
            Spinner.stop()
        }
    }
    
    private func setbtnFavouriteDesign(){
        btnFavourite.image = UIImage(systemName: pictureData!.favourite ? "star.fill" : "star")
    }
    
    private func getDetails(){
        lblDate.text = "Date: " + selectedDate.toString(format: "yyyy-MM-dd")
        lblHeading.text = ""
        imageView.image = nil
        txtDescription.text = ""
        navigationItem.rightBarButtonItem = nil
        btnPlay.isHidden = true
        
        Spinner.spin()
        viewModel.getDetails(date: selectedDate){ [weak self] result in
            switch result {
                
            case .success(let data):
                self?.pictureData = data
                self?.setData()
                break
                
            case .failure(let error):
                Spinner.stop()
                let alert = UIAlertController(title: nil, message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style:.default, handler: nil))
                self?.present(alert, animated: true)
                break
            }
        }
    }
    
}

