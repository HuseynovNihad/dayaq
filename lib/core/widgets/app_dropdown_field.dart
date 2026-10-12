import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../extensions/context_extensions.dart';
import '../theme/app_colors.dart';

class AppDropdownField<T> extends StatefulWidget {
  const AppDropdownField({
    super.key,
    required this.label,
    required this.items,
    required this.onChanged,
    this.value,
    this.hintText = 'Seçin',
    this.requiredField = false,
    this.prefixIcon,
    this.labelTrailing,
    this.validator,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.enabled = true,
  });

  final String label;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;

  final T? value;
  final String hintText;
  final bool requiredField;
  final bool enabled;

  final Widget? prefixIcon;
  final Widget? labelTrailing;

  final FormFieldValidator<T>? validator;
  final AutovalidateMode autovalidateMode;

  @override
  State<AppDropdownField<T>> createState() => _AppDropdownFieldState<T>();
}

class _AppDropdownFieldState<T> extends State<AppDropdownField<T>>
    with SingleTickerProviderStateMixin {
  final _fieldKey = GlobalKey();
  final _layerLink = LayerLink();
  final _overlayController = OverlayPortalController();

  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  bool _isOpen = false;
  double _menuHeight = 0;
  double _menuWidth = 0;

  static const _borderColor = Color(0xFFF4F1ED);
  static const _hintColor = Color(0xFFD7C6B0);

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
      reverseDuration: const Duration(milliseconds: 120),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, -0.05), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );
  }

  @override
  void didUpdateWidget(covariant AppDropdownField<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!widget.enabled && _isOpen) {
      _closeMenu();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _openMenu() {
    if (!widget.enabled || widget.items.isEmpty || _isOpen) {
      return;
    }

    final fieldContext = _fieldKey.currentContext;
    if (fieldContext == null) return;

    final renderBox = fieldContext.findRenderObject() as RenderBox?;
    if (renderBox == null || !renderBox.hasSize) return;

    final position = renderBox.localToGlobal(Offset.zero);
    final screenSize = MediaQuery.sizeOf(context);
    final bottomPadding = MediaQuery.paddingOf(context).bottom;

    final availableHeight =
        screenSize.height -
        (position.dy + renderBox.size.height) -
        bottomPadding -
        16.h;

    final desiredHeight = math.min(280.h, widget.items.length * 48.h + 12.h);

    // Mövcud ekran sahəsinə uyğun hündürlük.
    // Açılma mövqeyi həmişə field-in altıdır.
    _menuHeight = math.min(desiredHeight, math.max(0.0, availableHeight));
    _menuWidth = renderBox.size.width;

    if (_menuHeight < 48.h) {
      // Klaviatura açıqdırsa bağlayıb yenidən yer hesabla.
      FocusScope.of(context).unfocus();
      return;
    }

    setState(() {
      _isOpen = true;
    });

    _overlayController.show();
    _animationController.forward(from: 0);
  }

  void _closeMenu() {
    if (!_isOpen) return;

    _animationController.reverse();

    _overlayController.hide();

    if (mounted) {
      setState(() {
        _isOpen = false;
      });
    }
  }

  void _selectItem(T value, FormFieldState<T> fieldState) {
    fieldState.didChange(value);
    widget.onChanged?.call(value);
    _closeMenu();
  }

  Widget _buildOverlay(FormFieldState<T> fieldState) {
    final mediaSize = MediaQuery.sizeOf(context);

    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: _closeMenu,
            child: const ColoredBox(color: Colors.transparent),
          ),
        ),

        Positioned(
          width: _menuWidth,
          child: CompositedTransformFollower(
            link: _layerLink,
            showWhenUnlinked: false,
            targetAnchor: Alignment.bottomLeft,
            followerAnchor: Alignment.topLeft,
            offset: Offset(0, 6.h),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    constraints: BoxConstraints(
                      maxHeight: math.min(_menuHeight, mediaSize.height * 0.55),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(color: _borderColor),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.09),
                          blurRadius: 22.r,
                          offset: Offset(0, 8.h),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16.r),
                      child: ListView.builder(
                        padding: EdgeInsets.symmetric(vertical: 6.h),
                        shrinkWrap: true,
                        itemCount: widget.items.length,
                        itemBuilder: (context, index) {
                          final item = widget.items[index];

                          final selected = fieldState.value == item.value;

                          return InkWell(
                            onTap: item.enabled && item.value != null
                                ? () => _selectItem(item.value as T, fieldState)
                                : null,
                            child: Container(
                              height: 48.h,
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              color: selected
                                  ? const Color(0xFFFFF4DF)
                                  : Colors.transparent,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: DefaultTextStyle(
                                      style:
                                          context.textTheme.bodyMedium
                                              ?.copyWith(
                                                fontSize: 14.sp,
                                                fontWeight: selected
                                                    ? FontWeight.w600
                                                    : FontWeight.w400,
                                                color: item.enabled
                                                    ? AppColors.textPrimary
                                                    : AppColors.textSecondary,
                                              ) ??
                                          const TextStyle(),
                                      child: item.child,
                                    ),
                                  ),
                                  if (selected)
                                    Icon(
                                      Icons.check_rounded,
                                      size: 19.r,
                                      color: AppColors.primary,
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(18.r);

    OutlineInputBorder border(Color color, double width) {
      return OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide(color: color, width: width),
      );
    }

    return FormField<T>(
      initialValue: widget.value,
      validator: widget.validator,
      autovalidateMode: widget.autovalidateMode,
      builder: (fieldState) {
        final selectedItems = widget.items.where(
          (item) => item.value == fieldState.value,
        );

        final selectedItem = selectedItems.isNotEmpty
            ? selectedItems.first
            : null;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Label
            Row(
              children: [
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(text: widget.label),
                        if (widget.requiredField)
                          const TextSpan(
                            text: ' *',
                            style: TextStyle(color: Colors.red),
                          ),
                      ],
                    ),
                    style: context.textTheme.titleSmall?.copyWith(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                if (widget.labelTrailing != null) widget.labelTrailing!,
              ],
            ),

            SizedBox(height: 12.h),

            OverlayPortal(
              controller: _overlayController,
              overlayChildBuilder: (context) => _buildOverlay(fieldState),
              child: CompositedTransformTarget(
                link: _layerLink,
                child: GestureDetector(
                  onTap: _isOpen ? _closeMenu : _openMenu,
                  child: InputDecorator(
                    key: _fieldKey,
                    isFocused: _isOpen,
                    isEmpty: selectedItem == null,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: widget.enabled
                          ? Colors.white
                          : const Color(0xFFF7F7F7),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 18.w,
                        vertical: 18.h,
                      ),
                      border: border(_borderColor, 1),
                      enabledBorder: border(_borderColor, 1),
                      focusedBorder: border(AppColors.primary, 1.5),
                      errorBorder: border(Colors.red, 1),
                      focusedErrorBorder: border(Colors.red, 1.5),
                      errorText: fieldState.errorText,
                    ),
                    child: Row(
                      children: [
                        if (widget.prefixIcon != null) ...[
                          widget.prefixIcon!,
                          SizedBox(width: 10.w),
                        ],
                        Expanded(
                          child: selectedItem == null
                              ? Text(
                                  widget.hintText,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: _hintColor,
                                  ),
                                )
                              : DefaultTextStyle(
                                  style:
                                      context.textTheme.bodyLarge?.copyWith(
                                        fontSize: 14.sp,
                                        color: AppColors.textPrimary,
                                      ) ??
                                      const TextStyle(),
                                  child: selectedItem.child,
                                ),
                        ),
                        SizedBox(width: 8.w),
                        AnimatedRotation(
                          turns: _isOpen ? 0.5 : 0,
                          duration: const Duration(milliseconds: 180),
                          child: Icon(
                            Icons.keyboard_arrow_down_rounded,
                            size: 24.r,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
