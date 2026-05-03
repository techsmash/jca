import SwiftUI
import MapKit
import CoreLocation

struct JainCentersUSAView: View {
    @State private var tab = "Centers"
    @StateObject private var locationManager = LocationManager()

    var body: some View {
        VStack(spacing: 0) {
            PillTabBar(tabs: ["Centers", "Restaurants", "Map View"], selection: $tab)
                .padding(.vertical, 10)
                .background(Color.jcaCream)

            Divider().overlay(Color.jcaBorder)

            Group {
                switch tab {
                case "Restaurants":
                    RestaurantsListView(locationManager: locationManager)
                case "Map View":
                    JainCentersMapView(locationManager: locationManager)
                default:
                    CentersListView(locationManager: locationManager)
                }
            }
        }
        .background(Color.jcaCream.ignoresSafeArea())
        .navigationTitle("Jain Centers USA")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { locationManager.requestPermission() }
    }
}

// MARK: - Centers List

private struct CentersListView: View {
    let locationManager: LocationManager

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(MockDataProvider.jainCenters) { center in
                    CenterRow(center: center, userLocation: locationManager.location)
                    if center.id != MockDataProvider.jainCenters.last?.id {
                        Divider().overlay(Color.jcaBorder).padding(.horizontal, 16)
                    }
                }
            }
            .background(
                RoundedRectangle(cornerRadius: Radii.base)
                    .fill(Color.jcaPaper)
                    .overlay(RoundedRectangle(cornerRadius: Radii.base).stroke(Color.jcaBorder, lineWidth: 0.5))
                    .shadowSm()
            )
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
        }
        .background(Color.jcaCream.ignoresSafeArea())
    }
}

private struct CenterRow: View {
    let center: JainCenter
    let userLocation: CLLocation?
    @Environment(\.openURL) private var openURL

    private var distanceText: String {
        guard let loc = userLocation else { return "" }
        let meters = loc.distance(from: CLLocation(latitude: center.latitude, longitude: center.longitude))
        let miles = meters / 1609.34
        return String(format: "%.1f mi", miles)
    }

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.jcaCrimson.opacity(0.08))
                    .frame(width: 44, height: 44)
                Image(systemName: "building.columns.fill")
                    .font(.system(size: 18))
                    .foregroundStyle(Color.jcaCrimson)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(center.name)
                    .font(JCAFont.title)
                    .foregroundStyle(Color.jcaInk)
                    .lineLimit(2)
                Text(center.fullAddress)
                    .font(JCAFont.caption)
                    .foregroundStyle(Color.jcaMuted)
                Text(center.hours)
                    .font(JCAFont.caption)
                    .foregroundStyle(Color.jcaMuted)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 8) {
                if !distanceText.isEmpty {
                    Text(distanceText)
                        .font(JCAFont.caption)
                        .foregroundStyle(Color.jcaMuted)
                }
                Button {
                    openDirections(for: center)
                } label: {
                    Image(systemName: "arrow.triangle.turn.up.right.circle.fill")
                        .font(.system(size: 24))
                        .foregroundStyle(Color.jcaCrimson)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Get directions to \(center.name)")
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
    }

    private func openDirections(for center: JainCenter) {
        let item = MKMapItem(placemark: MKPlacemark(coordinate: center.coordinate))
        item.name = center.name
        item.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
    }
}

// MARK: - Restaurants List

private struct RestaurantsListView: View {
    let locationManager: LocationManager

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(MockDataProvider.vegRestaurants) { restaurant in
                    RestaurantRow(restaurant: restaurant, userLocation: locationManager.location)
                    if restaurant.id != MockDataProvider.vegRestaurants.last?.id {
                        Divider().overlay(Color.jcaBorder).padding(.horizontal, 16)
                    }
                }
            }
            .background(
                RoundedRectangle(cornerRadius: Radii.base)
                    .fill(Color.jcaPaper)
                    .overlay(RoundedRectangle(cornerRadius: Radii.base).stroke(Color.jcaBorder, lineWidth: 0.5))
                    .shadowSm()
            )
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
        }
        .background(Color.jcaCream.ignoresSafeArea())
    }
}

private struct RestaurantRow: View {
    let restaurant: VegRestaurant
    let userLocation: CLLocation?
    @Environment(\.openURL) private var openURL

