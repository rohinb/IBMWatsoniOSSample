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

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {
    
    @IBOutlet weak var startRecordingButton: UIButton!
    @IBOutlet weak var recordingTableView: UITableView!
    @IBOutlet weak var recordingTextView: UITextView!
    @IBOutlet weak var containerView: UIView!
    var blurView = UIVisualEffectView()
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var noteTypeSegment: UISegmentedControl!
    
    let sampleCell = ["Swift is your god now, obey the true almighty meme lord","Tuesday at 4:30 pm","14:05"]
    
    let stt = SpeechToText(username: "1842c225-fd2b-4c6a-8c47-5fdbdf99dc78", password: "P45oQOnWySuU")
    let settings = RecognitionSettings(contentType: .basic)
    
    var currentText = "" {
        didSet {
            recordingTextView.text = currentText
        }
    }
    
    var recordedLines = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sttSetup()
        //        tableViewGradient()
        designSetup()
    }
    
    func sttSetup() {
        stt.serviceURL = "https://stream.watsonplatform.net/speech-to-text/api"
    }
    
    func sstStart() {
        stt.recognizeMicrophone(settings: settings) { (res) in
            print(res)
            self.currentText = res.bestTranscript
        }
    }
    
    func sstStop() {
        stt.stopRecognizeMicrophone()
    }
    
    func designSetup() {
        startRecordingButton.layer.cornerRadius = 5.0
        recordingTextView.alpha = 0
    }
    
    func tableViewGradient() {
        
        let gradient = CAGradientLayer(layer: recordingTableView.layer)
        gradient.frame = recordingTableView.bounds
        gradient.colors = [UIColor.clear.cgColor, UIColor.blue.cgColor]
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 0.0, y: 0.75)
        recordingTableView.superview?.layer.mask = gradient
    }
    
    func addBlurView() {
        blurView = UIVisualEffectView()
        blurView.frame = view.bounds
        let blurEffect = UIBlurEffect(style: .light)
        containerView.addSubview(blurView)
        UIView.animate(withDuration: 0.3) {
            self.blurView.effect = blurEffect
        }
    }
    
    func removeBlurView() {
        UIView.animate(withDuration: 0.3) {
            self.blurView.effect = nil
        }
    }
    
    // MARK: Recording
    
    @IBAction func startRecordingClicked(_ sender: UIButton) {
        
        if sender.tag == 0 {
            sender.setTitle("Stop Recording", for: .normal)
            sender.tag = 1
            addBlurView()
            recordingTextView.animateAlpha(1, t: 0.3)
        } else if sender.tag == 1 {
            sender.setTitle("Start Recording", for: .normal)
            sender.tag = 0
            removeBlurView()
            recordingTextView.animateAlpha(0, t: 0.3)
            popupView.animateAlpha(1, t: 0.3)
        } else if sender.tag == 2 {
            
        }

    }
    
    func textViewDidChange(_ textView: UITextView) {
        let lines = numberOfLines(textView: textView)
        if lines > recordedLines {
            recordedLines = lines
            moveTextViewUp()
        }
    }
    
    func numberOfLines(textView: UITextView) -> Int {
        let layoutManager = textView.layoutManager
        let numberOfGlyphs = layoutManager.numberOfGlyphs
        var lineRange: NSRange = NSMakeRange(0, 1)
        var index = 0
        var numberOfLines = 0
        
        while index < numberOfGlyphs {
            layoutManager.lineFragmentRect(forGlyphAt: index, effectiveRange: &lineRange)
            index = NSMaxRange(lineRange)
            numberOfLines += 1
        }
        return numberOfLines
    }
    
    // MARK: Text View Stuff
    
    func moveTextViewUp() {
        UIView.animate(withDuration: 0.3) {
            self.recordingTextView.frame.size.height += self.recordingTextView.font!.lineHeight
            self.recordingTextView.frame.origin.y -= self.recordingTextView.font!.lineHeight
        }
    }
    
    // MARK: Popup Stuff
    
    @IBAction func doneButtonClicked(_ sender: Any) {
        
        if noteTypeSegment.selectedSegmentIndex == 0 {
            
        } else {
            let type = noteTypeSegment.selectedSegmentIndex * 4
            recordingTextView.text = createNote(type: type)
            changeTextView()
            popupView.animateAlpha(0, t: 0.3)
        }
        
    }
    
    func createNote(type: Int) -> String {
        
        return ""
    }
    
    func changeTextView() {
        recordingTextView.isEditable = false
        recordingTextView.isSelectable = true
        recordingTextView.frame.origin.y = 35
        recordingTextView.isScrollEnabled = true
        
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

extension UIView {
    func animateAlpha(_ a: CGFloat, t: Double) {
        UIView.animate(withDuration: t, animations: {
            self.alpha = a
        })
    }
}







