//
//  ContentView.swift
//  Scroll
//
//  Created by Kyle Erhabor on 3/4/23.
//

import SwiftUI
import CoreData

struct ContentView: View {
  @Environment(\.managedObjectContext) private var viewContext
  @Environment(\.openWindow) private var openWindow

  @FetchRequest(sortDescriptors: [SortDescriptor(\.title)])
  private var titles: FetchedResults<Title>

  var body: some View {
    NavigationStack {
      ScrollView {
        let width: CGFloat = 128

        LazyVGrid(columns: [.init(.adaptive(minimum: width))]) {
          ForEach(titles) { title in
            // It feels weird needing to set the spacing here.
            VStack(alignment: .leading, spacing: 16) {
              NavigationLink(value: title) {
                TitleCoverView(cover: title.cover)
              }
              .buttonStyle(.plain)
              // Interestingly, frame causes applied modifier afterwards only apply to a subset of the height of the view.
              .frame(width: width, height: width * (4 / 3))

              Text(title.title!)
                .font(.caption)
                .bold()
                .foregroundColor(.secondary)
            }
          }
        }.padding()
      }
      .navigationTitle("Titles")
      .navigationDestination(for: Title.self) { title in
        TitleView(title: title)
      }.toolbar {
        // In the future, I'd like to provide users the ability to create or *import* titles (likely in some file format).
        // When that happens, this will likely be a Menu.
        Button {
          openWindow(id: "new-title")
        } label: {
          Label("Create", systemImage: "plus")
        }
      }
    }
  }

  func createTitle() {
//    let title = Title(context: viewContext)
//    title.title = "New title"
//
//    try! viewContext.save()

//    let fetchRequest = NSFetchRequest<Title>(entityName: "Title")
//    fetchRequest.returnsObjectsAsFaults = false
//
//    do {
//      let results = try viewContext.fetch(fetchRequest)
//
//      for managedObject in results {
//        let managedObjectData:NSManagedObject = managedObject as NSManagedObject
//
//        viewContext.delete(managedObjectData)
//      }
//
//      try viewContext.save()
//    } catch let error as NSError {
//      print("Detele all data in title error : \(error) \(error.userInfo)")
//    }
  }

//  private func addItem() {
//    withAnimation {
//      let newItem = Item(context: viewContext)
//
//      newItem.timestamp = Date()
//
//      do {
//        try viewContext.save()
//      } catch {
//        // Replace this implementation with code to handle the error appropriately.
//        // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//        let nsError = error as NSError
//
//        fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//      }
//    }
//  }
//
//  private func deleteItems(offsets: IndexSet) {
//    withAnimation {
//      offsets.map { items[$0] }.forEach(viewContext.delete)
//
//      do {
//        try viewContext.save()
//      } catch {
//        // Replace this implementation with code to handle the error appropriately.
//        // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//        let nsError = error as NSError
//
//        fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//      }
//    }
//  }
}

private let itemFormatter: DateFormatter = {
  let formatter = DateFormatter()
  formatter.dateStyle = .short
  formatter.timeStyle = .medium
  return formatter
}()

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
  }
}
