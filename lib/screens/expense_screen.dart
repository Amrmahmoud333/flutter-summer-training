import 'package:expense/cubit/expense_cubit.dart';
import 'package:expense/cubit/expense_state.dart';
import 'package:expense/models/expense_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExpenseScreen extends StatelessWidget {
  const ExpenseScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        title: const Text('Expense Tracker'),
        actions: [
          BlocBuilder<ExpenseCubit, ExpenseState>(
            builder: (context, state) {
              return DropdownButton<CategoryFilter>(
                items:
                    CategoryFilter.values.map((filter) {
                      return DropdownMenuItem(
                        value: filter,
                        child: Text(
                          filter.name[0].toUpperCase() +
                              filter.name.substring(1),
                        ),
                      );
                    }).toList(),
                value: state.filter,
                onChanged: (newFilter) {
                  if (newFilter != null) {
                    context.read<ExpenseCubit>().changeFilter(newFilter);
                  }
                },
              );
            },
          ),
        ],
      ),
      body: SizedBox(
        width: double.infinity,
        child: BlocBuilder<ExpenseCubit, ExpenseState>(
          builder: (context, state) {
            return Column(
              children: [
                Card(
                  margin: const EdgeInsets.all(16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text('Total Amount ${state.totalAmount}'),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: state.filteredExpenses.length,
                    itemBuilder: (context, index) {
                      final exps = state.filteredExpenses[index];
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Icon(Icons.monetization_on),

                              Column(
                                children: [
                                  Text(exps.title),
                                  Text(exps.category.name),
                                ],
                              ),

                              Text('\$ ${exps.amount}'),

                              IconButton(
                                onPressed: () {
                                  context.read<ExpenseCubit>().deleteExpense(
                                    exps.id,
                                  );
                                },
                                icon: const Icon(Icons.delete),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return BlocProvider.value(
                value: BlocProvider.of<ExpenseCubit>(context),
                child: AddExpenseDialog(),
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class AddExpenseDialog extends StatefulWidget {
  const AddExpenseDialog({super.key});

  @override
  State<AddExpenseDialog> createState() => _AddExpenseDialogState();
}

class _AddExpenseDialogState extends State<AddExpenseDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  ExpenseCategory _selectedCategory = ExpenseCategory.food;

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add New Expense'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),

              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _amountController,
              decoration: const InputDecoration(
                labelText: 'Amount',
                prefixText: '\$',
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an amount';
                }
                // Check if the value is a valid double (not a string like "abc" )
                if (double.tryParse(value) == null) {
                  return 'Please enter a valid amount';
                }
                if (double.tryParse(value)! < 0) {
                  return 'Please enter a positive amount';
                }

                return null;
              },
            ),
            SizedBox(height: 16.h),
            DropdownButtonFormField<ExpenseCategory>(
              value: _selectedCategory,
              items:
                  ExpenseCategory.values.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category.name),
                    );
                  }).toList(),
              onChanged: (newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedCategory = newValue;
                  });
                }
              },
              decoration: InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              context.read<ExpenseCubit>().addExpense(
                _titleController.text,
                double.tryParse(_amountController.text)!,
                _selectedCategory,
              );
              Navigator.of(context).pop();
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
