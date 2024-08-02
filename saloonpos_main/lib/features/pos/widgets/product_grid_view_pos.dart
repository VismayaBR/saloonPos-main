// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saloon_pos/features/pos/model/commission_day_wise_model.dart';
import 'package:saloon_pos/features/pos/model/products_model.dart';
import 'package:saloon_pos/features/pos/view_model/pos_screen_view_model.dart';
import 'package:saloon_pos/helper/app_colors.dart';
import 'package:saloon_pos/helper/text_style.dart';
import 'package:saloon_pos/helper/ui_helper.dart';

class ProductsGridView extends StatelessWidget {
  final int crossAxisCount;
  final double titleSize;
  final double priceSize;
  final double aspectRatioHeight;
  final List<ProductDatum> productsAndService;
  const ProductsGridView({
    super.key,
    required this.crossAxisCount,
    required this.priceSize,
    required this.titleSize,
    required this.aspectRatioHeight,
    required this.productsAndService,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<PosScreenViewModel>(
      builder: (context, pos, child) {

        final filteredProducts = productsAndService.where((product) {
          return product.category_id == pos.categorySelectedId.toString();
        }).toList();
        // print('*********************${filteredProducts}');

        return Expanded(
            child: GridView.builder(
                padding: EdgeInsets.zero,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 2 / aspectRatioHeight,
                ),
                itemCount: productsAndService.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      print('_________________${filteredProducts[index]}');
                      pos.addProductToCart(filteredProducts[index]);
                      // log('height${getHeight(context: context)}');
                      // log('width${getWidth(context: context)}');
                    },
                    child: Container(
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(6))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 5,
                            decoration: const BoxDecoration(
                                color: AppColors.posScreenYellowBar,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(6),
                                    topRight: Radius.circular(6))),
                          ),
                          productsAndService[index].image != null
                              ? Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: NetworkImage(
                                                productsAndService[index]
                                                    .image!))),
                                    padding: const EdgeInsets.only(
                                        left: 20, right: 20, top: 20),
                                  ),
                                )
                              : Container(
                                  height: 80,
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20, top: 20),
                                  child: Text(
                                    productsAndService[index].name!,
                                    style: mainSubHeadingStyle().copyWith(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: titleSize,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                          productsAndService[index].image == null
                              ? Container(
                                  margin: const EdgeInsets.only(
                                      left: 20, right: 20, top: 10),
                                  padding: const EdgeInsets.all(15),
                                  decoration: const BoxDecoration(
                                      color: AppColors
                                          .posScreenContainerBackground,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(6))),
                                  child: Text(
                                    'Qr ${productsAndService[index].price}',
                                    style: mainSubHeadingStyle().copyWith(
                                        color: AppColors
                                            .posScreenSelectedTextColor,
                                        fontSize: priceSize),
                                  ),
                                )
                              : Container(
                                  margin: const EdgeInsets.only(
                                    top: 10,
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(
                                          left: 5,
                                          right: 10,
                                        ),
                                        padding: const EdgeInsets.fromLTRB(
                                            15, 15, 10, 15),
                                        decoration: const BoxDecoration(
                                            color: AppColors
                                                .posScreenContainerBackground,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(6))),
                                        child: Text(
                                          'Qr ${productsAndService[index].price}',
                                          style: mainSubHeadingStyle().copyWith(
                                              color: AppColors
                                                  .posScreenSelectedTextColor,
                                              fontSize: priceSize),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          productsAndService[index].name!,
                                          style: mainSubHeadingStyle().copyWith(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                          ),
                                          maxLines: 4,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                          verticalSpaceSmall
                        ],
                      ),
                    ),
                  );
                }));
      },
    );
  }
}
