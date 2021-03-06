//
//  DetailMovie_ViewController.swift
//  project-tmdb
//
//  Created by Achmad Abdul Aziz on 10/06/20.
//  Copyright © 2020 Achmad Abdul Aziz. All rights reserved.
//

import UIKit
import SkeletonView

class DetailMovie_ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var apis = APIs()
    var userDefaults = UserDefaults.standard
    var detailMovieViewModel: DetailMovieViewModel?
    var favoriteMovieViewModel: FavoriteMovieViewModel?
    
    var id_movie: Int!
    
    var loading = true
    
    var listIdentifer = ["title", "information", "description"]
    enum listIdentifier: String{
        case title = "title"
        case information = "information"
        case description = "description"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        detailMovieViewModel = DetailMovieViewModel(self, movie_id: id_movie)
        
        if userDefaults.getBoolValue(identifier: .isLogin){
            favoriteMovieViewModel = FavoriteMovieViewModel(self)
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    @objc func backAction(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func btnAddToFavorite(){
        if userDefaults.getBoolValue(identifier: .isLogin){
            if let movie = detailMovieViewModel?.movie{
                favoriteMovieViewModel?.addFavorite(movie: movie)
            }
        } else {
            let alert = UIAlertController(title: nil, message: "You have to login first to use this function", preferredStyle: .alert)
            let btnOK = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(btnOK)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}

extension DetailMovie_ViewController: ProtocolViewController{
    func success(message: String, response: APIResponseIndicator?) {
        switch response {
        case .markAsFavorite:
            let alert = UIAlertController(title: "Berhasil", message: message, preferredStyle: .alert)
            let btnOK = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(btnOK)
            self.present(alert, animated: true, completion: nil)
        default:
            loading = false
            tableView.reloadData()
        }
    }
    
    func failed(message: String, response: APIResponseIndicator?) {
        switch response {
        default:
            let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            let btnOK = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(btnOK)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}

extension DetailMovie_ViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listIdentifer.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: listIdentifer[indexPath.row]) else {return UITableViewCell()}
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? DetailMovie_TableViewCell else {return}
        
        if loading{
            cell.showAnimatedGradientSkeleton()
        } else {
            cell.hideSkeleton()
            let movie = detailMovieViewModel?.getMovie()
            switch cell.reuseIdentifier {
            case listIdentifier.title.rawValue:
                cell.titleTextView.text = movie?.title
                cell.titleBackButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
                cell.titleBackButton.setImage(UIImage.getImageToFollowTintColor(image: .back), for: .normal)
                cell.titleBackButton.tintColor = .white
                cell.titleBackButton.setTitle("Movies", for: .normal)
                cell.titleBackButton.titleLabel?.textColor = .white
                
                if let release_date = movie?.release_date{
                    let detailed_date = release_date.components(separatedBy: "-")
                    cell.titleLabelReleaseData.text = "Release Date: \(detailed_date[2]) \(String().getFullnameMonth(Number: detailed_date[1])) \(detailed_date[0])"
                }
                
                let placeholdeImage = UIImage.milkyWay
                
                guard let urlBackdrop = URL(string: apis.getImage(path: movie?.backdrop_path ?? "")) else {return}
                guard let urlMovie = URL(string: apis.getImage(path: movie?.poster_path ?? "")) else {return}
                
                cell.titleImageBackdrop.kf.setImage(with: urlBackdrop,
                                          placeholder: placeholdeImage,
                                          options: [.keepCurrentImageWhileLoading,
                                                    .scaleFactor(UIScreen.main.scale),
                                                    .transition(.fade(1)),
                                                    .cacheOriginalImage]) { (kingfisher) in
                }
                
                cell.titleImageMovie.kf.setImage(with: urlMovie,
                                                 placeholder: placeholdeImage,
                                                 options: [.keepCurrentImageWhileLoading,
                                                           .scaleFactor(UIScreen.main.scale),
                                                           .transition(.fade(1)),
                                                           .cacheOriginalImage]) { (kingfisher) in
                }
                
            case listIdentifier.information.rawValue:
                cell.informationViewRating.setToRound()
                cell.informationButtonReviews.isHidden = false
                cell.informationButtonTrailer.isHidden = false
                cell.informationButtonFavorite.isHidden = false
                cell.informationViewRating.setToRound()
                
                cell.informationButtonFavorite.addTarget(self, action: #selector(btnAddToFavorite), for: .touchUpInside)
                
                let rating = movie?.vote_average ?? 0
                
                cell.informationLabelRating.text = "\(Int(rating * 10))"
                
                let layer = UIView().shapeCircularLayer(center: cell.informationViewRating.center, radius: cell.informationViewRating.frame.width/2, color: .mainColor)
                layer.strokeEnd = CGFloat(rating/10)
                let baseLayer = UIView().shapeCircularLayer(center: cell.informationViewRating.center, radius: cell.informationViewRating.frame.width/2, color: .lightGray)
                
                cell.layer.addSublayer(baseLayer)
                cell.layer.addSublayer(layer)
                
            case listIdentifier.description.rawValue:
                cell.descriptionTextView.text = movie?.overview
            default:
                return
            }

        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row{
        case 0:
            return 230
        case 1:
            if loading{
                return 0
            } else {
                return 120
            }
        case 2:
            return UITableView.automaticDimension
        default:
            return 0
        }
    }
    
    
}
