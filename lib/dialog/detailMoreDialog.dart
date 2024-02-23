import 'package:flutter/material.dart';
import 'package:fmr_project/model/date_opening.dart';

class MoreDialogPage extends StatelessWidget {
  const MoreDialogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: 440,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(40),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  "ข้อมูลเพิ่มเติม",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
              Divider(),
              Text(
                "เวลาเปิด-ปิดร้าน",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 5,
              ),
              ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: getDateOpening.length,
                  itemBuilder: (BuildContext context, int index) {
                    dateOpening item = getDateOpening[index];
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                item.day,
                              ),
                              (item.timeclose == "ปิด" &&
                                      item.timeclose == "ปิด")
                                  ? Text(
                                      'ปิดทำการ',
                                    )
                                  : Text(
                                      '${item.timeopen} - ${item.timeclose} น.',
                                    ),
                            ],
                          ),
                        ),
                        Divider(),
                      ],
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
