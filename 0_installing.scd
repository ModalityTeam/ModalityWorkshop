/*
Modality Toolkit

The *Modality Toolkit* is a library to facilitate accessing (hardware) controllers in SuperCollider.
It is designed and developed by the ModalityTeam, a group of people that see themselves as both developers and (advanced) users of SuperCollider.

The central idea behind the Modality-toolkit is to simplify creation of individual (electronic) instruments with SuperCollider, using controllers of various kinds. To this end, a common code interface, MKtl, is used for connecting  controllers from various sources (and protocols). These are atm. HID and MIDI; OSC, Serialport and GUI-based are planned to be integrated.

The name *Modality* arose from the idea to scaffold the creation of modal interfaces, i.e. to create interfaces where one physical controller can be used for different purposes and it is possible to *switch its functionality, even at runtime*.
It is our believe that integration of such on-the-fly remapping features helps to create a setup much more flexible, powerful, and interesting to play.
Such a modal interface allows to cope with fast changes of overall direction as it can be necessary when e.g. improvising with musicians playing acoustic instruments.
*/

// Installation

//========= Using GIT and the terminal: =========
// - open the terminal and type:
git clone https://github.com/ModalityTeam/Modality-toolkit
// - check the path where you cloned it:
// e.g.
/home/nescivi/git/Modality/Modality-toolkit/Modality/

// - then on Linux in the terminal:
cd ~/.local/share/SuperCollider/Extensions
ln -s /home/nescivi/git/Modality/Modality-toolkit/Modality/
// - and recompile sclang

// - on MacOSX:
cd ~/Library/Application\ Support/SuperCollider/Extensions/
ln -s /Users/nescivi/git/Modality/Modality-toolkit/Modality/

//========= Using the zip download link: =========

// Download the toolkit from:
/*
https://github.com/ModalityTeam/Modality-toolkit/archive/master.zip
*/
// Unpack the toolkit (doubleclick, or rightclick and choose unpack...)

// And copy the folder Modality to your Extensions folder.

// You can open the extensions folder with this little line of SC code
Platform.userAppSupportDir.openOS;

//========= Additional quarks for this workshop: =========

// install the additional quarks:
Quarks.updateDirectory;
Quarks.install("JITLibExtensions");
Quarks.install("adclib");
thisProcess.recompile;
