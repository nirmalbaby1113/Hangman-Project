//
//  ViewController.swift
//  Hangman Project
//
//  Created by Nirmal Baby on 2023-10-22.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var textBox1: UITextField!
    
    @IBOutlet weak var textBox2: UITextField!
    
    @IBOutlet weak var textBox3: UITextField!
    
    @IBOutlet weak var textBox4: UITextField!
    
    @IBOutlet weak var textBox5: UITextField!
    
    @IBOutlet weak var textBox6: UITextField!
    
    @IBOutlet weak var textBox7: UITextField!
    
    @IBOutlet weak var lossLabel: UILabel!
    
    @IBOutlet weak var winLabel: UILabel!
    
    @IBOutlet weak var imageHangMan: UIImageView!
    
    //The needed global varibales are decalared.
    var collectionOfWords: [String] = []
    var textBoxes: [UITextField] = []
    var imageNames: [String] = []
    var imageNamesChangeOnGameOver: [String] = []
    var usedKeys: [UIButton] = []
    var selectedWord = "NA"
    var correctButtonClick = 0
    var wrongButtonClick = 0
    var winCount = 0
    var lossCount = 0
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Score text is initializing to zero at the beginning of the game.
        winLabel.text = String(0)
        lossLabel.text = String(0)
        
        //All game variables and assets are initialized in this method.
        initializing()
        
        getRandomSevenLetterWord { word in
            
            self.selectedWord = word.uppercased()
        }
        
    }
    
    /*
     -This IBAction is connected with all the keyboard keys in the game. Using the parameter we recoginzed which key is pressed.
     - Method gameMEchanics is called when a key is pressed which manages the eniter game cycle.
     - All the concepts are modularized into functions so that later development of the game can be done easily.
     */
    @IBAction func btnKeys(_ sender: UIButton) {
        gameMechanics(sender: sender)
    }
    
    @IBAction func btnRestartGame(_ sender: UIButton) {
        let alertRestartBtn = UIAlertController (title: "Restart Game", message: "Would you like to restart the game?", preferredStyle: .alert)
        let noBtn = UIAlertAction(title: "No", style: .default,handler: { (action) in
            alertRestartBtn.dismiss(animated: true, completion: nil)
        })
        let yesBtn = UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            self.gameReset()
            alertRestartBtn.dismiss(animated: true, completion: nil)
        })
        alertRestartBtn.addAction(noBtn)
        alertRestartBtn.addAction(yesBtn)
        self.show(alertRestartBtn, sender: nil)
    }
    
    /*
     - The initializing of arrays and assets that needed for each game cycle is done here.
     */
    func initializing() {
        imageHangMan.image = nil
        imageNames = ["hangManAsset_Pole","hangManAsset_head","hangManAsset_body","hangManAsset_rightArm","hangManAsset_leftArm","hangManAsset_rightLeg","hangManAsset_full"]
        imageNamesChangeOnGameOver = ["hangManAsset_rightArm_happy","hangManAsset_rightLeg_happy"]
        textBoxes = [textBox1,textBox2,textBox3,textBox4,textBox5,textBox6,textBox7]
    }
    
    func getRandomSevenLetterWord(completion: @escaping (String) -> Void) {
        // Make network call to fetch random seven letter word
        guard let url = getURL() else {
            print("Error in getting URL.")
            return
        }
        
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: url) { data, response, error in
            guard error == nil else {
                print("Error on URL fetch.")
                return
            }
            
            guard let data = data else {
                print("No data found")
                return
            }
        
            if let wordFromApiResponse = self.parseJSON(data: data) {
                print("Words From: \(wordFromApiResponse)")
                print("Word Length: \(wordFromApiResponse.count)")
                
                // Call the completion handler with the word
                completion(wordFromApiResponse)
            }
        }
        dataTask.resume()
    }

    
    //The URL combined in this function with different parameters.
    private func getURL() -> URL? {
        //Create and return the URL of word API
        let baseURL = "https://random-word-api.herokuapp.com/"
        let currentEndpoint = "word?"
        let length = "length=7"

        let urlString = "\(baseURL)\(currentEndpoint)\(length)"
            
        print("URL : \(urlString)")

        // Use URL(string:) to create a URL object
        guard let url = URL(string: urlString) else {
            return nil
        }

        return url
    }
    
    private func parseJSON(data: Data) -> String? {
        let decoder = JSONDecoder()
        var wordsResponse: [String]?

        do {
            wordsResponse = try decoder.decode([String].self, from: data)
            // Concatenate the strings into a single string, separated by a space
            let concatenatedString = wordsResponse?.joined(separator: " ")
            print("Word: \(String(describing: concatenatedString))")
            return concatenatedString
        } catch let error {
            print("Error Decoding: \(error)")
            return nil
        }
    }
    
    /*
     - Enitre game logic is implemented in this method. Whenever a keyboard button click happens this method called.
     */
    func gameMechanics(sender: UIButton){
        var arrayOfOccuredIndexes: [Int] = []
        usedKeys.append(sender)
        print("Selected Word: \(selectedWord)")
        if (selectedWord.contains(sender.currentTitle ?? "ERROR")) {//If section executed when the pressed key contains in the selected word.
            sender.backgroundColor = UIColor.green
            
            //User interaction is disables because gamer is only allowed to click a key one time.
            sender.isUserInteractionEnabled = false
            
            for (index, character) in selectedWord.enumerated() {
                if character == sender.currentTitle?.first{
                    arrayOfOccuredIndexes.append(index)
                    correctButtonClick+=1
                }
            }
            
            for (index, value) in textBoxes.enumerated() {
                if arrayOfOccuredIndexes.contains(index) {
                    value.text = sender.currentTitle
                }
            }
            
        } else {//Else section executed when the pressed key is not there in the selected word.
            sender.backgroundColor = UIColor.red
            imageHangMan.image = UIImage(named: imageNames[wrongButtonClick])
            wrongButtonClick+=1
            //User interaction is disables because gamer is only allowed to click a key one time.
            sender.isUserInteractionEnabled = false
        }
        
        if (correctButtonClick == 7) {//When gamer guess the correct word gameWin method called.
            gameWin()
        }
        
        if (wrongButtonClick == 7) {//When the seven chances are over gameLoss method called.
            gameLoss()
        }
        
        
    }
    
    /*
     - This method called when the gamer guesses the word correctly.
     */
    func gameWin(){
        winCount+=1
        winLabel.text = String (winCount)
        
        if (wrongButtonClick == 5)
        {
            imageHangMan.image = UIImage(named: imageNamesChangeOnGameOver[0])
        } else if (wrongButtonClick == 6){
            imageHangMan.image = UIImage(named: imageNamesChangeOnGameOver[1]) 
        }
        
        let alert = UIAlertController (title: "Woohoo!", message: "You saved me! Would you like to play again?", preferredStyle: .alert)
        let noBtn = UIAlertAction(title: "Exit", style: .default,handler: { (action) in
            //If gamer needs to not want to return back to the game, Alert closed and do nothing as per the project requirement.
            self.dismiss(animated: true, completion: nil)
            self.performSegue(withIdentifier: "goToTitleScreen", sender: self)
        })
        let yesBtn = UIAlertAction(title: "Continue", style: .default, handler: { (action) in
            //If gamer needs to return back to the game, gameReset method is called.
            //Future development can be implemented here like do something to quit the game with showing proper statistics of the game or something else.
            self.gameReset()
            self.dismiss(animated: true, completion: nil)
        })
        alert.addAction(noBtn)
        alert.addAction(yesBtn)
        self.show(alert, sender: nil)
    }
     
    /*
     - This method called when the gamer's seven chances gets over.
     */
    func gameLoss(){
        lossCount += 1
        lossLabel.text = String(lossCount)
        let alert = UIAlertController (title: "Uh oh", message: "The correct word was \(selectedWord). Would you like to try again?", preferredStyle: .alert)
        let noBtn = UIAlertAction(title: "Exit", style: .default,handler: { (action) in
            
            self.dismiss(animated: true, completion: nil)
            self.performSegue(withIdentifier: "goToTitleScreen", sender: self)
        })
        let yesBtn = UIAlertAction(title: "Continue", style: .default, handler: { (action) in
            //If gamer needs to return back to the game, gameReset method is called.
            self.gameReset()
            self.dismiss(animated: true, completion: nil)
        })
        alert.addAction(noBtn)
        alert.addAction(yesBtn)
        self.show(alert, sender: nil)
    }
    
    /*
     - The method implements all the neccesary things that needed to bring back the game state to initial state.
     */
    func gameReset(){
        // All the used variables and assets are removed or initialized back into the state where it is in the beginning of the game. So that the next game cycle shouold be start with any logical mistakes.
        imageHangMan.image = nil
        for value in textBoxes {
                value.text = ""
        }
        for value in usedKeys {
            value.backgroundColor = UIColor.lightGray
            value.isUserInteractionEnabled = true
        }
        collectionOfWords = []
        textBoxes = []
        imageNames = []
        usedKeys = []
        selectedWord = "NA"
        correctButtonClick = 0
        wrongButtonClick = 0
        
        initializing()
        
        getRandomSevenLetterWord { word in
            self.selectedWord = word.uppercased()
        }
    }
}



