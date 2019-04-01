//
//  MediaPlayer.swift
//  DogSay
//
//  Created by jewelz on 2017/5/7.
//  Copyright © 2017年 jewelz. All rights reserved.
//

import UIKit
import AVFoundation

public enum  MediaPlayerStyle {
    case small
    case fullScreen
}

public enum MediaPlayerState {
    /// 播放中
    case playing
    /// 暂停
    case pause
    /// 播放结束
    case toEnd
}

@objc public protocol MediaPlayerDelegte: NSObjectProtocol {
    
    /// 媒体当前播放时长
    @objc optional func mediaPlayer(_ player: MediaPlayerView, isPlayingWith second: CGFloat)
    
    /// 媒体播放完成
    @objc optional func mediaPlayerDidPlayToEnd(_ player: MediaPlayerView)
    
    /// 媒体加载失败
    @objc optional func mediaPlayerDidLoadMediaFailed(_ player: MediaPlayerView)
    
    /// 切换全屏
    @objc optional func mediaPlayerDidDisplayFullScreen(_ player: MediaPlayerView)
}

public class MediaPlayerView: UIView {
    
    @IBOutlet fileprivate weak var mainView: UIView!
    @IBOutlet fileprivate weak var playerView: UIView!
    @IBOutlet fileprivate weak var playButton: UIButton!
    @IBOutlet fileprivate weak var toolBar: UIView!
    @IBOutlet fileprivate weak var currentTimeLabel: UILabel!
    @IBOutlet fileprivate weak var endTimeLabel: UILabel!
    @IBOutlet fileprivate weak var progressView: UIProgressView!
    @IBOutlet fileprivate weak var sliderBar: SWSlider!
    @IBOutlet fileprivate weak var smallPlayButton: UIButton!
    @IBOutlet fileprivate weak var fullScreenButton: UIButton!
    @IBOutlet fileprivate weak var endTimeLabelRightConstraint: NSLayoutConstraint!
    @IBOutlet weak var replayLabel: UILabel!
    
    /// 视频地址
    public var url: URL? {
        didSet {
            guard let url = url else {
                return
            }
            removeObserverAndNotification()
            playerItem = AVPlayerItem(url: url)
            player.replaceCurrentItem(with: playerItem)
            addObserverAndNotification()
            if isAutoPlaying {
                play()
            }
            playerLayer.videoGravity = .resizeAspectFill
        }
    }
    
    /// 播发器类型
    public var playerStyle: MediaPlayerStyle {
        get {
            return _playerStyle
        }
        set {
            _playerStyle = newValue
        }
    }
    
    /// 播放器状态
    public var state: MediaPlayerState {
        return _state
    }
    
    /// 设置自动播放
    public var isAutoPlaying: Bool = false {
        didSet {
            if isAutoPlaying {
                play()
            }
        }
    }
    
    public weak var delegate: MediaPlayerDelegte?
    
    /// 是否隐藏 toolBar, 默认不隐藏
    public var isHideToolbar = false {
        didSet {
            toolBar.isHidden = isHideToolbar
        }
    }
    
    public var isHidePlayButton = false  {
        didSet{
            playButton.isHidden = isHidePlayButton
            replayLabel.isHidden = isHidePlayButton
        }
    }
    
    var playerSnapshot: UIView? {
        return playerView.snapshotView(afterScreenUpdates: true)
    }
    
    fileprivate var _playerStyle: MediaPlayerStyle = .small {
        didSet {
            fullScreenButton.isHidden = _playerStyle == .fullScreen
            endTimeLabelRightConstraint.constant = _playerStyle == .fullScreen ? 14 : 48
        }
    }
    fileprivate var _state: MediaPlayerState = .pause
    
