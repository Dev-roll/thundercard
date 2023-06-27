import 'package:flutter/material.dart';

class PreviewImg extends StatefulWidget {
  const PreviewImg({
    super.key,
    required this.image,
  });
  final Widget image;

  @override
  State<PreviewImg> createState() => _PreviewImgState();
}

class _PreviewImgState extends State<PreviewImg> with TickerProviderStateMixin {
  final TransformationController _transformationController =
      TransformationController();
  Animation<Matrix4>? _animation;
  late final AnimationController _animationController;

  void _onAnimateInit() {
    _transformationController.value = _animation!.value;
    if (!_animationController.isAnimating) {
      _animation!.removeListener(_onAnimateInit);
      _animation = null;
      _animationController.reset();
    }
  }

  void _expandAnimation(double w, double h) {
    _animationController.reset();
    _animation = Matrix4Tween(
      begin: _transformationController.value,
      end: Matrix4(
        2,
        0,
        0,
        0,
        0,
        2,
        0,
        0,
        0,
        0,
        2,
        0,
        -w / 2,
        -h / 2,
        0,
        1,
      ),
    ).animate(_animationController);
    _animation!.addListener(_onAnimateInit);
    _animationController.forward();
  }

  void _shrinkAnimation() {
    _animationController.reset();
    _animation = Matrix4Tween(
      begin: _transformationController.value,
      end: Matrix4.identity(),
    ).animate(_animationController);
    _animation!.addListener(_onAnimateInit);
    _animationController.forward();
  }

// Stop a running animation.
  void _animateStop() {
    _animationController.stop();
    _animation?.removeListener(_onAnimateInit);
    _animation = null;
    _animationController.reset();
  }

  void _onInteractionStart(ScaleStartDetails details) {
    // If the user tries to cause a transformation while the animation is
    // running, cancel the animation.
    if (_animationController.status == AnimationStatus.forward) {
      _animateStop();
    }
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: InteractiveViewer(
                  minScale: 1,
                  maxScale: 4,
                  transformationController: _transformationController,
                  onInteractionStart: _onInteractionStart,
                  child: GestureDetector(
                    onDoubleTap: (() {
                      _transformationController.value == Matrix4.identity()
                          ? _expandAnimation(
                              MediaQuery.of(context).size.width,
                              MediaQuery.of(context).size.height,
                            )
                          : _shrinkAnimation();
                    }),
                    child: Hero(
                      tag: 'card_image',
                      child: widget.image,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(
                Icons.close_rounded,
                size: 32,
              ),
              padding: const EdgeInsets.all(12),
            ),
          ),
        ],
      ),
    );
  }
}
