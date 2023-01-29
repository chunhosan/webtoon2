import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../models/webtoon_episode_model.dart';
class Episode extends StatelessWidget {
  const Episode({
    Key? key,
    required this.episode,
    required this.webtoonId,
  }) : super(key: key);
  //webtoon id 를 받아오기 위해 변수생성
  final String webtoonId;
  final WebtoonEpisodeModel episode;
  //클릭시 해당 경로로 이동
  onButtonTap() async{
    //launchUrl은 Futurl을 가져다 주는 function이기 때문에
    //await과 async이 필요
    //웹툰 url의 웹툰 id와 에피소드id를 문자열로 받아온다(${episode.id}）
    await launchUrlString('https://comic.naver.com/webtoon/detail?titleId=$webtoonId&no=${episode.id}');
  }
  @override
  Widget build(BuildContext context) {
    //container를 탭하는걸 감지하기 위해 GestureDetector 사용
    return GestureDetector(
      onTap: onButtonTap,
      child: Container(
        //margin으로 서로의 간격을 줌
        margin: EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(
          boxShadow: [BoxShadow(
            blurRadius: 5,
            //그림자 위치 지정
            offset: Offset(0,8),
            //투명도는 50%
            color: Colors.black.withOpacity(0.1),
          )],
          border: Border.all(
            width: 1,
            color: Colors.green.shade400,
          ),
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 20,
          ),
          child: Row(
            //children간 끝과 끝으로 정렬
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Text(episode.title,
                    style: TextStyle(
                      color: Colors.green.shade400,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Icon(Icons.chevron_right_rounded,color: Colors.green.shade400,),
            ],),
        ),
      ),
    );
  }
}