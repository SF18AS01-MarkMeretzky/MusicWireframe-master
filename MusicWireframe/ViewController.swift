//
//  ViewController.swift
//  MusicWireframe
//
//  Created by Mark Meretzky on 2/27/19.
//  Copyright © 2019 New York University School of Professional Studies. All rights reserved.
//

import UIKit;
import AVFoundation;

class ViewController: UIViewController {
    
    let composers: [Composer] = [
        Composer(imageName: "bach.jpg", soundName: "musette", soundExtension: "mp3"),
        Composer(imageName: "elvis.jpg", soundName: "elvis", soundExtension: "mp3"),
        Composer(imageName: "backstreetboys.jpg", soundName: "backstreetboys", soundExtension: "mp3")
    ];
    
    var current: Int = 0 {
        didSet {
            isPlaying = false;
            let composer: Composer = composers[current];
            albumImageView.image = UIImage(named: composer.imageName);
            
            guard let url: URL = Bundle.main.url(forResource: composer.soundName, withExtension: composer.soundExtension) else {
                return;
            }
            print("url = \(url)");
            
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url);
            } catch {
                print("could not create AVAudioPlayer: \(error)");
                return;
            }
            isPlaying = true;
        }
    }
    
    var audioPlayer: AVAudioPlayer? = nil;
    
    var isPlaying: Bool = false {  //pp. 818-819
        didSet {
            let name: String = isPlaying ? "pause" : "play";
            playPauseButton.setImage(UIImage(named: name)!, for: .normal);
            
            guard audioPlayer != nil else {
                return;
            }
            
            if isPlaying {
                audioPlayer!.play();
            } else {
                audioPlayer!.pause();
            }
        }
    }
    
    @IBOutlet weak var albumImageView: UIImageView!;   //p. 816
    
    @IBOutlet weak var reverseBackground: UIView!;
    @IBOutlet weak var playPauseBackground: UIView!;
    @IBOutlet weak var forwardBackground: UIView!;
    
    @IBOutlet weak var reverseButton: UIButton!;
    @IBOutlet weak var playPauseButton: UIButton!;
    @IBOutlet weak var forwardButton: UIButton!;
    
    
    override func viewDidLoad() {
        super.viewDidLoad();
        // Do any additional setup after loading the view, typically from a nib.
        
        [reverseBackground, playPauseBackground, forwardBackground].forEach { //p. 817
            $0!.layer.cornerRadius = $0!.constraints[0].constant / 2;
            $0!.clipsToBounds = true;
            $0!.alpha = 0.0;   //p. 818
        }
        
        current = 0;
    }

    @IBAction func playPauseButtonTapped(_ sender: UIButton) {   //p. 819
        if isPlaying {   //p. 820
            UIView.animate(withDuration: 0.5) {
                self.albumImageView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8);
            }
        } else {
            UIView.animate(withDuration: 0.5) {
                self.albumImageView.transform = .identity;
            }
        }
        
        isPlaying = !isPlaying;
    }
    
    @IBAction func touchedDown(_ sender: UIButton) {   //p. 822
        let buttonBackground: UIView;   //p. 823
        
        switch sender {
        case reverseButton:
            buttonBackground = reverseBackground;
        case playPauseButton:
            buttonBackground = playPauseBackground;
        case forwardButton:
            buttonBackground = forwardBackground;
        default:
            return;
        }
        
        UIView.animate(withDuration: 0.25) {
            buttonBackground.alpha = 0.3;
            sender.transform = CGAffineTransform(scaleX: 0.8, y: 0.8);
        }
    }
    
    @IBAction func touchedUpInside(_ sender: UIButton) {   //p. 822
        let buttonBackground: UIView;   //p. 825
    
        switch sender {
        case reverseButton:
            buttonBackground = reverseBackground;
            if current == 0 {
                current = composers.count - 1;
            } else {
                current -= 1;
            }
        case playPauseButton:
            buttonBackground = playPauseBackground;
        case forwardButton:
            buttonBackground = forwardBackground;
            if current == composers.count - 1 {
                current = 0;
            } else {
                current += 1;
            }
        default:
            return;
        }
    
        UIView.animate(withDuration: 0.25, animations: {
            buttonBackground.alpha = 0.0;
            buttonBackground.transform = CGAffineTransform(scaleX: 1.2, y: 1.2);
            sender.transform = .identity;
        }) {_ in   //This is the completion handler.
            buttonBackground.transform = .identity;
        }
        
        
    }
    
}

