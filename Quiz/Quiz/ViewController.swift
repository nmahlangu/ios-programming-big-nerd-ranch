//
//  ViewController.swift
//  Quiz
//
//  Created by Nicholas Mahlangu on 1/12/16.
//  Copyright © 2016 Big Nerd Ranch. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var questionLabel: UILabel!
    @IBOutlet var answerLabel: UILabel!
    
    let questions : [String] = ["From what is cognac made?",
                                "What is 7 + 7?",
                                "What is the capital of Vermont?"]
    let answers: [String] = ["Grapes", "14", "Montpelier"]
    var currentQuestionIndex: Int = 0
    
    @IBAction func showNextQuestion(sender: AnyObject) {
        currentQuestionIndex = (currentQuestionIndex + 1) % questions.count
        questionLabel.text = questions[currentQuestionIndex]
        answerLabel.text = "???"
    }
    
    @IBAction func showAnswer(sender: AnyObject) {
        answerLabel.text = answers[currentQuestionIndex]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionLabel.text = questions[currentQuestionIndex]
    }
}

