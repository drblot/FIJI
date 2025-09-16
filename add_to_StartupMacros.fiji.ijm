// add to macros/StartupMacros.fiji.ijm
// make channels bound to number 1-9
// quick switch only channel 1/2 etc on using F1-F5

///// Global variable to track channel state
var active = "";
var lastTitle = "";


macro "Toggle Channel 1 [1]" { toggle(0); }
macro "Toggle Channel 2 [2]" { toggle(1); }
macro "Toggle Channel 3 [3]" { toggle(2); }
macro "Toggle Channel 4 [4]" { toggle(3); }
macro "Toggle Channel 5 [5]" { toggle(4); }
macro "Toggle Channel 6 [6]" { toggle(5); }
macro "Toggle Channel 7 [7]" { toggle(6); }
macro "Toggle Channel 8 [8]" { toggle(7); }
macro "Toggle Channel 9 [9]" { toggle(8); }

macro "chan1 [F1]" { Stack.setActiveChannels("10000"); }
macro "chan2 [F2]" { Stack.setActiveChannels("01000"); }
macro "chan3 [F3]" { Stack.setActiveChannels("00100"); }
macro "chan4 [F4]" { Stack.setActiveChannels("00010"); }
macro "chan5 [F5]" { Stack.setActiveChannels("00001"); }

function toggle(idx) {
    // read the image dimensions: width, height, channels, slices, frames
    getDimensions(width, height, nch, slices, frames);

    // if image changed or mask wrong length, (re)build mask "111...1"
    title = getTitle();
    if (lastTitle != title || lengthOf(active) != nch) {
        active = "";
        for (i = 0; i < nch; i++) active = active + "1";
        lastTitle = title;
    }

    // guard: requested channel doesn't exist in this image
    if (idx >= nch) {
        // prevent substring/index error, and inform user
        print("Image \"" + title + "\" has only " + nch + " channel(s).");
        beep();
        return;
    }

    // toggle the chosen digit safely
    d = substring(active, idx, idx+1);
    if (d == "1")
        active = substring(active,0,idx) + "0" + substring(active, idx+1, nch);
    else
        active = substring(active,0,idx) + "1" + substring(active, idx+1, nch);

    // apply the new mask
    Stack.setActiveChannels(active);
}
/////

