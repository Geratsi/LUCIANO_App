
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'CheckUserScreen.dart';
import '../../Config.dart';
import '../../bloc/login/login_bloc.dart';
import '../../repository/login_repository.dart';

class MainLoginScreen extends StatelessWidget {
  const MainLoginScreen({Key? key}) : super(key: key);

  void _openCheckUserScreen(BuildContext context) {
    final LoginRepository loginRepository = LoginRepository();
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => BlocProvider<LoginBloc>(
        create: (context) => LoginBloc(loginRepository: loginRepository),
        child: const CheckUserScreen(),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    // final localizations = AppLocalizations.of(context);

    return Scaffold(
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: BoxDecoration(
          color: Config.shadowColor.withOpacity(.8),
          image: const DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        padding: EdgeInsets.fromLTRB(
          Config.padding / 2, MediaQuery.of(context).padding.top,
          Config.padding / 2, Config.padding / 2,
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Column(
              children: <Widget>[
                SvgPicture.asset('assets/images/logo.svg', width: 80, height: 80,),

                const SizedBox(height: Config.padding / 2,),

                const Text(
                  'Luciano', style: TextStyle(
                    fontSize: 80, color: Config.textColorOnPrimary,
                  ),
                ),

                const SizedBox(height: Config.padding / 2,),

                const Text(
                  'SPA | FITNESS | BEAUTY CLINIC | HOTEL | RESTAURANT',
                  style: TextStyle(
                    fontFamily: 'Forum',
                    fontSize: 24,
                    color: Config.primaryColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),

            InkWell(
              splashColor: Config.primaryDarkColor,
              child: Container(
                child: SvgPicture.asset('assets/images/auth.svg', width: 50, height: 50,),
                padding: const EdgeInsets.fromLTRB(
                  Config.padding * 1.5, Config.padding,
                  Config.padding / 2, Config.padding,
                ),
                decoration: BoxDecoration(
                  color: Config.primaryColor.withOpacity(.2),
                  border: Border.all(color: Config.primaryColor),
                  borderRadius: BorderRadius.circular(1000),
                ),
              ),
              onTap: () {
                _openCheckUserScreen(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
