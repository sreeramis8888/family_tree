import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:familytree/src/data/constants/color_constants.dart';
import 'package:familytree/src/data/constants/style_constants.dart';

class SearchableDropDown extends StatefulWidget {
  final String? label;
  final String? hintText;
  final List<DropdownMenuItem<String>> items;
  final String? value;
  final ValueChanged<String?> onChanged;
  final FormFieldValidator<String>? validator;

  const SearchableDropDown({
    this.label,
    this.hintText,
    required this.items,
    this.value,
    required this.onChanged,
    this.validator,
    Key? key,
  }) : super(key: key);

  @override
  _SearchableDropDownState createState() => _SearchableDropDownState();
}

class _SearchableDropDownState extends State<SearchableDropDown>
    with SingleTickerProviderStateMixin {
  late AnimationController _anim;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  late final List<String> _values;
  late final Map<String, String> _labels;

  @override
  void initState() {
    super.initState();

    _values = widget.items.map((e) => e.value!).toList();
    _labels = {
      for (var e in widget.items)
        e.value!: (e.child is Text) ? (e.child as Text).data ?? '' : e.value!
    };

    _anim = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _fade = CurvedAnimation(parent: _anim, curve: Curves.easeInOut);
    _slide = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero)
        .animate(CurvedAnimation(parent: _anim, curve: Curves.easeInOut));
    _anim.forward();
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.label != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(widget.label!, style: kSmallTitleM),
                ),
              Theme(
                data: Theme.of(context).copyWith(
                  canvasColor: kWhite,
                ),
                child: DropdownSearch<String>(
                  items: (filter, _) async {
                    return _values.where((v) {
                      final label = _labels[v]?.toLowerCase() ?? '';
                      return filter == null || filter.isEmpty
                          ? true
                          : label.contains(filter.toLowerCase());
                    }).toList();
                  },
                  selectedItem: widget.value,
                  onChanged: widget.onChanged,
                  popupProps: PopupProps.menu(
                    menuProps: MenuProps(
                      backgroundColor: Colors.white,
                    ),
                    showSearchBox: true,
                    searchFieldProps: TextFieldProps(
                      decoration: InputDecoration(
                        hintText: 'Search...',
                        hintStyle: const TextStyle(
                          color: Color(0xFF718096),
                          fontSize: 14,
                        ),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Color(0xFF718096),
                          size: 20,
                        ),
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        filled: true,
                        fillColor: kWhite,
                      ),
                    ),
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.7,
                      maxWidth: MediaQuery.of(context).size.width * 0.9,
                    ),
                    showSelectedItems: true,
                    fit: FlexFit.loose,
                    searchDelay: const Duration(milliseconds: 300),
                  ),
                  itemAsString: (String value) => _labels[value] ?? value,

                  // 👇 hint text if nothing selected
                  dropdownBuilder: (ctx, selectedItem) {
                    if (selectedItem == null || selectedItem.isEmpty) {
                      return Text(
                        widget.hintText ?? 'Select an option',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF718096), // hint color
                        ),
                      );
                    }
                    return Text(
                      _labels[selectedItem] ?? selectedItem,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF2D3748), // text color
                      ),
                    );
                  },

                  decoratorProps: DropDownDecoratorProps(
                    baseStyle:
                        const TextStyle(fontSize: 14, color: Color(0xFF2D3748)),
                    decoration: InputDecoration(
                      hintStyle: const TextStyle(
                          color: Color(0xFF718096), fontSize: 14),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      filled: true,
                      fillColor: kWhite,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide:
                            const BorderSide(color: kPrimaryColor, width: 2),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.red),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.red),
                      ),
                    ),
                  ),
                  validator: widget.validator,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
