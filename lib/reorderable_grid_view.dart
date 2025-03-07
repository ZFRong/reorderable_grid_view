import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:reorderable_grid_view_header/src/reorderable_wrapper_widget.dart';
import 'package:reorderable_grid_view_header/src/reorderable_item.dart';

export 'src/reorderable_sliver_grid_view.dart' show ReorderableSliverGridView;
export 'src/reorderable_wrapper_widget.dart' show ReorderableWrapperWidget;
export 'src/reorderable_item.dart' show ReorderableItemView;

/// Build the drag widget under finger when dragging.
/// The index here represents the index of current dragging widget
/// The child here represents the current index widget
typedef DragWidgetBuilder = Widget Function(int index, Widget child);

/// Control the scroll speed if drag over the boundary.
/// We can pass time here??
/// [timeInMilliSecond] is the time passed.
/// [overPercentage] is the scroll over the boundary percentage
/// [overSize] is the pixel drag over the boundary
/// [itemSize] is the drag item size
/// Maybe you need decide the scroll speed by the given param.
/// return how many pixels when scroll in 14ms(maybe a frame). 5 is the default
typedef ScrollSpeedController = double Function(
    int timeInMilliSecond, double overSize, double itemSize);

/// build the target placeholder
typedef PlaceholderBuilder = Widget Function(
    int dropIndex, int dropInddex, Widget dragWidget);

/// The drag and drop life cycle.
typedef OnDragStart = void Function(int dragIndex);

/// Usage:
/// ```
/// ReorderableGridView(
///   crossAxisCount: 3,
///   children: this.data.map((e) => buildItem("$e")).toList(),
///   onReorder: (oldIndex, newIndex) {
///     setState(() {
///       final element = data.removeAt(oldIndex);
///       data.insert(newIndex, element);
///     });
///   },
/// )
///```
/// I think it's borrowing to pass those params.
/// Will it to hard to calculate the position by delegator? not by crossAxis
/// and spacing?
/// And the SliverGridDelete need an constraint to get a layout but, I don't have the
/// constraint, and that method look called by the framework.
/// So I need the crossAxisCount, spacing to determine the pos.
class ReorderableGridView extends StatelessWidget {
  final List<Widget>? header;
  final List<Widget>? footer;
  final ReorderCallback onReorder;
  final DragWidgetBuilder? dragWidgetBuilder;
  final ScrollSpeedController? scrollSpeedController;
  final PlaceholderBuilder? placeholderBuilder;
  final OnDragStart? onDragStart;

  final bool? primary;
  final bool shrinkWrap;
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics? physics;
  final bool reverse;
  final double? cacheExtent;
  final int? semanticChildCount;

  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;
  final Clip clipBehavior;
  final String? restorationId;

  final SliverChildDelegate childrenDelegate;

  final SliverGridDelegate gridDelegate;
  final ScrollController? controller;
  final DragStartBehavior dragStartBehavior;

