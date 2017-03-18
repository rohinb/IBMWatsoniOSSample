//
//  ViewController.swift
//  IBMWatsonSample
//
//  Created by Rohin Bhushan on 3/16/17.
//  Copyright © 2017 DreamTeam5Ever. All rights reserved.
//

import UIKit
import NaturalLanguageClassifierV1
import AlchemyLanguageV1
import SpeechToTextV1

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var startRecordingButton: UIButton!
    @IBOutlet weak var recordingTableView: UITableView!
    @IBOutlet weak var blurView: UIVisualEffectView!
    
    let sampleCell = ["Swift is your god now, obey the true almighty meme lord","Tuesday at 4:30 pm","14:05"]
    
	override func viewDidLoad() {
		super.viewDidLoad()

        sttSetup()
        tableViewGradient()
        designSetup()
	}
    
    func sttSetup() {
        // Hackpassword1!
        // HackSpeechToText, credential: RohinCredential
        let stt = SpeechToText(username: "1842c225-fd2b-4c6a-8c47-5fdbdf99dc78", password: "P45oQOnWySuU")
        stt.serviceURL = "https://stream.watsonplatform.net/speech-to-text/api"
        print(stt)
        let settings = RecognitionSettings(contentType: .basic)
        stt.recognizeMicrophone(settings: settings) { (res) in
            print(res)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            stt.stopRecognizeMicrophone()
            
        }
    }
    
    func designSetup() {
        startRecordingButton.layer.cornerRadius = 5.0
    }
    
    func tableViewGradient() {
        
        let gradient = CAGradientLayer(layer: recordingTableView.layer)
        gradient.frame = recordingTableView.bounds
        gradient.colors = [UIColor.clear.cgColor, UIColor.blue.cgColor]
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 0.0, y: 0.75)
        recordingTableView.superview?.layer.mask = gradient
    }
    
    // MARK: Recording
    
    @IBAction func startRecordingClicked(_ sender: UIButton) {
        
        let blurEffect = UIBlurEffect(style: .dark)
        blurView.effect = blurEffect
        if sender.tag == 0 {
            sender.setTitle("Stop Recording", for: .normal)
            sender.tag = 1
        } else {
            sender.setTitle("Start Recording", for: .normal)
            blurView.effect = nil
        }
    }
    
    
    

    // MARK: Table View Stuff
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = recordingTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RecordingTableViewCell
        
        cell.titleLabel.text = sampleCell[0]
        cell.dateLabel.text = sampleCell[1]
        cell.lengthLabel.text = sampleCell[2]
        
        return UITableViewCell()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

}

class RecordingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var lengthLabel: UILabel!
    
    override func awakeFromNib() {
        
    }
    
    
}









