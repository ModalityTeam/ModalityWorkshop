// basic example on how to swap one action from one control element to another.

k = MKtl(\nnkn20);

(
// function that should be linked to some element
var setAmp = {|el ... args| "(%) % [%].\n".postf(el.parent.indexOf(el), el, el.value)};
var currentAssignment = 1;

// how switching works
var switchTo = {|to|
    "% >> %\n".postf(currentAssignment, to);
    k.elementAt(\sl, currentAssignment).action = nil;
    k.elementAt(\sl, to).action= setAmp;
    currentAssignment = to;
};

// elements between the functions are switched
var controlElems = [1, 2];

// initially assign to first control element
k.elementAt(\sl, controlElems[0]).action = setAmp;

// assign via pressing a knob to another control element
k.elementAt(\bt, 0, 0).action = {|el|
    (el.value == 1).if({
        switchTo.(controlElems[0]);
    },{
        switchTo.(controlElems[1]);
    })
}
)