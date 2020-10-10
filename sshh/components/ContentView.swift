import AMCoreAudio
import SwiftUI

struct ContentView: View {
    @ObservedObject var vm: ContentViewViewModel

    var body: some View {
        VStack {
            ForEach(vm.inputDevices, id: \.id) {
                device in InputRow(device: device, refresh: self.vm.refresh)
            }
            Divider()
            HStack {
                Button(action: {
                    exit(0)
                }) {
                    Text("Quit")
                }
            }
        }
        .padding(.top, 12)
        .padding(.leading, 12)
        .padding(.trailing, 12)
        .padding(.bottom, 4)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(vm: ContentViewViewModel())
    }
}
