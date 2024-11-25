class ReviewModel {
  final String customerName;
  final String customerPhone;
  final String customerDeviceToken;
  final String customerId;
  final String feedback;
  final String rating;
  final dynamic createdAt;

  // Constructor with named parameters
  ReviewModel({
    required this.customerName,
    required this.customerPhone,
    required this.customerDeviceToken,
    required this.customerId,
    required this.feedback,
    required this.rating,
    required this.createdAt,  // Optional if the createdAt is dynamically set
  });

  // Optional: You can also add methods like toJson() for easy conversion to JSON
  Map<String, dynamic> toJson() {
    return {
      'customerName': customerName,
      'customerPhone': customerPhone,
      'customerDeviceToken': customerDeviceToken,
      'customerId': customerId,
      'feedback': feedback,
      'rating': rating,
      'createdAt': createdAt,
    };
  }

  // Optional: You can add a factory constructor to create an instance from JSON
  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      customerName: json['customerName'],
      customerPhone: json['customerPhone'],
      customerDeviceToken: json['customerDeviceToken'],
      customerId: json['customerId'],
      feedback: json['feedback'],
      rating: json['rating'],
      createdAt: json['createdAt'],
    );
  }
}
