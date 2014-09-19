// relevant helpfiles:
"Modality".openHelpFile;
MKtl.openHelpFile;

// finding devices is as simple as:
MKtl.find;

// or for just one protocol:
MKtl.find( 'hid' ); // needs 3.7dev
MKtl.find( 'midi' );

// this will print out a list of devices, pick the one you want:

/*
// Available MIDIMKtls - you may want to change the names:
   MIDIMKtl('sprc0', 8454147, 8454144);  // SuperCollider
   MIDIMKtl('mdth0', 917504, 917504);  // Midi Through
   MIDIMKtl('syst0', 0, nil);  // System
   MIDIMKtl('syst1', 1, nil);  // System

-----------------------------------------------------

// Available	HIDMKtls - just give them unique names:
   HIDMKtl('rnnd0');  // Thrustmaster Run'N' Drive
   HIDMKtl('sbcm0');  // Plus More Enterprise LTD. USB-compliant keyboard
   HIDMKtl('0');  //
   HIDMKtl('sbcm1');  // Plus More Enterprise LTD. USB-compliant keyboard
   HIDMKtl('prtk20', "02");  // No brand 2Port KVMSwicther
*/

// e.g. we want to open the Thrustmaster Run'N' Drive:

MKtl( 'rnnd0' );

// create a gui to represent it:
// MKtl( 'rnnd0' ).gui; // gives a bug for Run'N' Drive

// if you do not have the device around, you can create a virtual one and simulate it with a GUI:

//create a virtual Run'N'Drive
MKtl.make(\fakeRun, \RunNDrive);

//create a gui to control it
MKtl(\fakeRun).gui;

// or just use the shortcut directly, and the gui pops up:
MKtl( 'rnnd0' );


// what can it do? complete list of the device description
MKtl( 'rnnd0' ).postDeviceDescription

// just look at the names of elements in a nice list:
MKtl( 'rnnd0' ).printElementNames

// print the output:
MKtl( 'rnnd0' ).verbose_( true );

// turn that off again:
MKtl( 'rnnd0' ).verbose_( false );

// this printing only works if your device is known already by the toolkit. If not, you can create your own description file:
"How to create a description file".openHelpFile;

"HIDExplorer".openHelpFile;
//Or just use:
MKtl( 'rnnd0' ).createDescFromDevice;


// --- does anyone have a device that is not yet known by the toolkit?
// - pick one to give an example how it works for everyone, preferably one of each type (MIDI / HID)
// - then help those who have other devices that do not work out of the box

