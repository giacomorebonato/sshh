import SwiftUI

struct ContentView: View {
    @EnvironmentObject var vm: ContentViewViewModel

    var body: some View {
        VStack {
            ForEach(0..<vm.inputViewModels.count, id: \.self) { index in
                InputRow(vm: $vm.inputViewModels[index])
            }
            Divider()
            HStack {
                QuitButton()
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
        ContentView()
            .environmentObject(ContentViewViewModel())
    }
}
