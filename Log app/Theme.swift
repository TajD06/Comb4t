//
//  Theme.swift
//  Log app
//
//  Shared styling helpers and components. UI only — no app logic lives here.
//

import SwiftUI

// MARK: - Brand

enum Brand {
    static let purple = Color(red: 0.48, green: 0.36, blue: 1.0)
    static let pink = Color(red: 1.0, green: 0.30, blue: 0.62)
    static let colors = [purple, pink]
    static let gradient = LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing)
}

// MARK: - Discipline styling

extension Discipline {
    static let uiOrder: [Discipline] = [.striking, .grappling, .MMA]

    var symbolName: String {
        switch self {
        case .striking:
            return "figure.boxing"
        case .grappling:
            return "figure.wrestling"
        case .MMA:
            return "figure.martial.arts"
        }
    }

    var colors: [Color] {
        switch self {
        case .striking:
            return [Color(red: 1.0, green: 0.58, blue: 0.20), Color(red: 1.0, green: 0.25, blue: 0.36)]
        case .grappling:
            return [Color(red: 0.10, green: 0.78, blue: 0.74), Color(red: 0.22, green: 0.44, blue: 0.98)]
        case .MMA:
            return Brand.colors
        }
    }

    var tint: Color { colors[0] }

    var gradient: LinearGradient {
        LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing)
    }
}

// MARK: - Backgrounds & cards

/// Grouped background with two soft colour glows at the top.
struct AmbientBackground: View {
    var colors: [Color] = Brand.colors

    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
            Circle()
                .fill(colors[0].opacity(0.32))
                .frame(width: 360, height: 360)
                .blur(radius: 100)
                .offset(x: -130, y: -320)
            Circle()
                .fill(colors[1].opacity(0.26))
                .frame(width: 320, height: 320)
                .blur(radius: 100)
                .offset(x: 150, y: -240)
        }
        .ignoresSafeArea()
    }
}

struct CardModifier: ViewModifier {
    var padding: CGFloat = 18

    func body(content: Content) -> some View {
        content
            .padding(padding)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 26, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 26, style: .continuous)
                    .strokeBorder(Color.white.opacity(0.08))
            )
    }
}

extension View {
    func card(padding: CGFloat = 18) -> some View {
        modifier(CardModifier(padding: padding))
    }
}

/// Small uppercase label shown at the top of a card.
struct CardHeader: View {
    var title: String
    var systemImage: String
    var trailing: String? = nil

    var body: some View {
        HStack {
            Label(title, systemImage: systemImage)
            Spacer()
            if let trailing {
                Text(trailing)
            }
        }
        .font(.caption.weight(.bold))
        .textCase(.uppercase)
        .tracking(0.8)
        .foregroundStyle(.secondary)
    }
}

// MARK: - Buttons

struct GradientCapsuleButtonStyle: ButtonStyle {
    var colors: [Color] = Brand.colors

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .background(
                LinearGradient(colors: colors, startPoint: .leading, endPoint: .trailing),
                in: Capsule()
            )
            .shadow(color: colors[1].opacity(0.35), radius: 16, y: 8)
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(.snappy(duration: 0.2), value: configuration.isPressed)
    }
}

/// Circular glass +/- button.
struct RoundIconButton: View {
    var systemImage: String
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: systemImage)
                .font(.title3.weight(.semibold))
                .frame(width: 46, height: 46)
        }
        .buttonStyle(.plain)
        .buttonRepeatBehavior(.enabled)
        .glassEffect(.regular.interactive(), in: Circle())
    }
}

// MARK: - Discipline views

/// Rounded square gradient icon for a discipline.
struct DisciplineBadge: View {
    var discipline: Discipline
    var size: CGFloat = 40

    var body: some View {
        Image(systemName: discipline.symbolName)
            .font(.system(size: size * 0.46, weight: .semibold))
            .foregroundStyle(.white)
            .frame(width: size, height: size)
            .background(discipline.gradient, in: RoundedRectangle(cornerRadius: size * 0.3, style: .continuous))
            .shadow(color: discipline.tint.opacity(0.35), radius: 6, y: 3)
    }
}

