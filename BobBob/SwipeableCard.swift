import SwiftUI

struct SwipeableCard<Content: View>: View {
    let content: Content
    let onDelete: () -> Void

    @GestureState private var dragOffset: CGFloat = 0
    @State private var revealDelete: Bool = false
    @State private var removed: Bool = false
    @State private var cardHeight: CGFloat = 0

    init(onDelete: @escaping () -> Void, @ViewBuilder content: () -> Content) {
        self.onDelete = onDelete
        self.content = content()
    }

    var body: some View {
        ZStack(alignment: .trailing) {

            if revealDelete || dragOffset < 0 {
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color.red)
                    .frame(width: 70, height: cardHeight)
                    .overlay(
                        Image(systemName: "trash")
                            .font(.title2)
                            .foregroundColor(.white)
                    )
                    .transition(.opacity)
            }

            content
                .background(
                    GeometryReader { geo in
                        Color.clear
                            .onAppear { cardHeight = geo.size.height }
                    }
                )
                .cornerRadius(14)
                .offset(
                    x: removed ? -500 :
                        revealDelete ? -70 :
                        dragOffset
                )
                .gesture(
                    DragGesture()
                        .updating($dragOffset) { value, state, _ in
                            if value.translation.width < 0 {
                                state = value.translation.width
                            }
                        }
                        .onEnded { value in
                            withAnimation(.spring()) {
                                revealDelete = value.translation.width < -40
                            }
                        }
                )
                .animation(.easeOut, value: dragOffset)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 0)
        .contentShape(Rectangle())
        .simultaneousGesture(
            TapGesture()
                .onEnded {
                    if revealDelete {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            removed = true
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                            onDelete()
                        }
                    }
                }
        )
    }
}
