NGPCarMenu plugin - MyPacenotes

If MyPacenotesPath is enabled in plugins\NGPCarMenu.ini configuration file then custom pacenotes per stage are stored here.
By default stages use the default pacenote supplied by the stage author, but if you create own custom pacenotes then those changes are stored and used from this storage location.

Benefits of MyPacenotes feature in NGPCarMenu plugin:
- Pacenote changes are autosaved, so if RBR crashes or you forgot to do "Save" or "Save as BTB" in pacenote editor then the latest changes are still preserved here.
- When a stage author releases the new version of an existing stage then your own custom pacenotes are not lost even when the stage is re-installed or updated (the default stage data files know nothing about your custom pacenotes).
- If RBR crashes during recce then autosave feature preserved the latest changes in MyPacenotes storage.
- If you use RSF_Launcher then it is very easy to switch between different versions of pacenotes (bad and good weather notes, some stages may have different obstables in morning/day/noon versions).
- The maintenance process of custom pacenotes is the same for both classic and BTB stages (MyPacenotes feature supports both stage formats).

The use of MyPacenotes feature is automatical under the hood when this feature and NGPCarMenu plugin is enabled in RBR. 
However, you may want to use RSF_Launcher application also to easiy manage MyPacenotes but the launcher is not required.
