import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:webtoon/models/webtoon.dart';
import 'package:webtoon/models/webtoon_episode_model.dart';
import '../models/webtoon_detail_model.dart';

//await은 데이터가 올때가지 기다린다.
//await을 사용할때는비동기 함수 내에서 사용할 수 있다(async)
//get 타입이 미래완료, Future이며 미래에 일어나기 때문에 await을 쓰게 된다.
class ApiService {
  static const String baseUrl = "https://webtoon-crawler.nomadcoders.workers.dev";
  static const String today = "today";
  static Future<List<WebtoonModel>> getTodaysToons() async {
    List<WebtoonModel> webtoonInstances = [];
    //http.get이 Future 반환
    final url = Uri.parse("$baseUrl/$today");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final webtoons = jsonDecode(
        response.body);
    //formjson의 Webtoonmodel 만듬
      for(var webtoon in webtoons) {
        final intance = WebtoonModel.fromJson(webtoon);
        webtoonInstances.add(intance);
      }
      //print(response.body);
      return webtoonInstances;
    }
    throw Error();
  }
  //ID로 webtoon을 한개 받아오는 method
  static Future<WebtoonDetailModel> getTodayById(String id) async {
    //http.get이 Future 반환
    final url = Uri.parse("$baseUrl/$id");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final webtoon = jsonDecode(response.body);
      //formjson의 Webtoonmodel 만듬
      return WebtoonDetailModel.fromJson(webtoon);
    }
    throw Error();
  }
  //다른 method는 에피소드를 받아온다.
  static Future<List<WebtoonEpisodeModel>> getLatestEpisodesById(String id) async {
    //에피소드 모델 리스트를 불러온다
    List<WebtoonEpisodeModel> episodesInstances =[];
    //http.get이 Future 반환
    //id와 episodes를 받아온다
    final url = Uri.parse("$baseUrl/$id/episodes");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final episodes = jsonDecode(response.body);
      for(var episode in episodes) {
        //모델들의 instance들을 리스트에 담아준다
        episodesInstances.add(WebtoonEpisodeModel.fromJson(episode));
      }
      return episodesInstances;
    }
    throw Error();
  }
}