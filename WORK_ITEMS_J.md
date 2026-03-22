# Agent J: Accessibility & Internationalization (i18n) - Work Items

**Branch**: `agent/j-accessibility-i18n`  
**Priority**: HIGH  
**Focus**: Multi-language support, WCAG 2.1 AA compliance, RTL support

## Completed ✅

- Configured Flutter i18n infrastructure with source-generated localizations
- Added English, Spanish, French, and German ARB resources under `lib/l10n/`
- Updated `lib/main.dart` to register localization delegates and supported locales
- Localized primary shell/navigation, profile, and library/permission strings
- Added `test/l10n_test.dart` and verified locale loading
- Validation passed: `flutter pub get`, `flutter test test/l10n_test.dart`, `flutter analyze`

## Backlog 📋

### Tier 1: Internationalization (i18n) Setup

- [x] Configure Flutter i18n infrastructure
  - [x] Add `intl` package to pubspec
  - [x] Create `lib/l10n/app_en.arb` (English baseline)
  - [x] Create `lib/l10n/app_es.arb` (Spanish)
  - [x] Create `lib/l10n/app_fr.arb` (French)
  - [x] Create `lib/l10n/app_de.arb` (German)
  - [x] Create generated localization delegates
  - [x] Update `lib/main.dart` to support locales
  - [x] Tests: `test/l10n_test.dart` (verify all languages load)

### Tier 2: String Extraction & Translation

- [ ] Extract all English strings from codebase
  - [ ] Home screen, Library, Now Playing, Settings, etc.
  - [ ] Use `AppLocalizations.of(context).label` pattern
  - [ ] Translate to Spanish, French, German
  - [ ] Add language selector in Settings screen

### Tier 3: RTL (Right-to-Left) Support

- [ ] Implement RTL layout flipping for Arabic/Hebrew
  - [ ] Use `Directionality` widget wrappers
  - [ ] Test horizontal padding/margins (should flip automatically)
  - [ ] Test icon positioning (should mirror)
  - [ ] Add RTL test coverage

### Tier 4: WCAG 2.1 AA Compliance

- [ ] Audit contrast ratios
  - [ ] Text/background: minimum 4.5:1 for normal text
  - [ ] UI components: minimum 3:1 for borders/icons
  - [ ] Use `flutter_contrast_checker` or manual tools
  - [ ] Adjust theme colors if needed

- [ ] Semantic Labels & Screen Readers
  - [ ] Add `Semantics` widgets to all interactive elements
  - [ ] Label buttons, icons, and images
  - [ ] Use `GestureDetector` with semantic intent
  - [ ] Test with TalkBack (Android) and VoiceOver (iOS)

- [ ] Navigation & Focus Management
  - [ ] Tab order follows visual hierarchy
  - [ ] Focus visible on all interactive elements
  - [ ] Add `FocusNode` and `FocusScope` where needed
  - [ ] Test keyboard navigation (Tab to cycle through controls)

- [ ] Font Scaling
  - [ ] Test text at 200% size (large text user preference)
  - [ ] Ensure layout doesn't break with scaled fonts
  - [ ] Use relative font sizes, not fixed pixels

### Tier 5: High-Contrast Theme

- [ ] Create high-contrast color variant
  - [ ] Update `lib/theme/app_theme.dart`
  - [ ] Add `AppTheme.highContrast()` builder
  - [ ] Increase all contrast ratios to 7:1+
  - [ ] Add toggle in Settings

### Tier 6: Testing & Validation

- [ ] Automated accessibility testing
  - [ ] Use `semantics_testing` or similar package
  - [ ] Run contrast and label checks
  - [ ] Generate accessibility report

- [ ] Manual testing checklist
  - [ ] TalkBack: navigate all screens, verify labels
  - [ ] VoiceOver (iOS): navigate all screens
  - [ ] Keyboard only: navigate and control entire app
  - [ ] 200% text scaling: no layout breaks
  - [ ] High-contrast mode: all text readable

## Testing Checklist

- [x] Unit tests for localization (all languages load)
- [ ] Widget tests for RTL layout in key screens
- [ ] Contrast ratio checks pass (automated + manual)
- [ ] Semantics tests for screen reader compatibility
- [ ] Integration test: switch languages, verify UI updates
- [ ] Manual accessibility audit (TalkBack + keyboard)
- [x] Analyzer: `flutter analyze` clean
- [x] Tests: `flutter test` all pass

## File Changes Summary

| File                               | Change | Reason                                                  |
| ---------------------------------- | ------ | ------------------------------------------------------- |
| `lib/l10n/app_*.arb`               | NEW    | i18n resources                                          |
| `l10n.yaml`                        | NEW    | Flutter source-generated l10n config                    |
| `lib/main.dart`                    | MODIFY | Add localization delegates                              |
| `lib/screens/library_screen.dart`  | MODIFY | Use AppLocalizations for library and permission strings |
| `lib/screens/profile_screen.dart`  | MODIFY | Use AppLocalizations for profile strings                |
| `lib/widgets/glass_nav_bar.dart`   | MODIFY | Localize primary navigation labels                      |
| `lib/theme/app_theme.dart`         | MODIFY | Add high-contrast theme                                 |
| `lib/screens/settings_screen.dart` | MODIFY | Add language selector                                   |
| `test/l10n_test.dart`              | NEW    | i18n tests                                              |
| `test/accessibility/`              | NEW    | A11y test suite                                         |

## Merge Criteria

Before submitting PR to `sprint/current`:

- ✅ Analyzer clean
- ✅ All tests passing
- ✅ All UI strings localized (no hardcoded English)
- ✅ RTL layout tested (all screens mirror correctly)
- ✅ Contrast ratios verified (4.5:1 text, 3:1 components)
- ✅ Screen reader compatible (TalkBack/VoiceOver tested)
- ✅ Keyboard navigation works end-to-end
- ✅ 200% text scaling doesn't break layouts
- ✅ Manual device test with accessibility tools enabled
- ✅ Commit message: `feat(a11y): add i18n, RTL, and WCAG 2.1 AA compliance`

## Notes

This is a high-impact feature that significantly expands addressable market:

- Enables use in non-English markets (EU, Latin America, Middle East)
- Required for many enterprise/institutional deployments
- Shows commitment to inclusive design
- Improves app ratings in accessibility reviews
