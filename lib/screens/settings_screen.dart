import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/audio_effects_service.dart';
import '../theme/app_theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final AudioEffectsService _eq = AudioEffectsService.instance;

  @override
  void initState() {
    super.initState();
    _eq.addListener(_onUpdate);
  }

  @override
  void dispose() {
    _eq.removeListener(_onUpdate);
    super.dispose();
  }

  void _onUpdate() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final bands = _eq.activeBands;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: AppColors.background,
            surfaceTintColor: Colors.transparent,
            pinned: true,
            expandedHeight: 100,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              color: AppColors.onSurface,
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.fromLTRB(20, 0, 0, 16),
              title: Text(
                'Settings',
                style: GoogleFonts.epilogue(
                  fontWeight: FontWeight.w900,
                  fontSize: 22,
                  color: AppColors.onSurface,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SectionHeader(label: 'Audio Effects'),
                // Enable toggle
                _Tile(
                  leading: const Icon(Icons.equalizer_rounded, color: AppColors.primary),
                  title: 'Equalizer',
                  subtitle: _eq.isEnabled ? 'Active — ${_eq.activePreset.name}' : 'Disabled',
                  trailing: Switch.adaptive(
                    value: _eq.isEnabled,
                    onChanged: _eq.setEnabled,
                    activeThumbColor: AppColors.primary,
                  activeTrackColor: AppColors.primary.withValues(alpha: 0.5),
                  ),
                ),
                const SizedBox(height: 8),
                // Preset selection
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Preset',
                    style: GoogleFonts.manrope(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 38,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: kBuiltinPresets.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (_, i) {
                      final preset = kBuiltinPresets[i];
                      final selected = _eq.activePresetId == preset.id;
                      return ChoiceChip(
                        label: Text(preset.name),
                        selected: selected,
                        onSelected: _eq.isEnabled ? (_) => _eq.selectPreset(preset.id) : null,
                        selectedColor: AppColors.primary,
                        backgroundColor: AppColors.surfaceContainerHighest,
                        disabledColor: AppColors.surfaceContainerHighest.withValues(alpha: 0.5),
                        labelStyle: GoogleFonts.manrope(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: selected ? AppColors.onPrimary : AppColors.onSurfaceVariant,
                        ),
                        side: BorderSide.none,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(999),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
                // Band sliders
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Custom EQ',
                    style: GoogleFonts.manrope(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: List.generate(5, (i) {
                      final gain = bands.gains[i];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 54,
                              child: Text(
                                kEqBandLabels[i],
                                style: GoogleFonts.manrope(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.onSurfaceVariant,
                                ),
                              ),
                            ),
                            Expanded(
                              child: SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  trackHeight: 4,
                                  thumbShape: const RoundSliderThumbShape(
                                      enabledThumbRadius: 8),
                                  activeTrackColor: AppColors.primary,
                                  inactiveTrackColor:
                                      AppColors.outlineVariant.withValues(alpha: 0.4),
                                ),
                                child: Slider(
                                  value: gain.clamp(-12.0, 12.0),
                                  min: -12,
                                  max: 12,
                                  divisions: 24,
                                  label: gain >= 0
                                      ? '+${gain.round()} dB'
                                      : '${gain.round()} dB',
                                  onChanged: _eq.isEnabled
                                      ? (v) => _eq.setCustomBand(i, v)
                                      : null,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 44,
                              child: Text(
                                gain >= 0
                                    ? '+${gain.round()}'
                                    : '${gain.round()}',
                                textAlign: TextAlign.end,
                                style: GoogleFonts.manrope(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: gain.abs() > 0.5
                                      ? AppColors.primary
                                      : AppColors.onSurfaceVariant,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextButton.icon(
                    onPressed: _eq.resetToFlat,
                    icon: const Icon(Icons.refresh_rounded, size: 16),
                    label: Text(
                      'Reset to Flat',
                      style: GoogleFonts.manrope(
                          fontSize: 13, fontWeight: FontWeight.w700),
                    ),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.onSurfaceVariant,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Helpers ──────────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
      child: Text(
        label.toUpperCase(),
        style: GoogleFonts.manrope(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.2,
          color: AppColors.primary,
        ),
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({
    required this.leading,
    required this.title,
    required this.subtitle,
    required this.trailing,
  });

  final Widget leading;
  final String title;
  final String subtitle;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      leading: leading,
      title: Text(
        title,
        style: GoogleFonts.manrope(
          fontWeight: FontWeight.w700,
          fontSize: 15,
          color: AppColors.onSurface,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.manrope(
          fontSize: 12,
          color: AppColors.onSurfaceVariant,
        ),
      ),
      trailing: trailing,
    );
  }
}
