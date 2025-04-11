// lib/screens/enhanced_bellabot_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:robot_display_v2/features/bella_bot_face_animation/bella_bot_providers.dart'
    show eyePupilPositionProvider;
import 'package:robot_display_v2/features/updated_bella_bot_face_v2/enhance_bella_bot_face_widget.dart';
import 'package:robot_display_v2/features/updated_bella_bot_face_v2/enhanced_background.dart';
import 'package:robot_display_v2/features/updated_bella_bot_face_v2/enhanced_bella_bot_face_modal.dart';
import 'package:robot_display_v2/features/updated_bella_bot_face_v2/enhanced_expression_factory.dart';
import 'package:robot_display_v2/features/updated_bella_bot_face_v2/enhanced_provider.dart';

class EnhancedBellaBotScreen extends ConsumerWidget {
  const EnhancedBellaBotScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeData = ref.watch(themeDataProvider);
    final currentTheme = ref.watch(robotThemeProvider);
    final currentSkin = ref.watch(characterSkinProvider);
    final currentAccessory = ref.watch(accessoryProvider);

    return Scaffold(
      backgroundColor:
          Colors.transparent, // Background handled by EnhancedBackground
      appBar: AppBar(
        title: const Text('BellaBot Face'),
        backgroundColor: themeData.backgroundColor.withOpacity(0.9),
        elevation: 0,
        actions: [
          // Settings button
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              _showSettingsPanel(context, ref);
            },
          ),
        ],
      ),
      body: EnhancedBackground(
        child: SafeArea(
          child: Column(
            children: [
              // Face takes most of the screen
              Expanded(
                flex: 3,
                child: GestureDetector(
                  // Face follows touch position
                  onPanUpdate: (details) {
                    _updateEyePosition(details.localPosition, context, ref);
                  },
                  onTapDown: (details) {
                    _updateEyePosition(details.localPosition, context, ref);
                  },
                  child: const Center(child: EnhancedBellaBotFace()),
                ),
              ),

              // Controls at bottom
              Expanded(flex: 1, child: _buildExpressionControls(ref)),
            ],
          ),
        ),
      ),
    );
  }

  void _updateEyePosition(
    Offset position,
    BuildContext context,
    WidgetRef ref,
  ) {
    // Convert touch position to normalized eye position
    final screenSize = MediaQuery.of(context).size;
    final normalizedPosition = Offset(
      (position.dx / screenSize.width) * 16 - 8,
      (position.dy / screenSize.height) * 16 - 8,
    );

    // Update the eye position
    ref.read(eyePupilPositionProvider.notifier).state = normalizedPosition;
  }

  Widget _buildExpressionControls(WidgetRef ref) {
    final currentExpression = ref.watch(bellaBotExpressionProvider).type;

    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const Text(
            'Facial Expressions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                // Primary expressions
                _buildExpressionColumn(ref, [
                  ExpressionType.neutral,
                  ExpressionType.happy,
                  ExpressionType.sad,
                ], 'Basic'),

                _buildExpressionColumn(ref, [
                  ExpressionType.angry,
                  ExpressionType.surprised,
                  ExpressionType.confused,
                ], 'Reactions'),

                _buildExpressionColumn(ref, [
                  ExpressionType.wink,
                  ExpressionType.loving,
                  ExpressionType.blushing,
                ], 'Playful'),

                _buildExpressionColumn(ref, [
                  ExpressionType.excited,
                  ExpressionType.thinking,
                  ExpressionType.sleepy,
                ], 'Mood'),

                _buildExpressionColumn(ref, [
                  ExpressionType.listening,
                  ExpressionType.processing,
                ], 'Activity'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpressionColumn(
    WidgetRef ref,
    List<ExpressionType> expressions,
    String title,
  ) {
    final currentExpression = ref.watch(bellaBotExpressionProvider).type;
    final themeData = ref.watch(themeDataProvider);

    return Container(
      width: 100,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              color: themeData.accentColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: expressions.length,
              itemBuilder: (context, index) {
                final expression = expressions[index];
                final isSelected = currentExpression == expression;

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: ElevatedButton(
                    onPressed: () {
                      ref
                          .read(bellaBotExpressionProvider.notifier)
                          .setExpression(expression);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isSelected
                              ? themeData.accentColor
                              : themeData.backgroundColor.withOpacity(0.7),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 8.0,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: isSelected ? 4 : 1,
                    ),
                    child: Text(
                      _expressionToDisplayName(expression),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showSettingsPanel(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.read(robotThemeProvider);
    final currentSkin = ref.read(characterSkinProvider);
    final currentAccessory = ref.read(accessoryProvider);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Customize Your BellaBot',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Theme selection
                  const Text(
                    'Theme',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children:
                          RobotTheme.values.map((theme) {
                            final isSelected = theme == currentTheme;
                            final themeData = ExpressionFactory().getThemeData(
                              theme,
                            );

                            return GestureDetector(
                              onTap: () {
                                ref.read(robotThemeProvider.notifier).state =
                                    theme;
                                setState(() {});

                                // Update background colors
                                ref.read(backgroundProvider.notifier).state =
                                    themeData.backgroundGradient;

                                // Update expression with new theme
                                ref
                                    .read(bellaBotExpressionProvider.notifier)
                                    .updateTheme(theme);
                              },
                              child: Container(
                                margin: const EdgeInsets.only(
                                  right: 10,
                                  top: 8,
                                  bottom: 8,
                                ),
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color:
                                        isSelected
                                            ? themeData.accentColor
                                            : Colors.transparent,
                                    width: 2,
                                  ),
                                ),
                                child: Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: themeData.backgroundGradient,
                                    ),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.palette,
                                      color: themeData.accentColor,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Character skin selection
                  const Text(
                    'Character',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children:
                          CharacterSkin.values.map((skin) {
                            final isSelected = skin == currentSkin;

                            return GestureDetector(
                              onTap: () {
                                ref.read(characterSkinProvider.notifier).state =
                                    skin;
                                setState(() {});

                                // Update expression with new skin
                                ref
                                    .read(bellaBotExpressionProvider.notifier)
                                    .updateSkin(skin);
                              },
                              child: Container(
                                margin: const EdgeInsets.only(
                                  right: 10,
                                  top: 8,
                                  bottom: 8,
                                ),
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color:
                                        isSelected
                                            ? Colors.amber
                                            : Colors.transparent,
                                    width: 2,
                                  ),
                                ),
                                child: Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: _getSkinColor(skin),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      _getSkinIcon(skin),
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Accessory selection
                  const Text(
                    'Accessories',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children:
                          AccessoryType.values.map((accessory) {
                            final isSelected = accessory == currentAccessory;

                            return GestureDetector(
                              onTap: () {
                                ref.read(accessoryProvider.notifier).state =
                                    accessory;
                                setState(() {});

                                // Update expression with new accessory
                                ref
                                    .read(bellaBotExpressionProvider.notifier)
                                    .updateAccessory(accessory);
                              },
                              child: Container(
                                margin: const EdgeInsets.only(
                                  right: 10,
                                  top: 8,
                                  bottom: 8,
                                ),
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color:
                                        isSelected
                                            ? Colors.white
                                            : Colors.transparent,
                                    width: 2,
                                  ),
                                ),
                                child: Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.grey.shade800,
                                  ),
                                  child: Center(
                                    child: Icon(
                                      _getAccessoryIcon(accessory),
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Animation controls
                  const Text(
                    'Animations',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildAnimationToggle(
                        'Floating',
                        Icons.waves,
                        ref.watch(animationStateProvider).isFloating,
                        (value) {
                          ref
                              .read(animationStateProvider.notifier)
                              .toggleFloating(value);
                        },
                      ),
                      _buildAnimationToggle(
                        'Bouncing',
                        Icons.height,
                        ref.watch(animationStateProvider).isBouncing,
                        (value) {
                          ref
                              .read(animationStateProvider.notifier)
                              .toggleBouncing(value);
                        },
                      ),
                      _buildAnimationToggle(
                        'Glowing',
                        Icons.lightbulb_outline,
                        ref.watch(animationStateProvider).isGlowing,
                        (value) {
                          ref
                              .read(animationStateProvider.notifier)
                              .toggleGlowing(value);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildAnimationToggle(
    String label,
    IconData icon,
    bool value,
    Function(bool) onChanged,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white, size: 20),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
        Switch(value: value, onChanged: onChanged, activeColor: Colors.cyan),
      ],
    );
  }

  IconData _getSkinIcon(CharacterSkin skin) {
    switch (skin) {
      case CharacterSkin.robot:
        return Icons.smart_toy;
      case CharacterSkin.cat:
        return Icons.pets;
      case CharacterSkin.dog:
        return Icons.emoji_nature;
      case CharacterSkin.alien:
        return Icons.auto_awesome;
      case CharacterSkin.panda:
        return Icons.face;
      case CharacterSkin.underwater:
        return Icons.water;
      case CharacterSkin.space:
        return Icons.stars;
      default:
        return Icons.smart_toy;
    }
  }

  Color _getSkinColor(CharacterSkin skin) {
    switch (skin) {
      case CharacterSkin.robot:
        return Colors.blueGrey;
      case CharacterSkin.cat:
        return Colors.amber.shade700;
      case CharacterSkin.dog:
        return Colors.brown.shade600;
      case CharacterSkin.alien:
        return Colors.green.shade700;
      case CharacterSkin.panda:
        return Colors.grey.shade800;
      case CharacterSkin.underwater:
        return Colors.blue.shade700;
      case CharacterSkin.space:
        return Colors.deepPurple;
      default:
        return Colors.blueGrey;
    }
  }

  IconData _getAccessoryIcon(AccessoryType accessory) {
    switch (accessory) {
      case AccessoryType.none:
        return Icons.not_interested;
      case AccessoryType.glasses:
        return Icons.visibility;
      case AccessoryType.hat:
        return Icons.face;
      case AccessoryType.bowtie:
        return Icons.architecture;
      case AccessoryType.headphones:
        return Icons.headphones;
      case AccessoryType.crown:
        return Icons.auto_awesome;
      case AccessoryType.flower:
        return Icons.local_florist;
      case AccessoryType.antenna:
        return Icons.settings_input_antenna;
      case AccessoryType.bandana:
        return Icons.face_retouching_natural;
      default:
        return Icons.not_interested;
    }
  }

  String _expressionToDisplayName(ExpressionType expression) {
    switch (expression) {
      case ExpressionType.happy:
        return 'Happy';
      case ExpressionType.sad:
        return 'Sad';
      case ExpressionType.angry:
        return 'Angry';
      case ExpressionType.surprised:
        return 'Surprised';
      case ExpressionType.wink:
        return 'Wink';
      case ExpressionType.neutral:
        return 'Neutral';
      case ExpressionType.blushing:
        return 'Blushing';
      case ExpressionType.sleepy:
        return 'Sleepy';
      case ExpressionType.thinking:
        return 'Thinking';
      case ExpressionType.loving:
        return 'Loving';
      case ExpressionType.confused:
        return 'Confused';
      case ExpressionType.excited:
        return 'Excited';
      case ExpressionType.scared:
        return 'Scared';
      case ExpressionType.laughing:
        return 'Laughing';
      case ExpressionType.listening:
        return 'Listening';
      case ExpressionType.processing:
        return 'Processing';
      default:
        return expression.toString().split('.').last;
    }
  }
}
