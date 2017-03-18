//
//  ViewControllerTableView.swift
//  IBMWatsonSample
//
//  Created by Sahand Edrisian on 3/18/17.
//  Copyright © 2017 DreamTeam5Ever. All rights reserved.
//

import UIKit

extension ViewController {
    
    // MARK: Table View Stuff
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : UITableViewCell
        if tableView == recordingTableView {
            cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RecordingTableViewCell
            
            (cell as! RecordingTableViewCell).titleLabel.text = sampleCell[0]
            (cell as! RecordingTableViewCell).dateLabel.text = sampleCell[1]
            (cell as! RecordingTableViewCell).lengthLabel.text = sampleCell[2]
            
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! NotesTableViewCell
            (cell as! NotesTableViewCell).noteLabel.text = noteArray![indexPath.row].0
            (cell as! NotesTableViewCell).isHeader = noteArray![indexPath.row].1
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
}
