# Jess Change Log

All notable changes to this project will be documented in this file.

Jess is in a pre-1.0 state. This means that its APIs and behavior are subject to breaking changes without deprecation notices. Until 1.0, version numbers will follow a [Semver][]-ish `0.y.z` format, where `y` is incremented when new features or breaking changes are introduced, and `z` is incremented for lesser changes or bug fixes.

## [Unreleased][]

* Your contribution here!

## [0.6.0][] (2018-04-12)

* Log more detailed stack trace when an HTTP error occurs

## [0.5.0][] (2018-03-18)

* `to_s` now produces the same output as `inspect` for `Computer` and `MobileDevice`

## [0.4.0][] (2018-01-03)

* `extension_attributes` now responds to `_json` like other objects

## [0.3.0][] (2017-03-17)

* Add `computers.all_ids` and `mobile_devices.all_ids`

## [0.2.0][] (2017-01-21)

* Improved support for using jess in irb with `awesome_print` by implementing `to_hash` on resources

## 0.1.0 (2016-10-03)

* Initial release

[Semver]: http://semver.org
[Unreleased]: https://github.com/mattbrictson/jess/compare/v0.5.0...HEAD
[0.5.0]: https://github.com/mattbrictson/jess/compare/v0.4.0...v0.5.0
[0.4.0]: https://github.com/mattbrictson/jess/compare/v0.3.0...v0.4.0
[0.3.0]: https://github.com/mattbrictson/jess/compare/v0.2.0...v0.3.0
[0.2.0]: https://github.com/mattbrictson/jess/compare/v0.1.0...v0.2.0
