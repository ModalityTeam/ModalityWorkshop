// Here is a very simple apporach to using one controller
// for several different pages of functions.
// Doing this paging in software is more flexibl than in hardware,
// where the lists of controller elements for all pages can get very long.

// Attach a single nanoKontrol2 first if you have one, then find it:
MKtl.find(\midi);

// Then make 2 MKtls which point to the same device
MKtl('\ada', "korg-nanokontrol2");
MKtl('\bob', "korg-nanokontrol2");

// trace the first one: posts come MKtl('\ada')
MKtl('\ada').trace;
// trace the second one: posts come MKtl('\ada')
MKtl('\bob').trace;

// and give each one a different action for the rew button
MKtl('\ada').elementAt(\rew).action_({ "rew page 1".postln });
MKtl('\bob').elementAt(\rew).action_({ "rew page 2".reverse.postln });

// activate page 1
MKtl('\ada').enable; MKtl('\bob').disable;

// activate page 2
MKtl('\bob').enable; MKtl('\ada').disable;

// And here is a way that works with any number of (named) pages:
~fatNK = ();  	// make a container dict
				// put in one mktl for each page
~fatNK.mktls = (
	ada: MKtl('\ada'),
	bob: MKtl('\bob')
);
~fatNK.page = { |fatNK, name|
	fatNK.mktls.keysValuesDo { |key, nk|
		if (key == name) { nk.enable } { nk.disable }
	};
};
)
~fatNK.page(\bob);
~fatNK.page(\ada);
~fatNK.page(\none); // non-existing keys turn all pages off

Note: The current implementation of HIDMKtlDevice does not allow
making multiple MKtls that point to the same device. This could
be fixed by redoing HIDMKtlDevice with HIDFuncs.


