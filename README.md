# Audio Device Switcher NG

Simple KDE/Plasma widget (plasmoid) to change the default audio output device (sink) or the default audio input device (source).

Tested on KDE/Plasma 5.27 and PipeWire 1.0.0. Since it uses the PulseAudio API, it should also work under PulseAudio. (Well, a lot of the work is done by KDE's own [plasma-pa](https://invent.kde.org/plasma/plasma-pa), as this widget here reuses the PulseAudio integration implemented there.)

## How to develop

1. Clone this repository.
2. Create the necessary directory, if needed: `mkdir -p ~/.local/share/plasma/plasmoids`
3. Link this repository over there: `ln -s path-to-this/repo/package ~/.local/share/plasma/plasmoids/clone.plasma-audio-device-switcher`
    * Using a distinct name to install the dev version alongside the stable version.
4. [Test it on a stand-alone window](https://develop.kde.org/docs/plasma/widget/testing/):
    * `plasmawindowed clone.plasma-audio-device-switcher`
    * `plasmoidviewer -a clone.plasma-audio-device-switcher`
    * `plasmoidviewer -a ./package`

These steps are inspired by the [Plasma Widget Tutorial](https://develop.kde.org/docs/plasma/widget/).

## How to install

There are several ways, just pick one:

* Plasma 5 only (probably):
    * `plasmapkg2 -i package` will install it on `~/.local/share/plasma/plasmoids/`.
    * `plasmapkg2 -g -i package` will install it system-wide.
    * `plasmapkg2 -u package` to upgrade it.
* You can use the [./install_this_repo_as_symlink.sh](./install_this_repo_as_symlink.sh) convenience script.
* You can also install it manually `cp -a package ~/.local/share/plasma/plasmoids/org.kde.plasma.audiodeviceswitcher-ng/`.
* Or you can unzip the release zipfile onto that directory.

You may need to log out and log back in to make sure KDE/Plasma can see the manually-installed widget. (If you know a better way, please contribute!)

## Credits

Originally created by [akrutzler](https://github.com/akrutzler/plasma-audio-device-switcher) and published as <https://store.kde.org/p/1195707/>.

More than one year after the last commit on that original repository, [lolcabanon's fork](https://github.com/lolcabanon/plasma-audio-device-switcher) [merged many pull requests](https://github.com/lolcabanon/plasma-audio-device-switcher/commit/2cda18ad121d11f17dbc4bb52cce229162a40d83), such as [#13](https://github.com/akrutzler/plasma-audio-device-switcher/pull/13), [#15](https://github.com/akrutzler/plasma-audio-device-switcher/pull/15), [#17](https://github.com/akrutzler/plasma-audio-device-switcher/pull/17), plus adding a few extra features.

Almost one year later [denilsonsa's fork](https://github.com/denilsonsa/plasma-audio-device-switcher) merged [one other pull request](https://github.com/akrutzler/plasma-audio-device-switcher/pull/13), and implemented further improvements.

With thanks to
[davidosomething](https://github.com/davidosomething/plasma-audio-device-switcher/commit/53b387127763f3780215c90371d5de3c01fefe7d),
[emvaized](https://github.com/emvaized/plasma-audio-device-switcher/commit/8498d7ab7e2d6b3e88f14d811084ad06b911282f),
[Phen-Ro](https://github.com/Phen-Ro/plasma-audio-device-switcher/commit/788e4376ba2e723d65a812ef90e21ef93fde9c33),
[plachste](https://github.com/plachste/plasma-audio-device-switcher/commit/97c17a4b845197cb8276e2698c131a3bea268d10),
[xpt3](https://github.com/xpt3/plasma-audio-device-switcher/commit/09b32256baaf9b1af7a1d67f6bbf65433a9696bb).

## Future

I myself won't be able to keep maintaining this code. I'm not sure if I understand it well enough. This project has passed over many hands, and if you are willing to, feel free to adopt it!

## Ideas for new features

* Volume control
    * [ ] Using the scroll wheel over each button could change the volume level of that device.
    * [ ] Middle-clicking could mute that device.
    * [ ] Muted devices could have a different background color or different effect. (For the icons-only view; because the "(muted)" text is already shown.)
    * [ ] We could have a background bar representing the volume level of each device.
* Other features
    * [ ] Somehow be able to [switch audio profiles](https://github.com/akrutzler/plasma-audio-device-switcher/issues/9). I have no idea how to make it useful while keeping the interface simple.
    * [ ] Add [Open Audio Volume Settings to the context menu](https://github.com/akrutzler/plasma-audio-device-switcher/issues/6)
* Visual features
    * [ ] Let [the background to be transparent](https://github.com/akrutzler/plasma-audio-device-switcher/issues/8), as well as disabling the background.
    * [ ] The vertical layout should be the default (due to very long device names). Or the icons-only horizontal layout.
    * [ ] Custom image at the "Add widget" interface.
