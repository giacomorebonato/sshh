import SwiftUI

struct InputRow: View {
    @Binding var vm: InputRowViewModel

    var body: some View {
        VStack {
            HStack(alignment: .center) {
                if vm.isDefaultDevice {
                    Text(vm.deviceName)
                } else {
                    Text(vm.deviceName)
                        .bold()
                }
            }
            HStack {
                Slider(value: $vm.volume, in: 0...1, step: 0.1)
                Toggle(isOn: $vm.isMuted) {
                    Text("Mute")
                }
                Button(action: {
                    vm.setDeviceAsDefault()
                }) {
                    Text("Default")
                }
                .disabled(vm.isDefaultDevice)
            }
        }
    }
}
