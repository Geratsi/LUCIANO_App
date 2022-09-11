
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'EditProfileScreen.dart';
import 'components/CustomAvatar.dart';
import '../login/MainLoginScreen.dart';
import '../../Config.dart';
import '../../Styles.dart';
import '../../entity/Person.dart';
import '../../components/ShortDivider.dart';
import '../../bloc/profile_change/profile_change_bloc.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({
    Key? key,
    required this.personInfo,
  }) : super(key: key);

  final Person personInfo;

  void _editProfile(BuildContext context, ProfileChangeBloc profileChangeBloc) {
    Navigator.push(context, MaterialPageRoute(
      builder: (context) => EditProfileScreen(
        personInfo: personInfo,
        updateParentState: () {
          profileChangeBloc.add(ProfileChangeUpdateEvent());
        },
      ),
    ),);
  }

  void _logOut(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
      builder: (context) => const MainLoginScreen(),
    ), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final ProfileChangeBloc profileChangeBloc = context.read<ProfileChangeBloc>();
    
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(Config.padding),
              child: Column(
                children: <Widget>[
                  BlocBuilder<ProfileChangeBloc, int>(
                    builder: (context, state) {
                      return CustomAvatar(
                        imageProvider: MemoryImage(personInfo.imageBytes,),
                      );
                    },
                  ),

                  const SizedBox(height: Config.padding,),

                  GestureDetector(
                    onTap: () {
                      _editProfile(context, profileChangeBloc);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Config.infoColor,
                        borderRadius: BorderRadius.circular(Config.smallBorderRadius),
                        border: Border.all(width: 2, color: Config.primaryLightColor),
                      ),
                      padding: const EdgeInsets.all(Config.padding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  '${personInfo.surname} ${personInfo.name} '
                                      '${personInfo.secondName}',
                                  style: Styles.titleStyle,
                                ),
                              ),

                              Image.asset(
                                'assets/images/edit.png',
                                  width: Config.iconSize - 10,
                                  height: Config.iconSize - 10,
                              ),
                            ],
                          ),

                          const SizedBox(height: Config.padding / 2,),

                          Text(
                            personInfo.position,
                            style: Styles.textTitleColorStyle,
                          ),
                        ],
                      ),
                    ),
                  ),

                  BlocBuilder<ProfileChangeBloc, int>(
                    builder: (context, state) {
                      return personInfo.notes != null ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          ShortDivider(context: context),

                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Config.infoColor,
                              borderRadius: BorderRadius.circular(Config.smallBorderRadius),
                            ),
                            padding: const EdgeInsets.all(Config.padding),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                const Text('Обо мне', style: Styles.titleStyle,),

                                const SizedBox(height: Config.padding,),

                                Text(
                                  personInfo.notes!,
                                  style: Styles.textTitleColorStyle,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ) : Config.emptyWidget;
                    },
                  ),
                ],
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(Config.padding / 2),
                  child: IconButton(
                    onPressed: () {
                      _logOut(context);
                    },
                    icon: const Icon(Icons.logout,),
                  ),
                ),
              ],
            ),
          ]
        ),
      ),
    );
  }
}
