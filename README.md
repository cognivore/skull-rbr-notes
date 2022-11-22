# Skull RBR Notes

Note INIs that are compatible with Skull's co-driver, together with samples, because why not.

## Automated co-driver making

There are scripts `.mk_template` and `.mk_codriver`, found in `Plugins/Pacenote/Scripts/`.

### Make template

Go to a codriver callout directory, for example `Plugins/Pacenote/sounds/SabrinaInkwell3` and call `.mk_template` from there.

It will generate a list of things a human needs to say with at least 200 msec pauses of silence between callouts to create a voice bank.

Speak loudly, as if you're driving in a loud car.

### Convert voice bank to OGG mono, 11025 Hz.

Use Audacity for that. Or use a `sox` script:

```
sox  ~/winhome/Documents/Raw\ Rawness.ogg -r 11025 -c 1 .template/jonn.ogg
```

### Finally split the bank into .codriver.

Given a properly prepared OGG voicebank, (mono, 11025 Hz), run `.mk_codriver` script in a directory with existing `.template` directory.

You will get a `.codriver` directory with properly named callouts, extracted from the aforementioned voicebank file.

### Roadmap

We're in progress of implementing `boost_volume_by` and `normalise_callout_file` scripts.
