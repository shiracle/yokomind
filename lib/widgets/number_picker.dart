import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:yoko_mind/theme/color.dart';

class NumberSelectorWidget extends StatefulWidget {
  final int initialValue;

  const NumberSelectorWidget(this.initialValue, {super.key});

  @override
  State<NumberSelectorWidget> createState() => _NumberSelectorWidgetState();
}

class _NumberSelectorWidgetState extends State<NumberSelectorWidget> {
  int selectedValue = 0;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      color: AppColor.background,
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
      height: size.height * .3,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: size.height * .15,
            child: CupertinoPicker(
              itemExtent: 40,
              squeeze: 2,
              useMagnifier: true,
              diameterRatio: 1,
              onSelectedItemChanged: (int index) {
                setState(() {
                  selectedValue = index;
                });
              },
              children: List<Widget>.generate(101, (int index) {
                return Container(
                  alignment: Alignment.center,
                  child: Text(
                    '$index',
                    style: TextStyle(
                        fontSize: size.height * .024, color: AppColor.outLine),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.outLine,
            ),
            onPressed: () => Navigator.of(context).pop(selectedValue),
            child: Text(
              'Болсон',
              style:
                  TextStyle(color: Colors.black, fontSize: size.height * .02),
            ),
          ),
        ],
      ),
    );
  }
}
