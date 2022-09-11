
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'components/LoginForm.dart';
import 'components/LoginHeader.dart';
import '../MainScreen.dart';
import '../../Config.dart';
import '../../entity/Person.dart';
import '../../bloc/login/login_bloc.dart';
import '../../components/ModalProgress.dart';
import '../../components/ErrorComponent.dart';
import '../../bloc/main_screen/main_screen_bloc.dart';


class CheckUserScreen extends StatelessWidget {
  const CheckUserScreen({Key? key}) : super(key: key);

  void _openMainScreen(BuildContext context, Person person,) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) =>
          BlocProvider<MainScreenBloc>(
            create: (context) => MainScreenBloc(),
            child: MainScreen(personInfo: person,),
          ),
      ),
          (context) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    // final localizations = AppLocalizations.of(context);
    final ModalProgress modalProgress = ModalProgress.of(context);
    final ErrorComponent errorComponent = ErrorComponent(context: context);

    var media = MediaQuery.of(context);
    double safePaddingTop = media.padding.top;
    double safePaddingBottom = media.padding.bottom;

    /// 555 height of content
    double availableHeight = media.size.height - safePaddingTop -
        safePaddingBottom - 555;

    return Container(
      constraints: const BoxConstraints.expand(),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/background.png'),
          fit: BoxFit.cover,
        ),
      ),

      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            Config.padding, safePaddingTop, Config.padding, safePaddingBottom,
          ),
          child: Column(
            children: <Widget>[
              SizedBox(height: availableHeight / 4,),

              const LoginHeader(),

              SizedBox(height: availableHeight / 4,),

              Container(
                decoration: BoxDecoration(
                  color: Config.primaryLightColor.withOpacity(.1),
                  borderRadius: BorderRadius.circular(
                      Config.activityBorderRadius),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                  child: const Padding(
                    padding: EdgeInsets.all(Config.padding),
                    child: LoginForm(),
                  ),
                ),
              ),

              BlocListener<LoginBloc, LoginState>(
                listener: (context, state) {
                  if (state is LoginLoadingState) {
                    modalProgress.show();
                  } else if (state is LoginLoadedState) {
                    _openMainScreen(context, state.person);
                  } else {
                    modalProgress.hide();

                    if (state is LoginErrorState) {
                      errorComponent.show(state.error);
                    }
                  }
                },
                child: Config.emptyWidget,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
