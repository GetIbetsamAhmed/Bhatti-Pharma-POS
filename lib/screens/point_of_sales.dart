import 'package:bhatti_pos/sample_data/pos_data.dart';
import 'package:bhatti_pos/sample_data/tagList.dart';
import 'package:bhatti_pos/shared/constants/border_radius.dart';
import 'package:bhatti_pos/shared/constants/colors.dart';
import 'package:bhatti_pos/shared/constants/spaces.dart';
import 'package:bhatti_pos/shared/constants/text_styles.dart';
import 'package:bhatti_pos/shared/widgets/screen_ratio.dart';
import 'package:flutter/material.dart';

class PosScreen extends StatefulWidget {
  const PosScreen({super.key});

  @override
  State<PosScreen> createState() => _PosScreenState();
}

class _PosScreenState extends State<PosScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 35,
          child: Center(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: tagList.length,
              itemBuilder: (context, index) => Tag(text: tagList[index]),
            ),
          ),
        ),
        const Space10v(),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: GridView.builder(
                itemCount: posData.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (context, index) => POSTile(data: posData[index])),
          ),
        ),
      ],
    );
  }
}

class Tag extends StatefulWidget {
  final String text;

  const Tag({
    super.key,
    required this.text,
  });

  @override
  State<Tag> createState() => _TagState();
}

class _TagState extends State<Tag> {
  bool isSelected = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 05),
      child: InkWell(
        onTap: () {
          setState(() {
            isSelected = !isSelected;
          });
        },
        child: Container(
          // height: 20,
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 04,
          ),
          decoration: BoxDecoration(
            color: isSelected ? blueColor : Colors.transparent,
            borderRadius: BorderRadius.circular(100),
            border: Border.all(
              color: isSelected ? Colors.transparent : blueColor,
            ),
          ),
          child: Center(
            child: Text(
              widget.text,
              style: TextStyle400FW12FS(
                textColor: isSelected ? Colors.white : blueColor,
                weight: isSelected ? FontWeight.w400 : FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class POSTile extends StatefulWidget {
  final Map<String, dynamic> data;
  const POSTile({
    super.key,
    required this.data,
  });

  @override
  State<POSTile> createState() => _POSTileState();
}

class _POSTileState extends State<POSTile> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: widget.data['image'].toString().compareTo("") == 0
                  ? blueColor
                  : Colors.transparent,
              // image: DecorationImage(
              //   // image: Image(image: ""),
              //   fit: BoxFit.contain,
              // ),
            ),
          ),
          Positioned(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 05),
              color:
                  widget.data['StockStatus'] > 0 ? lightGreen50p : lightRed50p,
              child: Text(
                widget.data['StockStatus'] > 0 ? "Available" : "Out of Stock",
                style: TextStyle400FW12FS(
                  textColor:
                      widget.data['StockStatus'] > 0 ? darkGreen : darkRed,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
