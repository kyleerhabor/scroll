//
//  ListPlanFormView.swift
//  Scroll
//
//  Created by Kyle Erhabor on 3/26/23.
//

import SwiftUI

struct ListPlanFormView: View {
  @Environment(\.dismiss) private var dismiss
  @Environment(\.managedObjectContext) private var viewContext

  var purpose: FormPurpose

  // This is unberaable.
  @ObservedObject var list: EntryList

  @FetchRequest private var entries: FetchedResults<Entry>

  var body: some View {
    Form {
      List(entries) { entry in
        HStack {
          Toggle(isOn: .constant(true)) {
            Text("...")
          }
        }
      }.listStyle(.inset)

      FormControlView(purpose: purpose, complete: true) {

      } cancel: {
        viewContext.rollback()
        dismiss()
      }
    }.scenePadding()
  }

  init(purpose: FormPurpose, list: EntryList) {
    self.purpose = purpose
    self.list = list

    _entries = .init(sortDescriptors: [], predicate: .init(format: "ANY list = %@", list))
  }
}

struct ListPlanFormView_Previews: PreviewProvider {
  private static let context = CoreDataStack.preview.container.viewContext
  private static let list: EntryList = {
    let list = EntryList(context: context)

    return list
  }()

  static var previews: some View {
    ListPlanFormView(purpose: .create, list: list)
  }
}
