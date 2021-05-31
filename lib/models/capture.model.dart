class Capture {
  final String image;
  final double lat;
  final double long;

  Capture(this.image, this.lat, this.long);

  Capture.fromJson(Map<String, dynamic> json)
      : image = json['image'],
        lat = json['lat'],
        long = json['long'];

  Map<String, dynamic> toJson() => {
        'image': image,
        'lat': lat,
        'long': long,
      };
}
