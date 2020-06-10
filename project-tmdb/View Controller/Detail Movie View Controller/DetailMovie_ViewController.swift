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
    
    var userDefaults = UserDefaults.standard
    var detailMovieViewModel: DetailMovieViewModel?
    
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
        
        detailMovieViewModel = DetailMovieViewModel(self, movie_id: id_movie)
        
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
}

extension DetailMovie_ViewController: ProtocolViewController{
    
    func success(message: String) {
        loading = false
        tableView.reloadData()
    }
    
    func failed(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let btnOK = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(btnOK)
        self.present(alert, animated: true, completion: nil)
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
            case listIdentifier.information.rawValue:
                cell.informationLabelAuthor.text = "Release date \(movie?.release_date ?? "")"
                cell.informationViewRating.setToRound()
                cell.informationButtonReviews.isHidden = false
                cell.informationButtonTrailer.isHidden = false
                cell.informationButtonFavorite.isHidden = false
                cell.informationViewRating.setToRound()
                
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
            return UITableView.automaticDimension
        case 1:
            if loading{
                return 0
            } else {
                return 150
            }
        case 2:
            return UITableView.automaticDimension
        default:
            return 0
        }
    }
    
    
}
