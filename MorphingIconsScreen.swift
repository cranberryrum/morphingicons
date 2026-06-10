import SwiftUI
import UIKit

// MARK: - Model

struct IconLine: Equatable {
    var start: CGPoint
    var end: CGPoint

    /// A zero-length line hidden at the icon's center. Icons that need fewer
    /// than three visible lines park their unused lines here.
    static let collapsed = IconLine(
        start: CGPoint(x: 0.5, y: 0.5),
        end: CGPoint(x: 0.5, y: 0.5)
    )

    var isCollapsed: Bool {
        hypot(end.x - start.x, end.y - start.y) < 0.0001
    }

    /// Rotates both endpoints around the unit-square center (0.5, 0.5).
    func rotated(byDegrees degrees: Double) -> IconLine {
        guard degrees.truncatingRemainder(dividingBy: 360) != 0 else { return self }
        let radians = degrees * .pi / 180

        func rotate(_ point: CGPoint) -> CGPoint {
            let dx = point.x - 0.5
            let dy = point.y - 0.5
            return CGPoint(
                x: 0.5 + dx * cos(radians) - dy * sin(radians),
                y: 0.5 + dx * sin(radians) + dy * cos(radians)
            )
        }

        return IconLine(start: rotate(start), end: rotate(end))
    }
}

struct MorphIcon: Identifiable, Equatable {
    let id: String
    let name: String
    /// Icons sharing a family have identical base lines and differ only by
    /// rotation, so they morph by rotating instead of moving coordinates.
    let family: String?
    /// Exactly three lines in a unit square, in the family's base orientation.
    let lines: [IconLine]
    let rotationDegrees: Double

    init(id: String, name: String, family: String?, lines: [IconLine], rotationDegrees: Double) {
        precondition(lines.count == 3, "Every morph icon must use exactly three lines")
        self.id = id
        self.name = name
        self.family = family
        self.lines = lines
        self.rotationDegrees = rotationDegrees
    }

    /// Base lines with the icon's own rotation applied.
    var bakedLines: [IconLine] {
        lines.map { $0.rotated(byDegrees: rotationDegrees) }
    }
}

// MARK: - Icon catalog

extension MorphIcon {
    private static let plusLines: [IconLine] = [
        IconLine(start: CGPoint(x: 0.5, y: 0.14), end: CGPoint(x: 0.5, y: 0.86)),
        .collapsed,
        IconLine(start: CGPoint(x: 0.14, y: 0.5), end: CGPoint(x: 0.86, y: 0.5))
    ]

    private static let arrowLines: [IconLine] = [
        IconLine(start: CGPoint(x: 0.5, y: 0.16), end: CGPoint(x: 0.22, y: 0.44)),
        IconLine(start: CGPoint(x: 0.5, y: 0.16), end: CGPoint(x: 0.78, y: 0.44)),
        IconLine(start: CGPoint(x: 0.5, y: 0.16), end: CGPoint(x: 0.5, y: 0.84))
    ]

    private static let chevronLines: [IconLine] = [
        IconLine(start: CGPoint(x: 0.5, y: 0.38), end: CGPoint(x: 0.2, y: 0.62)),
        IconLine(start: CGPoint(x: 0.5, y: 0.38), end: CGPoint(x: 0.8, y: 0.62)),
        .collapsed
    ]

