//
//  PostCell.swift
//  homeWork_13
//
//  Created by Дмитрий Яковлев on 18.12.2019.
//  Copyright © 2019 Дмитрий Яковлев. All rights reserved.
//

import UIKit

// MARK: - tableView Cell
class PostCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var userIDLabel: UILabel!
    private var hid = true
    private var updateAsked = false
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setPost(post: Post){
        titleLabel.text = post.title
        bodyLabel.text = post.body
        idLabel.text = String(post.id)
        userIDLabel.text = String(post.userId)
        bodyLabel.textColor = .systemGray
        let italicFont = UIFont.italicSystemFont(ofSize: 17)
        bodyLabel.font = italicFont
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setAsked(val: Bool){
        updateAsked = val
    }
    func getAsked()->Bool{
        return updateAsked
    }
}
