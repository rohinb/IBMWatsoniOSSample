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
import NaturalLanguageUnderstandingV1

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, SummaryEngineDelegate {
    
    
    @IBOutlet weak var startRecordingButton: UIButton!
    @IBOutlet weak var recordingTableView: UITableView!
    @IBOutlet weak var recordingTextView: UITextView!
    @IBOutlet weak var containerView: UIView!
    var blurView = UIVisualEffectView()
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var noteTypeSegment: UISegmentedControl!
    
    let sampleCell = ["Swift is your god now, obey the true almighty meme lord","Tuesday at 4:30 pm","14:05"]
    
    let stt = SpeechToText(username: "efb3a23d-c1c0-4cac-b4a6-795aa4b1f132", password: "C5WyyhXUrNWC")
    var settings = RecognitionSettings(contentType: .basic)
    
    var originalTextViewPosition = CGPoint()
    
    var currentText = "" {
        didSet {
            let UISpecificFilteredText = currentText.replacingOccurrences(of: "%HESITATION", with: ".")
            recordingTextView.text = UISpecificFilteredText
            self.textViewDidChange()
        }
    }
    @IBOutlet weak var writtenButton: UIButton!
    
    var recordedLines = 0
    
    var noteArray : [(String,Bool)]? = [("",true)]
    
    @IBOutlet weak var notesTableView: UITableView!

    
    
    
    var transcripts = ["Any way you slice it, cheese is considered by many to be a favorite food, whether cut into cubes as a snack, grated over pasta, layered in a sandwich or melted as a topping for pizza. Cheese can transform easily from a solid to a gooey liquid and back to a solid again. So it should come as no surprise that cheese is also a candidate for experiments with food and 3D printers. These projects involve squeezing a gel, paste or semiliquid material through a nozzle to shape it into a solid — and edible — object. In a recent study, scientists 3D-printed cheese and conducted a series of tests evaluating its texture, resilience and 'meltability,' to see how this cheese from the future would stack up — on a structural level — against regular processed cheese. The inspiration for the researchers' investigation was a question posed by a cheese manufacturer, who wondered how cheese might be used as a raw material in kitchens that are likely to be equipped with 3D printers in the not-so-distant future, study co-author Alan Kelly, a professor in the School of Food and Nutritional Sciences at University College Cork in Ireland, told Live Science in an email. Kelly was familiar with 3D printing and had studied cheese and dairy projects for 20 years, but this was the first time he'd thought to bring the two together, he said. Processed cheese is produced using techniques that 3D printing mimics very closely —mixing ingredients and molding them into a new shape. And 3D-printing cheese could provide valuable insight for engineers who are still developing materials for 3D printing, which need to be fluid enough to flow through a nozzle but also capable of settling into 'a buildable shape and structure,' Kelly explained.",
                       "Hey Gregg, I am calling today to ask you about the project. How is it going? When will you be done? investigation was a question posed by a cheese manufacturer, who wondered how cheedable shape and structure,' Kelly explained.",
                       "Ok, also don’t forget to call the San Fransisco office to let them know about the new project.",
                       "As long ago as 1860 it was the proper thing to be born at home. At present, so I am told, the high gods of medicine have decreed that the first cries of the young shall be utter.",
                       "On the September morning consecrated to the enormous event he arose nervously at six o'clock,into 'a buildable shape and structure,' Kelly explained.",
                       "When you read back the array you need to unarchive the NSData to get back your BC_Person objects.",
                       "First recognized in 1900 by Max Planck, it was originally the proportionality constant between the minimal increment of energy, E, of a hypot with a 'quantum' or minimal element of the energy of the electromagnetic wave itself. ",
                       "Any way you slice it, cheese is considered by many toalso capable of settling into 'a buildable shape and structure,' Kelly explained.",
                       "Any way you slice it, cheese is considered by man sandwich or melted as a topping for pizza. buildable shape and structure,' Kelly explained.",
                       "First recognized in 1900 by Max Planck, it was originally the proportionality constant betwe with a 'quantum' or minimal element of the energy of the electromagnetic wave itself. "]
    
    var notess = [[(String,Bool)]]()
    
    var times = ["Saturday at 4:56 am",
                 "Saturday at 4:53 am",
                 "Saturday at 4:44 am",
                 "Saturday at 4:40 am",
                 "Saturday at 4:32 am",
                 "Saturday at 4:22 am",
                 "Saturday at 4:10 am",
                 "Saturday at 3:59 am",
                 "Saturday at 3:38 am",
                 "Saturday at 3:01 am"]
    
    var chars = ["1412",
                 "1201",
                 "430",
                 "140",
                 "349",
                 "994",
                 "545",
                 "765",
                 "1003",
                 "1753"]
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        		let textToAnalyze = "Any way you slice it, cheese is considered by many to be a favorite food, whether cut into cubes as a snack, grated over pasta, layered in a sandwich or melted as a topping for pizza. Cheese can transform easily from a solid to a gooey liquid and back to a solid again. So it should come as no surprise that cheese is also a candidate for experiments with food and 3D printers. These projects involve squeezing a gel, paste or semiliquid material through a nozzle to shape it into a solid — and edible — object. In a recent study, scientists 3D-printed cheese and conducted a series of tests evaluating its texture, resilience and 'meltability,' to see how this cheese from the future would stack up — on a structural level — against regular processed cheese. The inspiration for the researchers' investigation was a question posed by a cheese manufacturer, who wondered how cheese might be used as a raw material in kitchens that are likely to be equipped with 3D printers in the not-so-distant future, study co-author Alan Kelly, a professor in the School of Food and Nutritional Sciences at University College Cork in Ireland, told Live Science in an email. Kelly was familiar with 3D printing and had studied cheese and dairy projects for 20 years, but this was the first time he'd thought to bring the two together, he said. Processed cheese is produced using techniques that 3D printing mimics very closely —mixing ingredients and molding them into a new shape. And 3D-printing cheese could provide valuable insight for engineers who are still developing materials for 3D printing, which need to be fluid enough to flow through a nozzle but also capable of settling into 'a buildable shape and structure,' Kelly explained."
        
        
        
        SummaryEngine.delegate = self

        for i in 0...9 {
            SummaryEngine.process(textToAnalyze: transcripts[i], noteComplexity: 8)
        }

        sttSetup()
        designSetup()
	}
    
    var counter = 0
	
    func resultsReceived(results: [(String, Bool)]) {

        noteArray = results

        notess.append(results)
        counter += 1
        if counter > 10 {
        notesTableView.reloadData()
        }
    }
    
    func sttSetup() {
        
        stt.serviceURL = "https://stream.watsonplatform.net/speech-to-text/api"
//        print(stt)
        settings.interimResults = true
        settings.continuous = true
        
    }
    
    func sstStart() {
        stt.recognizeMicrophone(settings: settings) { (res) in
//            print(res)
            self.currentText = res.bestTranscript
        }
    }
    
    func sstStop() {
        stt.stopRecognizeMicrophone()
    }
    
    func designSetup() {
        startRecordingButton.layer.cornerRadius = 5.0
        recordingTextView.alpha = 0
        originalTextViewPosition = recordingTextView.frame.origin
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
    
    
    @IBAction func keyboardButtonClicked(_ sender: Any) {
        
        addBlurView()
        recordingTextView.animateAlpha(1, t: 0.3)
        recordingTextView.frame.origin.y = 35.0
        recordingTextView.frame.size.height = 1400.0
        view.layoutIfNeeded()
        recordingTextView.isEditable = true
        recordingTextView.isScrollEnabled = true
        recordingTextView.isSelectable = true
        recordingTextView.becomeFirstResponder()
        startRecordingButton.setTitle("Summarize!", for: .normal)
        startRecordingButton.tag = 3
        writtenButton.animateAlpha(0, t: 0.3)
        sstStop()
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        view.endEditing(true)
        return true
    }
    
    
}