    static let plus = MorphIcon(
        id: "plus", name: "Plus", family: "plus",
        lines: plusLines, rotationDegrees: 0
    )
    static let close = MorphIcon(
        id: "close", name: "Close", family: "plus",
        lines: plusLines, rotationDegrees: 45
    )
    static let minus = MorphIcon(
        id: "minus", name: "Minus", family: nil,
        lines: [
            .collapsed,
            .collapsed,
            IconLine(start: CGPoint(x: 0.14, y: 0.5), end: CGPoint(x: 0.86, y: 0.5))
        ],
        rotationDegrees: 0
    )
    static let menu = MorphIcon(
        id: "menu", name: "Menu", family: nil,
        lines: [
            IconLine(start: CGPoint(x: 0.14, y: 0.26), end: CGPoint(x: 0.86, y: 0.26)),
            IconLine(start: CGPoint(x: 0.14, y: 0.5), end: CGPoint(x: 0.86, y: 0.5)),
            IconLine(start: CGPoint(x: 0.14, y: 0.74), end: CGPoint(x: 0.86, y: 0.74))
        ],
        rotationDegrees: 0
    )
    static let check = MorphIcon(
        id: "check", name: "Check", family: nil,
        lines: [
            .collapsed,
            IconLine(start: CGPoint(x: 0.18, y: 0.54), end: CGPoint(x: 0.43, y: 0.78)),
            IconLine(start: CGPoint(x: 0.43, y: 0.78), end: CGPoint(x: 0.84, y: 0.3))
        ],
        rotationDegrees: 0
    )
    static let play = MorphIcon(
        id: "play", name: "Play", family: nil,
        lines: [
            IconLine(start: CGPoint(x: 0.34, y: 0.18), end: CGPoint(x: 0.34, y: 0.82)),
            IconLine(start: CGPoint(x: 0.34, y: 0.18), end: CGPoint(x: 0.84, y: 0.5)),
            IconLine(start: CGPoint(x: 0.34, y: 0.82), end: CGPoint(x: 0.84, y: 0.5))
        ],
        rotationDegrees: 0
    )
    static let arrowUp = MorphIcon(
        id: "arrow-up", name: "Arrow up", family: "arrow",
        lines: arrowLines, rotationDegrees: 0
    )
    static let arrowRight = MorphIcon(
        id: "arrow-right", name: "Arrow right", family: "arrow",
        lines: arrowLines, rotationDegrees: 90
    )
    static let arrowDown = MorphIcon(
        id: "arrow-down", name: "Arrow down", family: "arrow",
        lines: arrowLines, rotationDegrees: 180
    )
    static let arrowLeft = MorphIcon(
        id: "arrow-left", name: "Arrow left", family: "arrow",
        lines: arrowLines, rotationDegrees: 270
    )
    static let chevronUp = MorphIcon(
        id: "chevron-up", name: "Chevron up", family: "chevron",
        lines: chevronLines, rotationDegrees: 0
    )
    static let chevronDown = MorphIcon(
        id: "chevron-down", name: "Chevron down", family: "chevron",
        lines: chevronLines, rotationDegrees: 180
    )

    static let catalog: [MorphIcon] = [
        plus, close, minus, menu,
        check, play, arrowUp, arrowRight,
        arrowDown, arrowLeft, chevronUp, chevronDown
    ]
}

// MARK: - Animatable line shape

private struct LineSegmentShape: Shape {
    var line: IconLine

    var animatableData: AnimatablePair<AnimatablePair<CGFloat, CGFloat>, AnimatablePair<CGFloat, CGFloat>> {
        get {
            AnimatablePair(
                AnimatablePair(line.start.x, line.start.y),
                AnimatablePair(line.end.x, line.end.y)
            )
        }
        set {
            line = IconLine(
                start: CGPoint(x: newValue.first.first, y: newValue.first.second),
                end: CGPoint(x: newValue.second.first, y: newValue.second.second)
            )
        }
    }

    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(
            x: rect.minX + line.start.x * rect.width,
            y: rect.minY + line.start.y * rect.height
        ))
        path.addLine(to: CGPoint(
            x: rect.minX + line.end.x * rect.width,
            y: rect.minY + line.end.y * rect.height
        ))
        return path
    }
}

// MARK: - Morphing icon component

/// Renders a `MorphIcon` and smoothly morphs whenever `icon` changes.
///
/// Same-family targets (arrows, chevrons, plus/close) rotate along the
/// shortest arc; everything else interpolates line endpoints, fading
/// collapsed lines in and out at the center.
struct MorphingIconView: View {
    let icon: MorphIcon
    var lineWidth: CGFloat = 10
    var color: Color = .primary

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    /// Lines currently displayed, expressed in the rotating frame.
    @State private var lines: [IconLine]
    @State private var opacities: [Double]
    @State private var frameRotation: Double
    @State private var current: MorphIcon
    @State private var wholeOpacity: Double = 1
    @State private var inFlightAnimations = 0
    @State private var morphGeneration = 0

