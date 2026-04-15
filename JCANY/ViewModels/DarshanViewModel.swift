import Foundation
import Observation

@Observable
final class DarshanViewModel {
    var streams: [LiveStream] = MockDataProvider.liveStreams
    var aartiSchedule: [AartiSchedule] = MockDataProvider.aartiSchedule

    var featuredStream: LiveStream? { streams.first(where: { $0.isLive }) ?? streams.first }
    var gridStreams: [LiveStream] { Array(streams.dropFirst()) }
}