/// Three large tappable tiles; the selected one fills with its gradient.
struct DisciplineSelector: View {
    @Binding var selection: Discipline
    var compact = false
    @Namespace private var namespace

    var body: some View {
        HStack(spacing: 10) {
            ForEach(Discipline.uiOrder, id: \.self) { discipline in
                let isSelected = discipline == selection
                Button {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                        selection = discipline
                    }
                } label: {
                    VStack(spacing: compact ? 6 : 10) {
                        Image(systemName: discipline.symbolName)
                            .font(.system(size: compact ? 20 : 28, weight: .semibold))
                            .symbolEffect(.bounce, value: isSelected)
                        Text(discipline.DisplayName)
                            .font(.footnote.weight(.semibold))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, compact ? 12 : 18)
                    .foregroundStyle(isSelected ? Color.white : Color.primary)
                    .background {
                        if isSelected {
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                .fill(discipline.gradient)
                                .matchedGeometryEffect(id: "selection", in: namespace)
                                .shadow(color: discipline.tint.opacity(0.4), radius: 10, y: 5)
                        } else {
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                .fill(Color(.tertiarySystemFill))
                        }
                    }
                    .contentShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                }
                .buttonStyle(.plain)
            }
        }
        .sensoryFeedback(.selection, trigger: selection)
    }
}

// MARK: - Duration dial

/// Drag around the ring to set minutes (snaps to 5), +/- for single minutes,
/// or tap a preset.
struct DurationDial: View {
    @Binding var minutes: Int
    var colors: [Color] = Brand.colors

    private let maxMinutes = 304
    private let minutesPerTurn = 300.0
    private let dialSize: CGFloat = 210
    private let lineWidth: CGFloat = 18
    private let presets = [30, 45, 60, 90, 120]

    private var progress: Double {
        min(Double(minutes) / minutesPerTurn, 1)
    }

