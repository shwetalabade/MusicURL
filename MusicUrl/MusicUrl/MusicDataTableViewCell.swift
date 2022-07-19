//
//  MusicDataTableViewCell.swift
//  MusicUrl
//
//  Created by Mac on 10/06/22.
//

import UIKit
import AVFoundation
class MusicDataTableViewCell:UITableViewCell
{
    
    @IBOutlet weak var artistIdLabel: UILabel!
    
    @IBOutlet weak var artistNameLabel: UILabel!
    
    @IBOutlet weak var trackIdLabel: UILabel!
    
    @IBOutlet weak var trackNameLabel: UILabel!
      
    @IBOutlet weak var playButton: UIButton!
    
   var playSongvar = false
    var preViewURL: String?
    var player:AVPlayer?
    override func awakeFromNib() {
        super.awakeFromNib()
    }
     
    @IBAction func playSongButton(_ sender: Any) {
        playSong()
    }
    }
extension MusicDataTableViewCell{
    private func playSong() {
        let url = URL(string: self.preViewURL ?? "")
        let playerItem:AVPlayerItem = AVPlayerItem(url: url!)
        player = AVPlayer(playerItem: playerItem)
        
        let playerLayer = AVPlayerLayer(player: player!)
        playerLayer.frame = CGRect(x: 0, y: 0, width: 10, height: 50)
        if playSongvar{
            playButton.setTitle("play", for: .normal)
            playSongvar = false
            player?.pause()
        }
        else{
            playButton.setTitle("pause", for: .normal)
              playSongvar = true
            player?.play()
            
        }
    }
}

