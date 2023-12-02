import 'package:flutter/material.dart';
import 'package:yoko_mind/theme/color.dart';

class Profile extends StatefulWidget {
  final Function onTap;
  final String profilePic;
  final String phone;
  final String name;
  final String email;
  const Profile({
    super.key,
    required this.onTap,
    required this.profilePic,
    required this.phone,
    required this.name,
    required this.email,
  });

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.11,
      margin: EdgeInsets.symmetric(
        vertical: size.height * 0.01,
        horizontal: size.width * .03,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: AppColor.outLine,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              // TODO: implement profile ontap function
            },
            child: Container(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(500)),
              width: size.width * .16,
              margin: EdgeInsets.symmetric(horizontal: size.width * .02),
              child: AspectRatio(
                aspectRatio: 1,
                child: Image.asset(
                  widget.profilePic,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 15),
            width: size.width * 0.6 - 20,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.name,
                  style: const TextStyle(
                    color: AppColor.outLine,
                    fontSize: 20,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    height: 0,
                  ),
                ),
                Text(
                  widget.phone,
                  style: TextStyle(
                    color: AppColor.outLine,
                    fontSize: size.height * 0.016,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    height: 0,
                  ),
                ),
                Text(
                  widget.email,
                  style: TextStyle(
                    color: AppColor.outLine,
                    fontSize: size.height * 0.016,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    height: 0,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => widget.onTap(),
              child: Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: AspectRatio(
                  aspectRatio: 1 / 1,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.red.shade800,
                    ),
                    child: Image.asset(
                      "assets/Qr Code.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
