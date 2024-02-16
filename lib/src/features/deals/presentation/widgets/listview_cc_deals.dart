import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:pzdeals/src/actions/navigate_screen.dart';
import 'package:pzdeals/src/constants/color_constants.dart';
import 'package:pzdeals/src/constants/sizes.dart';
import 'package:pzdeals/src/features/deals/presentation/screens/index.dart';
import 'package:pzdeals/src/features/deals/presentation/widgets/index.dart';

class CreditCardDealsWidget extends StatelessWidget {
  const CreditCardDealsWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: PZColors.pzLightGrey,
      padding: const EdgeInsets.only(
        top: Sizes.containerPaddingTop,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.only(
              left: Sizes.paddingLeft,
              right: Sizes.paddingRight,
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Credit Cards',
                  style: TextStyle(
                    fontSize: Sizes.bodyFontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(
                  child: NavigateScreenWidget(
                      destinationWidget: CreditCardDealsScreen(),
                      animationDirection: 'leftToRight',
                      childWidget: Text('View more >',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: Sizes.bodyFontSize,
                            color: PZColors.pzOrange,
                            fontWeight: FontWeight.w600,
                          ))),
                ),
              ],
            ),
          ),
          const SizedBox(height: Sizes.spaceBetweenContent),
          const Padding(
            padding: EdgeInsets.only(
              left: Sizes.cardPaddingLeft,
              right: Sizes.cardPaddingRight,
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  CreditCardItem(
                    imageAsset: 'assets/images/cc.png',
                    sourceType: 'asset',
                    displayType: 'listView',
                    title:
                        'Unbeatable Rewards with the Ink Business Unlimited® Credit Card: Earn 75,000 Bonus Points & 1.5% Cash Back with No Annual Fee',
                    description:
                        '<p><span style="color:#0af"><strong>Ez-Pz Recap:</strong></span></p><ul><li>75,000 Chase Ultimate Rewards<span data-mce-fragment="1">®</span><span>&nbsp;</span>points (\$750 cash&nbsp;value) after \$6,000 spend in the first 3 months of opening</li><li>No annual fee</li><li>Unlimited 1.5% cash back on all business purchases</li></ul><p>&nbsp;&nbsp;</p><p>Chase is offering 75,000 Chase Ultimate Rewards<span data-mce-fragment="1">®</span><span>&nbsp;</span>bonus points (\$750 cash value) with signup and initial spend of \$6,000 in the first 3 months of card opening. Normal \$6,000 spend at 1.5% cash back equals 9,000 bonus points, so total points earned after the initial \$6,000 spend would be 99,000 points (\$990 cash value).</p><p>&nbsp;&nbsp;</p><p><span style="color:#0af"><strong>The Fine Print:</strong>&nbsp;</span></p><p>If you received a signup bonus for an Ink Business Unlimited®&nbsp;Credit Card for the same business in the last 24 months you may not be approved. Once you are approved for the card, you are eligible for the bonus.&nbsp;Multiple businesses&nbsp;run by the same person can&nbsp;get approved for&nbsp;this card and signup bonus.&nbsp;You are eligible to&nbsp;get this card even if you already have other Chase Ink cards.</p><p>&nbsp;</p><p><em>If your application is pending, try sending a secure message through the Chase website or Chase app. Sometimes they need something as simple as a photo of your ID to get you approved!</em></p><p>&nbsp;&nbsp;</p><p><span style="color:#0af"><strong>OVERVIEW:</strong></span></p><p><span style="color:grey"><strong>Rewards:</strong>&nbsp;</span></p><ul><li>Unlimited 1.5% cash back on business purchases</li><li>No expiration on cash back for duration account remains open</li><li>Add employee cards at no additional cost. Employees earn cash back as well</li></ul><ul></ul><p>&nbsp;</p><p><span style="color:grey"><strong>Protections Offered:&nbsp;</strong></span></p><ul><li>Real-time fraud monitoring over account, no liability on unauthorized charges</li><li>Car rental insurance on theft and collision damage</li><li>New purchases covered for 120 days against damage or theft up to \$10,000/claim and \$50,000/account</li><li>One year extension to eligible US manufacturers warranties of less than 3 years</li></ul>',
                  ),
                  CreditCardItem(
                    imageAsset: 'assets/images/cc.png',
                    sourceType: 'asset',
                    displayType: 'listView',
                    title:
                        'Unbeatable Rewards with the Ink Business Unlimited® Credit Card: Earn 75,000 Bonus Points & 1.5% Cash Back with No Annual Fee',
                    description:
                        '<p><span style="color:#0af"><strong>Ez-Pz Recap:</strong></span></p><ul><li>75,000 Chase Ultimate Rewards<span data-mce-fragment="1">®</span><span>&nbsp;</span>points (\$750 cash&nbsp;value) after \$6,000 spend in the first 3 months of opening</li><li>No annual fee</li><li>Unlimited 1.5% cash back on all business purchases</li></ul><p>&nbsp;&nbsp;</p><p>Chase is offering 75,000 Chase Ultimate Rewards<span data-mce-fragment="1">®</span><span>&nbsp;</span>bonus points (\$750 cash value) with signup and initial spend of \$6,000 in the first 3 months of card opening. Normal \$6,000 spend at 1.5% cash back equals 9,000 bonus points, so total points earned after the initial \$6,000 spend would be 99,000 points (\$990 cash value).</p><p>&nbsp;&nbsp;</p><p><span style="color:#0af"><strong>The Fine Print:</strong>&nbsp;</span></p><p>If you received a signup bonus for an Ink Business Unlimited®&nbsp;Credit Card for the same business in the last 24 months you may not be approved. Once you are approved for the card, you are eligible for the bonus.&nbsp;Multiple businesses&nbsp;run by the same person can&nbsp;get approved for&nbsp;this card and signup bonus.&nbsp;You are eligible to&nbsp;get this card even if you already have other Chase Ink cards.</p><p>&nbsp;</p><p><em>If your application is pending, try sending a secure message through the Chase website or Chase app. Sometimes they need something as simple as a photo of your ID to get you approved!</em></p><p>&nbsp;&nbsp;</p><p><span style="color:#0af"><strong>OVERVIEW:</strong></span></p><p><span style="color:grey"><strong>Rewards:</strong>&nbsp;</span></p><ul><li>Unlimited 1.5% cash back on business purchases</li><li>No expiration on cash back for duration account remains open</li><li>Add employee cards at no additional cost. Employees earn cash back as well</li></ul><ul></ul><p>&nbsp;</p><p><span style="color:grey"><strong>Protections Offered:&nbsp;</strong></span></p><ul><li>Real-time fraud monitoring over account, no liability on unauthorized charges</li><li>Car rental insurance on theft and collision damage</li><li>New purchases covered for 120 days against damage or theft up to \$10,000/claim and \$50,000/account</li><li>One year extension to eligible US manufacturers warranties of less than 3 years</li></ul>',
                  ),
                  CreditCardItem(
                    imageAsset: 'assets/images/cc.png',
                    sourceType: 'asset',
                    displayType: 'listView',
                    title:
                        'Unbeatable Rewards with the Ink Business Unlimited® Credit Card: Earn 75,000 Bonus Points & 1.5% Cash Back with No Annual Fee',
                    description:
                        '<p><span style="color:#0af"><strong>Ez-Pz Recap:</strong></span></p><ul><li>75,000 Chase Ultimate Rewards<span data-mce-fragment="1">®</span><span>&nbsp;</span>points (\$750 cash&nbsp;value) after \$6,000 spend in the first 3 months of opening</li><li>No annual fee</li><li>Unlimited 1.5% cash back on all business purchases</li></ul><p>&nbsp;&nbsp;</p><p>Chase is offering 75,000 Chase Ultimate Rewards<span data-mce-fragment="1">®</span><span>&nbsp;</span>bonus points (\$750 cash value) with signup and initial spend of \$6,000 in the first 3 months of card opening. Normal \$6,000 spend at 1.5% cash back equals 9,000 bonus points, so total points earned after the initial \$6,000 spend would be 99,000 points (\$990 cash value).</p><p>&nbsp;&nbsp;</p><p><span style="color:#0af"><strong>The Fine Print:</strong>&nbsp;</span></p><p>If you received a signup bonus for an Ink Business Unlimited®&nbsp;Credit Card for the same business in the last 24 months you may not be approved. Once you are approved for the card, you are eligible for the bonus.&nbsp;Multiple businesses&nbsp;run by the same person can&nbsp;get approved for&nbsp;this card and signup bonus.&nbsp;You are eligible to&nbsp;get this card even if you already have other Chase Ink cards.</p><p>&nbsp;</p><p><em>If your application is pending, try sending a secure message through the Chase website or Chase app. Sometimes they need something as simple as a photo of your ID to get you approved!</em></p><p>&nbsp;&nbsp;</p><p><span style="color:#0af"><strong>OVERVIEW:</strong></span></p><p><span style="color:grey"><strong>Rewards:</strong>&nbsp;</span></p><ul><li>Unlimited 1.5% cash back on business purchases</li><li>No expiration on cash back for duration account remains open</li><li>Add employee cards at no additional cost. Employees earn cash back as well</li></ul><ul></ul><p>&nbsp;</p><p><span style="color:grey"><strong>Protections Offered:&nbsp;</strong></span></p><ul><li>Real-time fraud monitoring over account, no liability on unauthorized charges</li><li>Car rental insurance on theft and collision damage</li><li>New purchases covered for 120 days against damage or theft up to \$10,000/claim and \$50,000/account</li><li>One year extension to eligible US manufacturers warranties of less than 3 years</li></ul>',
                  ),
                  CreditCardItem(
                    imageAsset: 'assets/images/cc.png',
                    sourceType: 'asset',
                    displayType: 'listView',
                    title:
                        'Unbeatable Rewards with the Ink Business Unlimited® Credit Card: Earn 75,000 Bonus Points & 1.5% Cash Back with No Annual Fee',
                    description:
                        '<p><span style="color:#0af"><strong>Ez-Pz Recap:</strong></span></p><ul><li>75,000 Chase Ultimate Rewards<span data-mce-fragment="1">®</span><span>&nbsp;</span>points (\$750 cash&nbsp;value) after \$6,000 spend in the first 3 months of opening</li><li>No annual fee</li><li>Unlimited 1.5% cash back on all business purchases</li></ul><p>&nbsp;&nbsp;</p><p>Chase is offering 75,000 Chase Ultimate Rewards<span data-mce-fragment="1">®</span><span>&nbsp;</span>bonus points (\$750 cash value) with signup and initial spend of \$6,000 in the first 3 months of card opening. Normal \$6,000 spend at 1.5% cash back equals 9,000 bonus points, so total points earned after the initial \$6,000 spend would be 99,000 points (\$990 cash value).</p><p>&nbsp;&nbsp;</p><p><span style="color:#0af"><strong>The Fine Print:</strong>&nbsp;</span></p><p>If you received a signup bonus for an Ink Business Unlimited®&nbsp;Credit Card for the same business in the last 24 months you may not be approved. Once you are approved for the card, you are eligible for the bonus.&nbsp;Multiple businesses&nbsp;run by the same person can&nbsp;get approved for&nbsp;this card and signup bonus.&nbsp;You are eligible to&nbsp;get this card even if you already have other Chase Ink cards.</p><p>&nbsp;</p><p><em>If your application is pending, try sending a secure message through the Chase website or Chase app. Sometimes they need something as simple as a photo of your ID to get you approved!</em></p><p>&nbsp;&nbsp;</p><p><span style="color:#0af"><strong>OVERVIEW:</strong></span></p><p><span style="color:grey"><strong>Rewards:</strong>&nbsp;</span></p><ul><li>Unlimited 1.5% cash back on business purchases</li><li>No expiration on cash back for duration account remains open</li><li>Add employee cards at no additional cost. Employees earn cash back as well</li></ul><ul></ul><p>&nbsp;</p><p><span style="color:grey"><strong>Protections Offered:&nbsp;</strong></span></p><ul><li>Real-time fraud monitoring over account, no liability on unauthorized charges</li><li>Car rental insurance on theft and collision damage</li><li>New purchases covered for 120 days against damage or theft up to \$10,000/claim and \$50,000/account</li><li>One year extension to eligible US manufacturers warranties of less than 3 years</li></ul>',
                  ),
                  CreditCardItem(
                    imageAsset: 'assets/images/cc.png',
                    sourceType: 'asset',
                    displayType: 'listView',
                    title:
                        'Unbeatable Rewards with the Ink Business Unlimited® Credit Card: Earn 75,000 Bonus Points & 1.5% Cash Back with No Annual Fee',
                    description:
                        '<p><span style="color:#0af"><strong>Ez-Pz Recap:</strong></span></p><ul><li>75,000 Chase Ultimate Rewards<span data-mce-fragment="1">®</span><span>&nbsp;</span>points (\$750 cash&nbsp;value) after \$6,000 spend in the first 3 months of opening</li><li>No annual fee</li><li>Unlimited 1.5% cash back on all business purchases</li></ul><p>&nbsp;&nbsp;</p><p>Chase is offering 75,000 Chase Ultimate Rewards<span data-mce-fragment="1">®</span><span>&nbsp;</span>bonus points (\$750 cash value) with signup and initial spend of \$6,000 in the first 3 months of card opening. Normal \$6,000 spend at 1.5% cash back equals 9,000 bonus points, so total points earned after the initial \$6,000 spend would be 99,000 points (\$990 cash value).</p><p>&nbsp;&nbsp;</p><p><span style="color:#0af"><strong>The Fine Print:</strong>&nbsp;</span></p><p>If you received a signup bonus for an Ink Business Unlimited®&nbsp;Credit Card for the same business in the last 24 months you may not be approved. Once you are approved for the card, you are eligible for the bonus.&nbsp;Multiple businesses&nbsp;run by the same person can&nbsp;get approved for&nbsp;this card and signup bonus.&nbsp;You are eligible to&nbsp;get this card even if you already have other Chase Ink cards.</p><p>&nbsp;</p><p><em>If your application is pending, try sending a secure message through the Chase website or Chase app. Sometimes they need something as simple as a photo of your ID to get you approved!</em></p><p>&nbsp;&nbsp;</p><p><span style="color:#0af"><strong>OVERVIEW:</strong></span></p><p><span style="color:grey"><strong>Rewards:</strong>&nbsp;</span></p><ul><li>Unlimited 1.5% cash back on business purchases</li><li>No expiration on cash back for duration account remains open</li><li>Add employee cards at no additional cost. Employees earn cash back as well</li></ul><ul></ul><p>&nbsp;</p><p><span style="color:grey"><strong>Protections Offered:&nbsp;</strong></span></p><ul><li>Real-time fraud monitoring over account, no liability on unauthorized charges</li><li>Car rental insurance on theft and collision damage</li><li>New purchases covered for 120 days against damage or theft up to \$10,000/claim and \$50,000/account</li><li>One year extension to eligible US manufacturers warranties of less than 3 years</li></ul>',
                  ),
                  // Add more CreditCardItem widgets as needed
                ],
              ),
            ),
          ),
          const SizedBox(height: Sizes.spaceBetweenContent),
        ],
      ),
    );
  }
}
