import 'package:flutter/material.dart';
import '../models/stock_item.dart';
import '../models/stock_type.dart';

enum ItemMode { input, edit }

class NewItem extends StatefulWidget {
  final ItemMode mode;
  final StockItem? items;
  const NewItem({super.key, required this.mode, required this.items});

  @override
  State<NewItem> createState() {
    return _NewItemState();
  }
}

class _NewItemState extends State<NewItem> {
  final _formKey = GlobalKey<FormState>();

  late String? _enteredName;
  late int? _enterQuantity;
  StockType? _itemTypes;
  bool reset = true;

  @override
  void initState() {
    if (widget.mode == ItemMode.edit) {
      _enteredName = widget.items!.name;
      _enterQuantity = widget.items!.quantity;
      _itemTypes = widget.items!.type;
    } else {
      _enteredName = '';
      _enterQuantity = 1;
      _itemTypes = null;
    }
    super.initState();
  }

  void _saveItem(BuildContext context) {
    // 1 - Validate the form
    bool isValid = _formKey.currentState!.validate();
    if (isValid) {
      // 2 - Save the form to get last entered values
      _formKey.currentState!.save();

      final passedData = StockItem(
          id: 'z',
          name: _enteredName!,
          quantity: _enterQuantity!,
          type: _itemTypes!);
      Navigator.pop(context, passedData);
    }
  }

  void _resetForm() {
    _formKey.currentState!.reset();
  }

  String? validateQuantity(String? value) {
    if (value == null || value.isEmpty || int.tryParse(value) == null) {
      return 'Please enter a valid quantity.';
    }
    return null;
  }

  String? validateTitle(String? value) {
    if (value == null ||
        value.isEmpty ||
        value.trim().length <= 1 ||
        value.trim().length > 50) {
      return 'Must be between 1 and 50 characters.';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a new item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _enteredName,
                maxLength: 50,
                decoration: const InputDecoration(
                  label: Text('Name'),
                ),
                validator: validateTitle,
                onSaved: (value) {
                  _enteredName = value!;
                },
              ),
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      initialValue: _enterQuantity.toString(),
                      decoration: const InputDecoration(
                        label: Text('Quantity'),
                      ),
                      validator: validateQuantity,
                      onSaved: (value) {
                        _enterQuantity = int.parse(value!);
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: DropdownButtonFormField<StockType>(
                      value: _itemTypes,
                      items: [
                        for (final category in StockType.values)
                          DropdownMenuItem<StockType>(
                            value: category,
                            child: Row(
                              children: [
                                Icon(category.icon), // Replaced color with icon
                                const SizedBox(width: 6),
                                Text(category.label),
                              ],
                            ),
                          ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          if (reset == true) {
                            value = _itemTypes;
                          } else {
                            _itemTypes = value;
                          }
                        });
                      },
                      onSaved: (newValue) {
                        _itemTypes = newValue!;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _resetForm,
                    child: const Text('Reset'),
                  ),
                  ElevatedButton(
                    onPressed: () => _saveItem(context),
                    child: widget.mode == ItemMode.input
                        ? const Text("Add Item")
                        : const Text("Update Item"),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
