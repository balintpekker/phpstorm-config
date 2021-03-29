# phpstorm-config

This repository's goal is to share PhpStorm config between team members to keep everyone updated with the latest changes. This involves:
* Code styles
* Inspection profiles
* Live templates
* Plugins
* Default database connections for [ddev](https://github.com/drud/ddev)
* .editorconfig

### Prerequisites

In order to be able to use phpcs globally, you have to have it installed globally with `composer`, also you need to configure the `Drupal` and `DrupalPractice` coding standard if you haven't done it before.

```shell
composer global require "squizlabs/php_codesniffer=*"
composer global require drupal/coder
export PATH="$PATH:$HOME/.composer/vendor/bin"
phpcs --config-set installed_paths ~/.composer/vendor/drupal/coder/coder_sniffer
```

You can verify if your setup is working properly with running `phpcs -i` and checking if the coding standards mentioned above are installed.

### Configure a settings repository
On each computer where you want your settings to be applied, select **File | Manage IDE Settings | Settings Repository** from the main menu. Specify the URL of the repository you've created, and click **Overwrite Local**.

You can click **Merge** if you want the repository to keep a combination of the remote settings and your local settings. If any conflicts are detected, a dialog will be displayed where you can resolve these conflicts.

Your local settings will be automatically synchronized with the settings stored in the repository each time you perform an **Update Project** or a **Push** operation, or when you close your project or exit PhpStorm.

Further information on how to configure these settings can be found [here](https://www.jetbrains.com/help/phpstorm/sharing-your-ide-settings.html#settings-repository).

### Manual Setup

If you are for some reason unable to configure the settings repository to overwrite your local configuration, you can do it manually by copying the files from the repository to the respective places.

Run
`./update-config.sh`

> You can add an alias to this file, or paste it into your `PATH` in order to execute it without having to use the extension. It is recommended to set up an alias for it, and run the script occasionally to check for updates.
