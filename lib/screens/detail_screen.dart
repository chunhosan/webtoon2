import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:webtoon/models/webtoon_episode_model.dart';
import 'package:webtoon/services/api_service.dart';
import '../models/webtoon_detail_model.dart';
import '../widgets/episode_widget.dart';
//다른 property로 접근할 수 없기 때문에 StatefulWidget으로 변경
class DetailScreen extends StatefulWidget {
  //필요한 정보를 넣어주기 위한 변수 생성
  final String title, thumb, id;

  const DetailScreen({
    super.key,
    required this.title,
    required this.thumb,
    required this.id,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}
//StatefulWidget으로 변경하면서 별개의 클래스로 바뀐다. (title->widget.title로 리팩토링)
//homescreen에서 webtoonmodel을 가져온것처러 그대로!
class _DetailScreenState extends State<DetailScreen> {
  late Future<WebtoonDetailModel> webtoon;
  late Future<List<WebtoonEpisodeModel>> episodes;
  late SharedPreferences prefs;
  bool isLiked = false;
  //사용자가 버튼을 누를때마다 좋아요를 누른 모든 ID리스트를 가져온다.
  //화면이 로딩되면 해당 widget의 ID가 사용자가 좋아요를 누른 ID 목록에 있는지 반영
  //사용자가 좋아요를 누르면 likedToons에서 ID를 더하거나 빼준다
  Future initPrefs() async{
    prefs = await SharedPreferences.getInstance();
    final likedToons = prefs.getStringList('likedToons');
    //사용자가 보고있는 webtoon의 id가 likedToons안에 있는지 확인
    //사용자의 저장소에서 likedtoons을 찾아보고 저장소에 존재한다면
    //likedtoons에 웹툰의 id가 들어있는지 확인해보고 있으면 isliked에 true를 부여
    if(likedToons != null){
      //statefulwidget인 detailscreen의 id를 가져오기 위해 widget.id를 사용
      if(likedToons.contains(widget.id) == true){
        setState(() {
          isLiked = true;
        });
      }
    }else {
      await prefs.setStringList('likedToons', []);
    }
  }

  //initState로 webtoon이라는 future를 안전하게 초기화 가능
  @override
  void initState(){
    super.initState();
    //webtoon과 episodes를 APIservice에서 가져와 사용
    webtoon = ApiService.getTodayById(widget.id);
    episodes = ApiService.getLatestEpisodesById(widget.id);
    initPrefs();
  }
  //좋아요 클릭을 동작시키기 위해 생성
  onHeartTap() async {
    final likedToons = prefs.getStringList('likedToons');
    //웹툰에 likedtoons이 없다면 삭제
    if (likedToons != null) {
      if (isLiked) {
        likedToons.remove(widget.id);
      } else {
        likedToons.add(widget.id);
      }
      await prefs.setStringList('likedToons', likedToons);
      setState(() {
        isLiked = !isLiked;
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 2,
        backgroundColor: Colors.white,
        foregroundColor: Colors.green,
        //좋아요를 핸드폰 저장소에 데이터를 담기위해
        //shared_preferences를 임포트하여 사용한다!!
        //pub.dev에서 write data, read data 확인!
        //https://pub.dev/packages/shared_preferences

        actions: [
          IconButton(
            onPressed: onHeartTap,
            icon: Icon(
              isLiked
                  ? Icons.favorite
                  : Icons.favorite_border_outlined,
            ),
        )],
        title: Text(
          widget.title,
          style: TextStyle(
            //fontFamily: 'font',
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      //화면 오류는 SingleChildScrollview로 감싸준다
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 50,horizontal: 50),
          child: Column(
            children: [
              //Hero로 id를 맞춰주면 자연스럽게 이동이 가능
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Hero(
                    tag: widget.id,
                    child: Container(
                      width: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [BoxShadow(
                          blurRadius: 15,
                          //그림자 위치 지정
                          offset: Offset(0,10),
                          //투명도는 50%
                          color: Colors.black.withOpacity(0.5),

                        )
                        ],
                      ),
                      //clipbehavior로 모서리 저장!
                      clipBehavior: Clip.hardEdge,
                      child: Image.network(widget.thumb),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 25,
              ),
              //Future가 데이터를 받았는지 오류인지 알수있게 한다(로딩)
              FutureBuilder(
                future: webtoon,
                builder: (context, snapshot){
                  if(snapshot.hasData){
                    return Column(
                      //가로 정렬
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(snapshot.data!.about,
                        style: TextStyle(
                          fontSize: 16,
                        ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          '${snapshot.data!.genre}/ ${snapshot.data!.age}',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    );
                  }
                  return Text("wait....");
                },
              ),
              SizedBox(
                height: 10,
              ),
              FutureBuilder(
                future: episodes,
                builder: (context, snapshot){
                  if(snapshot.hasData){
                    return Column(
                        //가로 정렬
                        children: [
                          for(var episode in snapshot.data!)
                            //url의 웹툰 id도 같이 보내기 위해 추가 작성
                            Episode(episode: episode,webtoonId: widget.id)
                        ],
                      );
                  }
                  return Container();
                },
              ),
              /*FutureBuilder(
                future: episodes,
                builder: (context, snapshot){
                  if(snapshot.hasData){
                    return Column(
                      children: [
                        for(var episode in snapshot.data!)
                          Text(episode.title),
                      ],
                    );
                  }
                  return Container();
                },
              ),*/
            ],
          ),
        ),
      ),
    );
  }
}