    private let morphSpring = Animation.spring(response: 0.4, dampingFraction: 0.82)

    init(icon: MorphIcon, lineWidth: CGFloat = 10, color: Color = .primary) {
        self.icon = icon
        self.lineWidth = lineWidth
        self.color = color
        _current = State(initialValue: icon)
        _lines = State(initialValue: icon.bakedLines)
        _opacities = State(initialValue: icon.bakedLines.map { $0.isCollapsed ? 0 : 1 })
        _frameRotation = State(initialValue: 0)
    }

    var body: some View {
        ZStack {
            ForEach(0..<3) { index in
                LineSegmentShape(line: lines[index])
                    .stroke(color, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .round))
                    .opacity(opacities[index])
            }
        }
        .rotationEffect(.degrees(frameRotation))
        .opacity(wholeOpacity)
        .aspectRatio(1, contentMode: .fit)
        .onChange(of: icon) { _, newIcon in
            morph(to: newIcon)
        }
    }

    private func morph(to target: MorphIcon) {
        guard target.id != current.id else { return }
        let source = current
        current = target
        morphGeneration += 1
        let generation = morphGeneration

        // Reduced motion keeps the opacity change but drops the movement:
        // a quick fade out, instant geometry swap, fade back in.
        if reduceMotion {
            crossfade(to: target, generation: generation)
            return
        }

        // Rotation only works from a settled state: re-expressing the current
        // geometry as base-lines-plus-rotation is a snap, which is invisible
        // when settled but would jump mid-animation. Interrupted morphs fall
        // back to the coordinate path, which retargets continuously.
        let canRotate = target.family != nil
            && target.family == source.family
            && target.lines == source.lines
            && inFlightAnimations == 0

        if canRotate {
            // Re-express the settled icon as family base lines + rotation,
            // visually identical to what is on screen.
            var snap = Transaction()
            snap.disablesAnimations = true
            withTransaction(snap) {
                lines = source.lines
                opacities = source.lines.map { $0.isCollapsed ? 0 : 1 }
                frameRotation += shortestDelta(from: frameRotation, to: source.rotationDegrees)
            }

            // Animate on the next runloop pass so the snap commits first.
            DispatchQueue.main.async {
                guard generation == morphGeneration else { return }
                inFlightAnimations += 1
                withAnimation(morphSpring, completionCriteria: .logicallyComplete) {
                    frameRotation += shortestDelta(from: frameRotation, to: target.rotationDegrees)
                } completion: {
                    inFlightAnimations -= 1
                }
            }
        } else {
            // Express the target in the current frame so the world-space
            // result is a straight coordinate morph, with no rotation change.
            let targetLines = target.lines.map {
                $0.rotated(byDegrees: target.rotationDegrees - frameRotation)
            }
            inFlightAnimations += 1
            withAnimation(morphSpring, completionCriteria: .logicallyComplete) {
                lines = targetLines
                opacities = target.lines.map { $0.isCollapsed ? 0 : 1 }
            } completion: {
                inFlightAnimations -= 1
            }
        }
    }

    private func crossfade(to target: MorphIcon, generation: Int) {
        withAnimation(.easeOut(duration: 0.1), completionCriteria: .logicallyComplete) {
            wholeOpacity = 0
        } completion: {
            guard generation == morphGeneration else { return }
            var snap = Transaction()
            snap.disablesAnimations = true
            withTransaction(snap) {
                lines = target.bakedLines
                opacities = target.bakedLines.map { $0.isCollapsed ? 0 : 1 }
                frameRotation = 0
            }
            withAnimation(.easeOut(duration: 0.15)) {
                wholeOpacity = 1
            }
        }
    }

    private func shortestDelta(from: Double, to: Double) -> Double {
        var delta = (to - from).truncatingRemainder(dividingBy: 360)
        if delta > 180 {
            delta -= 360
        } else if delta < -180 {
            delta += 360
        }
        return delta
    }
}

/// Static, non-animating render of an icon for pickers and lists.
private struct IconGlyph: View {
    let icon: MorphIcon
    let lineWidth: CGFloat
    let color: Color

