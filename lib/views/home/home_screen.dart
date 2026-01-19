import 'package:flutter/material.dart';
import 'package:school_management_demo/route_structure/go_navigator.dart';
import 'package:school_management_demo/route_structure/go_router.dart';
import 'package:school_management_demo/theme/colors.dart';
import 'package:school_management_demo/theme/spacing.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:school_management_demo/widgets/custom_button.dart';

import 'package:school_management_demo/widgets/filled_box.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 👋 Greeting Row
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Hello, Ali",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "Admin",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                   GestureDetector(
                    onTap: () => Go.named(context, MyRouter.transactions),
                     child: FilledBox(
                      shape: BoxShape.circle,
                      padding: EdgeInsets.zero,
                      width: 50,
                      height: 50,
                      color: Theme.of(context).cardColor,
                      child: Center(
                        child: Icon(
                          LucideIcons.history,
                          size: 30,
                          color: AppTheme.grey,
                        ),
                      ),
                                       ),
                   ),
                  10.kW,
                  GestureDetector(
                    onTap: () => Go.named(context, MyRouter.profile),
                    child: FilledBox(
                      shape: BoxShape.circle,
                      padding: EdgeInsets.zero,
                      width: 50,
                      height: 50,
                      color: Theme.of(context).cardColor,
                      child: Center(
                        child: Icon(
                          LucideIcons.userCircle2,
                          size: 30,
                          color: AppTheme.grey,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              30.kH,

              // 💰 Lifetime Spent
              FilledBox(
                width: double.infinity,
                color: Theme.of(context).cardColor,
                borderRadius: const BorderRadius.all(Radius.circular(25)),
                child: Column(
                  children: [
                    Text(
                      "Lifetime Spent",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context).disabledColor,
                      ),
                    ),
                    Text(
                      "\$12,345.67",
                      style: TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                      
                      ),
                    ),
                  ],
                ),
              ),

              25.kH,

              // 📊 Income + Expenses Row
              Row(
                children: [
                  Expanded(
                    child: FilledBox(
                      color: Theme.of(context).cardColor,
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Monthly Income",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                            color: Theme.of(context).disabledColor,
                            ),
                          ),
                          Text(
                            "\$5,000",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                         
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  20.kW,
                  Expanded(
                    child: FilledBox(
                      color: Theme.of(context).cardColor,
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Monthly Expenses",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                       color: Theme.of(context).disabledColor,
                            ),
                          ),
                          Text(
                            "\$2,500",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                  
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              30.kH,

              // 📈 Insights Section
              Text(
                "Spending Insights",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  
                ),
              ),

              15.kH,

              // 📊 Daily Avg Spending Chart
         
              FilledBox(
                color: Theme.of(context).cardColor,
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Spending Alert",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                     color: Theme.of(context).disabledColor,
                      ),
                    ),
                    Text(
                      "You're spending too much this week",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                     
                      ),
                    ),
                    10.kH,
                    CustomButton(
                      onTap: () {},
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      child: (Text(
                        'View Details',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.white
                        ),
                      )),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
