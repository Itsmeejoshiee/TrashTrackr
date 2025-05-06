import 'package:flutter/material.dart';
import 'package:trashtrackr/core/utils/constants.dart';

class DisposalGuide extends StatelessWidget {
  const DisposalGuide({
    super.key,
    required this.material,
    required this.guide,
    required this.toDo,
    required this.notToDo,
    required this.proTip,
  });

  final String material;
  final String guide;
  final List<String> toDo;
  final List<String> notToDo;
  final String proTip;

  List<Widget> _listBuilder(List<String> list) {
    List<Widget> listItems = [];
    for (String item in list) {
      String textContent = ' • $item';
      listItems.add(Text(textContent, style: TextStyle(color: Colors.black54)));
    }
    return listItems;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 18),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          RichText(
            text: TextSpan(
              style: kBodyLarge.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
              children: [
                TextSpan(text: 'Smart Guide to Disposing of '),
                TextSpan(
                  text: material,
                  style: TextStyle(color: kAppleGreen),
                ),
              ],
            ),
          ),

          Text(
            guide,
            style: kPoppinsBodyMedium.copyWith(color: Colors.black54),
          ),

          IntrinsicHeight(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          'What to do',
                          style: kBodyLarge.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      ..._listBuilder(toDo),
                    ],
                  ),
                ),
                const VerticalDivider(
                  width: 20,
                  thickness: 1,
                  color: Colors.black,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          'What NOT to do',
                          style: kBodyLarge.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      ..._listBuilder(notToDo)
                    ],
                  ),
                ),
              ],
            ),
          ),

          Text(
            '♻️ Pro Tip',
            style: kBodyLarge.copyWith(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),

          Text(
            proTip,
            style: kPoppinsBodyMedium.copyWith(color: Colors.black54),
          ),
        ],
      ),
    );
  }
}