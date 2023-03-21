//
//  SettingsView.swift
//  Scroll
//
//  Created by Kyle Erhabor on 3/21/23.
//

import SwiftUI

struct SettingsView: View {
  @AppStorage("alwaysShowTitleQualifier") private var alwaysShowTitleQualifier = false

  var body: some View {
    Form {
      Toggle("Always display title qualifier text field", isOn: $alwaysShowTitleQualifier)
        .border(.orange)
    }.padding()
  }
}

struct SettingsView_Previews: PreviewProvider {
  static var previews: some View {
    SettingsView()
  }
}
