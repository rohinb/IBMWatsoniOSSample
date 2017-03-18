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
	static func process(textToAnalyze: String) {
		let naturalLanguageUnderstanding = NaturalLanguageUnderstanding(username: "c74116ac-99d9-4177-a368-436ffa4f7e00", password: "et6zAj7aCoKm", version: "2016-01-23")
		
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
		for sentence in filteredText.characters.split(separator: ".").map(String.init) {
			let parameters = Parameters(features: features, text: sentence)
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

					print("- \(getFirstWordsOf(subject)) \(getFirstWordsOf(action)) \(getFirstWordsOf(object))")
					
				}
			}
		}
	}
	
	//get first three words
	private static func getFirstWordsOf(_ string: String) -> String {
		let arr = string.components(separatedBy: " ")
		let numWords = 5
		let endIndex = arr.count > numWords ? numWords : arr.count
		let firstThree = arr[0..<endIndex]
		return firstThree.joined(separator: " ")
	}
}
