import 'package:flutter/material.dart';
import '../utils/assets.dart';
import '../utils/platform_utils.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback? onInitializationComplete;
  
  const SplashScreen({
    Key? key,
    this.onInitializationComplete,
  }) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startInitialization();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 0.8, curve: Curves.elasticOut),
    ));

    _animationController.forward();
  }

  Future<void> _startInitialization() async {
    // Wait for animation to complete
    await _animationController.forward();
    
    // Add a small delay for better UX
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Perform any initialization tasks here
    await _performInitialization();
    
    // Callback when initialization is complete
    widget.onInitializationComplete?.call();
  }

  Future<void> _performInitialization() async {
    // Initialize platform-specific settings
    await _initializePlatformSettings();
    
    // Initialize app services
    await _initializeServices();
    
    // Load user preferences
    await _loadUserPreferences();
  }

  Future<void> _initializePlatformSettings() async {
    try {
      final deviceType = await PlatformUtils.deviceType;
      print('Running on: $deviceType');
      
      if (await PlatformUtils.isAndroidTV || await PlatformUtils.isAppleTV) {
        // TV-specific initialization
        print('TV platform detected - applying TV settings');
      } else {
        // Mobile-specific initialization
        print('Mobile platform detected - applying mobile settings');
      }
    } catch (e) {
      print('Error initializing platform settings: $e');
    }
  }

  Future<void> _initializeServices() async {
    // Initialize your services here
    // Example: Database, Network services, etc.
    await Future.delayed(const Duration(milliseconds: 300));
  }

  Future<void> _loadUserPreferences() async {
    // Load user preferences from SharedPreferences
    await Future.delayed(const Duration(milliseconds: 200));
  }

  Future<bool> _checkIfTV() async {
    final isAndroidTV = await PlatformUtils.isAndroidTV;
    final isAppleTV = await PlatformUtils.isAppleTV;
    return isAndroidTV || isAppleTV;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _getBackgroundColor(),
      body: FutureBuilder<bool>(
        future: _checkIfTV(),
        builder: (context, snapshot) {
          final isTV = snapshot.data ?? false;
          
          return Container(
            decoration: _getBackgroundDecoration(),
            child: SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo Section
                    AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _scaleAnimation.value,
                          child: FadeTransition(
                            opacity: _fadeAnimation,
                            child: _buildLogo(isTV),
                          ),
                        );
                      },
                    ),
                    
                    SizedBox(height: isTV ? 48 : 32),
                    
                    // App Name
                    AnimatedBuilder(
                      animation: _fadeAnimation,
                      builder: (context, child) {
                        return FadeTransition(
                          opacity: _fadeAnimation,
                          child: Text(
                            'Streamify',
                            style: TextStyle(
                              fontSize: isTV ? 48 : 32,
                              fontWeight: FontWeight.bold,
                              fontFamily: Assets.roboto,
                              color: Colors.white,
                              letterSpacing: 2.0,
                            ),
                          ),
                        );
                      },
                    ),
                    
                    SizedBox(height: isTV ? 24 : 16),
                    
                    // Subtitle
                    AnimatedBuilder(
                      animation: _fadeAnimation,
                      builder: (context, child) {
                        return FadeTransition(
                          opacity: _fadeAnimation,
                          child: Text(
                            'Premium IPTV Player',
                            style: TextStyle(
                              fontSize: isTV ? 24 : 16,
                              fontFamily: Assets.roboto,
                              color: Colors.white70,
                              letterSpacing: 1.0,
                            ),
                          ),
                        );
                      },
                    ),
                    
                    SizedBox(height: isTV ? 80 : 60),
                    
                    // Loading Indicator
                    AnimatedBuilder(
                      animation: _fadeAnimation,
                      builder: (context, child) {
                        return FadeTransition(
                          opacity: _fadeAnimation,
                          child: SizedBox(
                            width: isTV ? 60 : 40,
                            height: isTV ? 60 : 40,
                            child: CircularProgressIndicator(
                              strokeWidth: isTV ? 4 : 3,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Color _getBackgroundColor() {
    return const Color(0xFF1A1A1A); // Dark background
  }

  BoxDecoration _getBackgroundDecoration() {
    return BoxDecoration(
      image: DecorationImage(
        image: AssetImage(Assets.splashScreen),
        fit: BoxFit.cover,
        colorFilter: ColorFilter.mode(
          Colors.black.withValues(alpha: 0.3),
          BlendMode.darken,
        ),
      ),
    );
  }

  Widget _buildLogo(bool isTV) {
    final logoSize = isTV ? 200.0 : 120.0;
    
    // Try to load custom logo first, fallback to default
    return Container(
      width: logoSize,
      height: logoSize,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(isTV ? 24 : 16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(isTV ? 24 : 16),
        child: _buildLogoImage(logoSize),
      ),
    );
  }

  Widget _buildLogoImage(double size) {
    // Try to load splash logo, fallback to app logo, then to default icon
    return Image.asset(
      Assets.splashLogo,
      width: size,
      height: size,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Image.asset(
          Assets.appLogo,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            // Fallback to default icon with app colors
            return Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).primaryColor,
                    Theme.of(context).primaryColor.withValues(alpha: 0.7),
                  ],
                ),
              ),
              child: Icon(
                Icons.play_circle_filled,
                size: size * 0.6,
                color: Colors.white,
              ),
            );
          },
        );
      },
    );
  }
}
