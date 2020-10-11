import SwiftUI

struct InputRow: View {
    @Binding var vm: InputRowViewModel
    @EnvironmentObject var content: ContentViewViewModel

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
                    vm.isDefaultDevice = true
                    content.reload()
                }) {
                    Text("Default")
                }
                .disabled(vm.isDefaultDevice)
            }
        }
    }
}
