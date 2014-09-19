// relevant helpfiles:
"Modality".openHelpFile;
MKtl.openHelpFile;

// finding devices is as simple as:
MKtl.find;

// or for just one protocol:
MKtl.find( 'hid' );
MKtl.find( 'midi' );

// this will print out a list of devices, pick the one you want:

/*
// Available MIDIMKtls - you may want to change the names:
   MIDIMKtl('sprc0', 8454149, 8454144);  // SuperCollider
   MIDIMKtl('cncn2000', 1310720, 1310720);  // iCON iControls V2.00
   MIDIMKtl('mdth0', 917504, 917504);  // Midi Through
   MIDIMKtl('cncn2001', 1310721, nil);  // iCON iControls V2.00
   MIDIMKtl('sprc1', 8454150, 8454145);  // SuperCollider
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

MKtl( 'cncn2000' );

// create a gui to represent it:
MKtl( 'cncn2000' ).gui;

// if you do not have the device around, you can create a virtual one and simulate it with a GUI:

//create a virtual Run'N'Drive
MKtl.make(\fakeIcon, \ICONIControls)

//create a gui to control it
MKtl(\fakeIcon).gui // gives a bug right now

// or just use the shortcut directly, and the gui pops up:
MKtl( 'cncn2000' );

// what can it do? complete list of the device description
MKtl( 'cncn2000' ).postDeviceDescription

// just look at the names of elements in a nice list:
MKtl( 'cncn2000' ).printElementNames

// print the output:
MKtl( 'cncn2000' ).verbose_( true );

// turn that off again:
MKtl( 'cncn2000' ).verbose_( false );

// this printing only works if your device is known already by the toolkit. If not, you can create your own description file:
"How to create a description file".openHelpFile;
//"MIDIExplorer".openHelpFile;

// --- does anyone have a device that is not yet known by the toolkit?
// - pick one to give an example how it works for everyone, preferably one of each type (MIDI / HID)
// - then help those who have other devices that do not work out of the box

