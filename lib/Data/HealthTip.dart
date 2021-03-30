class TipModel {
  final String title;
  final int created_at;
  final String description;
  final bool is_deleted;
  final String tip_id;

  TipModel(
      {this.title = '',
      this.description = '',
      this.created_at = 0,
      this.is_deleted = false,
      this.tip_id = ''});

  TipModel.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        description = json['description'],
        tip_id = json['tip_id'],
        is_deleted = json['is_deleted'],
        created_at = json['created_at'];

  Map<String, dynamic> toJson() => {
        'title': title,
        'tip_id': tip_id,
        'is_deleted': is_deleted,
        'created_at': created_at,
        'description': description
      };
}
