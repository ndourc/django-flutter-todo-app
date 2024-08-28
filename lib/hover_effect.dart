import 'package:flutter/material.dart';

class OnHoverButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const OnHoverButton({
    Key? key,
    required this.child,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  _OnHoverButtonState createState() => _OnHoverButtonState();
}

class _OnHoverButtonState extends State<OnHoverButton> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final hoveredTransform = Matrix4.identity()..scale(1.1);
    final transform = isHovered ? hoveredTransform : Matrix4.identity();

    return GestureDetector(
      onSecondaryTapDown: (TapDownDetails details) {
        _showContextMenu(context, details.globalPosition);
      },
      child: MouseRegion(
          onEnter: (event) => onEntered(true),
          onExit: (event) => onEntered(false),
          child: AnimatedContainer(
              duration: Duration(milliseconds: 200),
              transform: transform,
              child: widget.child)),
    );
  }

  onEntered(bool isHovered) => setState(() {
        this.isHovered = isHovered;
      });

  void _showContextMenu(BuildContext context, Offset position) async {
    final menu = await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy,
        position.dx,
        position.dy,
      ),
      items: [
        PopupMenuItem(
          value: 'Edit',
          child: Text('Edit'),
        ),
        PopupMenuItem(
          value: 'Delete',
          child: Text('Delete'),
        ),
      ],
    );

    if (menu == 'Edit') {
      widget.onEdit();
    } else if (menu == 'Delete') {
      widget.onDelete();
    }
  }
}
