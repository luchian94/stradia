class Capture {
  final String deviceId;
  final String tripId;
  final double latitude;
  final double longitude;
  final double heading;
  final String date;
  final String image;

  Capture(
    this.deviceId,
    this.tripId,
    this.latitude,
    this.longitude,
    this.heading,
    this.date,
    this.image,
  );

  Capture.fromJson(Map<String, dynamic> json)
      : deviceId = json['deviceId'],
        tripId = json['tripId'],
        latitude = json['latitude'],
        longitude = json['longitude'],
        heading = json['heading'],
        date = json['date'],
        image = json['image'];

  Map<String, dynamic> toJson() => {
        'deviceId': deviceId,
        'tripId': tripId,
        'latitude': latitude,
        'longitude': longitude,
        'date': date,
        'image': image,
      };
}
