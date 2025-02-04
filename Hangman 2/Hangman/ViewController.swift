//
//  ViewController.swift
//  Hangman
//
//  Created by Faraz Ahmed on 2024-10-09.
//

import UIKit

class ViewController: UIViewController {

    //MARK: - Properties
    let words = ["improve", "foreign", "smoking", "helping", "medical", "jointly", "auction", "journal", "himself", "kingdom", "parking", "organic", "serving","running"]
    var correctChoices: [Int] = []
    var guessedWord: String = ""
    var lostCount: Int = 0
    var winCount: Int = 0
    var wordCount: Int = 1
    
    //MARK: - IBOutlets
    @IBOutlet var keyboardKeysCollection: [UIButton]!
    @IBOutlet weak var labelLossCount: UILabel!
    @IBOutlet weak var labelWinCount: UILabel!
    @IBOutlet weak var imageHead: UIImageView!
    @IBOutlet weak var imageSmile: UIImageView!
    @IBOutlet weak var imageLeftLeg: UIImageView!
    @IBOutlet weak var imageSad: UIImageView!
    @IBOutlet weak var imageRightLeg: UIImageView!
    @IBOutlet weak var imageLeftARM: UIImageView!
    @IBOutlet weak var imageRightArm: UIImageView!
    @IBOutlet weak var imageBody: UIImageView!
    @IBOutlet var buttonCollection: [UIButton]!
    
    //MARK: - View Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.guessedWord = self.words.randomElement() ?? "" //Random word from the collection
        print(self.guessedWord)
        self.setupImagesInitially()
    }
    
    /*
     This method is responsible to prepare the image views initially. Includes hiding of image views.
     */
    fileprivate func setupImagesInitially() {
        self.imageSad.isHidden = true
        self.imageRightArm.isHidden = true
        self.imageBody.isHidden = true
        self.imageLeftARM.isHidden = true
        self.imageRightLeg.isHidden = true
        self.imageHead.isHidden = true
        self.imageSmile.isHidden = true
        self.imageLeftLeg.isHidden = true
    }
    
    /*
     This method caters the alert shown once the entire game is completed, with a status parameter
     -status: A boolean value to handle win and loss messages.
     The actions are a yes or a no
     -yes: All states or attributes are reset followed by dismissal of alert
     -no: No change, just dismisses the alert
     */
    fileprivate func showAlert(status: Bool) {
        let alert = UIAlertController(title: status == true ? AppConstants.successAlertTitle : AppConstants.failureAlertTitle, message: status == true ?  AppConstants.successAlertMessage : AppConstants.failureAlertMessage + self.guessedWord + AppConstants.playAgainMessage, preferredStyle: .alert)
        let actionYes = UIAlertAction(title: "Yes", style: .default) {_ in
            self.setupImagesInitially()
            self.guessedWord = self.words.randomElement() ?? ""
            print(self.guessedWord)
            self.wordCount = 1
            self.correctChoices.removeAll()
            for button in self.buttonCollection {
                button.setTitle("_", for: .normal)
            }
            
            for keyboardKey in self.keyboardKeysCollection {
                keyboardKey.tintColor = UIColor.tintColor
            }
            alert.dismiss(animated: true)
        }
        
        let actionNo = UIAlertAction(title: "No", style: .destructive) {_ in
            alert.dismiss(animated: true)
        }
        
        alert.addAction(actionYes)
        alert.addAction(actionNo)
        self.present(alert, animated: true)
    }

    
    /*
     This method handles the on-screen keyboard interaction.
     */
    @IBAction func didTapKeyboard(_ sender: UIButton) {
        guard let selectedKey = sender.titleLabel?.text?.lowercased() else { return } //retrieving the text from the button pressed
        
    
        //A conditional statement, which performs particular actions when a button is pressed, if the substring exists in the randomly guessed word, the tint color changes, and title is set for the correct guess a user makes.
        if self.guessedWord.contains(selectedKey) {
            sender.tintColor = UIColor.green
            self.settingTitlesForCorrectSelections(selectedKey: selectedKey)
            if self.correctChoices.count == 7 {
                self.winCount += 1
                self.labelWinCount.text = "\(self.winCount)"
                self.imageSmile.isHidden = false
                self.imageHead.isHidden = false
                self.showAlert(status: true)
            }
        } else {
            //This part of the condition, changes the tint color for the wrong guess.
            sender.tintColor = UIColor.red
            self.configureImageViewsOnUserResponse()
        }
    }
    
    /*
     This method calculates the range of the guessed substring, and retrieves the index, so it updates the selected text on the UI for the correct guess.
     */
    fileprivate func settingTitlesForCorrectSelections(selectedKey: String) {
        if let range: Range<String.Index> = self.guessedWord.range(of: selectedKey) {
            let index: Int = self.guessedWord.distance(from: self.guessedWord.startIndex, to: range.lowerBound)
            self.buttonCollection[index].setTitle(selectedKey.uppercased(), for: .normal)
            self.correctChoices.append(1)
        }
    }
    
    /*
     This method contains a switch statement, for every wrong guess, the image views visibility is handled, and the word count for the wrong guess is incremented.
     */
    fileprivate func configureImageViewsOnUserResponse() {
        switch self.wordCount {
        case 1:
            self.wordCount += 1
            self.imageHead.isHidden = false
        case 2:
            self.wordCount += 1
            self.imageBody.isHidden = false
        case 3:
            self.wordCount += 1
            self.imageLeftARM.isHidden = false
        case 4:
            self.wordCount += 1
            self.imageRightArm.isHidden = false
        case 5:
            self.wordCount += 1
            self.imageLeftLeg.isHidden = false
        case 6:
            self.wordCount += 1
            self.imageRightLeg.isHidden = false
        case 7:
            self.wordCount += 1
            self.imageSad.isHidden = false
            self.lostCount += 1
            self.labelLossCount.text = "\(self.lostCount)"
            self.showAlert(status: false)
        default:
            print("failed")
        }
    }
}



