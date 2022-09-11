
import 'package:flutter/material.dart';

import 'ScannedProductsComponent.dart';
import '../components/BarcodeScannerComponent.dart';
import '../../../Config.dart';
import '../../../Styles.dart';
import '../../../entity/Product.dart';
import '../../../utilities/Message.dart';
import '../../../entity/DialogAction.dart';
import '../../../modelView/ProductFromServer.dart';
import '../../../components/CustomProgressIndicator.dart';

class ScanProductsScreen extends StatefulWidget {
  const ScanProductsScreen({
    Key? key,
    required this.ownerId,
    required this.addScannedProducts,
  }) : super(key: key);

  final int ownerId;
  final Function(List<Product?>) addScannedProducts;

  @override
  State<ScanProductsScreen> createState() => _ScanProductsScreenState();
}

class _ScanProductsScreenState extends State<ScanProductsScreen> {
  final Duration slideDuration = const Duration(milliseconds: Config.animDuration);
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  late Message _message;
  late Message _confirmationMessage;
  late DialogAction _cancelAction;
  late DialogAction _acceptAction;

  bool _isLoading = false;
  /// null for correct animated list
  List<Product?> _scannedProducts = [null];
  AnimatedListState? get _animatedList => _listKey.currentState;

  @override
  void initState() {
    super.initState();

    _message = Message(context: context);
    _cancelAction = DialogAction(
      label: 'Отмена', callback: () {
      Navigator.of(context).pop();
    },);
    _acceptAction = DialogAction(
      label: 'Да', callback: () {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      widget.addScannedProducts(_scannedProducts);
    },);
    _confirmationMessage = Message(
      context: context, cancelAction: _cancelAction, acceptAction: _acceptAction,
    );
  }

  Future<void> _addProduct(String code) async {
    bool contains = false;
    if (_scannedProducts.isNotEmpty) {
      final List<Product?> scannedProducts = [..._scannedProducts];
      for (final Product? product in scannedProducts) {
        if (product != null && product.code == code) {
          if (product.quantity - product.count > 0) {
            product.count += 1;
          } else {
            _message.showMessage(
              title: 'Ошибка', content: 'Превышено доступное количество товара',
            );
          }
          contains = true;
        }
      }

      if (!contains) {
        await _addFromServer(code);
      }
    } else {
      await _addFromServer(code);
    }

    setState(() {});
  }

  Future<void> _addFromServer(String code) async {
    setState(() {
      _isLoading = true;
    });

    Product? _product = await ProductFromServer.getProduct(
      ownerId: widget.ownerId, code: code, context: context,
    );
    if (_product != null) {
      _scannedProducts.insert(0, _product);
      _animatedList!.insertItem(0, duration: slideDuration);
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _addAll() {
    _confirmationMessage.showMessage(
      title: 'Вы уверены?',
      content: 'Подтверждение на добавление отсканированных позиций',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Добавление товара'),
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Stack(children: <Widget>[
              BarcodeScannerComponent(addFunc: _addProduct,),

              _isLoading
                  ? const Center(child: CustomProgressIndicator(),)
                  : const SizedBox(),
            ],)
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                Config.padding, Config.padding / 2, Config.padding,
                Config.padding * 4,
              ),
              child: ScannedProductsComponent(
                listKey: _listKey, animated: true,
                scannedProducts: _scannedProducts,
                updateScannedProducts: (List<Product?> data) {
                  _scannedProducts = data;
                },
              ),
            ),
          ),

        ],
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _scannedProducts.length > 1 ? FloatingActionButton.extended(
        shape: RoundedRectangleBorder( // BeveledRectangleBorder for rectangle border, not circle
          borderRadius: BorderRadius.circular(Config.activityBorderRadius),
        ),
        backgroundColor: Config.primaryColor, onPressed: _addAll,
        label: SizedBox(
          width: MediaQuery.of(context).size.width - Config.padding * 4.5,
          child: const Text(
            'Сохранить', style: Styles.titleBoldStyle, textAlign: TextAlign.center,
          ),
        ),
      ) : const SizedBox(),
    );
  }
}
