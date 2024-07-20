import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saloon_pos/features/pos/view_model/pos_screen_view_model.dart';
import 'package:saloon_pos/helper/text_style.dart';
import 'package:saloon_pos/helper/ui_helper.dart';

import '../../../helper/app_colors.dart';
class SwitchTypeBarReportMobile extends StatelessWidget {
  const SwitchTypeBarReportMobile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<PosScreenViewModel>(
      builder: (context,pos,child){
        return  SizedBox(
          height: 40,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 1,
                  color: AppColors.posScreenSeparator,
                ),
              ),
              ListView.builder(
                scrollDirection: Axis.horizontal,
                  itemCount:pos.typesOfReport.length ,
                  itemBuilder: (context,index){
                    return Align(
                      alignment: Alignment.bottomCenter,
                      child: GestureDetector(
                        onTap: () {
                          pos.switchReport(pos.typesOfReport[index]);
                          },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              margin:const EdgeInsets.only(right:5),
                              padding:
                              const EdgeInsets.only(left: 8.0, right: 8.0),
                              child: Text(pos.typesOfReport[index],
                                  style: mainSubHeadingStyle().copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: pos.selectedReportType == pos.typesOfReport[index]
                                          ? AppColors.posScreenSelectedTextColor
                                          : AppColors.textFieldTextColor,
                                      fontSize:14)),
                            ),
                            verticalSpaceSmall,
                            IntrinsicWidth(
                              child: Container(
                                height: 2,
                                decoration: BoxDecoration(
                                  color: pos.selectedReportType == pos.typesOfReport[index]
                                      ? AppColors.posScreenSelectedTextColor
                                      : Colors.transparent,
                                  borderRadius:
                                  const BorderRadius.all(Radius.circular(2)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  })
            ],
          ),
        );
      },

    );
  }
}
