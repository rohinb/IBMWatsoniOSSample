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

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
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

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}

