//
//  ViewController.swift
//  FollowMe
//
//  Created by Blake Wallick on 12/5/21.
//

import UIKit

class ViewController: UIViewController, UIAlertViewDelegate {

    enum ButtonColor: Int {
        case Red = 1
        case Blue = 2
        case Yellow = 3
        case Green = 4
    }

    enum WhoseTurn {
        case Human
        case Computer
        //use these below for multiplayer action!
        //case P1
        //case P2
        //case P3
    }

    // view related objects and variables
    @IBOutlet weak var redButton: UIButton!
    @IBOutlet weak var blueButton: UIButton!
    @IBOutlet weak var yellowButton: UIButton!
    @IBOutlet weak var greenButton: UIButton!

    // model related objects and variables
    let winningNumber: Int = 25
    var currentPlayer: WhoseTurn = .Computer
    var inputs = [ButtonColor]()
    var indexOfNextButtonToTouch: Int = 0

    //make this a user-chosen number for a 'difficulty setting'
    var highlightSquareTime = 0.5

    override func viewDidLoad(){
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated
    }

    override func viewDidAppear(_ animated: Bool) {
        startNewGame()
    }

    func buttonByColor(color: ButtonColor) -> UIButton {
        switch color {
        case .Red:
            return redButton
        case .Blue:
            return blueButton
        case .Yellow:
            return yellowButton
        case .Green:
            return greenButton
        }
    }

    func playSequence(index: Int, highlightTime: Double) {
        currentPlayer = .Computer

        if index == inputs.count {
            currentPlayer = .Human
            return
        }

        let button: UIButton = buttonByColor(color: inputs[index])
        let originalColor: UIColor? = button.backgroundColor
        let highlightColor: UIColor = UIColor.white

        UIView.animate(
            withDuration: highlightTime,
            delay: 0.0,
            options: UIView.AnimationOptions.curveLinear.intersection(.allowUserInteraction).intersection(.beginFromCurrentState),
            animations: {
                button.backgroundColor = highlightColor
            },
            completion: { finished in
                button.backgroundColor = originalColor
                let newIndex: Int = index + 1
                self.playSequence(index: newIndex, highlightTime: highlightTime)
            })
    }

    @IBAction func buttonTouched(sender: UIButton) {
        //determine which button was touched by looking at its tag
        let buttonTag: Int = sender.tag

        if let colorTouched = ButtonColor(rawValue: buttonTag) {
            if currentPlayer == .Computer {
            //ignore touches as long as this flag is set to true
            return
            }

            if colorTouched == inputs [indexOfNextButtonToTouch] {
                //the player touched the correct button...
                indexOfNextButtonToTouch += 1

            //determine if there are any more buttons left in this round
            if indexOfNextButtonToTouch == inputs.count {
                //the player has won this round
                if advanceGame() == false {
                    playerWins()
                }
                indexOfNextButtonToTouch = 0
            }
            else {
            // there are more buttons left in this round...keep going
            }
        }
        else {
            //the player touched the wrong button
            playerLoses()
            indexOfNextButtonToTouch = 0
        }
    }

        func alertView() {
            
        }

    func playerWins() {
        let winner: UIAlertView = UI alertView(title: "You won!", message: "Congratulations!", delegate: self, cancelButtonTitle: nil, otherButtonTitles: "Awesome!")
        winner.show()
    }

    func playerLoses() {
        let loser: UIAlertView = UIAlertView(title: "You lost!", message: "Sorry!", delegate: self, cancelButtonTitle: nil, otherButtonTitles: "Try again!")
        loser.show()
    }

    func startNewGame() -> Void {
        //randomize input array
        inputs = [ButtonColor]()
        advanceGame()
    }

    func advanceGame() -> Bool {
        var result: Bool = true

        if inputs.count == winningNumber {
            result = false
        } else {
            //add a new random number to the input list
            inputs += [randomButton()]

            // play the button sequence
            playSequence(0, highlightTime: highlightSquareTime)
        }
        return result
    }
}