    var body: some View {
        ZStack {
            ForEach(Array(icon.bakedLines.enumerated()), id: \.offset) { _, line in
                if !line.isCollapsed {
                    LineSegmentShape(line: line)
                        .stroke(color, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .round))
                }
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

// MARK: - Screen

struct MorphingIconsScreen: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    @State private var selected: MorphIcon = .plus
    @State private var hasAppeared = false

    private let backgroundColor = Color(red: 245 / 255, green: 245 / 255, blue: 245 / 255)
    private let textColor = Color(red: 15 / 255, green: 15 / 255, blue: 15 / 255)
    private let secondaryTextColor = Color(red: 84 / 255, green: 84 / 255, blue: 84 / 255)
    private let hairlineColor = Color(red: 227 / 255, green: 227 / 255, blue: 227 / 255)
    private let selectedStrokeColor = Color(red: 160 / 255, green: 160 / 255, blue: 160 / 255)

    init() {
        OpenSauceOneFont.preload()
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
                previewCard

                iconGrid
            }
            .padding(20)
        }
        .background(backgroundColor.ignoresSafeArea())
        .navigationTitle("morphing icons")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var previewCard: some View {
        VStack(spacing: 20) {
            MorphingIconView(icon: selected, lineWidth: 11, color: textColor)
                .frame(width: 150, height: 150)
                .padding(.top, 40)

            // Blur bridges the two overlapping texts during the swap, so the
            // change reads as one transformation instead of a plain crossfade.
            VStack(spacing: 4) {
                ZStack {
                    Text(selected.name)
                        .font(.openSauceSemibold(size: 16))
                        .foregroundStyle(textColor)
                        .id(selected.name)
                        .transition(.blurReplace)
                }

                ZStack {
                    Text(morphHint)
                        .font(.openSauceRegular(size: 12))
                        .foregroundStyle(secondaryTextColor)
                        .id(morphHint)
                        .transition(.blurReplace)
                }
            }
            .animation(.easeOut(duration: 0.18), value: selected.id)
            .padding(.bottom, 32)
        }
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(.white)
        )
    }

    private var morphHint: String {
        if let family = selected.family {
            return "\(family) family \u{2014} rotates within its family"
        }
        return "morphs line by line"
    }

    private var iconGrid: some View {
        LazyVGrid(
            columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 4),
            spacing: 16
        ) {
            ForEach(Array(MorphIcon.catalog.enumerated()), id: \.element.id) { index, icon in
                iconButton(icon)
                    .opacity(hasAppeared ? 1 : 0)
                    .offset(y: hasAppeared || reduceMotion ? 0 : 10)
                    .animation(
                        .easeOut(duration: 0.24).delay(Double(index) * 0.025),
                        value: hasAppeared
                    )
            }
        }
        .onAppear {
            hasAppeared = true
        }
    }

    private func iconButton(_ icon: MorphIcon) -> some View {
        let isSelected = icon == selected

        return Button {
            select(icon)
        } label: {
            VStack(spacing: 8) {
                IconGlyph(
                    icon: icon,
                    lineWidth: 2.4,
                    color: textColor
                )
                .frame(width: 26, height: 26)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(.white)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .strokeBorder(
                            isSelected ? selectedStrokeColor : hairlineColor,
                            lineWidth: isSelected ? 1.6 : 1
                        )
                )

                Text(icon.name)
                    .font(.openSauceRegular(size: 10))
                    .foregroundStyle(isSelected ? textColor : secondaryTextColor)
                    .lineLimit(1)
            }
        }
        .buttonStyle(PressableButtonStyle())
        .animation(.easeOut(duration: 0.15), value: isSelected)
    }

    private func select(_ icon: MorphIcon) {
        guard icon != selected else { return }
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        selected = icon
    }
}

/// Scales the label down slightly while pressed so the button visibly
/// responds the moment the finger lands.
private struct PressableButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.96 : 1)
            .animation(.easeOut(duration: 0.16), value: configuration.isPressed)
    }
}

#Preview {
    NavigationStack {
        MorphingIconsScreen()
    }
}
