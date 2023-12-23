//
//  TitleScreenViewController.swift
//  Hangman Project
//
//  Created by Nirmal Baby on 2023-12-23.
//

import UIKit

class TitleScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func playGameBtn(_ sender: UIButton) {
        performSegue(withIdentifier: "goToGameScreen", sender: self)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
