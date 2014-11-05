// basic example on how to swap one action from one control element to another.

k = MKtl(\nnkn0);

(
// function that should be linked to some element
var setAmp = {|el ... args| "I (%) set the amp of a synth to %.\n".postf(el.parent.indexOf(el), el)};
var currentAssignment = 1;

// how switching works
var switchTo = {|to|
    "% >> %\n".postf(currentAssignment, to);
    k.elementAt(\sl, 0, currentAssignment).action = nil;
    k.elementAt(\sl, 0, to).action= setAmp;
    currentAssignment = to;
};

// elements between the functions are switched
var controlElems = [1, 2];

// initially assign to first control element
k.elementAt(\sl, 0, controlElems[0]).action = setAmp;

// assign via pressing a knob to another control element
k.elementAt(\bt, 0, 0, 0).action = {|el|
    (el.value == 1).if({
        switchTo.(controlElems[0]);
    },{
        switchTo.(controlElems[1]);
    })
}
)