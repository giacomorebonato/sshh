import AMCoreAudio
import SwiftUI

class InputRowViewModel: ObservableObject {
    var device: AudioDevice
    var refresh: () -> Void
    var lastVolumeLevel: Float32 = 0
    
    init(device: AudioDevice, refresh: @escaping () -> Void) {
        let volumeInfo = device.volumeInfo(channel: 0, direction: .recording)
        
        self.device = device
        self.isMuted = (device.isMuted(channel: 0, direction: .recording)) ?? false
        self.refresh = refresh
        self.volume = volumeInfo?.volume ?? self.lastVolumeLevel
        
        print("Volume is " + String(self.volume))
    }
    
    func toggleMute() {
        let isMuted = self.device.isMuted(channel: 0, direction: .recording) ?? false
        self.lastVolumeLevel = self.device.volumeInfo(channel: 0, direction: .recording)?.volume ?? 0
        self.device.setMute(!isMuted, channel: 0, direction: .recording)
    }
    
    func isDefault() -> Bool {
        return AudioDevice.defaultInputDevice()?.id == self.device.id
    }
    
    @Published var volume: Float32 = 0 {
        didSet {
            device.setVolume(volume, channel: 0, direction: .recording)
        }
    }
    
    @Published var isMuted: Bool = false {
        didSet {
            self.toggleMute()
            self.refresh()
        }
    }
}

struct InputRow: View {
    var device: AudioDevice
    var refresh: () -> Void
    @ObservedObject var vm: InputRowViewModel
    
    init(device: AudioDevice, refresh: @escaping () -> Void) {
        self.device = device
        self.refresh = refresh
        vm = InputRowViewModel(device: device, refresh: refresh)
    }
    
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                self.vm.isDefault() ?
                    Text(device.name).bold() : Text(device.name)
            }
            HStack {
                Slider(value: self.$vm.volume, in: 0...1, step: 0.1)
                Toggle(isOn: self.$vm.isMuted) {
                    Text("Mute")
                }
                Button(action: {
                    self.device.setAsDefaultInputDevice()
                    self.refresh()
                }) {
                    Text("Default")
                }
                .disabled(self.vm.isDefault())
            }
        }
    }
}
