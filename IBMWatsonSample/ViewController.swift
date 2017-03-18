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
    
    let stt = SpeechToText(username: "1842c225-fd2b-4c6a-8c47-5fdbdf99dc78", password: "P45oQOnWySuU")
    var settings = RecognitionSettings(contentType: .basic)
    
    var originalTextViewPosition = CGPoint()
    
    var currentText = "" {
        didSet {
            let UISpecificFilteredText = currentText.replacingOccurrences(of: "%HESITATION", with: "")
            recordingTextView.text = UISpecificFilteredText
            self.textViewDidChange()
        }
    }
    
    var recordedLines = 0
    
    var noteArray : [(String,Bool)]? = [("Astronomy",true), ("was pretty freaking cool",false), ("was not actually lol",false)]
    
    @IBOutlet weak var notesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //		let textToAnalyze = "Although astronomy is as ancient as recorded history itself, it was long separated from the study of terrestrial physics. In the Aristotelian worldview, bodies in the sky appeared to be unchanging spheres whose only motion was uniform motion in a circle, while the earthly world was the realm which underwent growth and decay and in which natural motion was in a straight line and ended when the moving object reached its goal. Consequently, it was held that the celestial region was made of a fundamentally different kind of matter from that found in the terrestrial sphere; either Fire as maintained by Plato, or Aether as maintained by Aristotle. During the 17th century, natural philosophers such as Galileo, Descartes, and Newton began to maintain that the celestial and terrestrial region-s were made of similar kinds of material and were subject to the same natural laws. Their challenge was that the tools had not yet been invented with which to prove these assertions. For much of the nineteenth century, astronomical research was focused on the routine work of measuring the positions and computing the motions of astronomical objects. A new astronomy, soon to be called astrophysics, began to emerge when William Hyde Wollaston and Joseph von Fraunhofer independently discovered that, when decomposing the light from the Sun, a multitude of dark lines (regions where there was less or no light) were observed in the spectrum. By 1860 the physicist, Gustav Kirchhoff, and the chemist, Robert Bunsen, had demonstrated that the dark lines in the solar spectrum corresponded to bright lines in the spectra of known gases, specific lines corresponding to unique chemical elements. Kirchhoff deduced that the dark lines in the solar spectrum are caused by absorption by chemical elements in the Solar atmosphere. In this way it was proved that the chemical elements found in the Sun and stars were also found on Earth."
        
        SummaryEngine.delegate = self
        
        sttSetup()
        designSetup()
    }
    
    
    func sttSetup() {
        
        stt.serviceURL = "https://stream.watsonplatform.net/speech-to-text/api"
        print(stt)
        settings.interimResults = true
        settings.continuous = true
        
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
    
    
    
}








