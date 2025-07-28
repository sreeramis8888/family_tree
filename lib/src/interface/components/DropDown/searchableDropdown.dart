import 'package:flutter/material.dart';
import 'package:familytree/src/data/constants/color_constants.dart';

class SearchableDropDown extends StatefulWidget {
  final String? hintText;
  final String? label;
  final List<DropdownMenuItem<String>> items;
  final String? value;
  final ValueChanged<String?> onChanged;
  final FormFieldValidator<String>? validator;
  final String searchHintText;
  final bool searchable;

  const SearchableDropDown({
    this.label,
    required this.items,
    this.value,
    required this.onChanged,
    this.validator,
    Key? key,
    this.hintText,
    this.searchHintText = 'Search...',
    this.searchable = true,
  }) : super(key: key);

  @override
  _SearchableDropDownState createState() => _SearchableDropDownState();
}

class _SearchableDropDownState extends State<SearchableDropDown>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final FocusNode _focusNode = FocusNode();
  final TextEditingController _searchController = TextEditingController();

  String? _selectedValue;
  List<DropdownMenuItem<String>> _filteredItems = [];
  VoidCallback? _searchListener;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward();

    _filteredItems = List.from(widget.items);
    _selectedValue = widget.value;
  }

  @override
  void dispose() {
    _animationController.dispose();
    _focusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(SearchableDropDown oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update selected value when widget updates
    if (widget.value != _selectedValue) {
      setState(() {
        _selectedValue = widget.value;
      });
    }
  }

  void _filterItems(String query) {
    print("Filtering for: $query"); // 🔥 check this
    if (!mounted) return;
    setState(() {
      try {
        if (query.trim().isEmpty) {
          _filteredItems = List.from(widget.items);
        } else {
          final queryWords = query
              .toLowerCase()
              .trim()
              .split(' ')
              .where((word) => word.isNotEmpty)
              .toList();

          _filteredItems = widget.items.where((item) {
            final itemText = (item.child as Text).data!.toLowerCase();
            return queryWords.every((word) => itemText.contains(word)) ||
                itemText.contains(query.toLowerCase());
          }).toList();
        }
      } catch (e) {
        _filteredItems = List.from(widget.items);
      }
    });
  }

  void _selectItem(DropdownMenuItem<String> item) {
    setState(() {
      _selectedValue = item.value;
    });

    widget.onChanged(item.value);

    // Remove listener before closing dialog
    if (_searchListener != null) {
      _searchController.removeListener(_searchListener!);
      _searchListener = null;
    }
    Navigator.of(context).pop();
  }

  String? _getDisplayText() {
    if (_selectedValue == null) return null;

    // Special handling for new family value
    if (_selectedValue == '__new_family__') {
      // Look for the new family item in the list
      final newFamilyItem = widget.items.firstWhere(
        (item) => item.value == '__new_family__',
        orElse: () => const DropdownMenuItem(value: '', child: Text('')),
      );

      if (newFamilyItem.value != '') {
        return (newFamilyItem.child as Text).data;
      }
    }

    final selectedItem = widget.items.firstWhere(
      (item) => item.value == _selectedValue,
      orElse: () => const DropdownMenuItem(value: '', child: Text('')),
    );

    return selectedItem.value == '' ? null : (selectedItem.child as Text).data;
  }

  void _showSearchDialog() {
    _filteredItems = List.from(widget.items);
    _searchController.clear();
    _searchListener = () {
      _filterItems(_searchController.text);
    };
    _searchController.addListener(_searchListener!);

    // Determine the heading based on the label or hint text
    String getHeading() {
      final label = widget.label?.toLowerCase() ?? '';
      final hint = widget.hintText?.toLowerCase() ?? '';

      if (label.contains('family') || hint.contains('family')) {
        return 'Select Family';
      } else if (label.contains('member') || hint.contains('member')) {
        return 'Select Members';
      } else if (label.contains('relationship') ||
          hint.contains('relationship')) {
        return 'Select Relationship';
      } else {
        return widget.label ?? 'Select Option';
      }
    }

    void _cleanupListener() {
      if (_searchListener != null) {
        _searchController.removeListener(_searchListener!);
        _searchListener = null;
      }
    }

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return PopScope(
          onPopInvoked: (didPop) {
            if (didPop) {
              _cleanupListener();
            }
          },
          child: Dialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: StatefulBuilder(
              // 👈 Add this
              builder: (BuildContext context, StateSetter setStateDialog) {
                return Container(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.7,
                    maxWidth: MediaQuery.of(context).size.width * 0.9,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Search Field
                      if (widget.searchable)
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: TextField(
                            controller: _searchController,
                            autofocus: true,
                            decoration: InputDecoration(
                              hintText: widget.searchHintText,
                              prefixIcon: const Icon(Icons.search),
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) {
                              setStateDialog(() {
                                _filterItems(value); // rebuild dialog UI
                              });
                            },
                          ),
                        ),

                      // Items List
                      Flexible(
                        child: _filteredItems.isEmpty
                            ? const Center(child: Text("No items found"))
                            : ListView.builder(
                                itemCount: _filteredItems.length,
                                itemBuilder: (context, index) {
                                  final item = _filteredItems[index];
                                  final isSelected =
                                      item.value == _selectedValue;

                                  return ListTile(
                                    title: item.child,
                                    trailing: isSelected
                                        ? const Icon(Icons.check_circle,
                                            color: Colors.blue)
                                        : null,
                                    onTap: () => _selectItem(item),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.label != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    widget.label ?? "",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Color(0xFF2D3748),
                    ),
                  ),
                ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _showSearchDialog,
                child: FormField<String>(
                  validator: widget.validator,
                  initialValue: _selectedValue,
                  builder: (FormFieldState<String> state) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: kWhite,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: state.hasError
                                  ? Colors.red
                                  : const Color(0xFFE2E8F0),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  child: Text(
                                    _getDisplayText() ?? widget.hintText ?? '',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: _selectedValue == null
                                          ? const Color(0xFF718096)
                                          : const Color(0xFF2D3748),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 12.0),
                                child: Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: const Color(0xFF718096),
                                  size: 24,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (state.hasError)
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 4.0, left: 16.0),
                            child: Text(
                              state.errorText!,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
