## Serious Sam Classic Gentoo overlay

Description:  
This overlay contains the gentoo ebuilds that install add-ons for the games  
Serious Sam The First Encounter and Serious Sam The Second Encounter..

### Getting this overlay

Type this in your terminal:
```
emerge eselect-repository
eselect repository enable serioussam
emaint sync --repo serioussam
```

## Ebuilds



### Modification's

To install XPLUS Modification type this in your terminal:
```
emerge serioussam-xplus --autounmask=y
```

To install Alpha Remake Modification type this in your terminal:
```
emerge serioussam-alpharemake --autounmask=y
```

To install OddWorld Modification type this in your terminal:
```
emerge serioussam-oddworld --autounmask=y
```

To install DancesWorld Modification type this in your terminal:
```
emerge serioussam-dancesworld --autounmask=y
```

To install Parse Error Modification type this in your terminal:
```
emerge serioussam-parseerror --autounmask=y
```

To install Nightmare Tower Modification type this in your terminal:
```
emerge serioussam-tower --autounmask=y
```

To install ST8VI Modification type this in your terminal:
```
emerge serioussam-st8vi --autounmask=y
```

To install ST8VIPE Modification type this in your terminal:
```
emerge serioussam-st8vipe --autounmask=y
```

To install Hero Number One Modification type this in your terminal:
```
emerge serioussam-hno --autounmask=y
```

To install The Sequel Modification type this in your terminal:
```
emerge serioussam-sequel --autounmask=y
```
### Mappack's

To install Bright Island, Ancient Rome Next Encounter and Rakanishu Mappacks type this in your terminal:
```
emerge serioussam-brightisland-mappack serioussam-nextencounter-mappack serioussam-rakanishu-mappacks --autounmask=y
```

### Metapackage's

You can use metapackage for Serious Sam The First Encounte and Serious Sam The Second Encounter.
```
emerge serioussam-tfe-meta serioussam-tse-meta --autounmask=y
```

License
-------

  * Serious Engine v1.10 is licensed under the GNU GPL v2 (see LICENSE file).

