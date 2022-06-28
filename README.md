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
or
```
eselect repository add serioussam git https://github.com/tx00100xt/serioussam-overlay.git
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

   * All saving game settings, controls, ,scores, saves, recorded demos, logs, in home directory ".local/share/Serious-Engine/..."

### Modification's

To install XPLUS Modification type this in your terminal:
```
emerge serioussam-tfe-xplus serioussam-tse-xplus
```

To install Alpha Remake Modification type this in your terminal:
```
emerge serioussam-alpharemake
```

To install OddWorld Modification type this in your terminal:
```
emerge serioussam-oddworld
```

To install DancesWorld Modification type this in your terminal:
```
emerge serioussam-dancesworld
```

To install Parse Error Modification type this in your terminal:
```
emerge serioussam-pefe2q serioussam-pese2q
```

To install Nightmare Tower Modification type this in your terminal:
```
emerge serioussam-tower
```

License
-------

  * Serious Engine v1.10 is licensed under the GNU GPL v2 (see LICENSE file).

