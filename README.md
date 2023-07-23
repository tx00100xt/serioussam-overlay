## Serious Sam Classic Gentoo overlay

Description:  
This overlay contains gentoo ebuild's to build from the source games  
Serious Sam The First Encounter and Serious Sam The Second Encounter.

### Getting this overlay

Type this in your terminal:
```
emerge eselect-repository
eselect repository add serioussam git https://github.com/tx00100xt/serioussam-overlay.git
emaint sync --repo serioussam
```

### Ebuild's

To build a game with Opengl support, use command:

```
emerge serioussam
```

To build a game with Opengl and Vulkan support, use command:

```
emerge serioussam-vk

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

To install XPLUS Modification type this in your terminal commands before building packages:
```
# echo "games-fps/serioussam xplus" >> /etc/portage/package.use/serioussam
# echo "games-fps/serioussam-vk xplus" >> /etc/portage/package.use/serioussam
# echo "games-fps/serioussam-parseerror xplus" >> /etc/portage/package.use/serioussam
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
emerge serioussam-parseerror
```

To install Nightmare Tower Modification type this in your terminal:
```
emerge serioussam-tower
```

To install ST8VI Modification type this in your terminal:
```
emerge serioussam-st8vi
```

To install ST8VIPE Modification type this in your terminal:
```
emerge serioussam-st8vipe
```

To install Hero Number One Modification type this in your terminal:
```
emerge serioussam-hno
```

To install Bright Island, Ancient Rome Next Encounter and Rakanishu Mappacks type this in your terminal:
```
emerge serioussam-brightisland-mappack serioussam-nextencounter-mappack serioussam-rakanishu-mappacks
```

### Metapackage's

You can use metapackage for Serious Sam The First Encounte and Serious Sam The Second Encounter.
```
emerge serioussam-tfe-meta serioussam-tse-meta
```

License
-------

  * Serious Engine v1.10 is licensed under the GNU GPL v2 (see LICENSE file).

