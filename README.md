# PhpStorm IDE Configuration

![Shellcheck](https://github.com/balintpekker/phpstorm-config/workflows/Shellcheck/badge.svg)

This repository's goal is to share PhpStorm config between team members to keep everyone updated with the latest changes. This involves:

Directory | Contents
----------|---------
codestyle | Code Style settings (Editor > Code Style)
fileTemplates | File and Code Templates (Editor > File and Code Templates)
inspection | Inspection profiles (Editor > Inspections)
templates | Live templates (Editor > Live Templates)

## Installation
### 1. Install with configuring a settings repository (prefered)
On each computer where you want your settings to be applied, select **File > Manage IDE Settings > Settings Repository** from the main menu. Specify the URL of this repository, and click **Overwrite Local**.

Your local settings will be automatically synchronized with the settings stored in this repository each time you perform an **Update Project** or a **Push** operation, or when you close your project or exit PhpStorm.

Further information on how to configure these settings can be found [here](https://www.jetbrains.com/help/phpstorm/sharing-your-ide-settings.html#settings-repository).

### 2. Install Manually
After cloning the repository, you can run the bash script which will take care of copying the files to the chosen PhpStorm version's configuration directory.

> NOTE: If you install the configuration manually instead of using this repository as the settings configuration in PhpStorm (see first point), the updates to this repository will not affect your local configuration automatically.

In order to copy the configuration files, please run:

`./update-config.bash`

