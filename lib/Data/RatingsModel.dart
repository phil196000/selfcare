class RatingsModel {
  final String comment;
  final int created_at;
  final String id;
  final int rating;
  final Map? user;

  RatingsModel(
      {this.comment = '',
      this.id = '',
      this.created_at = 0,
      this.user,
      this.rating = 0});

  RatingsModel.fromJson(Map<String, dynamic> json)
      : comment = json['comment'],
        id = json['id'],
        user = json['user'],
        rating = json['rating'],
        created_at = json['created_at'];

  Map<String, dynamic> toJson() => {
        'comment': comment,
        'rating': rating,
        'created_at': created_at,
        'id': id,
        'user': user
      };
}
