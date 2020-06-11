//
//  DetailMovie_TableViewCell.swift
//  project-tmdb
//
//  Created by Achmad Abdul Aziz on 10/06/20.
//  Copyright © 2020 Achmad Abdul Aziz. All rights reserved.
//

import UIKit

class DetailMovie_TableViewCell: UITableViewCell {

    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var titleBackButton: UIButton!
    @IBOutlet weak var titleImageBackdrop: UIImageView!
    @IBOutlet weak var titleImageMovie: UIImageView!
    @IBOutlet weak var titleLabelReleaseData: UILabel!
    
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var informationButtonFavorite: UIButton!
    @IBOutlet weak var informationButtonTrailer: UIButton!
    @IBOutlet weak var informationButtonReviews: UIButton!
    @IBOutlet weak var informationViewRating: UIView!
    @IBOutlet weak var informationLabelRating: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
