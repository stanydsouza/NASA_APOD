//
//  FavouritesViewController.swift
//  NASA_APOD
//
//  Created by Stany Dsouza on 23/09/22.
//

import UIKit

final class FavouritesViewController: UIViewController {
    
    @IBOutlet weak var tbvFavourites: UITableView!
    
    private let dataRepository: PictureDataRepository = .init()
    private var favouritesData: [APODModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initViews()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getFavourites()
    }
    
    private func initViews(){
        navigationItem.title = "Favourites"
        tbvFavourites.dataSource = self
        tbvFavourites.delegate = self
    }
   
    private func getFavourites(){
        favouritesData = dataRepository.getFavourites()
        tbvFavourites.reloadData()
    }
    
    private func removeFavourite(indexPath: IndexPath){
        var model = favouritesData[indexPath.row]
        model.favourite = false
        dataRepository.updateData(model)
        favouritesData.remove(at: indexPath.row)
        tbvFavourites.beginUpdates()
        tbvFavourites.deleteRows(at: [indexPath], with: .none)
        tbvFavourites.endUpdates()
    }

}

extension FavouritesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favouritesData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! favouritesCell
        cell.populateData(favouritesData[indexPath.row])
        cell.onRemove = { [unowned self] cell in
            let actualIndexPath = tableView.indexPath(for: cell)!
            self.removeFavourite(indexPath: actualIndexPath)
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "PictureViewController") as! PictureViewController
        vc.pictureData = favouritesData[indexPath.row]
        vc.fromFavourite = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

final class favouritesCell: UITableViewCell {
    
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var viewContent: UIView!
    
    var onRemove: ((UITableViewCell) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewContent.layer.cornerRadius = 5.0
        viewContent.layer.borderWidth = 1.0
        viewContent.layer.borderColor = UIColor.systemGray.cgColor
        viewContent.layer.masksToBounds = true
    }
    
    func populateData(_ data: APODModel){
        lblDate.text = "Date: " + data.date!
        lblTitle.text = data.title
        
        let imageUrl = data.media_type == "video" ? data.thumbnail_url : data.url
        imgView.setImage(urlString: imageUrl!, name: "apod_\(data.date!)")
    }
    
    @IBAction func onRemoveAction(_ sender: Any){
        onRemove?(self)
    }
    
}
