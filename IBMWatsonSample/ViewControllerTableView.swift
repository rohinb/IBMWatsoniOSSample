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
        var cell = UITableViewCell()
        
        if tableView == recordingTableView {
            cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RecordingTableViewCell
            
            
            (cell as! RecordingTableViewCell).titleLabel.text = transcripts[indexPath.row]
            (cell as! RecordingTableViewCell).dateLabel.text = times[indexPath.row]
            (cell as! RecordingTableViewCell).lengthLabel.text = chars[indexPath.row]
            
        } else {
            if notess.count >= 10 {
                cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! NotesTableViewCell
                (cell as! NotesTableViewCell).noteLabel.text = noteArray![indexPath.row].0
                (cell as! NotesTableViewCell).isHeader = noteArray![indexPath.row].1
                (cell as! NotesTableViewCell).reload()
            }
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == recordingTableView {
            //            var notes = notesDefaults.value(forKey: "notes") as! [(String,String,[(String,Bool)],Int)]
            return 10
        } else {
            return (noteArray?.count)!
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == recordingTableView {
            return 90.0
        } else {
            return 45.0
        }
    }
}
