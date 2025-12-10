// @file:   windows.jai
// @author: jak2 <jak2@clover-work.shop>
//
// from the poet to the lover, the support of clover
//

libc     :: #library,system "msvcrt";
Kernel32 :: #library,system "Kernel32";

// Windows specific function to delete the console.
FreeConsole  :: () -> bool #foreign Kernel32;
free_console :: FreeConsole;

user_path := "LOCALAPPDATA";
