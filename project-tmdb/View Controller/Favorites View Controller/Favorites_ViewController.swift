//
//  Favorites_ViewController.swift
//  project-tmdb
//
//  Created by Achmad Abdul Aziz on 04/06/20.
//  Copyright © 2020 Achmad Abdul Aziz. All rights reserved.
//

import UIKit
import SkeletonView
import Kingfisher

import UIKit
import SkeletonView
import Kingfisher

class Favorites_ViewController: UIViewController {

    var loading = true
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewFilter: UIView!
    @IBOutlet weak var btnFilter: UIButton!
    @IBOutlet weak var lblFilter: UILabel!
    @IBOutlet weak var editNavigationButton: UIBarButtonItem!
    
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var constraintSearchView: NSLayoutConstraint!
    
    var refreshControl = UIRefreshControl()

    var favoriteModelView: FavoriteMovieViewModel?
    
    var apis = APIs()
    var userDefaults = UserDefaults.standard
    
    private var statusEdit = false
    
    var noDataViewController: NoData_ViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        favoriteModelView = FavoriteMovieViewModel(self)
        btnFilter.addTarget(self, action: #selector(filterAction), for: .touchUpInside)
        
        if userDefaults.getBoolValue(identifier: .isLogin){
            tableView.delegate = self
            tableView.dataSource = self
            
            searchBar.delegate = self
            
            refreshControl.endRefreshing()
            refreshControl.tintColor = UIColor.black
            refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
            tableView.refreshControl = refreshControl
        } else {
            self.navigationController?.navigationBar.isHidden = true
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let login_ViewController = storyboard.instantiateViewController(withIdentifier: "login_ViewController") as? Login_ViewController else {return}
            self.addChild(login_ViewController)
            self.view.addSubview(login_ViewController.view)
            login_ViewController.view.translatesAutoresizingMaskIntoConstraints = true
        }
    }
    
    func installNoDataView(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let noDataViewController = storyboard.instantiateViewController(withIdentifier: "noData_ViewController") as? NoData_ViewController else {return}
        self.addChild(noDataViewController)
        self.view.addSubview(noDataViewController.view)
        noDataViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate(
            [noDataViewController.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
             noDataViewController.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
             noDataViewController.view.topAnchor.constraint(equalTo: tableView.topAnchor),
            noDataViewController.view.bottomAnchor.constraint(equalTo: tableView.bottomAnchor)])
        
        noDataViewController.initViewTitle(title: "Gagal terhubung")
        noDataViewController.btnOnView.addTarget(self, action: #selector(refreshView), for: .touchUpInside)

    }
    
    @objc func refreshView(){
        if userDefaults.getBoolValue(identifier: .isLogin){
            tableView.delegate = self
            tableView.dataSource = self
            
            searchBar.delegate = self
            
            refreshControl.endRefreshing()
            refreshControl.tintColor = UIColor.black
            refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
            tableView.refreshControl = refreshControl
            
            noDataViewController?.view.isHidden = true
            self.view.bringSubviewToFront(tableView)
        }
    }
    
    @objc func refresh(){
        loading = true
        favoriteModelView?.refresh()
    }
    
    @IBAction func editAction(_ sender: Any) {
        if let sender = sender as? UIBarButtonItem{
            if sender.title ?? "" == "Edit"{
                sender.title = "Cancel"
                statusEdit = true
                tableView.reloadData()
            } else {
                sender.title = "Edit"
                statusEdit = false
                tableView.reloadData()
            }
        }
    }
    
    @objc func deleteAction(sender: UIButton){
        guard let movie = favoriteModelView?.getValueFor(index: sender.tag) else {return}
        favoriteModelView?.addFavorite(movie: movie)
    }
    
    @objc func filterAction(){
        print(self.searchBar.frame, self.searchView.frame, self.viewFilter.frame)
        if constraintSearchView.constant == 0{
            UIView.animate(withDuration: 1, delay: 0.1, animations: {
                self.lblFilter.text = "Cancel"
                self.searchView.frame = CGRect(x: 0, y: self.searchView.frame.minY, width: self.view.frame.width-70, height: self.searchView.frame.height)
                self.viewFilter.frame = CGRect(x: self.searchView.frame.width, y: self.viewFilter.frame.minY, width: 70, height: self.viewFilter.frame.height)
                
                self.constraintSearchView.constant = self.searchView.frame.width
                
            }, completion: {(isCompleted) in
                self.constraintSearchView.constant = self.view.frame.width-70
            })
            
            
        } else {
            
            UIView.animate(withDuration: 1, delay: 0.1, animations: {
                
                self.lblFilter.text = "Add Filter"
                
                self.searchView.frame = CGRect(x: 0, y: self.searchView.frame.minY, width: 0, height: self.searchView.frame.height)
                self.searchBar.frame = CGRect(x: 0, y: 0, width: 0, height: self.searchView.frame.height)
                self.viewFilter.frame = CGRect(x: 0, y: self.viewFilter.frame.minY, width: self.view.frame.width, height: self.viewFilter.frame.height)
                
                self.constraintSearchView.constant = self.searchView.frame.width
            }, completion: {(isCompleted) in
                self.constraintSearchView.constant = 0
            })
            
            searchBar.text =  ""
            searchBar.resignFirstResponder()
            
            favoriteModelView?.filter(key: "")
            tableView.reloadData()
            
        }
    }

}

extension Favorites_ViewController: ProtocolViewController{
    
    func success(message: String, response: APIResponseIndicator?) {
        switch response {
        case .markAsFavorite:
            favoriteModelView?.refresh()
        default:
            loading = false
            refreshControl.endRefreshing()
            tableView.reloadData()
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

extension Favorites_ViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        favoriteModelView?.filter(key: searchBar.text ?? "")
        searchBar.resignFirstResponder()
        tableView.reloadData()
    }
    
}

extension Favorites_ViewController: UITableViewDelegate, UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if loading{
            return 8
        } else {
            return favoriteModelView?.countValue() ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell()
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? Favorites_TableViewCell else {return}
        if loading{
            cell.showAnimatedGradientSkeleton()
        } else {
            cell.hideSkeleton()
            
            let movieModel = favoriteModelView?.getValueFor(index: indexPath.row)
            
            let placeholdeImage = UIImage.milkyWay
                        
            guard let url = URL(string: apis.getImage(path: movieModel?.poster_path ?? "")) else {return}
            
            if statusEdit{
                cell.deleteViewConstaint.constant = 70
            } else {
                cell.deleteViewConstaint.constant = 0
            }
            
            cell.imgMovie.kf.setImage(with: url,
                                      placeholder: placeholdeImage,
                                      options: [.keepCurrentImageWhileLoading,
                                                .scaleFactor(UIScreen.main.scale),
                                                .transition(.fade(1)),
                                                .cacheOriginalImage]) { (kingfisher) in
                                                    //                                                    print("image showed")
            }
            
            cell.btnDelete.tag = indexPath.row
            cell.btnDelete.addTarget(self, action: #selector(deleteAction), for: .touchUpInside)
            
            cell.lblMovieTitle.text = movieModel?.title
            cell.textViewMovieDescription.text = movieModel?.overview
            
            let release_date = movieModel?.release_date ?? ""
            let release_date_component = release_date.components(separatedBy: "-")
            
            cell.lblMovieReleaseYear.text = release_date_component[0]
            
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
}
