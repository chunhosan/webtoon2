class WebtoonDetailModel{
  final String title, about, genre, age;
  //Json으로 초기와
  WebtoonDetailModel.fromJson(Map<String, dynamic> json)
      :title = json['title'],
      about = json['about'],
      genre = json['genre'],
      age = json['age'];
}