    fileprivate var _isPlaying = false {
        didSet {
            let imageName = self._isPlaying ? "video_replay_icon" : "video_paly_icon"
            self.playButton.setImage(UIImage.bundleImage(named: imageName), for: .normal)
            self.smallPlayButton.isSelected = self._isPlaying
            if self._isPlaying {
                self.player.play()
                self._state = .playing
                self.playButton.alpha = 0
                self.replayLabel.alpha = 0
            } else {
                self.player.pause()
                if self._state == .toEnd {
                    self.playButton.setImage(UIImage.bundleImage(named: "video_replay_icon"), for: .normal)
                    self.playButton.alpha = 1
                    self.replayLabel.alpha = 1
                }
                else {
                    self._state = .pause
                }
            }
        }
    }
    
    
    /// 是否正在滑动进度条
    fileprivate var isSliding = false
    
    fileprivate var playTimeObserver: Any?
    fileprivate var playerItem: AVPlayerItem?
    fileprivate var player: AVPlayer!
    fileprivate var playerLayer: AVPlayerLayer!
    
    // MARK: - Life cycle
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        setupView()
    }
    
    deinit {
        destory()
    }
    
    fileprivate func setupView() {
        
        mainView = SwiftlyKit.bundle!.loadNibNamed("MediaPlayerView", owner: self, options: nil)?.last! as! UIView!
        addSubview(mainView)
        
        toolBar.isHidden = isHideToolbar
        if let image = UIImage.bundleImage(named: "video_lower_bg") {
            toolBar.backgroundColor = UIColor(patternImage: image)
        }
        sliderBar.setThumbImage(UIImage.bundleImage(named: "video_progresspoint_icon"), for: .normal)
        player = AVPlayer()
        
        self.replayLabel.alpha = 0
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resizeAspectFill
        playerView.layer.addSublayer(playerLayer)
        
        
        try? AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord, with: AVAudioSessionCategoryOptions.defaultToSpeaker)
        //addObserverAndNotification()
        sliderBar.sliderHeight = 3
        
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        //playerView.layer.addSublayer(playerLayer)
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        mainView.frame = self.bounds
        playerLayer.frame = self.bounds
    }
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if toolBar.isHidden && !isHideToolbar {
            UIView.animate(withDuration: 0.25, animations: {
                self.toolBar.alpha = 1
                self.toolBar.isHidden = false
                // self.playButton.alpha = 1
            })
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: {
                UIView.animate(withDuration: 0.25, animations: {
                    self.toolBar.alpha = 0
                    self.toolBar.isHidden = true
                    self.playButton.alpha = 0
                    self.replayLabel.alpha = 0
                })
            })
            
        } else  if self._state != .toEnd {
            UIView.animate(withDuration: 0.25, animations: {
                self.toolBar.alpha = 0
                self.toolBar.isHidden = true
                self.playButton.alpha = 0
                self.replayLabel.alpha = 0
            })
        }
    }
    
    func updatePlayer(with url: URL) {
        removeObserverAndNotification()
        
        playerItem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: playerItem)
        
        addObserverAndNotification()
    }
    
    
    public func play() {
        _isPlaying = true
    }
    
    public func pause() {
        _isPlaying = false
    }
    
    public func setPlayToEnd() {
        _state = .toEnd
        _isPlaying = false
        delegate?.mediaPlayerDidPlayToEnd?(self)
        playerItem?.seek(to: kCMTimeZero)
    }
    
    /// 销毁播放器
    public func destory() {
        pause()
        removeObserverAndNotification()
        playerItem = nil
    }
    
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let item = object as? AVPlayerItem, let keyPath = keyPath, let change = change else {
            return
        }
        
        if keyPath == #keyPath(AVPlayerItem.status) {
            let nu = (change[.newKey] as AnyObject).uintValue
            
            let status = AVPlayerStatus.init(rawValue: Int(nu!))
            
            if status == .readyToPlay {
                //                print("准备播放")
                let duration = CMTimeGetSeconds(item.duration)
                //                print("视频总长度: \(duration)")
                setMaxDuration(duration)
                
            } else if status == .failed {
                //                print("视频加载失败")
                delegate?.mediaPlayerDidLoadMediaFailed?(self)
            }
            
        } else if keyPath == #keyPath(AVPlayerItem.loadedTimeRanges), let playerItem = playerItem {
            let timeInterval = avaliableDuration()
            let total = CMTimeGetSeconds(playerItem.duration)
            
            let progress = timeInterval / total
            // print("已缓冲:\(progress)")
            // 设置缓存条进度
            progressView.progress = Float(progress)
        }
    }
    
    
    
    // MARK: - Action
    /// 播放按钮点击
    @IBAction fileprivate func playButtonClicked(_ sender: UIButton) {
        UIView.animate(withDuration: 0.25, animations: {
            if !self.isHideToolbar { self.toolBar.alpha = 0 }
            self.playButton.alpha = 0
            self.replayLabel.alpha = 0
        })
        if _isPlaying {
            pause()
        } else {
            play()
        }
    }
    
    /// 全屏按钮点击
    @IBAction fileprivate func fullScreenButtonClicked(_ sender: UIButton) {
        fullScreenButton.isHidden = true
        _playerStyle = .fullScreen
        endTimeLabelRightConstraint.constant = 10
        delegate?.mediaPlayerDidDisplayFullScreen?(self)
    }
    
    /// 进度条
    @IBAction fileprivate func playerSliderTouchDown(_ sender: UISlider) {
        pause()
    }
    
    @IBAction fileprivate func playerSliderTouchUpInside(_ sender: UISlider) {
        isSliding = false //// 滑动结束
        play()
    }
    
    @IBAction fileprivate func playerSliderValueChanged(_ sender: UISlider) {
        isSliding = true
        pause()
        let time = CMTimeGetSeconds(playerItem!.duration) * Float64(sender.value)
        playerItem?.seek(to: CMTimeMakeWithSeconds(Float64(time), 1), completionHandler: { finished in
            
        })
    }
    
    
    // MARK: - Notification handler
    
    @objc fileprivate func itemDidPlayToEndNotificationHandler(_ sender: Notification) {
        //print("播放完成")
        _state = .toEnd
        _isPlaying = false
        delegate?.mediaPlayerDidPlayToEnd?(self)
        playerItem?.seek(to: kCMTimeZero)
    }
    
    @objc fileprivate func willEnterForegroundNotificationHandler(_ sender: Notification) {
       // play()
    }
    
    @objc fileprivate func didEnterBackgroundNotificationHandler(_ sender: Notification) {
        pause()
    }
    
    @objc fileprivate func interruptionNotificationHandler(_ sender: Notification) {
        guard let info = sender.userInfo else { return }
        print(info)
        guard let type = info[AVAudioSessionInterruptionTypeKey] as? Int else {
            return
        }
        
        if type == 0 { //beigin
            pause()
        } else { // end
            if let options = info[AVAudioSessionInterruptionOptionKey] as? AVAudioSessionInterruptionOptions, options == .shouldResume {
                play()
            }
            
        }
    }
    
    @objc fileprivate func sessionRateChangedNotificationHandler(_ sender: Notification) {
        guard let info = sender.userInfo else { return }
        
        guard let reason = info[AVAudioSessionRouteChangeReasonKey] as? Int else {
            return
        }
        
        // 表示旧输出不可用
        if  reason == 2 {
            let routeDesc = info[AVAudioSessionRouteChangePreviousRouteKey] as! AVAudioSessionRouteDescription
            guard let portDesc = routeDesc.outputs.first else { return }
            if portDesc.portType == "Headphones" {
                try? AVAudioSession.sharedInstance().setPreferredIOBufferDuration(TimeInterval(kAudioSessionOverrideAudioRoute_Speaker))
                if _isPlaying {
                    pause()
                }
            }
        }
    }
}


