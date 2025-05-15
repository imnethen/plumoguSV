# plumoguSV v1.1.2
<img src="./logo.png" alt="plumoguSV Logo">

> "The ultimate community-driven and open-source competitive SV plugin. Remastered with many new features."

This is a plugin for [Quaver](https://github.com/Quaver), the ultimate community-driven and open-source competitive rhythm game. Originally made by [amogu](https://github.com/kloi34), this fork aims to continue the legacy that kloi left behind. The plugin has support for manipulating SVs (scroll velocities) and SSFs (scroll speed factors) in all sorts of ways, and it is the de facto plugin for SV mapmaking.

## Installation
1. Go to the releases tab on the right, and download the latest release's `.zip` file.
2. Extract the downloaded `.zip` file to get the plumoguSV-main folder
3. Move the plumoguSV-main folder into the `/Plugins` folder (located in the `/Quaver` folder)

## Plugin Overview 
plumoguSV makes working with SVs quick and easy!

Once you open the plugin in the map editor you:
1. Choose an SV tool
2. Adjust the SV tool's settings
3. Select notes you want to use the tool at/between
4. Use the SV tool by pressing 'T' on your keyboard (or hitting the big button that appears)

plumoguSV lets you do 4 general SV actions: select, create, edit, and delete.

## Building and Developing
As plumoguSV uses a multifile structure, there will be a few extra steps to start making your own changes to the plugin:
1. If you haven't already, install [Node.JS](https://nodejs.org/en).
2. In the root directory, type `npm i` into the terminal to install all the packages.
3. To start developing, type `npm run watch` into the terminal. This will start the watcher.
4. Now, any time you make a change to a file in the `/src` directory, `plugin.lua` will automatically recompile and will be hot-reloaded in game.

## Special Note
Thanks to [asterSSH](https://github.com/asterssh) for the banner and other graphic design help. Thanks to [7xbi](https://github.com/7xbi) and [imnethen](https://github.com/imnethen) for PRs which have positively moved this plugin forward.

Most of the core ideas and base functionality were taken (stolen) from [iceSV](https://github.com/IceDynamix/iceSV) by [IceDynamix](https://github.com/IceDynamix).
Other SV ideas also taken (stolen) from [Illuminati-CRAZ](https://github.com/Illuminati-CRAZ)’s SV plugins.
Without these two people’s contributions to SV plugins in general, plumoguSV would not be as good as it is today or even exist in the first place, so huge thanks to them.

Also, some cursor effects were inspired (stolen) from https://github.com/tholman/cursor-effects

## Related Links
* [Quaver Plugin Guide](https://github.com/IceDynamix/QuaverPluginGuide/blob/master/quaver_plugin_guide.md) by IceDynamix
* [iceSV](https://github.com/IceDynamix/iceSV) by IceDynamix
* [KeepStill](https://github.com/Illuminati-CRAZ/KeepStill) by Illuminati-CRAZ
* [Vibrato](https://github.com/Illuminati-CRAZ/Vibrato) by Illuminati-CRAZ
* [Displacer](https://github.com/Illuminati-CRAZ/Displacer) by Illuminati-CRAZ
* [AFFINE](https://github.com/ESV-Sweetplum/AFFINE) by ESV-Sweetplum
* [mulch](https://github.com/Emik03/mulch) by Emik03

## TO-DO
* Automate TG effects (v2)
* Migrate affine vibrato (v1.2)
* ~~Add SSF vibrato (v1.2)~~
* ~~Improve dev exp~~ (v1.1.2)
* ~~Lint code~~ (v1.1.2)
* Move to vector system (v1.2)
* ~~Improved SV/SSF window~~ (v1.1.2)
* ~~Upgrade dev ops by adding fns to libraries~~ (v1.1.2)