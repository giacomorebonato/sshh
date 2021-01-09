//
//  InputRowViewModel.swift
//  sshh
//
//  Created by Boris Bielik on 10/10/2020.
//  Copyright © 2020 Giacomo Rebonato. All rights reserved.
//

import Foundation
import AMCoreAudio

enum VolumeChannel {
    case mono(UInt32)
    case stereo(left: UInt32, right: UInt32)
}

final class InputRowViewModel: ObservableObject, Identifiable {

    @Published var device: AudioDevice
    @Published var isDefaultDevice = false {
        didSet {
            if isDefaultDevice {
                setDeviceAsDefault()
            }
        }
    }
    @Published var isMuted: Bool = false {
        didSet {
            guard isMuted != oldValue else { return }
            toggleMute()
        }
    }
    @Published var volume: Float32 = 0 {
        didSet {
            guard volume != oldValue else { return }
            setVolume()
        }
    }

    let id = UUID()
    var deviceName: String {
        device.name
    }
    private var lastVolumeLevel: Float32 = 0
    private var direction: Direction

    init(device: AudioDevice) {
        self.direction = device.isOutputOnlyDevice() ? .playback : .recording
        self.device = device
        self.isMuted = deviceIsMuted()

        readDefaultDevice()
        readVolume()
    }

    // MARK: Volume

    private func readVolume() {
        guard let channels = volumeChannels() else {
            return
        }

        func volume(forChannel channel: UInt32) -> Float32? {
            return device.volume(channel: channel, direction: direction)
        }

        switch channels {
        case .mono(let channel):
            self.volume = volume(forChannel: channel) ?? 00
        case .stereo(let left, _):
            self.volume = volume(forChannel: left) ?? 0
        }
    }

    private func setVolume() {
        guard let channels = volumeChannels() else { return }

        func setVolume(onChannel channel: UInt32) {
            device.setVolume(volume, channel: channel, direction: direction)
        }

        switch channels {
        case .mono(let channel):
            setVolume(onChannel: channel)
        case .stereo(let left, let right):
            setVolume(onChannel: left)
            setVolume(onChannel: right)
        }

        print("Volume for \(device) is \(volume)")
    }

    // MARK: Muting the sound

    private func deviceIsMuted() -> Bool {
        device.isMuted(channel: 0, direction: direction) ?? false
    }

    private func muteDevice(_ shouldMute: Bool) {
        device.setMute(shouldMute, channel: 0, direction: direction)
    }

    func toggleMute() {
        let isMuted = deviceIsMuted()
        if isMuted {
            volume = lastVolumeLevel
            muteDevice(!isMuted)
        } else {
            self.lastVolumeLevel = volumeInfo()?.volume ?? 0
            muteDevice(!isMuted)
        }
    }

    // MARK: Default device

    private func readDefaultDevice() {
        switch direction {
        case .playback:
            self.isDefaultDevice = AudioDevice.defaultOutputDevice()?.id == device.id
        case .recording:
            self.isDefaultDevice = AudioDevice.defaultInputDevice()?.id == device.id
        }
    }

    func setDeviceAsDefault() {
        if device.isInputOnlyDevice() {
            device.setAsDefaultInputDevice()
        } else if device.isOutputOnlyDevice() {
            device.setAsDefaultOutputDevice()
        } else {
            device.setAsDefaultOutputDevice()
            device.setAsDefaultInputDevice()
        }
    }
}

// MARK: Helpers

extension InputRowViewModel {

    private func volumeChannels() -> VolumeChannel? {
        guard device.channels(direction: direction) > 0 else {
            return nil
        }

        switch direction {
        case .playback:
            guard let channels = device.preferredChannelsForStereo(direction: direction) else {
                return nil
            }
            return .stereo(left: channels.left, right: channels.right)

        case .recording:
            return .mono(0)
        }
    }

    private func volumeInfo() -> VolumeInfo? {
        guard let channels = volumeChannels() else { return nil }
        switch channels {
        case .mono(let channel):
            return device.volumeInfo(channel: channel, direction: direction)
        case .stereo(let left, _):
            return device.volumeInfo(channel: left, direction: direction)
        }
    }

}