    private var distanceText: String {
        guard let loc = userLocation else { return "" }
        let meters = loc.distance(from: CLLocation(latitude: restaurant.latitude, longitude: restaurant.longitude))
        let miles = meters / 1609.34
        return String(format: "%.1f mi", miles)
    }

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(hex: "#047857").opacity(0.08))
                    .frame(width: 44, height: 44)
                Image(systemName: "fork.knife")
                    .font(.system(size: 18))
                    .foregroundStyle(Color(hex: "#047857"))
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(restaurant.name)
                    .font(JCAFont.title)
                    .foregroundStyle(Color.jcaInk)
                Text("\(restaurant.address), \(restaurant.city)")
                    .font(JCAFont.caption)
                    .foregroundStyle(Color.jcaMuted)
                HStack(spacing: 6) {
                    Text(restaurant.kind.badge)
                        .font(JCAFont.caption)
                        .foregroundStyle(Color(hex: "#047857"))
                    HStack(spacing: 3) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 9))
                            .foregroundStyle(Color.jcaGoldDeep)
                        Text(String(format: "%.1f", restaurant.rating))
                            .font(JCAFont.caption)
                            .foregroundStyle(Color.jcaMuted)
                    }
                }
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 8) {
                if !distanceText.isEmpty {
                    Text(distanceText)
                        .font(JCAFont.caption)
                        .foregroundStyle(Color.jcaMuted)
                }
                Button {
                    let item = MKMapItem(placemark: MKPlacemark(coordinate: restaurant.coordinate))
                    item.name = restaurant.name
                    item.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
                } label: {
                    Image(systemName: "arrow.triangle.turn.up.right.circle.fill")
                        .font(.system(size: 24))
                        .foregroundStyle(Color(hex: "#047857"))
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Get directions to \(restaurant.name)")
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
    }
}

// MARK: - Map View

private struct JainCentersMapView: View {
    let locationManager: LocationManager
    @State private var selectedCenter: JainCenter? = nil

    private var region: MKCoordinateRegion {
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 39.5, longitude: -98.35),
            span: MKCoordinateSpan(latitudeDelta: 40, longitudeDelta: 40)
        )
    }

    var body: some View {
        Map(initialPosition: .region(region)) {
            ForEach(MockDataProvider.jainCenters) { center in
                Annotation(center.name, coordinate: center.coordinate) {
                    Button {
                        selectedCenter = center
                    } label: {
                        ZStack {
                            Circle()
                                .fill(Color.jcaCrimson)
                                .frame(width: 32, height: 32)
                                .shadow(color: Color.jcaCrimson.opacity(0.4), radius: 4, y: 2)
                            Image(systemName: "building.columns.fill")
                                .font(.system(size: 14))
                                .foregroundStyle(.white)
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
            if locationManager.location != nil {
                UserAnnotation()
            }
        }
        .mapStyle(.standard)
        .ignoresSafeArea(edges: .bottom)
        .sheet(item: $selectedCenter) { center in
            CenterMapDetail(center: center)
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
        }
    }
}

private struct CenterMapDetail: View {
    let center: JainCenter
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text(center.name)
                    .font(.fraunces(size: 18, weight: .semibold))
                    .foregroundStyle(Color.jcaInk)
                Spacer()
                Button { dismiss() } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 22))
                        .foregroundStyle(Color.jcaMuted.opacity(0.4))
                }
                .buttonStyle(.plain)
            }

            Label(center.fullAddress, systemImage: "mappin")
                .font(JCAFont.body)
                .foregroundStyle(Color.jcaInkSoft)

            Label(center.hours, systemImage: "clock")
                .font(JCAFont.body)
                .foregroundStyle(Color.jcaInkSoft)

            Button {
                let item = MKMapItem(placemark: MKPlacemark(coordinate: center.coordinate))
                item.name = center.name
                item.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
            } label: {
                Label("Get Directions", systemImage: "arrow.triangle.turn.up.right.circle.fill")
                    .font(JCAFont.title)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 13)
                    .background(Color.jcaCrimson)
                    .clipShape(RoundedRectangle(cornerRadius: Radii.base))
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Get directions to \(center.name)")
        }
        .padding(24)
        .background(Color.jcaCream)
    }
}

// MARK: - Location Manager

final class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var location: CLLocation? = nil
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined

    private let manager = CLLocationManager()

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyKilometer
    }

    func requestPermission() {
        manager.requestWhenInUseAuthorization()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.last
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
        if manager.authorizationStatus == .authorizedWhenInUse {
            manager.startUpdatingLocation()
        }
    }
}

#Preview {
    NavigationStack {
        JainCentersUSAView()
    }
}
