
import 'package:flutter/material.dart';

import 'DismissibleProduct.dart';
import '../../../Config.dart';
import '../../../entity/Product.dart';

class ScannedProductsComponent extends StatefulWidget {
  const ScannedProductsComponent({
    Key? key,
    required this.listKey,
    required this.scannedProducts,
    this.updateScannedProducts,
    this.animated = false,
  }) : super(key: key);

  final bool animated;
  final List<Product?> scannedProducts;
  final GlobalKey<AnimatedListState> listKey;
  final Function(List<Product?>)? updateScannedProducts;

  @override
  State<ScannedProductsComponent> createState() => _ScannedProductsComponentState();
}

class _ScannedProductsComponentState extends State<ScannedProductsComponent> {
  final Tween<Offset> _offset = Tween(
    begin: const Offset(1, 0), end: const Offset(0, 0),
  );

  late bool _animated;
  late List<Product?> _scannedProducts;
  late GlobalKey<AnimatedListState> _listKey;

  @override
  void initState() {
    super.initState();

    _listKey = widget.listKey;
    _animated = widget.animated;
    _scannedProducts = widget.scannedProducts;
  }

  @override
  void didUpdateWidget(covariant ScannedProductsComponent oldWidget) {
    super.didUpdateWidget(oldWidget);

    _scannedProducts = widget.scannedProducts;
  }

  void _deleteProduct(Product item) {
    int _index = _scannedProducts.indexOf(item);
    _scannedProducts.removeAt(_index);

    if (_animated) {
      _listKey.currentState!.removeItem(
        _index, (BuildContext context, Animation<double> animation) {
          return const SizedBox();
        },
      );
    } else {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_scannedProducts.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: Config.padding / 2),
        child: _animated ? AnimatedList(
          key: _listKey,
          initialItemCount: _scannedProducts.length,
          itemBuilder: (context, index, animation) {
            Product? product = _scannedProducts[index];
            if (product != null) {
              return SlideTransition(
                position: animation.drive(_offset),
                child: DismissibleProduct(
                  product: product,
                  onDismissed: () {
                    _deleteProduct(product);
                    if (widget.updateScannedProducts != null) {
                      widget.updateScannedProducts!(_scannedProducts);
                    }
                  },
                ),
              );
            } return const SizedBox();
          },
        ) : Column(
          children: <Widget>[
            ..._scannedProducts.map((product) {
              if (product != null) {
                return DismissibleProduct(
                  product: product,
                  onDismissed: () {
                    _deleteProduct(product);
                    if (widget.updateScannedProducts != null) {
                      widget.updateScannedProducts!(_scannedProducts);
                    }
                  },
                );
              } return const SizedBox();
            },),
          ],
        ),
      );
    }

    return const SizedBox(height: Config.padding / 2,);
  }
}
