//
//  NoData_ViewController.swift
//  project-tmdb
//
//  Created by Achmad Abdul Aziz on 05/06/20.
//  Copyright © 2020 Achmad Abdul Aziz. All rights reserved.
//

import UIKit

class NoData_ViewController: UIViewController {
    
    @IBOutlet weak var viewTitle: UILabel!
    @IBOutlet weak var btnOnView: UIButton!
    @IBOutlet weak var btnLink: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnOnView.setToCurve()
        btnLink.addTarget(self, action: #selector(linkAction), for: .touchUpInside)
    }
    
    func initViewTitle(title: String){
        viewTitle.text = title
    }
    
    func initButton(action: Selector){
        btnOnView.addTarget(self, action: action, for: .touchUpInside)
    }
    
    @objc func linkAction(){
        if let url = URL(string: "https://www.flaticon.com/search?search-type=icons&word=darius+dan&license=&color=&stroke=&current_section=&author_id=&pack_id=&family_id=&style_id=&category_id="){
            UIApplication.shared.open(url, options: [UIApplication.OpenExternalURLOptionsKey.universalLinksOnly: false]) { (success) in
            }
        }
    }
    
}
