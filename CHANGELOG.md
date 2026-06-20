# Changelog

All notable changes to the SNBDHost WHMCS theme will be documented in this file.

## [1.0.4] - 2026-06-20
### Fixed
- Fixed CAPTCHA validation rendering issue in `includes/captcha.tpl` causing login problems.
- Fixed WHMCS 8 dashboard layout compatibility for the top admin notice using Javascript injection instead of legacy hooks.
- Corrected database configuration keys so the addon module properly fetches the GitHub Repository data.

### Added
- Added a manual override form in the manager module to set custom dashboard bug notifications.
- Restricted the SNBDHost top banner notification to only display on the Admin Dashboard page (`index.php`), removing it from all other admin pages.

## [1.0.3] - 2026-06-20
### Added
- Added a top important notification section to the WHMCS Admin Dashboard.
- Dashboard now dynamically fetches the latest build SHA from GitHub and displays the last reported bug directly from the local theme audit logs.

## [1.0.2] - 2026-06-20
### Fixed
- Fixed template path resolution error in updater module that caused a 404 error during zip extraction.

### Added
- Split update buttons in the manager module to allow updating the theme and the module entirely separately.
- Overhauled the manager module UI to use beautiful SNBDHost branding colors and modern Bootstrap styling.

## [1.0.1] - 2026-06-20
### Added
- Added capability for the updater script to automatically update the manager addon module itself alongside the standard theme templates.

## [1.0.0] - 2026-06-15
### Added
- Initial release of the SNBDHost Portal Template.
- Custom login and checkout pages.
- Client area enhancements.
