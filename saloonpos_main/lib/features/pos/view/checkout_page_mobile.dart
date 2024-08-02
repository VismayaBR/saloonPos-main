import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saloon_pos/features/common_widgets/expanded_square_button.dart';
import 'package:saloon_pos/features/common_widgets/square_button.dart';
import 'package:saloon_pos/features/pos/view/test_print.dart';
import 'package:saloon_pos/features/pos/view_model/pos_screen_view_model.dart';
import 'package:saloon_pos/features/pos/widgets/cart_item_list.dart';
import 'package:saloon_pos/features/pos/widgets/payment_method_widget.dart';
import 'package:saloon_pos/features/pos/widgets/price_details_widget.dart';
import 'package:saloon_pos/helper/app_colors.dart';
import 'package:saloon_pos/helper/themes.dart';
import 'package:saloon_pos/helper/ui_helper.dart';
import 'package:get/get.dart';
import '../../../helper/text_style.dart';

class CheckoutPageMobile extends StatelessWidget {
  const CheckoutPageMobile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<PosScreenViewModel>(
        builder: (context,pos,child){
          return Container(
            decoration: BoxDecoration(
              border: pos.isEditEnabled?Border.all(
                color: const Color(0xff39FF14),
                width: 3.0,
              ):null,
              color: AppColors.posScreenContainerBackground,

            ),

            child: Column(
              children: [
                verticalSpaceLarge,
                InkWell(
                  onTap: (){
                    pos.backToHomeInMobile();
                    },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        const Icon(Icons.chevron_left,size: 20 ,),
                        horizontalSpaceSmall,
                        Text('BACK TO HOME',style: mainSubHeadingStyle().copyWith(color: Colors.black,fontWeight: FontWeight.w700,fontSize: 14),)
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(15,15,15,0),
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10))
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          CartItemList(size: 14,dropDownWidth: getWidth(context: context)/3,containerHeight: getHeight(context: context)/8,cartHeight: getHeight(context: context)/2.5,),
                          verticalSpaceMedium,
                          PriceDetailsWidget(size: 14,discountWidth: getWidth(context: context)/5,),
                          verticalSpaceSmall,
                           if(pos.paymentDropDown.isNotEmpty)
                           PaymentMethodWidget(size: 14,listViewHeight: getHeight(context: context)/6,padding: 15,dropDownTextSize: 14,),
                          verticalSpaceTiny,
                          // Row(
                          //   children: [
                          //     Container(
                          //         decoration: const BoxDecoration(
                          //           borderRadius: BorderRadius.all(Radius.circular(10)),
                          //         ),
                          //         child: Checkbox(
                          //           activeColor: AppColors.posScreenSelectedTextColor,
                          //           value: pos.otBills, onChanged: (value){
                          //             pos.changeOtBills(value!);
                          //         },shape: RoundedRectangleBorder(
                          //             borderRadius: BorderRadius.circular(5)),)),
                          //     horizontalSpaceTiny,
                          //     Text('OTBILL',style: mainSubHeadingStyle().copyWith(fontSize: 14,color: Colors.black),),


                          //   ],
                          // ),
                          verticalSpaceSmall,
                          Row(
                            children: [
                              ExpandedSquareButton(onTap: (){pos.clearCart(context);}, title: 'CANCEL', textColor: AppColors.cancelColor,color: AppColors.posScreenContainerBackground,),
                              horizontalSpaceSmall,
                              ExpandedSquareButton(
                                  isLoading:pos.checkoutLoading,
                                  onTap: ()async{
                                    // TestPrint();
                                    pos.checkoutLoading=true;
                                // bool validation=await pos.validateFormKeys(context);
                                // if(validation){
                                if(pos.isEditEnabled){
                                   showDialog(context: context, builder: (context){
                                     return LayoutBuilder(
                                     builder: (BuildContext context, BoxConstraints constraints){
                                         return Dialog(
                                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                                           child: SizedBox(
                                             height: 150,
                                             width: constraints.maxWidth<800?getWidth(context: context):getWidth(context: context)/2,
                                             child: Padding(
                                               padding: const EdgeInsets.all(20.0),
                                               child: Column(
                                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                 children: [
                                                   Text('Are you sure',style: mainHeadingStyle().copyWith(color: Colors.black,fontSize: 18),),
                                                   Row(
                                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                     children: [
                                                       SquareButton(onTap: (){Get.back();}, title: 'No',width: 100,height: 40,),
                                                       SquareButton(onTap: () async {
                                                         log('check validate');
                                                         double totalAmountCollected=0;
                                                         for(int i=0;i<pos.paymentMethods.length;i++){
                                                           totalAmountCollected=totalAmountCollected+(pos.paymentControllers[i].text.isNotEmpty?double.parse(pos.paymentControllers[i].text):0.0);
                                                         }
                                                         if(totalAmountCollected<(pos.total-pos.discount)){
                                                           // ignore: use_build_context_synchronously
                                                           Themes.showSnackBar(msg: 'You have not collected the full amount',context: context);
                                                         }
                                                         else if(totalAmountCollected>(pos.total-pos.discount)){
                                                           double extraAmtTemp=totalAmountCollected-(pos.total-pos.discount);
                                                           // ignore: use_build_context_synchronously
                                                           // Themes.showSnackBar(msg: 'Total Amount is ${pos.total-pos.discount},Balance is $extraAmtTemp',context: context);
                                                           showDialog(
                                                               barrierDismissible: false,
                                                               context: context,
                                                               builder: (BuildContext context) {
                                                                 return LayoutBuilder(
                                                                     builder: (BuildContext context, BoxConstraints constraints){
                                                                       return Dialog(
                                                                         shape: RoundedRectangleBorder(
                                                                             borderRadius:
                                                                             BorderRadius.circular(20.0)),
                                                                         child: SizedBox(
                                                                           height: 150,
                                                                           width: constraints.maxWidth<800?getWidth(context: context):getWidth(context: context)/2,
                                                                           child: Padding(padding: const EdgeInsets.all(12.0),
                                                                             child: Column(
                                                                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                               crossAxisAlignment: CrossAxisAlignment.center,
                                                                               children: [
                                                                                 Text('Total Amount is ${pos.total-pos.discount},Balance is $extraAmtTemp',style: textFieldStyle().copyWith(fontSize: 16,color: Colors.black),),
                                                                                 SquareButton(onTap:() async {
                                                                                   for(int i=0;i<pos.paymentMethods.length;i++){
                                                                                     await pos.onChangedPaymentAmount(i, pos.paymentControllers[i].text);
                                                                                   }
                                                                                   // ignore: use_build_context_synchronously
                                                                                   await pos.saveSingleSale(context);
                                                                                 }, title: 'OK')
                                                                               ],
                                                                             ),
                                                                           ),
                                                                         ),
                                                                       );
                                                                     }
                                                                 );
                                                               }
                                                           );
                                                         }
                                                         else{
                                                           for(int i=0;i<pos.paymentMethods.length;i++){
                                                             await pos.onChangedPaymentAmount(i, pos.paymentControllers[i].text);
                                                           }
                                                           // ignore: use_build_context_synchronously
                                                           await pos.saveSingleSale(context);

                                                         }
                                                       }, title: 'Yes',width: 100,height: 40,),
                                                     ],
                                                   ),
                                                 ],
                                               ),
                                             ),
                                           ),
                                         );
                                       }
                                     );
                                   });
                                }
                                else{
                                  log('check validate');
                                  double totalAmountCollected=0;
                                  for(int i=0;i<pos.paymentMethods.length;i++){
                                    totalAmountCollected=totalAmountCollected+(pos.paymentControllers[i].text.isNotEmpty?double.parse(pos.paymentControllers[i].text):0.0);
                                  }
                                  if(totalAmountCollected<(pos.total-pos.discount)){
                                    // ignore: use_build_context_synchronously
                                    Themes.showSnackBar(msg: 'You have not collected the full amount',context: context);
                                  }
                                  else if(totalAmountCollected>(pos.total-pos.discount)){
                                    double extraAmtTemp=totalAmountCollected-(pos.total-pos.discount);
                                    // ignore: use_build_context_synchronously
                                    // Themes.showSnackBar(msg: 'Total Amount is ${pos.total-pos.discount},Balance is $extraAmtTemp',context: context);
                                    showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (BuildContext context) {
                                          return LayoutBuilder(
                                              builder: (BuildContext context, BoxConstraints constraints){
                                                return Dialog(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                      BorderRadius.circular(20.0)),
                                                  child: SizedBox(
                                                    height: 150,
                                                    width: constraints.maxWidth<800?getWidth(context: context):getWidth(context: context)/2,
                                                    child: Padding(padding: const EdgeInsets.all(12.0),
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          Text('Total Amount is ${pos.total-pos.discount},Balance is $extraAmtTemp',style: textFieldStyle().copyWith(fontSize: 16,color: Colors.black),),
                                                          SquareButton(
                                                              onTap:() async {
                                                            for(int i=0;i<pos.paymentMethods.length;i++){
                                                              await pos.onChangedPaymentAmount(i, pos.paymentControllers[i].text);
                                                            }
                                                            // ignore: use_build_context_synchronously
                                                            await pos.saveSingleSale(context);
                                                          }, title: 'OK',)
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }
                                          );
                                        }
                                    );
                                  }
                                  else{
                                    for(int i=0;i<pos.paymentMethods.length;i++){
                                      await pos.onChangedPaymentAmount(i, pos.paymentControllers[i].text);
                                    }
                                    // ignore: use_build_context_synchronously
                                    await pos.saveSingleSale(context);

                                  }
                                }
                              },title: 'PAY & PRINT',textColor: Colors.white,color: AppColors.posScreenSelectedTextColor)
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