    var body: some View {
        VStack(spacing: 20) {
            HStack {
                RoundIconButton(systemImage: "minus") {
                    minutes = max(minutes - 1, 0)
                }
                Spacer(minLength: 0)
                dial
                Spacer(minLength: 0)
                RoundIconButton(systemImage: "plus") {
                    minutes = min(minutes + 1, maxMinutes)
                }
            }

            HStack(spacing: 8) {
                ForEach(presets, id: \.self) { preset in
                    let isSelected = preset == minutes
                    Button {
                        withAnimation(.snappy) {
                            minutes = preset
                        }
                    } label: {
                        Text(presetLabel(preset))
                            .font(.footnote.weight(.semibold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 9)
                            .foregroundStyle(isSelected ? Color.white : Color.primary)
                            .background {
                                if isSelected {
                                    Capsule().fill(LinearGradient(colors: colors, startPoint: .leading, endPoint: .trailing))
                                } else {
                                    Capsule().fill(Color(.tertiarySystemFill))
                                }
                            }
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .sensoryFeedback(.selection, trigger: minutes)
    }

    private var dial: some View {
        let radius = dialSize / 2 - lineWidth / 2

        return ZStack {
            Circle()
                .stroke(Color(.tertiarySystemFill), lineWidth: lineWidth)
                .padding(lineWidth / 2)

            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    AngularGradient(colors: colors + [colors[0]], center: .center),
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .padding(lineWidth / 2)

            Circle()
                .fill(.white)
                .frame(width: lineWidth + 10, height: lineWidth + 10)
                .shadow(color: .black.opacity(0.25), radius: 4, y: 2)
                .offset(y: -radius)
                .rotationEffect(.degrees(progress * 360))

            VStack(spacing: 0) {
                Text("\(minutes)")
                    .font(.system(size: 56, weight: .bold, design: .rounded))
                    .monospacedDigit()
                    .contentTransition(.numericText(value: Double(minutes)))
                Text(minutes == 1 ? "minute" : "minutes")
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(.secondary)
            }
        }
        .frame(width: dialSize, height: dialSize)
        .animation(.snappy(duration: 0.25), value: minutes)
        .contentShape(Circle())
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { value in
                    let dx = value.location.x - dialSize / 2
                    let dy = value.location.y - dialSize / 2
                    var angle = atan2(dx, -dy) * 180 / .pi
                    if angle < 0 { angle += 360 }
                    let snapped = Int((angle / 360 * minutesPerTurn / 5).rounded()) * 5
                    // Ignore jumps across the top of the ring (e.g. 0 -> 295).
                    guard abs(snapped - minutes) <= 150 else { return }
                    let clamped = min(max(snapped, 0), maxMinutes)
                    if clamped != minutes {
                        minutes = clamped
                    }
                }
        )
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Duration")
        .accessibilityValue("\(minutes) minutes")
        .accessibilityAdjustableAction { direction in
            switch direction {
            case .increment:
                minutes = min(minutes + 5, maxMinutes)
            case .decrement:
                minutes = max(minutes - 5, 0)
            @unknown default:
                break
            }
        }
    }

    private func presetLabel(_ preset: Int) -> String {
        switch preset {
        case 90:
            return "1.5h"
        case let value where value % 60 == 0:
            return "\(value / 60)h"
        default:
            return "\(preset)m"
        }
    }
}

// MARK: - Counters, stats & rows

/// Big number with +/- buttons, used for sparring rounds and minutes.
struct CounterCard: View {
    var title: String
    var systemImage: String
    @Binding var value: Int
    var range: ClosedRange<Int>
    var unit: String = ""

    var body: some View {
        VStack(spacing: 14) {
            Label(title, systemImage: systemImage)
                .font(.caption.weight(.bold))
                .textCase(.uppercase)
                .tracking(0.8)
                .foregroundStyle(.secondary)

            HStack(alignment: .firstTextBaseline, spacing: 4) {
                Text("\(value)")
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .monospacedDigit()
                    .contentTransition(.numericText(value: Double(value)))
                if !unit.isEmpty {
                    Text(unit)
                        .font(.headline)
                        .foregroundStyle(.secondary)
                }
            }

            HStack(spacing: 14) {
                RoundIconButton(systemImage: "minus") {
                    value = max(value - 1, range.lowerBound)
                }
                .opacity(value == range.lowerBound ? 0.4 : 1)
                RoundIconButton(systemImage: "plus") {
                    value = min(value + 1, range.upperBound)
                }
                .opacity(value == range.upperBound ? 0.4 : 1)
            }
        }
        .frame(maxWidth: .infinity)
        .card(padding: 16)
        .animation(.snappy, value: value)
        .sensoryFeedback(.selection, trigger: value)
    }
}

struct StatTile: View {
    var value: String
    var unit: String = ""
    var label: String
    var systemImage: String
    var tint: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: systemImage)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(tint)
            HStack(alignment: .firstTextBaseline, spacing: 3) {
                Text(value)
                    .font(.system(.title2, design: .rounded, weight: .bold))
                    .monospacedDigit()
                if !unit.isEmpty {
                    Text(unit)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                }
            }
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}

/// Small rounded label used for metadata like duration.
struct MetaPill: View {
    var text: String
    var systemImage: String

    var body: some View {
        Label(text, systemImage: systemImage)
            .font(.caption.weight(.medium))
            .foregroundStyle(.secondary)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color(.tertiarySystemFill), in: Capsule())
    }
}

struct SparringRoundRow: View {
    var round: Sparring

    var body: some View {
        HStack(spacing: 12) {
            DisciplineBadge(discipline: round.discipline, size: 34)
            VStack(alignment: .leading, spacing: 2) {
                Text("\(round.rounds) × \(round.minutesPerRound) min")
                    .font(.body.weight(.semibold))
                Text(round.discipline.DisplayName)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Text("\(round.rounds * round.minutesPerRound) min")
                .font(.subheadline.weight(.semibold))
                .monospacedDigit()
                .foregroundStyle(.secondary)
        }
    }
}



