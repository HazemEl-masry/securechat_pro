import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SearchBarWidget extends StatefulWidget {
  final Function(String) onSearchChanged;
  final VoidCallback? onFilterTap;
  final String hintText;

  const SearchBarWidget({
    Key? key,
    required this.onSearchChanged,
    this.onFilterTap,
    this.hintText = 'Search conversations...',
  }) : super(key: key);

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearchActive = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _clearSearch() {
    _searchController.clear();
    widget.onSearchChanged('');
    setState(() {
      _isSearchActive = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: Theme.of(context).inputDecorationTheme.fillColor,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Search input field
          Expanded(
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                widget.onSearchChanged(value);
                setState(() {
                  _isSearchActive = value.isNotEmpty;
                });
              },
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: Theme.of(context).inputDecorationTheme.hintStyle,
                prefixIcon: Padding(
                  padding: EdgeInsets.all(3.w),
                  child: CustomIconWidget(
                    iconName: 'search',
                    color: AppTheme.textMediumEmphasisLight,
                    size: 5.w,
                  ),
                ),
                suffixIcon: _isSearchActive
                    ? GestureDetector(
                        onTap: _clearSearch,
                        child: Padding(
                          padding: EdgeInsets.all(3.w),
                          child: CustomIconWidget(
                            iconName: 'clear',
                            color: AppTheme.textMediumEmphasisLight,
                            size: 5.w,
                          ),
                        ),
                      )
                    : null,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 4.w,
                  vertical: 2.h,
                ),
              ),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),

          // Filter button
          if (widget.onFilterTap != null)
            GestureDetector(
              onTap: widget.onFilterTap,
              child: Container(
                padding: EdgeInsets.all(3.w),
                margin: EdgeInsets.only(right: 2.w),
                decoration: BoxDecoration(
                  color: AppTheme.primaryLight.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: CustomIconWidget(
                  iconName: 'filter_list',
                  color: AppTheme.primaryLight,
                  size: 5.w,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
