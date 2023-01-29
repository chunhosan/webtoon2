import 'package:flutter/material.dart';
import 'package:webtoon/models/webtoon.dart';
import 'package:webtoon/services/api_service.dart';
import 'package:webtoon/widgets/webtoon_widget.dart';

//state를 사용하기 위해 statefulwidget 사용
class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  //다른 클래스 webtoonmodel 리스트 가지고 오기!!!
  final Future<List<WebtoonModel>> webtoons = ApiService.getTodaysToons();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 2,
        backgroundColor: Colors.white,
        foregroundColor: Colors.green,
        title: Text(
            '오늘의 웹툰',
          style: TextStyle(
            //fontFamily: 'font',
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      //Future가 데이터를 받았는지 오류인지 알수있게 한다(로딩)
      body: FutureBuilder(
        future: webtoons,
        builder: (context, snapshot) {
          //snapshot의 데이터는 future의 결과값
          //snapshot이 데이터를 가지고 있을때 실행(future의 동작이 끝나고 서버가 응답할때)
          if(snapshot.hasData){
            //Listview로 많은 양의 데이터를 나열하는데 유용하다
            //Listview.builder는 수평방향 스크롤도 가능하고, ListView보다 최적화가 되어있다.
            //ListView.separated는 여백을 줄 수 있다
            return Column(
              //Listview에 높이값이 없어서 Column을 쓰면 오류가남
              //해결하려면 ListVIew에 제한없는 높이값을 주어야한다.
              //즉 Expanded을 줘야함
              children: [
                SizedBox(height: 50,),
                Expanded(child: makeList(snapshot)),
              ],
            );
          }
          return Center(
            //로딩화면
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

//extract method를 사용해서 코드를 보기 편하게 분리한다(makeList).

  ListView makeList(AsyncSnapshot<List<WebtoonModel>> snapshot) {
    return ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: snapshot.data!.length,
            //수평수직 방향
            padding: EdgeInsets.symmetric(vertical: 10,horizontal: 30),
            itemBuilder: (context, index){
              var webtoon = snapshot.data![index];
              //Column대신 webtoonDetail클래스 리턴
              return WebtoonDetail(title: webtoon.title, thumb: webtoon.thumb, id: webtoon.id);
            },
            separatorBuilder: (context, index) => SizedBox(width: 20,),
          );
  }
}
