## Serious Sam Classic Gentoo overlay

Description:  
This overlay contains gentoo ebuild's to build from the source games  
Serious Sam The First Encounter and Serious Sam The Second Encounter.

### Getting this overlay

Type this in your terminal:

```
emerge layman 
layman -o https://raw.githubusercontent.com/tx00100xt/serioussam-overlay/main/serioussam-overlay.xml -f -a serioussam
```

### Ebuild's

To build a game with Opengl support, use command:

```
emerge serioussam-tfe
emerge serioussam-tse
```

To build a game with Opengl and Vulkan support, use command:

```
emerge serioussam-tfe-vk
emerge serioussam-tse-vk

```
To copy game content from your CD or your CD image (First release or Gold edition), use command:

```
emerge serioussam-tfe-data
emerge serioussam-tse-data
```

### The first launch of the game

After the first start of the game:
   * Select options, video options. Select the desired aspect ratio, screen resolution, fullscreen mode, set presets to quality, click apply
   * Then the options again, Execute Addon. Click to "GFX: Default quality" ("Default" for Second Encounter), and press ESC.
   * Select options, audio options. Choose 44,1kHZ, click apply.
   * Back to main menu.
   * Play.

### Saving game settings, saving gameplay, recording game demo:

   * To save the game settings, permission to write to the file "Scripts/"PersistentSymbols.ini is required.
   * To save the gameplay, write permission to the "SaveGame/Player0" and "SaveGame/Player0/Quick" directories is required.
   * To record demos of the gameplay, permission to write to the "Demos" directory is required

License
-------

  * Serious Engine v1.10 is licensed under the GNU GPL v2 (see LICENSE file).

