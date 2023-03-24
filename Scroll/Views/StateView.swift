//
//  StateView.swift
//  Scroll
//
//  Created by Kyle Erhabor on 3/23/23.
//

import SwiftUI

// Heavily borrowed from https://www.swiftbysundell.com/articles/handling-loading-states-in-swiftui/

enum ViewState<Value, Error> {
  case idle, loading, loaded(Value), failed(Error)
}

struct StateView<Value, Error, Idle: View, Loading: View, Loaded: View, Failed: View>: View {
  @Binding var state: ViewState<Value, Error>
  var load: () -> Void
  var idle: () -> Idle
  var loading: () -> Loading
  @ViewBuilder var loaded: (Value) -> Loaded
  @ViewBuilder var failed: (Error) -> Failed

  var body: some View {
    switch state {
      case .idle:
        idle().onAppear(perform: load)
      case .loading:
        loading()
      case .loaded(let value):
        loaded(value)
      case .failed(let err):
        failed(err)
    }
  }
}

typealias DefaultStateViewIdle = Color

typealias DefaultStateViewLoading = ProgressView<EmptyView, EmptyView>

extension StateView where Idle == DefaultStateViewIdle {
  init(
    state: Binding<ViewState<Value, Error>>,
    load: @escaping () -> Void,
    loading: @escaping () -> Loading,
    @ViewBuilder loaded: @escaping (Value) -> Loaded,
    @ViewBuilder failed: @escaping (Error) -> Failed
  ) {
    self.init(
      state: state,
      load: load,
      idle: { Color.clear },
      loading: loading,
      loaded: loaded,
      failed: failed
    )
  }
}

extension StateView where Loading == DefaultStateViewLoading {
  init(
    state: Binding<ViewState<Value, Error>>,
    load: @escaping () -> Void,
    idle: @escaping () -> Idle,
    @ViewBuilder loaded: @escaping (Value) -> Loaded,
    @ViewBuilder failed: @escaping (Error) -> Failed
  ) {
    self.init(
      state: state,
      load: load,
      idle: idle,
      loading: { .init() },
      loaded: loaded,
      failed: failed
    )
  }
}

extension StateView where Idle == DefaultStateViewIdle, Loading == DefaultStateViewLoading {
  init(
    state: Binding<ViewState<Value, Error>>,
    load: @escaping () -> Void,
    @ViewBuilder loaded: @escaping (Value) -> Loaded,
    @ViewBuilder failed: @escaping (Error) -> Failed
  ) {
    self.init(
      state: state,
      load: load,
      idle: { .clear },
      loading: { .init() },
      loaded: loaded,
      failed: failed
    )
  }
}

struct StateView_Previews: PreviewProvider {
  @State private static var state = ViewState<Int, Error>.idle

  static var previews: some View {
    StateView(state: $state) {
      state = .loaded(5)
    } loaded: { val in
      Text("\(val)!!!")
    } failed: { err in
      Text("Oh, no! \(err.localizedDescription)")
    }
  }
}
