# Skull RBR Notes

Note INIs that are compatible with Skull's co-driver, together with samples, because why not.

## Automated co-driver making

There are scripts `.mk_template` and `.mk_codriver`, found in `Plugins/Pacenote/Scripts/`. Go to a codriver callout directory, for example `Plugins/Pacenote/sounds/SabrinaInkwell3` and call `.mk_template` from there. It will generate a list of things a human needs to say with at least 200 msec pauses of silence between callouts to create a voice bank. Given a properly prepared OGG voicebank, (mono, 11025 Hz), run `.mk_codriver` script in a directory with existing `.template` directory to get a `.codriver` directory with properly named callouts, extracted from the aforementioned file.

I used the following command to convert my Audacity-exported OGG into correctly sampled mono OGG: `sox  ~/winhome/Documents/Raw\ Rawness.ogg -r 11025 -c 1 .template/jonn.ogg`.

We're in progress of implementing `boost_volume_by` and `normalise_callout_file` scripts.
