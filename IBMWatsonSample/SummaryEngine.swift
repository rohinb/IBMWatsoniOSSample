//
//  SummaryEngine.swift
//  IBMWatsonSample
//
//  Created by Rohin Bhushan on 3/17/17.
//  Copyright © 2017 DreamTeam5Ever. All rights reserved.
//

import Foundation

import NaturalLanguageUnderstandingV1

struct SummaryEngine {
	static var delegate : SummaryEngineDelegate?
	
	static func process(textToAnalyze: String) {
		let naturalLanguageUnderstanding = NaturalLanguageUnderstanding(username: "6d022503-94eb-44b0-91b5-52034a59f198", password: "zfZuJsCWq6cd", version: "2016-01-23")
		
		let concepts = ConceptsOptions(limit: 50, linkedData: true)
		let emotions = EmotionOptions(document: nil, targets: nil)
		let entities = EntitiesOptions(limit: 50, model: nil, disambiguation: nil, sentiment: nil)
		let categories = CategoriesOptions()
		let semantics = SemanticRolesOptions(limit: 500, keywords: true, entities: true, requireEntities: true, disambiguate: false)
		let features = Features(concepts: concepts, emotion: emotions, entities: entities, keywords: nil, metadata: nil, relations: nil, semanticRoles: semantics, sentiment: nil, categories: categories)
		
		let failure = { (error: Error) in print(error) }
		var filteredText = textToAnalyze.replacingOccurrences(of: "of ", with: "")
		filteredText = filteredText.replacingOccurrences(of: "the ", with: "")
		filteredText = filteredText.replacingOccurrences(of: "a ", with: "")
		filteredText = filteredText.replacingOccurrences(of: "an ", with: "")
		filteredText = filteredText.replacingOccurrences(of: "%HESITATION", with: "")
		var subjectDict = [String: [String]]()
		var sentences = filteredText.characters.split(separator: ".").map(String.init)
		//for (index, sentence) in sentences.enumerated() {
			let parameters = Parameters(features: features, text: filteredText)
			//print(sentence)
			naturalLanguageUnderstanding.analyzeContent(withParameters: parameters, failure: failure) {
				results in
				/*for concept in results.concepts! {
					print(concept.name!, concept.relevance!)
				}
				print(results.entities!)
				print(results.categories!)
				print(results.semanticRoles!)
				*/
				for role in results.semanticRoles! {
					guard let subject = role.subject?.text else {
						continue
					}
					guard let action = role.action?.text else {
						continue
					}
					guard let object = role.object?.text else {
						continue
					}
					let key = getFirstWordsOf(subject)
					if subjectDict[key] == nil {
						subjectDict[key] = [String]()
					}

					subjectDict[key]?.append("- \(getFirstWordsOf(action)) \(getFirstWordsOf(object))")
				}
				delegate?.resultsReceived(infoDict: subjectDict)
				//if index == sentences.count - 1 {
//					for (key, val) in subjectDict {
//						print(key)
//						for item in val {
//							print(item)
//						}
//					}
				//}
			}
		//}
		
	}
	
	//get first three words
	private static func getFirstWordsOf(_ string: String) -> String {
		let arr = string.components(separatedBy: " ")
		let numWords = 8
		let endIndex = arr.count > numWords ? numWords : arr.count
		let firstThree = arr[0..<endIndex]
		return firstThree.joined(separator: " ")
	}
}

protocol SummaryEngineDelegate {
	func resultsReceived(infoDict : [String: [String]])
}
