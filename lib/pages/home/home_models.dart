import 'package:flutter/material.dart';

/// Static mock data backing the tenant homepage.
///
/// These are intentionally plain immutable value objects with hard-coded
/// sample content so the screen matches the Figma reference pixel-for-pixel
/// without any backend. Swap [HomeMockData] for a provider/service later.

/// A property tile in the "Properties Near You" grid.
class PropertyListing {
  final String title;
  final String location;
  final int priceFrom;
  final String currency;

  /// Optional asset path; when null (the default) the card renders a
  /// gradient + icon placeholder so the build never depends on artwork.
  final String? image;

  /// Optional network image URL. Takes priority over [image] when set.
  final String? imageUrl;

  /// Seed used to pick a deterministic placeholder gradient.
  final int seed;

  const PropertyListing({
    required this.title,
    required this.location,
    required this.priceFrom,
    this.currency = '€',
    this.image,
    this.imageUrl,
    this.seed = 0,
  });
}

/// A video reel tile in the "Reeling you in" grid.
class TravelReel {
  final String place; // top-left chip, e.g. "Warsaw"
  final String duration; // top-right, e.g. "6:01"
  final String landmark; // bottom-left bold, e.g. "Lummus Beach"
  final String author; // bottom-right, e.g. "Altinio casa"
  final String? image;
  final String? imageUrl;
  final int seed;

  const TravelReel({
    required this.place,
    required this.duration,
    required this.landmark,
    required this.author,
    this.image,
    this.imageUrl,
    this.seed = 0,
  });
}

class HomeMockData {
  HomeMockData._();

  static const String userName = 'Sara';
  static const String searchLocation = 'Dubai';
  static const String moveInDate = '01 Oct 2025';
  static const String moveOutDate = '02 Apr 2026';

  /// Shared sample interior photo.
  static const String propertyPhoto =
      'https://images-pw.pixieset.com/elementfield/118151704/airbnb-professional-photography-property-videos-photographer-2fccd033-1500.jpg';

  static const List<PropertyListing> properties = [
    PropertyListing(
        title: 'A101 - Future Towers',
        location: 'Dubai',
        priceFrom: 780,
        imageUrl: propertyPhoto,
        seed: 0),
    PropertyListing(
        title: 'A101 - Future Towers',
        location: 'Dubai',
        priceFrom: 1200,
        imageUrl: propertyPhoto,
        seed: 1),
    PropertyListing(
        title: 'A101 - Future Towers',
        location: 'Dubai',
        priceFrom: 1480,
        imageUrl: propertyPhoto,
        seed: 2),
    PropertyListing(
        title: 'A101 - Future Towers',
        location: 'Dubai',
        priceFrom: 1389,
        imageUrl: propertyPhoto,
        seed: 3),
  ];

  static const List<TravelReel> reels = [
    TravelReel(
        place: 'Warsaw',
        duration: '6:01',
        landmark: 'Lummus Beach',
        author: 'Altinio casa',
        imageUrl: propertyPhoto,
        seed: 4),
    TravelReel(
        place: 'Milan',
        duration: '6:01',
        landmark: 'La Digue',
        author: 'Fernanda',
        imageUrl: propertyPhoto,
        seed: 5),
    TravelReel(
        place: 'Greece',
        duration: '6:01',
        landmark: 'Navagio Beach',
        author: 'Olivia',
        imageUrl: propertyPhoto,
        seed: 6),
    TravelReel(
        place: 'Dubai',
        duration: '6:01',
        landmark: 'Burj Khalifa',
        author: 'Sammy',
        imageUrl: propertyPhoto,
        seed: 7),
    TravelReel(
        place: 'Dubai',
        duration: '6:01',
        landmark: 'Museum of\nthe Future',
        author: 'Sammy',
        imageUrl: propertyPhoto,
        seed: 8),
  ];

  /// Deterministic placeholder gradients so each card looks distinct even
  /// before real imagery is dropped in.
  static List<Color> placeholderGradient(int seed) {
    const palettes = <List<Color>>[
      [Color(0xff8D6E63), Color(0xff4E342E)],
      [Color(0xff5C6BC0), Color(0xff283593)],
      [Color(0xff26A69A), Color(0xff00695C)],
      [Color(0xffEC407A), Color(0xffAD1457)],
      [Color(0xff29B6F6), Color(0xff0277BD)],
      [Color(0xff66BB6A), Color(0xff2E7D32)],
      [Color(0xff26C6DA), Color(0xff00838F)],
      [Color(0xffFFA726), Color(0xffEF6C00)],
      [Color(0xff7E57C2), Color(0xff4527A0)],
    ];
    return palettes[seed % palettes.length];
  }
}
