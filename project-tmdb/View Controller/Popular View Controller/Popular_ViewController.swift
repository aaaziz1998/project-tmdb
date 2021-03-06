//
//  PopularViewController.swift
//  project-tmdb
//
//  Created by Achmad Abdul Aziz on 03/06/20.
//  Copyright © 2020 Achmad Abdul Aziz. All rights reserved.
//

import UIKit
import Kingfisher
import SkeletonView

import UIKit
import Kingfisher
import SkeletonView

class Popular_ViewController: UIViewController {
    
    var collectionViewIdentifier = "cell"
    var searchBar = UISearchController(searchResultsController: nil)
    var refreshControl = UIRefreshControl()
    
    var genre: GenreModel?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var loading = true
    var loadPage = true
//    var statusUserValid = false
    
    var movieViewModel: ProtocolMovieViewModel?
    var favoriteViewModel: ProtocolFavoriteMovieViewModel?
    var authorizationViewModel: ProtocolAuthorizationViewModel?
    var accountViewModel: ProtocolAccountViewModel?
    
    var userDefaults = UserDefaults.standard
    
    var apis = APIs()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        searchBar.searchBar.delegate = self
        
        setupNavigationBar()
        
        if userDefaults.getBoolValue(identifier: .isLogin){
            favoriteViewModel = FavoriteMovieViewModel(self)
        }
        
        if let genre = genre{
            movieViewModel = MovieViewModel(self, genre)
        } else {
            movieViewModel = MovieViewModel(self)
        }
        
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        refreshControl.endRefreshing()
        refreshControl.tintColor = UIColor.black
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }
    
    @objc func refresh(){
        movieViewModel?.refresh()
        favoriteViewModel?.refresh()
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    func setupNavigationBar(){
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.barTintColor = .mainColor
        self.navigationItem.searchController = searchBar
    }

    @objc func addToFavorite(sender: UIButton){
        guard let movie = movieViewModel?.getResultOn(index: sender.tag) else {return}
        favoriteViewModel?.addFavorite(movie: movie)
        print("Add to favorites")
    }
    
    @objc func alertAskLogin(sender: UIButton){
        let alert = UIAlertController(title: nil, message: "You have to login first to use this function", preferredStyle: .alert)
        let btnOK = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(btnOK)
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension Popular_ViewController: ProtocolViewController{
    
    func success(message: String, response: APIResponseIndicator?) {
        refreshControl.endRefreshing()
        switch response {
        case .indexFavoriteMovies:
            collectionView.reloadData()
        case .pagination(indicator: .indexMovieByGenre):
            loading = false
            guard let countMovieModel = movieViewModel?.countValue() else {return}
            if collectionView.numberOfItems(inSection: 0) == countMovieModel{
                return
            } else {
                collectionView.reloadData()
            }
        default:
            loading = false
            loadPage = false
            collectionView.reloadData()
        }
    }
    
    func failed(message: String, response: APIResponseIndicator?) {
        loading = false
        
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let btnOK = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(btnOK)
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension Popular_ViewController: UISearchControllerDelegate, UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        movieViewModel?.filterResult(key: searchBar.text ?? "")
        self.collectionView.reloadData()
        self.searchBar.dismiss(animated: true, completion: nil)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        movieViewModel?.filterResult(key: "")
        self.collectionView.reloadData()
    }

}

extension Popular_ViewController: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if loading{
            return 8
        } else {
            return movieViewModel?.countValue() ?? 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewIdentifier, for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? Popular_CollectionViewCell else {return}
        cell.setToCurve()
        if loading{
            cell.showAnimatedGradientSkeleton()
        } else {
            cell.hideSkeleton()
            
            guard let movieModel = movieViewModel?.getResultOn(index: indexPath.row) else {return}
            cell.imgFavorite.image = UIImage.getImageToFollowTintColor(image: UIImage.favorite)
            cell.imgFavorite.tintColor = .unfavoriteColor
            if userDefaults.getBoolValue(identifier: .isLogin){
                if favoriteViewModel?.searchFavoriteStatus(movie: movieModel) ?? false{
                    cell.imgFavorite.tintColor = .favoriteColor
                } else {
                    cell.imgFavorite.tintColor = .unfavoriteColor
                }
                cell.btnFavorite.tag = indexPath.row
                cell.btnFavorite.addTarget(self, action: #selector(addToFavorite), for: .touchUpInside)
            } else {
                cell.btnFavorite.addTarget(self, action: #selector(alertAskLogin), for: .touchUpInside)
            }
            
            let placeholdeImage = UIImage.milkyWay
            
            guard let url = URL(string: apis.getImage(path: movieModel.poster_path ?? "")) else {return}
            
            cell.imgMovie.kf.setImage(with: url,
                                      placeholder: placeholdeImage,
                                      options: [.keepCurrentImageWhileLoading,
                                                .scaleFactor(UIScreen.main.scale),
                                                .transition(.fade(1)),
                                                .cacheOriginalImage]) { (kingfisher) in
            }
            
            cell.lblMovie.text = movieModel.title

        }
                
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sizeForCollectionView = self.view.frame.width
        let widthForCell = (sizeForCollectionView/2)-30
        
        return CGSize(width: widthForCell, height: (widthForCell*3)/2)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset, scrollView.contentSize.height, self.view.frame.height)
        if !loadPage{
            if scrollView.contentOffset.y >= (scrollView.contentSize.height - (self.view.frame.height*2)){
                        movieViewModel?.nextPage()
                    }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let detailView = storyboard?.instantiateViewController(withIdentifier: "detailMovie_ViewController") as? DetailMovie_ViewController else {return}
        detailView.id_movie = movieViewModel?.getResultOn(index: indexPath.row).id ?? 0
        self.navigationController?.pushViewController(detailView, animated: true)
    }
    
}
