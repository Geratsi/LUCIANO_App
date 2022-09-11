
import 'package:flutter/material.dart';

import 'ServicesList.dart';
import 'ChooseRepository.dart';
import '../../../Config.dart';
import '../../../Styles.dart';
import '../../../entity/Service.dart';
import '../../../components/MainExpansionTile.dart';
import '../../../modelView/ServicesFromServer.dart';
import '../../../components/MainSearchDelegate.dart';
import '../../../components/CustomProgressIndicator.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({
    Key? key,
    required this.allServices,
    required this.updateServices,
    required this.updateParentData,
  }) : super(key: key);

  final List<Service> allServices;
  final Function(List<Service>) updateServices;
  final Function(List<Service>, List<Service>) updateParentData;

  @override
  _ServicesScreenState createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  final List<Service> _currentServiceItems = [];
  final Set<String> _repositoryNames = {'Все папки'};

  late bool _isEmptyData;
  late final Future<bool> _future = initialize();

  String currentRepository = 'Все папки';
  List<Service> _initialServiceItems = [];
  List<Service> _servicesAfterFilter = [];

  Future<bool> initialize() async {
    _initialServiceItems = await ServicesFromServer.getServices(context);

    if (_initialServiceItems.isNotEmpty) {
      _prepareData();
      if (mounted) {
        setState(() {});
      }
    }

    return true;
  }

  @override
  void initState() {
    super.initState();

    _isEmptyData = widget.allServices.isEmpty;

    if (!_isEmptyData) {
      _initialServiceItems = widget.allServices;
      _prepareData();
    }
  }

  void _prepareData() {
    for (final Service item in _initialServiceItems) {
      _currentServiceItems.add(Service(
        id: item.id, inCode: item.inCode, label: item.label,
        isSelected: item.isSelected, ownerId: item.ownerId,
        price: item.price, count: item.count, protocol: item.protocol,
        repositoryId: item.repositoryId, repositoryName: item.repositoryName,
      ),);
      _repositoryNames.add(item.repositoryName);
    }
  }

  void _addSelectedItems() {
    List<Service> selected = [];
    for (var item in _currentServiceItems) {
      if (item.isSelected) {
        selected.add(item);
      }
    }

    widget.updateParentData(selected, _initialServiceItems);
    Navigator.of(context).pop();
  }

  Widget _buildContent() {
    _servicesAfterFilter = [];
    if (currentRepository == 'Все папки') {
      _servicesAfterFilter.addAll(_currentServiceItems);
    } else {
      for (final Service item in _currentServiceItems) {
        if (item.repositoryName == currentRepository) {
          _servicesAfterFilter.add(item);
        }
      }
    }

    /// sort by isSelected value
    _servicesAfterFilter.sort((a, b) => b.isSelected ? 1 : -1);

    return RefreshIndicator(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(Config.padding),
        child: Column(
          children: <Widget>[
            MainExpansionTile(
              title: Text(currentRepository, style: Styles.textTitleColorBoldStyle,),
              childrenWidgets: _repositoryNames.map((repositoryName) => InkWell(
                onTap: () {
                  setState(() {
                    currentRepository = repositoryName;
                  });
                },
                child: ChooseRepository(name: repositoryName,),
              )).toList(),
            ),

            ServicesList(
              onPressed: (Service service) {
                if (mounted) {
                  setState(() {
                    service.isSelected = !service.isSelected;
                  });
                }
              },
              servicesList: _servicesAfterFilter,
            ),
          ],
        ),
      ),
      onRefresh: initialize,
    );
  }

  @override
  Widget build(BuildContext context) {
    bool _someIsChanged = false;
    for (int i = 0; i < _currentServiceItems.length; i++) {
      if (_currentServiceItems[i].isSelected != _initialServiceItems[i].isSelected) {
        _someIsChanged = true;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Услуги'),
        leading: IconButton(
          icon: Icon(Icons.adaptive.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
            widget.updateServices(_initialServiceItems);
          },
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () async {
              await showSearch(
                context: context,
                delegate: MainSearchDelegate(
                  allSearchItems: _servicesAfterFilter,
                ),
              );
              if (mounted) {
                setState(() {});
              }
            },
            icon: const Icon(Icons.search,),
          ),
        ],
      ),

      body: _isEmptyData ? FutureBuilder<bool>(
        future: _future,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CustomProgressIndicator(),);
          } else if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()),);
          } else {
            return _buildContent();
          }
        },
      ) : _buildContent(),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _someIsChanged ? FloatingActionButton.extended(
          shape: RoundedRectangleBorder( // BeveledRectangleBorder for rectangle border, not circle
            borderRadius: BorderRadius.circular(Config.activityBorderRadius),
          ),
          backgroundColor: Config.primaryColor,
          onPressed: _addSelectedItems,
          label: SizedBox(
            width: MediaQuery.of(context).size.width - Config.padding * 4.5,
            child: const Text(
              'Сохранить', style: Styles.titleBoldStyle, textAlign: TextAlign.center,
            ),
          )
      ) : const SizedBox(),
    );
  }
}
