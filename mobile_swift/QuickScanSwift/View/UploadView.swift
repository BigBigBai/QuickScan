import SwiftUI
import Combine
import FBSDKCoreKit
import FBSDKLoginKit
import FirebaseAuth

struct UploadView: View {
    @State var pushActive = false
    @ObservedObject private var viewModel: UploadViewModel
    
    init(state: AppState, url: String) {
        self.viewModel = UploadViewModel(authAPI: AuthService(), state: state, url: url)
    }
    
    var body: some View {
        VStack {
            NavigationLink(destination: HomeView(state: viewModel.state),
                           isActive: self.$pushActive) {
              EmptyView()
            }.hidden()
            VStack(alignment: .center, spacing: 10) {
                Text("Upload")
                    .modifier(TextModifier(font: UIConfiguration.titleFont,
                                           color: UIConfiguration.tintColor))
                    .padding(.horizontal, 60)
                VStack(alignment: .center) {
                    customButton(title: "Upload Video",
                                 backgroundColor: UIColor(hexString: "#913FE7"),
                                 action: {
                        self.viewModel.upload()
                        self.viewModel.buttonTapped()
                    })
                    .padding(.horizontal, 60)
                }
                VStack(alignment: .center) {
                    CustomTextField(placeHolderText: "Title",
                                  text: $viewModel.title)
                    CustomTextField(placeHolderText: "Description",
                                  text: $viewModel.description)
                }.padding(.horizontal, 25)
            }
            Spacer()
        }.alert(item: self.$viewModel.statusViewModel) { status in
            Alert(title: Text(status.title),
                  message: Text(status.message),
                  dismissButton: .default(Text("OK"), action: {
                    if status.title == "Successful" {
                        self.pushActive = true
                    }
                  }))
        }
    }
    
    private func customButton(title: String,
                              backgroundColor: UIColor,
                              action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .modifier(ButtonModifier(font: UIConfiguration.buttonFont,
                                         color: backgroundColor,
                                         textColor: .white,
                                         width: 275,
                                         height: 55))
        }
    }
}
