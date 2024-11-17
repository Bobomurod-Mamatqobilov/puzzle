//
//  ViewController.swift
//  Puzzles
//
//  Created by MacBook Pro on 17/11/24.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    let wd = UIScreen.main.bounds.width
    let hd = UIScreen.main.bounds.height
    
    var tm: CGFloat = 300
    var wm: CGFloat = 40
    var btnm: CGFloat = 3
    lazy var haw: CGFloat = (wd-2*wm)/4.0
    
    var btnText = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16"]
    var tag = 0
    var moveStack: [(buttonTag: Int, emptyButtonTag: Int)] = []
//    var currenttag: [Int] = []
    var checktag: [Int] = []
    
    let puzzleLabel = UIView()
    let steps = UILabel()
    
    let restart = UIButton()
    let orqaga = UIButton()
    
    var isRestartTapped = false
    var stepsPuzzle = 0
    
    var player1: AVPlayer?
    var player2: AVPlayer?
    
    lazy var musicLabal: UILabel = {
        let myLabel = UILabel()
        myLabel.text = "Background Music"
        myLabel.textColor = .white
        myLabel.font = UIFont.systemFont(ofSize: 25)
        return myLabel
    }()
    
    lazy var clickLabel: UILabel = {
        let myLabel = UILabel()
        myLabel.text = "Click button"
        myLabel.textColor = .white
        myLabel.font = UIFont.systemFont(ofSize: 25)
        return myLabel
    }()
    
    
    lazy var musicSwitch: UISwitch = {
        let mySwitch = UISwitch()
        mySwitch.isOn = false
        mySwitch.clipsToBounds = true
        mySwitch.addTarget(self, action: #selector(valuChange), for: .valueChanged)
        return mySwitch
    }()
    
    lazy var clickSwitch: UISwitch = {
        let mySwitch = UISwitch()
        mySwitch.isOn = false
        mySwitch.clipsToBounds = true
        mySwitch.addTarget(self, action: #selector(valuChange), for: .valueChanged)
        return mySwitch
    }()
    
    var ismoved = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = colorApp.viewColor
        
        puzzleLabel.backgroundColor = colorApp.lblColor
        puzzleLabel.frame = CGRect(x: 30, y: tm, width: wd-64, height: wd-64)
        view.addSubview(puzzleLabel)
        view.addSubview(musicSwitch)
        musicSwitch.tag = 100
        view.addSubview(clickSwitch)
        clickSwitch.tag = 101
        view.addSubview(clickLabel)
        view.addSubview(musicLabal)
        setUpPlayer1()
//        setUpPlayer2()
        
        musicLabal.frame =  CGRect(x: 20, y: 90, width: 200, height: 50)
        clickLabel.frame =  CGRect(x: 20, y: 120, width: 200, height: 50)
        
        musicSwitch.frame =  CGRect(x: 245, y: 90, width: 50, height: 50)
        clickSwitch.frame =  CGRect(x: 245, y: 120, width: 50, height: 50)
        
        restart.setTitle("r", for: .normal)
        restart.setImage(UIImage(named: "restart"), for: .normal)
        restart.frame = CGRect(x: 310, y: 90, width: 55, height: 55)
        restart.backgroundColor = .brown
        restart.tag = 999
        restart.layer.cornerRadius = 17
        restart.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
        view.addSubview(restart)
        
        orqaga.setTitle("o", for: .normal)
        orqaga.setImage(UIImage(named: "undo"), for: .normal)
        orqaga.frame = CGRect(x: 245, y: 90, width: 50, height: 50)
        orqaga.backgroundColor = .brown
        orqaga.tag = 777
        orqaga.layer.cornerRadius = 17
        orqaga.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
//        view.addSubview(orqaga)
        
        steps.backgroundColor = .brown
        steps.text = "Steps: \(stepsPuzzle)"
        steps.font = .systemFont(ofSize: 30)
        steps.textAlignment = .center
        steps.frame = CGRect(x: btnm+30+(btnm+(wd-2*wm)/4)*CGFloat(1%4), y: tm+btnm-haw-40, width: haw*2+btnm, height: haw-20)
        steps.layer.cornerRadius = 17
        steps.clipsToBounds = true
        view.addSubview(steps)
        
        for i in 0...15 {
            let btn = UIButton()
            btn.backgroundColor = colorApp.btnColor
            btn.setTitle(btnText[i], for: .normal)
            if btnText[i] == "16"{
                btn.setTitle(" ", for: .normal)
                btn.backgroundColor = .clear
                btn.tag = 16
            } else {
                btn.tag = Int(btnText[i]) ?? 0
            }
            btn.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
            btn.frame = CGRect(x: btnm + 30 + (btnm + (wd - 2 * wm) / 4) * CGFloat(i % 4), y: tm + btnm + (btnm + (wd - 2 * wm) / 4) * CGFloat(i / 4), width: haw, height: haw)
            view.addSubview(btn)
        }
    }
    
    @objc func valuChange(_ sender: UISwitch){
        if sender.tag == 100 {
            if sender.isOn == true {
                player1?.play()
            }else{
                player1?.pause()
            }
        }else {
            if sender.isOn == true {
                player2?.play()
            }else{
                player2?.pause()
            }
        }
    }
    
    func numShuffle(_ num: [String]) -> [String] {
        var nums2 = num
        nums2.removeLast()
        nums2.shuffle()
        nums2.append("16")
        return nums2
    }

    
    func isDoneAll(_ mas: [Int]) -> Bool {
        guard mas.count == 16 else { return false }
        for i in 0..<mas.count {
            if mas[i] != 1 + i {
                return false
            }
        }
        return true
    }
    
    func setUpPlayer1(){
        
        if let path = Bundle.main.path(forResource: "music", ofType: "mp3") {
            if #available(iOS 16.0, *) {
                player1 = AVPlayer(url: URL(filePath: path))
            } else {
                // Fallback on earlier versions
            }
            
            player1?.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 10000), queue: DispatchQueue.main, using: { time in
            })
        }
    }
    func setUpPlayer2(){
        
        if let path = Bundle.main.path(forResource: "m", ofType: "mp3") {
            if #available(iOS 16.0, *) {
                player2 = AVPlayer(url: URL(filePath: path))
            } else {
                // Fallback on earlier versions
            }
            player2?.play()
        }
    }
    
    
    @objc func btnClick(_ sender: UIButton) {
        print(sender.tag)
        ismoved = true
        if sender.tag == 999 {
            isRestartTapped = true
            btnText = numShuffle(btnText)
                
            for i in 0...15 {
                if let btn = view.viewWithTag(i+1) as? UIButton {
                    btn.setTitle(btnText[i], for: .normal)
                    if btnText[i] == "16" {
                        btn.setTitle(" ", for: .normal)
                        btn.backgroundColor = .clear
                        btn.tag = 16
                    } else {
                        btn.tag = Int(btnText[i]) ?? 0
                        btn.backgroundColor = colorApp.btnColor
                    }
                }
            }
                
            moveStack.removeAll()
            stepsPuzzle = 0
            steps.text = "Steps: \(stepsPuzzle)"
            
            print("Restart button tapped. New order:", btnText)
            return
        }
        
        if sender.tag == 777 {
            print("undo button clicked")
            undoLastMove()
            return
        }
        print(sender.tag)
        let myCenter = sender.center
        _ = sender.tag
        guard let randomBtn = view.viewWithTag(16) as? UIButton else { return }
        let randomCenter = randomBtn.center
        if (abs(myCenter.x - randomCenter.x) == haw + btnm && myCenter.y == randomCenter.y) ||
            (abs(myCenter.y - randomCenter.y) == haw + btnm && myCenter.x == randomCenter.x) {
            
            UIView.animate(withDuration: 0.4){
                sender.center = randomBtn.center
                randomBtn.center = myCenter
                if self.clickSwitch.isOn == true {
                    self.player2 = nil
                    self.setUpPlayer2()
                }
                
                self.stepsPuzzle += 1
                self.steps.text = "steps: \(self.stepsPuzzle)"
            }
            if isDoneAll(checktag) {
                
                let alertController = UIAlertController(title: "You Win!", message: "Congratulations! You scored \(stepsPuzzle)!", preferredStyle: .alert)
                let action1 = UIAlertAction(title: "Restart", style: .default) { _ in
                    self.moveStack.removeAll()
                    self.isRestartTapped = true
                }
                let action2 = UIAlertAction(title: "Cancel", style: .destructive) { _ in
                    print("Cancel clicked!")
                }
                alertController.addAction(action1)
                alertController.addAction(action2)
                present(alertController, animated: true)
            }
        }
    }
    
    func undoLastMove() {
        guard let lastMove = moveStack.popLast() else {
            print("No moves to undo")
            return
        }
        
        guard let button = view.viewWithTag(lastMove.buttonTag) as? UIButton,
              let emptyButton = view.viewWithTag(lastMove.emptyButtonTag) as? UIButton else { return }
        
        let buttonCenter = button.center
        let emptyButtonCenter = emptyButton.center
        
        UIView.animate(withDuration: 0.4) {
            button.center = emptyButtonCenter
            emptyButton.center = buttonCenter
            self.stepsPuzzle -= 1
            self.steps.text = "steps: \(self.stepsPuzzle)"
        }
        
        if let buttonIndex = btnText.firstIndex(of: "\(button.tag)"),
           let emptyButtonIndex = btnText.firstIndex(of: "\(emptyButton.tag)") {
            btnText.swapAt(buttonIndex, emptyButtonIndex)
        }
    }
}

class colorApp {
    static let viewColor = UIColor(red: 26/255, green: 34/255, blue: 44/255, alpha: 1)
    static let btnColor = UIColor(red: 70/255, green: 87/255, blue: 98/255, alpha: 1)
    static let lblColor = UIColor(red: 49/255, green: 53/255, blue: 49/255, alpha: 1)
}
