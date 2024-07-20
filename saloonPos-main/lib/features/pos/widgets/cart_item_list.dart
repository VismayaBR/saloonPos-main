
import 'package:flutter/material.dart';
import 'package:flutter_dropdown/flutter_dropdown.dart';
import 'package:provider/provider.dart';
import 'package:saloon_pos/features/pos/model/employee_model.dart';
import 'package:saloon_pos/features/pos/view_model/pos_screen_view_model.dart';
import 'package:saloon_pos/features/pos/widgets/counter_widget.dart';
import 'package:saloon_pos/helper/app_colors.dart';
import 'package:saloon_pos/helper/assets.dart';
import 'package:saloon_pos/helper/text_style.dart';
import 'package:saloon_pos/helper/ui_helper.dart';
class CartItemList extends StatelessWidget {
  final double size;
  final double dropDownWidth;
  final double containerHeight;
  final double cartHeight;
   CartItemList({
    super.key,
    required this.size,
    required this.dropDownWidth,
    required this.containerHeight,
    required this.cartHeight

  });

  final TextEditingController countController=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<PosScreenViewModel>(
      builder: (context,pos,child){
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 20,right: 5,bottom: 20),
              child: Row(
                children: [
                  Expanded(
                      flex:3,
                      child: Text('Item',style: mainSubHeadingStyle().copyWith(color: AppColors.textFieldTextColor,fontSize: size),)),
                  Expanded(
                      flex:2,
                      child: Text('Price',style: mainSubHeadingStyle().copyWith(color: AppColors.textFieldTextColor,fontSize: size)))

                ],
              ),
            ),
            SizedBox(
              height: cartHeight,
              child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: pos.cartItems.length,
                  itemBuilder: (context,index){
                    return Container(
                        height: containerHeight,
                        padding: const EdgeInsets.only(top: 5,bottom: 5,left: 20,right: 5),
                        margin: const EdgeInsets.only(bottom: 5),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          color: AppColors.posScreenContainerBackground,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(pos.cartItems[index].name!,style: mainSubHeadingStyle().copyWith(color: Colors.black,fontSize: size,overflow: TextOverflow.ellipsis),maxLines: 1,),
                                  verticalSpaceTiny,
                                //  Row(
                                //           children: [
                                //             IconButton(
                                //               icon: Icon(Icons.remove),
                                //               onPressed: () {
                                               
                                //               },
                                //             ),
                                //             Container(
                                //               height:
                                //                   20, // Set height for the line
                                //               width:
                                //                   .5, // Set width for the line
                                //               color: Colors
                                //                   .grey, // Set color for the line
                                //             ),
                                //             Padding(
                                //               padding: const EdgeInsets
                                //                   .symmetric(
                                //                   horizontal:
                                //                       8.0), // Add padding between elements
                                //               child: Text(
                                //                 '1',
                                //                 style: mainSubHeadingStyle()
                                //                     .copyWith(
                                //                   color: Colors.black,
                                //                   fontSize: size,
                                //                 ),
                                //               ),
                                //             ),
                                //             Container(
                                //               height:
                                //                   20, // Set height for the line
                                //               width:
                                //                   1, // Set width for the line
                                //               color: Colors
                                //                   .grey, // Set color for the line
                                //             ),
                                //             IconButton(
                                //               icon: Icon(Icons.add),
                                //               onPressed: () {
                                                
                                //               },
                                //             ),
                                //           ],
                                //         ),
                                CounterTextField(controller: countController,)
                                ],
                              ),),
                            Expanded(flex:2,child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                               
                                Text('Qr ${(pos.cartItems[index].price??0)*double.parse(countController.text)}',style: mainSubHeadingStyle().copyWith(color: Colors.black,fontSize: size,fontWeight: FontWeight.w600),),
                                InkWell(
                                  onTap: (){
                                    pos.deleteProduct(pos.cartItems[index].id!, pos.cartItems[index].price!);
                                  },
                                  child: Container(
                                    width: 60,
                                    decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(Radius.circular(8))),
                                    height: getHeight(context: context)/10,
                                    child: Center(
                                      child: Image.asset(Assets.deleteIcon,scale: 0.8,),
                                    ),

                                  ),
                                )
                              ],
                            ))
                          ],
                        )
                    );
                  }),
            ),
          ],
        );
      },

    );
  }
}