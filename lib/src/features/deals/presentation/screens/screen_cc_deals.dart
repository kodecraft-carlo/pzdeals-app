import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:pzdeals/src/common_widgets/text_widget.dart';
import 'package:pzdeals/src/constants/color_constants.dart';
import 'package:pzdeals/src/constants/sizes.dart';
import 'package:pzdeals/src/features/deals/presentation/widgets/card_cc_deal.dart';

class CreditCardDealsScreen extends StatelessWidget {
  const CreditCardDealsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const TextWidget(
          text: "Latest Credit Card Deals",
          textDisplayType: TextDisplayType.appbarTitle,
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        surfaceTintColor: PZColors.pzWhite,
        backgroundColor: PZColors.pzWhite,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: const SingleChildScrollView(
          child: Padding(
        padding: EdgeInsets.only(
          left: Sizes.paddingLeft,
          right: Sizes.paddingRight,
          bottom: Sizes.paddingBottom,
        ),
        child: Column(
          children: [
            CreditCardItem(
              imageAsset:
                  'https://www.forbes.com/advisor/wp-content/uploads/2021/07/ff304640-e963-11eb-a48f-65ac0bb53c5b.png',
              sourceType: 'network',
              title:
                  'Earn 100,000 bonus miles when you spend \$20,000 on purchases in the first 12 months from account opening, ',
              displayType: 'scrollView',
              description:
                  '<p><span style="color:#0af"><strong>Ez-Pz Recap:</strong></span></p><ul><li>75,000 Chase Ultimate Rewards<span data-mce-fragment="1">®</span><span>&nbsp;</span>points (\$750 cash&nbsp;value) after \$6,000 spend in the first 3 months of opening</li><li>No annual fee</li><li>Unlimited 1.5% cash back on all business purchases</li></ul><p>&nbsp;&nbsp;</p><p>Chase is offering 75,000 Chase Ultimate Rewards<span data-mce-fragment="1">®</span><span>&nbsp;</span>bonus points (\$750 cash value) with signup and initial spend of \$6,000 in the first 3 months of card opening. Normal \$6,000 spend at 1.5% cash back equals 9,000 bonus points, so total points earned after the initial \$6,000 spend would be 99,000 points (\$990 cash value).</p><p>&nbsp;&nbsp;</p><p><span style="color:#0af"><strong>The Fine Print:</strong>&nbsp;</span></p><p>If you received a signup bonus for an Ink Business Unlimited®&nbsp;Credit Card for the same business in the last 24 months you may not be approved. Once you are approved for the card, you are eligible for the bonus.&nbsp;Multiple businesses&nbsp;run by the same person can&nbsp;get approved for&nbsp;this card and signup bonus.&nbsp;You are eligible to&nbsp;get this card even if you already have other Chase Ink cards.</p><p>&nbsp;</p><p><em>If your application is pending, try sending a secure message through the Chase website or Chase app. Sometimes they need something as simple as a photo of your ID to get you approved!</em></p><p>&nbsp;&nbsp;</p><p><span style="color:#0af"><strong>OVERVIEW:</strong></span></p><p><span style="color:grey"><strong>Rewards:</strong>&nbsp;</span></p><ul><li>Unlimited 1.5% cash back on business purchases</li><li>No expiration on cash back for duration account remains open</li><li>Add employee cards at no additional cost. Employees earn cash back as well</li></ul><ul></ul><p>&nbsp;</p><p><span style="color:grey"><strong>Protections Offered:&nbsp;</strong></span></p><ul><li>Real-time fraud monitoring over account, no liability on unauthorized charges</li><li>Car rental insurance on theft and collision damage</li><li>New purchases covered for 120 days against damage or theft up to \$10,000/claim and \$50,000/account</li><li>One year extension to eligible US manufacturers warranties of less than 3 years</li></ul>',
            ),
            CreditCardItem(
              imageAsset:
                  'https://icm.aexp-static.com/Internet/internationalcardshop/en_in/images/cards/Platinum_Card.png',
              sourceType: 'network',
              title:
                  'Earn 100,000 bonus miles when you spend \$20,000 on purchases in the first 12 months from account opening, ',
              displayType: 'scrollView',
              description:
                  '<p><span style="color:#0af"><strong>Ez-Pz Recap:</strong></span></p><ul><li>75,000 Chase Ultimate Rewards<span data-mce-fragment="1">®</span><span>&nbsp;</span>points (\$750 cash&nbsp;value) after \$6,000 spend in the first 3 months of opening</li><li>No annual fee</li><li>Unlimited 1.5% cash back on all business purchases</li></ul><p>&nbsp;&nbsp;</p><p>Chase is offering 75,000 Chase Ultimate Rewards<span data-mce-fragment="1">®</span><span>&nbsp;</span>bonus points (\$750 cash value) with signup and initial spend of \$6,000 in the first 3 months of card opening. Normal \$6,000 spend at 1.5% cash back equals 9,000 bonus points, so total points earned after the initial \$6,000 spend would be 99,000 points (\$990 cash value).</p><p>&nbsp;&nbsp;</p><p><span style="color:#0af"><strong>The Fine Print:</strong>&nbsp;</span></p><p>If you received a signup bonus for an Ink Business Unlimited®&nbsp;Credit Card for the same business in the last 24 months you may not be approved. Once you are approved for the card, you are eligible for the bonus.&nbsp;Multiple businesses&nbsp;run by the same person can&nbsp;get approved for&nbsp;this card and signup bonus.&nbsp;You are eligible to&nbsp;get this card even if you already have other Chase Ink cards.</p><p>&nbsp;</p><p><em>If your application is pending, try sending a secure message through the Chase website or Chase app. Sometimes they need something as simple as a photo of your ID to get you approved!</em></p><p>&nbsp;&nbsp;</p><p><span style="color:#0af"><strong>OVERVIEW:</strong></span></p><p><span style="color:grey"><strong>Rewards:</strong>&nbsp;</span></p><ul><li>Unlimited 1.5% cash back on business purchases</li><li>No expiration on cash back for duration account remains open</li><li>Add employee cards at no additional cost. Employees earn cash back as well</li></ul><ul></ul><p>&nbsp;</p><p><span style="color:grey"><strong>Protections Offered:&nbsp;</strong></span></p><ul><li>Real-time fraud monitoring over account, no liability on unauthorized charges</li><li>Car rental insurance on theft and collision damage</li><li>New purchases covered for 120 days against damage or theft up to \$10,000/claim and \$50,000/account</li><li>One year extension to eligible US manufacturers warranties of less than 3 years</li></ul>',
            ),
            CreditCardItem(
              imageAsset:
                  'https://www.forbes.com/advisor/wp-content/uploads/2021/07/ff304640-e963-11eb-a48f-65ac0bb53c5b.png',
              sourceType: 'network',
              title:
                  'Earn 100,000 bonus miles when you spend \$20,000 on purchases in the first 12 months from account opening, ',
              displayType: 'scrollView',
              description:
                  '<p><span style="color:#0af"><strong>Ez-Pz Recap:</strong></span></p><ul><li>75,000 Chase Ultimate Rewards<span data-mce-fragment="1">®</span><span>&nbsp;</span>points (\$750 cash&nbsp;value) after \$6,000 spend in the first 3 months of opening</li><li>No annual fee</li><li>Unlimited 1.5% cash back on all business purchases</li></ul><p>&nbsp;&nbsp;</p><p>Chase is offering 75,000 Chase Ultimate Rewards<span data-mce-fragment="1">®</span><span>&nbsp;</span>bonus points (\$750 cash value) with signup and initial spend of \$6,000 in the first 3 months of card opening. Normal \$6,000 spend at 1.5% cash back equals 9,000 bonus points, so total points earned after the initial \$6,000 spend would be 99,000 points (\$990 cash value).</p><p>&nbsp;&nbsp;</p><p><span style="color:#0af"><strong>The Fine Print:</strong>&nbsp;</span></p><p>If you received a signup bonus for an Ink Business Unlimited®&nbsp;Credit Card for the same business in the last 24 months you may not be approved. Once you are approved for the card, you are eligible for the bonus.&nbsp;Multiple businesses&nbsp;run by the same person can&nbsp;get approved for&nbsp;this card and signup bonus.&nbsp;You are eligible to&nbsp;get this card even if you already have other Chase Ink cards.</p><p>&nbsp;</p><p><em>If your application is pending, try sending a secure message through the Chase website or Chase app. Sometimes they need something as simple as a photo of your ID to get you approved!</em></p><p>&nbsp;&nbsp;</p><p><span style="color:#0af"><strong>OVERVIEW:</strong></span></p><p><span style="color:grey"><strong>Rewards:</strong>&nbsp;</span></p><ul><li>Unlimited 1.5% cash back on business purchases</li><li>No expiration on cash back for duration account remains open</li><li>Add employee cards at no additional cost. Employees earn cash back as well</li></ul><ul></ul><p>&nbsp;</p><p><span style="color:grey"><strong>Protections Offered:&nbsp;</strong></span></p><ul><li>Real-time fraud monitoring over account, no liability on unauthorized charges</li><li>Car rental insurance on theft and collision damage</li><li>New purchases covered for 120 days against damage or theft up to \$10,000/claim and \$50,000/account</li><li>One year extension to eligible US manufacturers warranties of less than 3 years</li></ul>',
            ),
            CreditCardItem(
              imageAsset:
                  'https://www.forbes.com/advisor/wp-content/uploads/2021/07/ff304640-e963-11eb-a48f-65ac0bb53c5b.png',
              sourceType: 'network',
              title:
                  'Earn 100,000 bonus miles when you spend \$20,000 on purchases in the first 12 months from account opening, ',
              displayType: 'scrollView',
              description:
                  '<p><span style="color:#0af"><strong>Ez-Pz Recap:</strong></span></p><ul><li>75,000 Chase Ultimate Rewards<span data-mce-fragment="1">®</span><span>&nbsp;</span>points (\$750 cash&nbsp;value) after \$6,000 spend in the first 3 months of opening</li><li>No annual fee</li><li>Unlimited 1.5% cash back on all business purchases</li></ul><p>&nbsp;&nbsp;</p><p>Chase is offering 75,000 Chase Ultimate Rewards<span data-mce-fragment="1">®</span><span>&nbsp;</span>bonus points (\$750 cash value) with signup and initial spend of \$6,000 in the first 3 months of card opening. Normal \$6,000 spend at 1.5% cash back equals 9,000 bonus points, so total points earned after the initial \$6,000 spend would be 99,000 points (\$990 cash value).</p><p>&nbsp;&nbsp;</p><p><span style="color:#0af"><strong>The Fine Print:</strong>&nbsp;</span></p><p>If you received a signup bonus for an Ink Business Unlimited®&nbsp;Credit Card for the same business in the last 24 months you may not be approved. Once you are approved for the card, you are eligible for the bonus.&nbsp;Multiple businesses&nbsp;run by the same person can&nbsp;get approved for&nbsp;this card and signup bonus.&nbsp;You are eligible to&nbsp;get this card even if you already have other Chase Ink cards.</p><p>&nbsp;</p><p><em>If your application is pending, try sending a secure message through the Chase website or Chase app. Sometimes they need something as simple as a photo of your ID to get you approved!</em></p><p>&nbsp;&nbsp;</p><p><span style="color:#0af"><strong>OVERVIEW:</strong></span></p><p><span style="color:grey"><strong>Rewards:</strong>&nbsp;</span></p><ul><li>Unlimited 1.5% cash back on business purchases</li><li>No expiration on cash back for duration account remains open</li><li>Add employee cards at no additional cost. Employees earn cash back as well</li></ul><ul></ul><p>&nbsp;</p><p><span style="color:grey"><strong>Protections Offered:&nbsp;</strong></span></p><ul><li>Real-time fraud monitoring over account, no liability on unauthorized charges</li><li>Car rental insurance on theft and collision damage</li><li>New purchases covered for 120 days against damage or theft up to \$10,000/claim and \$50,000/account</li><li>One year extension to eligible US manufacturers warranties of less than 3 years</li></ul>',
            ),
            CreditCardItem(
              imageAsset:
                  'https://www.forbes.com/advisor/wp-content/uploads/2021/07/ff304640-e963-11eb-a48f-65ac0bb53c5b.png',
              sourceType: 'network',
              title:
                  'Earn 100,000 bonus miles when you spend \$20,000 on purchases in the first 12 months from account opening, ',
              displayType: 'scrollView',
              description:
                  '<p><span style="color:#0af"><strong>Ez-Pz Recap:</strong></span></p><ul><li>75,000 Chase Ultimate Rewards<span data-mce-fragment="1">®</span><span>&nbsp;</span>points (\$750 cash&nbsp;value) after \$6,000 spend in the first 3 months of opening</li><li>No annual fee</li><li>Unlimited 1.5% cash back on all business purchases</li></ul><p>&nbsp;&nbsp;</p><p>Chase is offering 75,000 Chase Ultimate Rewards<span data-mce-fragment="1">®</span><span>&nbsp;</span>bonus points (\$750 cash value) with signup and initial spend of \$6,000 in the first 3 months of card opening. Normal \$6,000 spend at 1.5% cash back equals 9,000 bonus points, so total points earned after the initial \$6,000 spend would be 99,000 points (\$990 cash value).</p><p>&nbsp;&nbsp;</p><p><span style="color:#0af"><strong>The Fine Print:</strong>&nbsp;</span></p><p>If you received a signup bonus for an Ink Business Unlimited®&nbsp;Credit Card for the same business in the last 24 months you may not be approved. Once you are approved for the card, you are eligible for the bonus.&nbsp;Multiple businesses&nbsp;run by the same person can&nbsp;get approved for&nbsp;this card and signup bonus.&nbsp;You are eligible to&nbsp;get this card even if you already have other Chase Ink cards.</p><p>&nbsp;</p><p><em>If your application is pending, try sending a secure message through the Chase website or Chase app. Sometimes they need something as simple as a photo of your ID to get you approved!</em></p><p>&nbsp;&nbsp;</p><p><span style="color:#0af"><strong>OVERVIEW:</strong></span></p><p><span style="color:grey"><strong>Rewards:</strong>&nbsp;</span></p><ul><li>Unlimited 1.5% cash back on business purchases</li><li>No expiration on cash back for duration account remains open</li><li>Add employee cards at no additional cost. Employees earn cash back as well</li></ul><ul></ul><p>&nbsp;</p><p><span style="color:grey"><strong>Protections Offered:&nbsp;</strong></span></p><ul><li>Real-time fraud monitoring over account, no liability on unauthorized charges</li><li>Car rental insurance on theft and collision damage</li><li>New purchases covered for 120 days against damage or theft up to \$10,000/claim and \$50,000/account</li><li>One year extension to eligible US manufacturers warranties of less than 3 years</li></ul>',
            ),
            CreditCardItem(
              imageAsset:
                  'https://www.forbes.com/advisor/wp-content/uploads/2021/07/ff304640-e963-11eb-a48f-65ac0bb53c5b.png',
              sourceType: 'network',
              title:
                  'Earn 100,000 bonus miles when you spend \$20,000 on purchases in the first 12 months from account opening, ',
              displayType: 'scrollView',
              description:
                  '<p><span style="color:#0af"><strong>Ez-Pz Recap:</strong></span></p><ul><li>75,000 Chase Ultimate Rewards<span data-mce-fragment="1">®</span><span>&nbsp;</span>points (\$750 cash&nbsp;value) after \$6,000 spend in the first 3 months of opening</li><li>No annual fee</li><li>Unlimited 1.5% cash back on all business purchases</li></ul><p>&nbsp;&nbsp;</p><p>Chase is offering 75,000 Chase Ultimate Rewards<span data-mce-fragment="1">®</span><span>&nbsp;</span>bonus points (\$750 cash value) with signup and initial spend of \$6,000 in the first 3 months of card opening. Normal \$6,000 spend at 1.5% cash back equals 9,000 bonus points, so total points earned after the initial \$6,000 spend would be 99,000 points (\$990 cash value).</p><p>&nbsp;&nbsp;</p><p><span style="color:#0af"><strong>The Fine Print:</strong>&nbsp;</span></p><p>If you received a signup bonus for an Ink Business Unlimited®&nbsp;Credit Card for the same business in the last 24 months you may not be approved. Once you are approved for the card, you are eligible for the bonus.&nbsp;Multiple businesses&nbsp;run by the same person can&nbsp;get approved for&nbsp;this card and signup bonus.&nbsp;You are eligible to&nbsp;get this card even if you already have other Chase Ink cards.</p><p>&nbsp;</p><p><em>If your application is pending, try sending a secure message through the Chase website or Chase app. Sometimes they need something as simple as a photo of your ID to get you approved!</em></p><p>&nbsp;&nbsp;</p><p><span style="color:#0af"><strong>OVERVIEW:</strong></span></p><p><span style="color:grey"><strong>Rewards:</strong>&nbsp;</span></p><ul><li>Unlimited 1.5% cash back on business purchases</li><li>No expiration on cash back for duration account remains open</li><li>Add employee cards at no additional cost. Employees earn cash back as well</li></ul><ul></ul><p>&nbsp;</p><p><span style="color:grey"><strong>Protections Offered:&nbsp;</strong></span></p><ul><li>Real-time fraud monitoring over account, no liability on unauthorized charges</li><li>Car rental insurance on theft and collision damage</li><li>New purchases covered for 120 days against damage or theft up to \$10,000/claim and \$50,000/account</li><li>One year extension to eligible US manufacturers warranties of less than 3 years</li></ul>',
            ),
            CreditCardItem(
              imageAsset:
                  'https://www.forbes.com/advisor/wp-content/uploads/2021/07/ff304640-e963-11eb-a48f-65ac0bb53c5b.png',
              sourceType: 'network',
              title:
                  'Earn 100,000 bonus miles when you spend \$20,000 on purchases in the first 12 months from account opening, ',
              displayType: 'scrollView',
              description:
                  '<p><span style="color:#0af"><strong>Ez-Pz Recap:</strong></span></p><ul><li>75,000 Chase Ultimate Rewards<span data-mce-fragment="1">®</span><span>&nbsp;</span>points (\$750 cash&nbsp;value) after \$6,000 spend in the first 3 months of opening</li><li>No annual fee</li><li>Unlimited 1.5% cash back on all business purchases</li></ul><p>&nbsp;&nbsp;</p><p>Chase is offering 75,000 Chase Ultimate Rewards<span data-mce-fragment="1">®</span><span>&nbsp;</span>bonus points (\$750 cash value) with signup and initial spend of \$6,000 in the first 3 months of card opening. Normal \$6,000 spend at 1.5% cash back equals 9,000 bonus points, so total points earned after the initial \$6,000 spend would be 99,000 points (\$990 cash value).</p><p>&nbsp;&nbsp;</p><p><span style="color:#0af"><strong>The Fine Print:</strong>&nbsp;</span></p><p>If you received a signup bonus for an Ink Business Unlimited®&nbsp;Credit Card for the same business in the last 24 months you may not be approved. Once you are approved for the card, you are eligible for the bonus.&nbsp;Multiple businesses&nbsp;run by the same person can&nbsp;get approved for&nbsp;this card and signup bonus.&nbsp;You are eligible to&nbsp;get this card even if you already have other Chase Ink cards.</p><p>&nbsp;</p><p><em>If your application is pending, try sending a secure message through the Chase website or Chase app. Sometimes they need something as simple as a photo of your ID to get you approved!</em></p><p>&nbsp;&nbsp;</p><p><span style="color:#0af"><strong>OVERVIEW:</strong></span></p><p><span style="color:grey"><strong>Rewards:</strong>&nbsp;</span></p><ul><li>Unlimited 1.5% cash back on business purchases</li><li>No expiration on cash back for duration account remains open</li><li>Add employee cards at no additional cost. Employees earn cash back as well</li></ul><ul></ul><p>&nbsp;</p><p><span style="color:grey"><strong>Protections Offered:&nbsp;</strong></span></p><ul><li>Real-time fraud monitoring over account, no liability on unauthorized charges</li><li>Car rental insurance on theft and collision damage</li><li>New purchases covered for 120 days against damage or theft up to \$10,000/claim and \$50,000/account</li><li>One year extension to eligible US manufacturers warranties of less than 3 years</li></ul>',
            ),
            CreditCardItem(
              imageAsset:
                  'https://www.forbes.com/advisor/wp-content/uploads/2021/07/ff304640-e963-11eb-a48f-65ac0bb53c5b.png',
              sourceType: 'network',
              title:
                  'Earn 100,000 bonus miles when you spend \$20,000 on purchases in the first 12 months from account opening, ',
              displayType: 'scrollView',
              description:
                  '<p><span style="color:#0af"><strong>Ez-Pz Recap:</strong></span></p><ul><li>75,000 Chase Ultimate Rewards<span data-mce-fragment="1">®</span><span>&nbsp;</span>points (\$750 cash&nbsp;value) after \$6,000 spend in the first 3 months of opening</li><li>No annual fee</li><li>Unlimited 1.5% cash back on all business purchases</li></ul><p>&nbsp;&nbsp;</p><p>Chase is offering 75,000 Chase Ultimate Rewards<span data-mce-fragment="1">®</span><span>&nbsp;</span>bonus points (\$750 cash value) with signup and initial spend of \$6,000 in the first 3 months of card opening. Normal \$6,000 spend at 1.5% cash back equals 9,000 bonus points, so total points earned after the initial \$6,000 spend would be 99,000 points (\$990 cash value).</p><p>&nbsp;&nbsp;</p><p><span style="color:#0af"><strong>The Fine Print:</strong>&nbsp;</span></p><p>If you received a signup bonus for an Ink Business Unlimited®&nbsp;Credit Card for the same business in the last 24 months you may not be approved. Once you are approved for the card, you are eligible for the bonus.&nbsp;Multiple businesses&nbsp;run by the same person can&nbsp;get approved for&nbsp;this card and signup bonus.&nbsp;You are eligible to&nbsp;get this card even if you already have other Chase Ink cards.</p><p>&nbsp;</p><p><em>If your application is pending, try sending a secure message through the Chase website or Chase app. Sometimes they need something as simple as a photo of your ID to get you approved!</em></p><p>&nbsp;&nbsp;</p><p><span style="color:#0af"><strong>OVERVIEW:</strong></span></p><p><span style="color:grey"><strong>Rewards:</strong>&nbsp;</span></p><ul><li>Unlimited 1.5% cash back on business purchases</li><li>No expiration on cash back for duration account remains open</li><li>Add employee cards at no additional cost. Employees earn cash back as well</li></ul><ul></ul><p>&nbsp;</p><p><span style="color:grey"><strong>Protections Offered:&nbsp;</strong></span></p><ul><li>Real-time fraud monitoring over account, no liability on unauthorized charges</li><li>Car rental insurance on theft and collision damage</li><li>New purchases covered for 120 days against damage or theft up to \$10,000/claim and \$50,000/account</li><li>One year extension to eligible US manufacturers warranties of less than 3 years</li></ul>',
            ),
          ],
        ),
      )),
    );
  }
}
