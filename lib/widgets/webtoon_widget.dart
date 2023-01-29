import 'package:flutter/material.dart';
import 'package:webtoon/screens/detail_screen.dart';

class WebtoonDetail extends StatelessWidget {
  //다른 클래스의 webtoon을 받아오기 위한 변수 생성!
  final String title, thumb, id;
  const WebtoonDetail({super.key,
    required this.title,
    required this.thumb,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    //GestrueDetector은 동작을 감지하기 위해 사용(onTap)
    return GestureDetector(
      onTap: (){
        //Navigator로 동작이 감지되면 다음 화면으로 이동
        //Navigator.ush는 StatelessWiget을 사용하지 않기 때문에
        //MaterialPageRoute로 route를 감싸준다
        //webtoon변수도 넘겨주고 다시돌아가기 위한 화살표도 준다
        Navigator.push(
          context,
          MaterialPageRoute(
          builder: (context) =>
              DetailScreen(title: title, thumb: thumb, id: id),
            //fullscreenDialog: true,
         ),
        );
      },
      child: Column(
        children: [
          //박스를 꾸미기 위한 Container
          //Hero로 id를 맞춰주면 자연스럽게 이동이 가능
          Hero(
            tag: id,
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

                )],
              ),
              //clipbehavior로 모서리 저장!
              clipBehavior: Clip.hardEdge,
              child: Image.network(thumb),
            ),
          ),
          Text(title,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w200,
            ),
          ),
        ],
      ),
    );
  }
}
