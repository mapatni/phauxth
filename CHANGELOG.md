# Phauxth Changelog

## Version 1.2.2

* Enhancements
  * Added UserMessages module to make it easier to customize messages that are sent to the end user
    * this can also be used to translate these messages (using gettext)

## Version 1.2.0

* Enhancements
  * Improvements to session management
    * the session id in the Plug Session has a customizable max age
    * session ids are stored in the database (as a map in the users table)
      * if the session id is not found in the database, the user is not authenticated

* Changes
  * Moved the installer to a separate (phauxth_installer) repository

## Version 1.1.3

* Enhancements
  * Added `backups` option to the installer
    * if a file already exists, the installer will now create a backup of the file by default
    * running the installer with the `--no-backups` option will overwrite files

* Changes
  * replaced `configure_session(conn, drop: true)` with `delete_session(conn, :user_id)`
    * this preserves flash messages

## Version 1.1.2

* Enhancements
  * token implementation uses JSON instead of binary_to_term / term_to_binary

## Version 1.1.0

* Enhancements
  * the endpoint value in the config (used by the Confirm module) is now overridable
    * if necessary, you can set this value in the keyword options
    * this is to make it easier to use Phauxth with umbrella apps
  * key options are passed on to Phauxth.Token
    * this applies to the Authenticate, Remember and Confirm modules
  * minor updates to the installer templates - to make it more umbrella-friendly
