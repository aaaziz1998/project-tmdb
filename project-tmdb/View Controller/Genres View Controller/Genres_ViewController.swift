//
//  Genres_ViewController.swift
//  project-tmdb
//
//  Created by Achmad Abdul Aziz on 10/06/20.
//  Copyright © 2020 Achmad Abdul Aziz. All rights reserved.
//

import UIKit

class Genres_ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var genres: ProtocolGenresViewModel?
    
    @IBOutlet weak var btnRefresh: UIBarButtonItem!
    
    var loading = true
    
    var cellIdentifier = "cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        genres = GenresViewModel(self)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func refreshAction(_ sender: Any) {
        loading = true
        genres?.refresh()
    }
}

extension Genres_ViewController: ProtocolViewController{
    
    func success(message: String, response: APIResponseIndicator?) {
        loading = false
        collectionView.reloadData()
    }
    
    func failed(message: String, response: APIResponseIndicator?) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let btnOK = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(btnOK)
        self.present(alert, animated: true, completion: nil)
    }

}

extension Genres_ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if loading{
            return 6
        } else {
            return genres?.getGenresCount() ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? Genres_CollectionViewCell else {return}
        cell.setToCurve()
        if loading{
            cell.showAnimatedGradientSkeleton()
        } else {
            cell.hideSkeleton()
            let genre = genres?.getGenreAt(index: indexPath.row)
            cell.lblGenres.text = genre?.name
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sizeForCollectionView = self.view.frame.width
        let widthForCell = (sizeForCollectionView/2)-30
        
        return CGSize(width: widthForCell, height: 60)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let view = storyboard.instantiateViewController(withIdentifier: "popular_ViewController") as? Popular_ViewController else {return}
        view.genre = genres?.getGenreAt(index: indexPath.row)
        self.navigationController?.pushViewController(view, animated: true)
    }
    
}
