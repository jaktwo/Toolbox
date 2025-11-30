// @file:   platform.jai
// @author: jak2 <jak2@clover-work.shop>
//
// from the poet to the lover, the support of clover
//

getenv :: (char: *u8) -> *u8 #foreign libc;
strlen :: (char: *u8) -> int #foreign libc;

#if OS == .WINDOWS {
    #load "windows.jai";
}

#if OS == .LINUX {
    #load "linux.jai";
}
