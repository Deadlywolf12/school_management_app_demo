import 'package:flutter/material.dart';

import 'package:lucide_icons/lucide_icons.dart';
import 'package:school_management_demo/theme/colors.dart';
import 'package:school_management_demo/theme/spacing.dart';
import 'package:school_management_demo/widgets/filled_box.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  String selectedCategory = 'All';
  String selectedDate = 'All Time';

  final List<String> categories = [
    'All',
    'Food',
    'Transport',
    'Shopping',
    'Entertainment',
    'Bills',
    'Health',
    'Education',
  ];

  final List<String> dateFilters = [
    'All Time',
    'Today',
    'This Week',
    'This Month',
    'Last Month',
  ];

  @override
  Widget build(BuildContext context) {
    // Calculate totals
    double totalExpense = transactions
        .where((t) => t.type == 'expense')
        .fold(0, (sum, t) => sum + t.amount);
    double totalIncome = transactions
        .where((t) => t.type == 'income')
        .fold(0, (sum, t) => sum + t.amount);

    return Scaffold(
   
      appBar: AppBar(
    
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(LucideIcons.arrowLeft,  color: Theme.of(context).disabledColor,),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Transactions',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
         
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(LucideIcons.plus,  color: Colors.white),
              onPressed: () {
                // Add new transaction
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Filters
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: _buildFilterButton(
                    label: selectedCategory,
                    icon: LucideIcons.tag,
                    onTap: () => _showCategoryFilter(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildFilterButton(
                    label: selectedDate,
                    icon: LucideIcons.calendar,
                    onTap: () => _showDateFilter(),
                  ),
                ),
              ],
            ),
          ),

          // Transaction List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                return _buildTransactionCard(transactions[index]);
              },
            ),
          ),

          // Summary Bottom Container
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Expense',
                        style: TextStyle(
                          fontSize: 13,
                          color: Theme.of(context).disabledColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '\$${totalExpense.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 1,
                  height: 40,
                color: Theme.of(context).disabledColor,
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Total Income',
                        style: TextStyle(
                          fontSize: 13,
                        color: Theme.of(context).disabledColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '\$${totalIncome.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                     
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: FilledBox(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: AppTheme.primaryColor,
                size: 18,
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                LucideIcons.chevronDown,
              color: Theme.of(context).disabledColor,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionCard(Transaction transaction) {
    final isExpense = transaction.type == 'expense';

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: FilledBox(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Row(
            children: [
              // Icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                color: Theme.of(context).disabledColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  transaction.icon,
             color: Theme.of(context).cardColor,
                  size: 24,
                ),
              ),
              20.kW,

              // Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${isExpense ? '-' : '+'}\$${transaction.amount.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      transaction.reason,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
             
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      transaction.category,
                      style: TextStyle(
                        fontSize: 12,
                      color: Theme.of(context).disabledColor,
                      ),
                    ),
                  ],
                ),
              ),

              // Time
              Text(
                transaction.timeAgo,
                style: TextStyle(
                  fontSize: 14,
                
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCategoryFilter() {
    showModalBottomSheet(
      context: context,
      backgroundColor:Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Category',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                 
                ),
              ),
              const SizedBox(height: 20),
              ...categories.map((category) {
                return _buildFilterOption(
                  title: category,
                  isSelected: selectedCategory == category,
                  onTap: () {
                    setState(() {
                      selectedCategory = category;
                    });
                    Navigator.pop(context);
                  },
                );
              }).toList(),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  void _showDateFilter() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Date Range',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
            
                ),
              ),
              const SizedBox(height: 20),
              ...dateFilters.map((dateFilter) {
                return _buildFilterOption(
                  title: dateFilter,
                  isSelected: selectedDate == dateFilter,
                  onTap: () {
                    setState(() {
                      selectedDate = dateFilter;
                    });
                    Navigator.pop(context);
                  },
                );
              }).toList(),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterOption({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primaryColor.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: isSelected ? AppTheme.primaryColor :Theme.of(context).disabledColor,
              ),
            ),
            const Spacer(),
            if (isSelected)
              Icon(
                LucideIcons.check,
                color: AppTheme.primaryColor,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}

// Model class for transactions
class Transaction {
  final String type; // 'expense' or 'income'
  final double amount;
  final String reason;
  final String category;
  final String timeAgo;
  final IconData icon;

  Transaction({
    required this.type,
    required this.amount,
    required this.reason,
    required this.category,
    required this.timeAgo,
    required this.icon,
  });
}

// Sample data
final List<Transaction> transactions = [
  Transaction(
    type: 'expense',
    amount: 45.50,
    reason: 'Lunch at restaurant',
    category: 'Food',
    timeAgo: '1 hour ago',
    icon: LucideIcons.utensils,
  ),
  Transaction(
    type: 'income',
    amount: 2500.00,
    reason: 'Monthly salary',
    category: 'Salary',
    timeAgo: '1 day ago',
    icon: LucideIcons.dollarSign,
  ),
  Transaction(
    type: 'expense',
    amount: 120.00,
    reason: 'Grocery shopping',
    category: 'Shopping',
    timeAgo: '2 days ago',
    icon: LucideIcons.shoppingCart,
  ),
  Transaction(
    type: 'expense',
    amount: 25.00,
    reason: 'Uber ride',
    category: 'Transport',
    timeAgo: '3 days ago',
    icon: LucideIcons.car,
  ),
  Transaction(
    type: 'expense',
    amount: 89.99,
    reason: 'Movie tickets',
    category: 'Entertainment',
    timeAgo: '1 week ago',
    icon: LucideIcons.film,
  ),
  Transaction(
    type: 'income',
    amount: 150.00,
    reason: 'Freelance project',
    category: 'Freelance',
    timeAgo: '1 week ago',
    icon: LucideIcons.briefcase,
  ),
  Transaction(
    type: 'expense',
    amount: 200.00,
    reason: 'Electricity bill',
    category: 'Bills',
    timeAgo: '2 weeks ago',
    icon: LucideIcons.zap,
  ),
  Transaction(
    type: 'expense',
    amount: 65.00,
    reason: 'Gym membership',
    category: 'Health',
    timeAgo: '2 weeks ago',
    icon: LucideIcons.dumbbell,
  ),
];