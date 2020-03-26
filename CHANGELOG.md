# Changelog

This project uses [Semantic Versioning](https://semver.org).

## [Unreleased][unreleased]
* Added new classes for the different environments
* Fixed the authentication in the production environment
* Fixed the production url for the retoure
* Added missing configuration options (app_id and app_token) for the production environment
* Added a fix for validations not working with activemodel ~> 4
* Changed the dependency of active model
* Added validations to the simple address object
* Added new functions to retrieve a shipping label, a qr code or both documents
* Added the connection class and the basic response object
* Added a filter for sensitive data to vcr
* Added the base classes
* Added support for dev environments, vcr and webmock as well configured rubocop and added a class to configure the gem itself
* initial commit
