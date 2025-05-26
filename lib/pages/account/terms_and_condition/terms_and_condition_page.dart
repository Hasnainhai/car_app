import 'package:fl_carmax/utils/constant.dart';
import 'package:fl_carmax/utils/widgets.dart';
import 'package:flutter/material.dart';

import '../../../helper/language_constant.dart';

class TermsAndConditionPage extends StatelessWidget {
  const TermsAndConditionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMethod(context),
      body: bodyMethod(),
    );
  }

  SingleChildScrollView bodyMethod() {
    List termsAndConditionList = [
      'Possimus ipsa ea. Dolorum ea vel et sit voluptatem quis ex. Sequi iusto velit ratione voluptas repudiandae aliquid molestiae non. Et enim quam. Et consequatur sunt dicta esse eveniet tempore deserunt.',
      'Possimus ipsa ea. Dolorum ea vel et sit voluptatem quis ex. Sequi iusto velit ratione voluptas repudiandae aliquid molestiae non. Et enim quam. Et consequatur sunt dicta esse eveniet tempore deserunt.Possimus ipsa ea. Dolorum ea vel et sit voluptatem quis ex. Sequi iusto velit ratione voluptas repudiandae Possimus ipsa ea. Dolorum ea vel et sit voluptatem quis ex. Sequi iusto velit ratione voluptas repudiandae',
      'Possimus ipsa ea. Dolorum ea vel et sit voluptatem quis ex. Sequi iusto velit ratione voluptas repudiandae aliquid molestiae non. Et enim quam. Et consequatur sunt dicta esse eveniet tempore deserunt.',
      'Possimus ipsa ea. Dolorum ea vel et sit voluptatem quis ex. Sequi iusto velit ratione voluptas repudiandae aliquid molestiae non. Et enim quam. Et consequatur sunt dicta esse eveniet tempore deserunt.Possimus ipsa ea. Dolorum ea vel et sit voluptatem quis ex. Sequi iusto velit ratione voluptas repudiandae Possimus ipsa ea. Dolorum ea vel et sit voluptatem quis ex. Sequi iusto velit ratione voluptas repudiandae',
      'Possimus ipsa ea. Dolorum ea vel et sit voluptatem quis ex. Sequi iusto velit ratione voluptas repudiandae aliquid molestiae non. Et enim quam. Et consequatur sunt dicta esse eveniet tempore deserunt.Possimus ipsa ea. Dolorum ea vel et sit voluptatem quis ex. Sequi iusto velit ratione voluptas repudiandae Possimus ipsa ea. Dolorum ea vel et sit voluptatem quis ex. Sequi iusto velit ratione voluptas repudiandae',
      'Possimus ipsa ea. Dolorum ea vel et sit voluptatem quis ex. Sequi iusto velit ratione voluptas repudiandae aliquid molestiae non. Et enim quam. Et consequatur sunt dicta esse eveniet tempore deserunt.'
    ];

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: List.generate(
              termsAndConditionList.length,
              (index) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      termsAndConditionList[index],
                      style: colorA6Regular14,
                    ),
                  )),
        ),
      ),
    );
  }

  PreferredSize appBarMethod(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(56),
      child: CustomAppBar(title: translation(context).profileItem7),
    );
  }
}