  ReorderableGridView.builder({
    Key? key,
    required ReorderCallback onReorder,
    ScrollSpeedController? scrollSpeedController,
    DragWidgetBuilder? dragWidgetBuilder,
    PlaceholderBuilder? placeholderBuilder,
    OnDragStart? onDragStart,
    List<Widget>? header,
    List<Widget>? footer,
    bool reverse = false,
    ScrollController? controller,
    bool? primary,
    ScrollPhysics? physics,
    bool shrinkWrap = false,
    EdgeInsetsGeometry? padding,
    required SliverGridDelegate gridDelegate,
    required IndexedWidgetBuilder itemBuilder,
    int? itemCount,
    bool addAutomaticKeepAlives = true,
    bool addRepaintBoundaries = true,
    bool addSemanticIndexes = true,
    double? cacheExtent,
    int? semanticChildCount,
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
    ScrollViewKeyboardDismissBehavior keyboardDismissBehavior =
        ScrollViewKeyboardDismissBehavior.manual,
    String? restorationId,
    Clip clipBehavior = Clip.hardEdge,
  }) : this(
          key: key,
          onReorder: onReorder,
          dragWidgetBuilder: dragWidgetBuilder,
          scrollSpeedController: scrollSpeedController,
          placeholderBuilder: placeholderBuilder,
          onDragStart: onDragStart,
          header: header,
          footer: footer,

          // how to determine the
          childrenDelegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              Widget child = itemBuilder(context, index);
              return ReorderableItemView(
                  child: child, key: child.key!, index: index);
            },
            childCount: itemCount,
            addAutomaticKeepAlives: addAutomaticKeepAlives,
            addRepaintBoundaries: addRepaintBoundaries,
            addSemanticIndexes: addSemanticIndexes,
          ),

          gridDelegate: gridDelegate,
          reverse: reverse,
          controller: controller,
          primary: primary,
          physics: physics,
          shrinkWrap: shrinkWrap,
          padding: padding,
          cacheExtent: cacheExtent,
          semanticChildCount: semanticChildCount ?? itemCount,
          dragStartBehavior: dragStartBehavior,
          keyboardDismissBehavior: keyboardDismissBehavior,
          restorationId: restorationId,
          clipBehavior: clipBehavior,
        );

  ReorderableGridView.count({
    Key? key,
    required ReorderCallback onReorder,
    DragWidgetBuilder? dragWidgetBuilder,
    ScrollSpeedController? scrollSpeedController,
    PlaceholderBuilder? placeholderBuilder,
    OnDragStart? onDragStart,
    List<Widget>? header,
    List<Widget>? footer,
    double mainAxisSpacing = 0.0,
    double crossAxisSpacing = 0.0,
    double childAspectRatio = 1.0,
    bool reverse = false,
    ScrollController? controller,
    bool? primary,
    ScrollPhysics? physics,
    bool shrinkWrap = false,
    EdgeInsetsGeometry? padding,
    required int crossAxisCount,
    bool addAutomaticKeepAlives = true,
    bool addRepaintBoundaries = true,
    bool addSemanticIndexes = true,
    double? cacheExtent,
    List<Widget> children = const <Widget>[],
    int? semanticChildCount,
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
    ScrollViewKeyboardDismissBehavior keyboardDismissBehavior =
        ScrollViewKeyboardDismissBehavior.manual,
    String? restorationId,
    Clip clipBehavior = Clip.hardEdge,
  }) : this(
          key: key,
          onReorder: onReorder,
          dragWidgetBuilder: dragWidgetBuilder,
          scrollSpeedController: scrollSpeedController,
          placeholderBuilder: placeholderBuilder,
          onDragStart: onDragStart,
          header: header,
          footer: footer,
          childrenDelegate: SliverChildListDelegate(
            ReorderableItemView.wrapMeList(children, header, footer),
            addAutomaticKeepAlives: addAutomaticKeepAlives,
            addRepaintBoundaries: addRepaintBoundaries,
            addSemanticIndexes: addSemanticIndexes,
          ),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: mainAxisSpacing,
            crossAxisSpacing: crossAxisSpacing,
            childAspectRatio: childAspectRatio,
          ),
          reverse: reverse,
          controller: controller,
          primary: primary,
          physics: physics,
          shrinkWrap: shrinkWrap,
          padding: padding,
          cacheExtent: cacheExtent,
          semanticChildCount: semanticChildCount ?? children.length,
          dragStartBehavior: dragStartBehavior,
          keyboardDismissBehavior: keyboardDismissBehavior,
          restorationId: restorationId,
          clipBehavior: clipBehavior,
        );

  ReorderableGridView({
    Key? key,
    required this.onReorder,
    this.dragWidgetBuilder,
    this.scrollSpeedController,
    this.placeholderBuilder,
    this.header,
    this.footer,
    this.onDragStart,
    required this.gridDelegate,
    required this.childrenDelegate,
    this.reverse = false,
    this.primary,
    this.physics,
    this.shrinkWrap = false,
    this.padding,
    this.cacheExtent,
    this.semanticChildCount,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    this.restorationId,
    this.clipBehavior = Clip.hardEdge,
    this.controller,
    this.dragStartBehavior = DragStartBehavior.start,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ReorderableWrapperWidget(
      child: GridView.custom(
        key: key,
        gridDelegate: gridDelegate,
        childrenDelegate: childrenDelegate,
        controller: controller,
        reverse: reverse,
        primary: primary,
        physics: physics,
        shrinkWrap: shrinkWrap,
        padding: padding,
        cacheExtent: cacheExtent,
        semanticChildCount: semanticChildCount,
        keyboardDismissBehavior: keyboardDismissBehavior,
        restorationId: restorationId,
        clipBehavior: clipBehavior,
        dragStartBehavior: dragStartBehavior,
      ),
      onReorder: onReorder,
      dragWidgetBuilder: dragWidgetBuilder,
      scrollSpeedController: scrollSpeedController,
      placeholderBuilder: placeholderBuilder,
      onDragStart: onDragStart,
    );
  }
}
