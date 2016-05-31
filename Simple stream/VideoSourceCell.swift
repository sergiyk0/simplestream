//
//  VideoSourceCell.swift
//  Simple stream
//
//  Created by Serhii Shapoval on 5/19/16.
//  Copyright © 2016 Serhii Shapoval. All rights reserved.
//

import UIKit

public class VideoSourceCell: UITableViewCell {
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override public func drawRect(rect: CGRect) {
        thumbnailImageView.layer.cornerRadius = thumbnailImageView.frame.height / 2
        thumbnailImageView.layer.masksToBounds = true
        super.drawRect(rect)
    }
}
