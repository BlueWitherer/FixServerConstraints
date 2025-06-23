# <img src="addon.jpg" width="30" alt="The addon's logo." /> Fix Server Constraints Limit
Fix constraint limits for your dedicated Garry's Mod server.

> [<img alt="YouTube" src="https://img.shields.io/youtube/channel/subscribers/UCi2M6N_ff1UC6MyfWzKQvgg?style=for-the-badge&logo=youtube&logoColor=ffffff&label=YouTube">](https://www.youtube.com/@cheese_works/) [<img alt="Bluesky" src="https://img.shields.io/badge/dynamic/json?url=https%3A%2F%2Fpublic.api.bsky.app%2Fxrpc%2Fapp.bsky.actor.getProfile%2F%3Factor%3Dcheeseworks.xyz&query=%24.followersCount&style=for-the-badge&logo=bluesky&logoColor=ffffff&label=Bluesky">](https://bsky.app/profile/cheeseworks.xyz) [<img alt="Discord" src="https://img.shields.io/discord/460081436637134859?style=for-the-badge&logo=discord&logoColor=ffffff&label=Discord">](https://dsc.gg/cubic)

> [<img alt="Updated" src="https://img.shields.io/steam/update-date/3497996983?style=for-the-badge&logo=github&logoColor=ffffff&label=Updated">](https://steamcommunity.com/sharedfiles/filedetails/changelog/3497996983)    [<img alt="Code License" src="https://img.shields.io/github/license/BlueWitherer/FixServerConstraints?style=for-the-badge&logo=gnu&logoColor=ffffff&label=License">](LICENSE.md)
>  
> [<img alt="Subscriptions" src="https://img.shields.io/steam/downloads/3497996983?style=for-the-badge&logo=steam&logoColor=ffffff&label=Subscriptions">](https://steamcommunity.com/sharedfiles/filedetails/?id=3497996983)

Can't use ropes or welds on your dedicated server? Don't worry! This addon fixes that, and makes it easy to manage!

> [!TIP]
> *This addon has settings you can utilize to customize your experience.*

---

## About

When you host a dedicated Garry's Mod server, chances are you won't be able to create welds or ropes because of the non-existent constraint limit values, essentially prohibiting all constraints.

If you're hosting a dedicated server to play with friends and need to use welds and ropes, but can't - this addon is for you! Add it to your collection, and enjoy welding and roping!

This addon simply adds the missing ConVars needed to define weld and rope limits.

---

### Configuration
###### Change options in the addon

If you're an admin, you can find configurations in the spawnmenu in `Utilities` > `Admin` > `Fix Constraint Limits`. You may change the constraint and rope constraint limits. You can also find a button to reset all values to default. If you're a superadmin, you can find an option in `Options` > `Constraints` > `Admin` to restrict the ability to modify these limits strictly to superadmins, from regular admins.

If you're the server operator, you can also type the following variables as commands in the console to modify them.

|           Variable            | About                                   | Default |
| :---------------------------: | --------------------------------------- | :-----: |
|   **`sbox_maxconstraints`**   | Maximum weld limit                      | `2000`  |
| **`sbox_maxropeconstraints`** | Maximum rope limit                      | `1000`  |
|       `fsc_superadmin`        | Only allow superadmins to change limits |   `1`   |

Format: `variable_name {number}`