// MARK: - parvate

extension MediaPlayerView {
    
    fileprivate func addObserverAndNotification() {
        
        playerItem?.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.status), options: .new, context: nil)
        playerItem?.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.loadedTimeRanges), options: .new, context: nil)
        
        if let playerItem = playerItem {
            updatePlayback(playerItem)
        }
        
        NotificationCenter.default.removeObserver(self)
        
        NotificationCenter.default.addObserver(self, selector: #selector(MediaPlayerView.itemDidPlayToEndNotificationHandler(_:)), name: .AVPlayerItemDidPlayToEndTime, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MediaPlayerView.willEnterForegroundNotificationHandler(_:)), name: .UIApplicationWillEnterForeground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MediaPlayerView.didEnterBackgroundNotificationHandler(_:)), name: .UIApplicationDidEnterBackground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MediaPlayerView.interruptionNotificationHandler(_:)), name: .AVAudioSessionInterruption, object: AVAudioSession.sharedInstance())
        NotificationCenter.default.addObserver(self, selector: #selector(MediaPlayerView.sessionRateChangedNotificationHandler(_:)), name: .AVAudioSessionRouteChange, object: AVAudioSession.sharedInstance())
    }
    
    fileprivate func removeObserverAndNotification() {
        player.replaceCurrentItem(with: nil)
        playerItem?.removeObserver(self, forKeyPath: #keyPath(AVPlayerItem.status))
        playerItem?.removeObserver(self, forKeyPath: #keyPath(AVPlayerItem.loadedTimeRanges))
        
        if playTimeObserver != nil {
            player.removeTimeObserver(playTimeObserver!)
            playTimeObserver = nil
        }
        
        NotificationCenter.default.removeObserver(self)
    }
    
    fileprivate func updatePlayback(_ item: AVPlayerItem) {
        playTimeObserver = player.addPeriodicTimeObserver(forInterval:  CMTime(seconds: 1, preferredTimescale: 30), queue: DispatchQueue.main) { [weak self] time in
            let current = CMTimeGetSeconds(item.currentTime())
            if !self!.isSliding {
                self!.updateVideoProgress(with: current)
            }
        }
    }
    
    
    // 已缓冲进度
    fileprivate func avaliableDuration() -> Float64 {
        guard let playerItem = playerItem else {
            return 0
        }
        
        let loadedTimeRanges = playerItem.loadedTimeRanges
        guard let timeRange = loadedTimeRanges.first?.timeRangeValue else {
            return 0
        }
        
        let start = CMTimeGetSeconds(timeRange.start)
        let duration = CMTimeGetSeconds(timeRange.duration)
        
        // 计算总缓冲时间 = start + duration
        
        return start + duration
    }
    
    // 设置视频时长
    fileprivate func setMaxDuration(_ duration: Float64) {
        endTimeLabel.text = String.clock(TimeInterval(duration))
    }
    
    // 更新播放进度条
    fileprivate func updateVideoProgress(with time: Float64) {
        
        let percent = time / CMTimeGetSeconds(playerItem!.duration)
        
        if progressView.progress <= Float(percent) {//
            //print("已播放完缓冲")
        }
        
        // print("---已播放：\(percent)")
        // currentTimeLabel.text =
        
        currentTimeLabel.text = String.clock(TimeInterval(time))
        sliderBar.value = Float(percent)
        delegate?.mediaPlayer?(self, isPlayingWith: CGFloat(time))
    }
    
}


class SWSlider: UISlider {
    
    var sliderHeight: CGFloat = 1
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: 0, y: (bounds.size.height - sliderHeight)/2 , width: bounds.size.width, height: sliderHeight)
    }
}

extension String {
    static public func clock(_ second: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: second)
        let formatter: DateFormatter
        if second / 3600 >= 1 {
            formatter = DateTool.shared.hourFormatter
        } else {
            formatter = DateTool.shared.minuteFormatter
        }
        
        return formatter.string(from: date)
    }
}


