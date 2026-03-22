# Agent G: Audio Effects & Equalizer - Work Items

**Branch**: `agent/g-audio-effects`  
**Priority**: MEDIUM  
**Focus**: Equalizer, audio profiles, DSP effects  

## Completed ✅

None yet (just starting)

## Backlog 📋

### Tier 1: Audio Effects Service
- [ ] Create `lib/services/audio_effects_service.dart`
  - [ ] `EqualizerPreset` model with 5-band controls (20Hz, 1kHz, 4kHz, 8kHz, 16kHz)
  - [ ] Presets: Normal, Bass Boost, Treble Boost, Vocal Clarity, Custom
  - [ ] Apply EQ values to just_audio via audio processing pipeline
  - [ ] Persist active preset + custom values to SharedPreferences
  - [ ] Tests: `test/services/audio_effects_service_test.dart`

### Tier 2: Now Playing EQ UI
- [ ] Update `lib/screens/now_playing_screen.dart`
  - [ ] Add EQ icon button in control bar (opens EQ panel)
  - [ ] Show current preset name
  - [ ] Display frequency bands + sliders (±12dB range)
  - [ ] Preset quick-select buttons (Normal, Bass, Treble, etc.)
  - [ ] Real-time audio preview as sliders move
  - [ ] "Reset to Normal" button

### Tier 3: Settings & Profiles Screen
- [ ] Create `lib/screens/settings_screen.dart`
  - [ ] Full EQ interface with all presets
  - [ ] Save custom profile with custom name
  - [ ] Delete custom profiles
  - [ ] Show list of all saved profiles (system + user-created)
  - [ ] Reorder presets (drag to prioritize)

### Tier 4: Audio Pipeline Integration
- [ ] Test EQ application with just_audio
  - [ ] Verify audio processing works across different formats (MP3, FLAC, etc.)
  - [ ] Measure CPU impact of EQ processing
  - [ ] Test on low-end devices (ensure no stuttering)
  - [ ] Test preset switching (should be seamless, no clicks/pops)

## Testing Checklist

- [ ] Unit tests for `EqualizerPreset` and preset switching
- [ ] Widget test for EQ UI sliders and preset buttons
- [ ] Integration test: switch presets, verify audio change
- [ ] Device test: listen to different genres with different presets
- [ ] Analyzer: `flutter analyze` clean
- [ ] Tests: `flutter test` all pass

## File Changes Summary

| File | Change | Reason |
|------|--------|--------|
| `lib/services/audio_effects_service.dart` | NEW | EQ logic and state |
| `lib/screens/now_playing_screen.dart` | MODIFY | Add EQ panel |
| `lib/screens/settings_screen.dart` | NEW | Full settings UI |
| `test/services/audio_effects_service_test.dart` | NEW | EQ service tests |

## Merge Criteria

Before submitting PR to `sprint/current`:
- ✅ Analyzer clean
- ✅ All tests passing
- ✅ EQ presets switch smoothly in real-time
- ✅ No audio artifacts (clicks, pops, distortion)
- ✅ Manual device test: switch presets while playing
- ✅ Commit message: `feat(audio): add equalizer and audio effects`
