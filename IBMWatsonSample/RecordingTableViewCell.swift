//
//  RecordingTableViewCell.swift
//  IBMWatsonSample
//
//  Created by Sahand Edrisian on 3/18/17.
//  Copyright © 2017 DreamTeam5Ever. All rights reserved.
//

import UIKit


class RecordingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var lengthLabel: UILabel!
    
    override func awakeFromNib() {
        
    }
    
}


class NotesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var noteLabel: UILabel!
    var isHeader = false
    
    override func awakeFromNib() {
        if isHeader {
            noteLabel.font = UIFont(name: "AvenirNext-Medium", size: 19)
        } else {
            noteLabel.font = UIFont(name: "AvenirNext-Light", size: 17)
            let bulletPoint: String = "\u{2022}"
            noteLabel.text = "  \(bulletPoint) \(noteLabel.text)"
        }
    }
    
}
