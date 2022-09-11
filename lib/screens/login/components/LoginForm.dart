
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Styles.dart';
import '../../../Config.dart';
import '../../../Storage.dart';
import '../../../entity/DialogAction.dart';
import '../../../bloc/login/login_bloc.dart';
import '../../../components/MainTextInput.dart';
import '../../../components/CustomCheckbox.dart';
import '../../../components/MainOpacityButton.dart';
import '../../../components/DialogActionButton.dart';
import '../../../components/MainTextInputSecure.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final FocusNode _usernameFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isChecked = true;

  @override
  void initState() {
    super.initState();

    initialize();
  }

  void initialize() async {
    _usernameController.text = await Storage.get(Config.username) ?? '';
    _passwordController.text = await EncryptedStorage.get(Config.password) ?? '';
  }

  Future<bool?> _updateCheckboxValue() async {
    final String? isChecked = await Storage.get(Config.isSaveData);
    if (isChecked != null) {
      return isChecked == 'true';
    }
    return null;
  }

  void _authorize(LoginBloc loginBloc) {
    loginBloc.add(LoginAuthorize(
      name: _usernameController.text,
      pass: _passwordController.text,
      isSaveData: _isChecked,
    ));
  }

  @override
  void dispose() {
    if (mounted) {
      _usernameFocusNode.dispose();
      _passwordFocusNode.dispose();
      _usernameController.dispose();
      _passwordController.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final LoginBloc loginBloc = context.read<LoginBloc>();

    return Column(
      children: <Widget>[
        const Text(
          'Добро пожаловать', style: Styles.titleWhiteStyle,
        ),

        const SizedBox(height: Config.padding * 1.5,),

        MainTextInput(
          iconColor: Config.textColor,
          focusNode: _usernameFocusNode,
          controller: _usernameController,
          placeholder: 'Ваш логин',
          borderRadius: Config.smallBorderRadius,
          textInputAction: TextInputAction.next,
          capitalization: TextCapitalization.none,
          backgroundColor: Config.primaryLightColor.withOpacity(.7),
          defaultValidation: true,
          onSubmit: () {
            FocusScope.of(context).requestFocus(_passwordFocusNode);
          },
        ),

        const SizedBox(height: Config.padding,),

        MainTextInputSecure(
          iconColor: Config.textColor,
          focusNode: _passwordFocusNode,
          controller: _passwordController,
          placeholder: 'Ваш пароль',
          borderRadius: Config.smallBorderRadius,
          textInputAction: TextInputAction.go,
          backgroundColor: Config.primaryLightColor.withOpacity(.7),
          defaultValidation: true,
          onSubmit: () {
            _authorize(loginBloc);
          },
        ),

        const SizedBox(height: Config.padding / 2,),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            CustomCheckbox(
              label: 'Запомнить?',
              isChecked: _isChecked,
              onChanged: (bool newVal) {
                _isChecked = newVal;
              },
              updater: _updateCheckboxValue,
            ),

            DialogActionButton(
              action: DialogAction(
                label: 'Забыли пароль?',
                callback: () {},
                labelStyle:  Styles.textTitleColorStyle,
                backgroundColor: Config.primaryLightColor.withOpacity(.7),
              ),
              padding: false,
            ),

          ],
        ),

        const SizedBox(height: Config.padding * 2,),

        MainOpacityButton(
          width: MediaQuery.of(context).size.width / 2,
          label: 'Войти',
          labelStyle: Styles.titleWhiteStyle,
          controllers: [_usernameController, _passwordController],
          activeOpacity: 0.2,
          backgroundColor: Config.primaryColor.withOpacity(.2),
          onPressed: () {
            _authorize(loginBloc);
          },
        ),
      ],
    );
  }
}
