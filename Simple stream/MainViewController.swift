//
//  ViewController.swift
//  Simple stream
//
//  Created by Serhii Shapoval on 5/17/16.
//  Copyright © 2016 Serhii Shapoval. All rights reserved.
//

import UIKit
import AVFoundation

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var videoListTableView: UITableView!
    @IBOutlet weak var videoHolderView: UIView!
    
    var videoSources: Array<NSMutableDictionary> = Array()
    var videoPlayer: AVPlayer?
    let networkManager = NetworkManager()
    var currentVideoIndex: Int = 0
    
    // MARK: Superclass method overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.networkManager.getVideoList { (results, error) in
            if nil == error && nil != results {
                self.videoSources = JSONInfoParser().extractUsedData(results!) as! Array
                self.downloadThumbnails()
            }
            dispatch_async(dispatch_get_main_queue(), { 
                self.videoListTableView.reloadData()
                if self.videoSources.count > 0 {
                    self.preparePlayer()
                    self.videoListTableView.selectRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), animated: true, scrollPosition: .Top)
                }
            })
        }
    }

    // MARK: UITableViewDataSource
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(kVideoSourceCellReuseIdentifier) as! VideoSourceCell
        cell.titleLabel.text = videoSources[indexPath.row][kUsernameKey] as? String
        cell.thumbnailImageView.image = videoSources[indexPath.row][kThumbnailKey] as? UIImage
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videoSources.count
    }
    
    // MARK: UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row != self.currentVideoIndex {
            self.playVideo(indexPath.row)
        } else {
            self.videoPlayer?.pause()
        }
    }
    
    // MARK: Helper methods
    func downloadThumbnails() {
        for i: Int in 0..<videoSources.count {
            let videoInfo: NSMutableDictionary = videoSources[i] 
            self.networkManager.getThumbnail(videoInfo[kThumbnailURLKey] as! String, completionHandler: { (resultImage, error) in
                videoInfo[kThumbnailKey] = resultImage
                self.videoSources[i] = videoInfo
                dispatch_async(dispatch_get_main_queue(), { 
                    self.videoListTableView.reloadRowsAtIndexPaths([NSIndexPath(forItem: i, inSection: 0)], withRowAnimation: .Automatic)
                })
            })
        }
    }
    
    func preparePlayer() {
        self.videoPlayer = AVPlayer()
        let playerLayer = AVPlayerLayer(player: self.videoPlayer!)
        playerLayer.frame = self.videoHolderView.bounds
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        self.videoHolderView.layer.addSublayer(playerLayer)
        self.playVideo(0)
    }
    
    // MARK: Video playback controls
    func playVideo(index: Int) {
        let playerItem = AVPlayerItem(URL: NSURL(string: self.videoSources[index][kVideoURLKey] as! String)!)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(playNextVideo), name: AVPlayerItemDidPlayToEndTimeNotification, object: playerItem)
        self.videoPlayer?.pause()
        self.videoPlayer?.replaceCurrentItemWithPlayerItem(playerItem)
        self.videoPlayer?.play()
        self.currentVideoIndex = index
    }
    
    @objc func playNextVideo() {
        if self.currentVideoIndex < self.videoSources.count - 1 {
            self.playVideo(self.currentVideoIndex + 1)
            self.videoListTableView.selectRowAtIndexPath(NSIndexPath(forItem: self.currentVideoIndex, inSection: 0), animated: true, scrollPosition: .None)
        } else {
            self.playVideo(0)
            self.videoListTableView.selectRowAtIndexPath(NSIndexPath(forItem: self.currentVideoIndex, inSection: 0), animated: true, scrollPosition: .None)
        }
    }
}

