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
	
	static func process(textToAnalyze: String, noteComplexity: Int) {
		let naturalLanguageUnderstanding = NaturalLanguageUnderstanding(username: "73a403ef-8e18-45c2-ae92-70e9c1db7089", password: "OYNOJ0oY8UsV", version: "2016-01-23")
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
		filteredText = filteredText.replacingOccurrences(of: "%HESITATION", with: ".")
		var subjectDict = [String: [String]]()
		//var sentences = filteredText.characters.split(separator: ".").map(String.init)
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
                var oldSubject: String?
				for role in results.semanticRoles! {
                    
                    //var oldSubject: String
                    
					guard var subject = role.subject?.text else {
						continue
					}
					guard let action = role.action?.text else {
						continue
					}
					guard let object = role.object?.text else {
						continue
					}
                    

                    if oldSubject != nil && subject == "it" || subject == "them" {
                        subject = oldSubject!
                    }
                    
                    oldSubject = subject
                    
					let key = getFirstWordsOf(subject, numWords: noteComplexity)
                    
					if subjectDict[key] == nil {
						subjectDict[key] = [String]()
					}

					subjectDict[key]?.append("\(getFirstWordsOf(action, numWords: noteComplexity)) \(getFirstWordsOf(object, numWords: noteComplexity))")
				}
				for (key, val) in subjectDict {
					subjectDict[key] = removeSimilarItems(array: val)
				}
				var resArray = [(String, Bool)]()
				for (key, val) in subjectDict {
					print(key)
                    if val.count > 1 {
                        resArray.append((key, true))
                        for item in val {
                            print(item)
                            resArray.append((item, false))
                        }
                    }
                    else {
                        resArray.append(("- \(key) \(val[0])", true))
                    }
				}
                DispatchQueue.main.async {
                    delegate?.resultsReceived(results: resArray)
                }
			}
		//}
		
	}
	
	private static func removeSimilarItems(array: [String]) -> [String] {
		if array.count > 1 {
			var res = [String]()
			for i in 1..<array.count {
				if array[i].contains(array[i-1]) || array[i-1].contains(array[i]) {
					if array[i].characters.count > array[i-1].characters.count {
						res.append(array[i])
					} else {
						res.append(array[i-1])
					}
				}
				else {
					res.append(array[i])
					if i == 1 {
						res.append(array[0])
					}
				}
			}
			return res
		} else {
			return array
		}
	}
	
	//get first three words
	private static func getFirstWordsOf(_ string: String, numWords: Int) -> String {
		let arr = string.components(separatedBy: " ")
		let endIndex = arr.count > numWords ? numWords : arr.count
		let firstThree = arr[0..<endIndex]
		return firstThree.joined(separator: " ")
	}
}

protocol SummaryEngineDelegate {
	func resultsReceived(results : [(String, Bool)])
}
