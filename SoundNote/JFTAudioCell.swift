//
//  JFTAudioCell.swift
//  SoundNote
//
//  Created by jft0m on 2017/8/21.
//  Copyright © 2017年 jft0m. All rights reserved.
//

import UIKit

class JFTAudioCell: UITableViewCell {
    
    var fileNameLabel : UILabel!
    var playButton : UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        fileNameLabel = UILabel()
        contentView.addSubview(fileNameLabel!)
        
        playButton = UIButton()
        playButton.setTitle("点击播放", for: UIControlState.normal)
        playButton.backgroundColor = UIColor.black
        playButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        contentView.addSubview(playButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        fileNameLabel.sizeToFit()
        fileNameLabel.frame = CGRect.init(x: 5, y: contentView.bounds.height / 2, width: contentView.bounds.width / 2, height: fileNameLabel.bounds.height)
        
        playButton.sizeToFit()
        playButton.frame = CGRect.init(x: contentView.bounds.width - playButton.bounds.width,
                                       y: (contentView.bounds.height - playButton.bounds.height ) / 2 ,
                                       width: playButton.bounds.width, height: playButton.bounds.height);
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
