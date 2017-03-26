//
//  ViewControllerExtension.swift
//  IBMWatsonSample
//
//  Created by Sahand Edrisian on 3/18/17.
//  Copyright © 2017 DreamTeam5Ever. All rights reserved.
//

import UIKit

extension ViewController {
    
    // MARK: Recording
    
    @IBAction func startRecordingClicked(_ sender: UIButton) {
        
        if sender.tag == 0 {
            sender.setTitle("Stop Recording", for: .normal)
            sender.tag = 1
            addBlurView()

            recordingTextView.animateAlpha(1, t: 0.3)
            writtenButton.animateAlpha(0, t: 0.3)
            sstStart()
        } else if sender.tag == 1 {
            sender.setTitle("Start Recording", for: .normal)
            sender.isEnabled = false
            popupView.animateAlpha(1, t: 0.3)
            sstStop()
        } else if sender.tag == 2 {
            sender.setTitle("Start Recording", for: .normal)
            sender.tag = 0
            removeBlurView()
            textViewSpeakingMode()
            notesTableView.animateAlpha(0, t: 0.3)
            writtenButton.animateAlpha(1, t: 0.3)
            shareButton.animateAlpha(0, t: 0.3)

            view.bringSubview(toFront: recordingTableView)
        } else if sender.tag == 3 {
            sender.setTitle("Done!", for: .normal)
            sender.tag = 2
            popupView.animateAlpha(1, t: 0.3)
        }
        
    }
    
    // Check for new text view lines
    
    func textViewDidChange() {
        let lines = numberOfLines(textView: recordingTextView)
        if lines > recordedLines {
            recordedLines = lines
            moveTextViewUp()
        }
    }
    
    // get number of lines
    
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
    
    // Move text view up
    
    func moveTextViewUp() {
        UIView.animate(withDuration: 0.3) {
            self.recordingTextView.frame.size.height += self.recordingTextView.font!.lineHeight
            self.recordingTextView.frame.origin.y -= self.recordingTextView.font!.lineHeight
        }
    }
    
    // When done button in popup clicked
    
    @IBAction func doneButtonClicked(_ sender: Any) {
        
        if noteTypeSegment.selectedSegmentIndex == 0 {
            
        } else {
            let type = noteTypeSegment.selectedSegmentIndex * 4
            createNote(type: type)
            popupView.animateAlpha(0, t: 0.3)
            startRecordingButton.tag = 2
            startRecordingButton.isEnabled = true
            startRecordingButton.setTitle("Done!", for: .normal)
            notesTableView.animateAlpha(1, t: 0.3)
            recordingTextView.animateAlpha(0, t: 0.3)
            shareButton.animateAlpha(1, t: 0.3)

        }
        
    }
    
    // Create a note
    
    func createNote(type: Int) {
        SummaryEngine.process(textToAnalyze: recordingTextView.text, noteComplexity: type)
        
    }
    
    
    // move textview back to original state
    
    func textViewReadingMode() {
        recordingTextView.animateAlpha(0, t: 0.3)
        notesTableView.animateAlpha(1, t: 0.3)
//        recordingTextView.isEditable = false
//        recordingTextView.isSelectable = true
//        recordingTextView.frame.origin.y = 35
//        recordingTextView.isScrollEnabled = true
    }
    
    func textViewSpeakingMode() {
        recordingTextView.isEditable = false
        recordingTextView.isSelectable = true
        recordingTextView.isScrollEnabled = false
        recordingTextView.frame.origin = originalTextViewPosition
        recordingTextView.animateAlpha(0, t: 0.3)
        notesTableView.animateAlpha(0, t: 0.3)
    }
    
    
}
