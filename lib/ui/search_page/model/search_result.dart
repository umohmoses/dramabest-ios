class SearchResult {
  String? sId;
  String? name;
  String? description;
  String? thumbnail;
  String? releaseDate;
  bool? isActive;
  String? categoryId;
  String? category;

  SearchResult(
      {this.sId, this.name, this.description, this.thumbnail, this.releaseDate, this.isActive, this.categoryId, this.category});

  SearchResult.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    description = json['description'];
    thumbnail = json['thumbnail'];
    releaseDate = json['releaseDate'];
    isActive = json['isActive'];
    categoryId = json['categoryId'];
    category = json['category'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    data['description'] = description;
    data['thumbnail'] = thumbnail;
    data['releaseDate'] = releaseDate;
    data['isActive'] = isActive;
    data['categoryId'] = categoryId;
    data['category'] = category;
    return data;
  }
}
